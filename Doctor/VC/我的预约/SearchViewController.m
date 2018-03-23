//
//  SearchViewController.m
//  YSProject
//
//  Created by MrZhang on 15/6/18.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "SearchViewController.h"
#import "PendingTableViewCell.h"
#import "PendingDetailViewController.h"
#import "TabBarViewController.h"
@interface SearchViewController ()<UITextFieldDelegate>
{
     CWHttpRequest *request;
     NSMutableArray *dataArray;
     NSDictionary *statusDic;
    //moreData
    NSInteger morePage;
    NSInteger totalDataNum;
}
@property (strong, nonatomic)  UITextField *textField;
@property (strong, nonatomic)  UIButton *cancelButt;
@property (weak, nonatomic) IBOutlet UITableView *baseTable;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (strong,nonatomic)NSString *searchName;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@""];
    [self addBackButt];
    self.view.backgroundColor=[CWNSFileUtil colorWithHexString:@"#e5e5e5"];
    self.noDataView.hidden=YES;
    self.baseTable.hidden=YES;
    morePage=1;
    [self creatSearchView];
    statusDic=@{@"-99":@"已取消",@"-2":@"已拒绝",@"-1":@"已拒绝",@"0":@"待确认",@"1":@"已确认",@"3":@"已确认",@"99":@"已完成",@"2":@"待确认"};
    [self.baseTable addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [self.baseTable addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboard)];
    [self.noDataView addGestureRecognizer:tapGesture];
    
}
-(void)resignKeyboard
{
    [_textField resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
    [(TabBarViewController*)self.tabBarController  tabbarImageView].hidden=YES;
    
}
-(void)creatSearchView
{
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(40, 20, kSCREEN_WIDTH-80, 30)];
    _textField.borderStyle=UITextBorderStyleNone;
    _textField.background=[UIImage imageNamed:@"sousuo_03"];
    [_textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    NSMutableAttributedString *attibutString=[[NSMutableAttributedString alloc]initWithString:@"请输入你要搜索的内容"];
    [attibutString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attibutString.length)];
    _textField.attributedPlaceholder=attibutString;
    [[self.view viewWithTag:10000] addSubview:_textField];
    
    UIView *leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 30)];
    _textField.leftView=leftView;
    _textField.leftViewMode=UITextFieldViewModeAlways;
    
    UIButton *rightButt=[UIButton buttonWithType:UIButtonTypeCustom];
    rightButt.frame=CGRectMake(0, 0, 30, 30);
    [rightButt setBackgroundImage:[UIImage imageNamed:@"0_208"] forState:UIControlStateNormal];
    [rightButt addTarget:self action:@selector(clearTextfieldText) forControlEvents:UIControlEventTouchUpInside];
    _textField.rightView=rightButt;
    _textField.rightViewMode=UITextFieldViewModeWhileEditing;
    
    UIButton *searchButt=[UIButton buttonWithType:UIButtonTypeCustom];
    searchButt.frame=CGRectMake(kSCREEN_WIDTH-30, 20, 20, 20);
    [searchButt setBackgroundImage:[UIImage imageNamed:@"fangdajing"] forState:UIControlStateNormal];
    [searchButt addTarget:self action:@selector(beginSearchAction) forControlEvents:UIControlEventTouchUpInside];
    [[self.view viewWithTag:10000] addSubview:searchButt];
}
-(void)clearTextfieldText
{
    _textField.text=nil;
}
-(void)beginSearchAction
{
    NSString *searchText = [_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([searchText length] == 0) {
        [ShowViewCenterViewController showAlertViewWithTitle:nil message:@"请输入您要搜索的内容" cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:nil cancelBlock:nil otherBlock:nil];
        return;
    }
    [self getServiceDataFromServiceType:@"0" andPage:1 AndName:self.searchName andRefresh:YES];
}
-(void)getServiceDataFromServiceType:(NSString*)type andPage:(NSInteger)page AndName:(NSString*)name andRefresh:(BOOL)refresh
{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
     [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
       NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"stype":type, @"SessionID": sessionID,@"name":name==nil?@"":name,@"page":[NSNumber numberWithInteger:page],@"size":@"5"};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, SearchOrder] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            NSLog(@"responseObject===%@",responseObject);
            if ([code integerValue]==0){
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                 totalDataNum=[[[responseObject objectForKey:@"data"] objectForKey:@"total"] integerValue];
                if (totalDataNum==0) {
                    self.noDataView.hidden=NO;
                    self.baseTable.hidden=YES;
                }else
                {
                    self.noDataView.hidden=YES;
                    self.baseTable.hidden=NO;
                    if (refresh) {
                        [dataArray removeAllObjects];
                        dataArray=[[[responseObject objectForKey:@"data"] objectForKey:@"rs"] mutableCopy];
                        morePage=1;
                        [self.baseTable.header endRefreshing];
                    }else
                    {
                        [dataArray addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"rs"]];
                    }
                    [self.baseTable reloadData];
                }
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"登录接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}
-(void)refreshData
{
    [self getServiceDataFromServiceType:@"0" andPage:1 AndName:self.searchName andRefresh:YES];
}
-(void)loadMoreData
{
    morePage++;
    if (dataArray.count==totalDataNum){
        [self.baseTable.footer noticeNoMoreData];
    }else
    {
        [self getServiceDataFromServiceType:@"0" andPage:morePage AndName:self.searchName andRefresh:NO];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        static NSString *cellIdentity = @"CELL";
        PendingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"PendingTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentity];
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
        }
        tableView.tableFooterView=[UIView new];
        [cell  configeCellData:[dataArray objectAtIndex:indexPath.row] andSatusDic:statusDic];
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
           return 150.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
         [tableView deselectRowAtIndexPath:indexPath animated:YES];
        PendingDetailViewController *pendingDetailVC = [[PendingDetailViewController alloc] init];
        pendingDetailVC.recieveDic=[dataArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:pendingDetailVC animated:YES];
}
#pragma mark----textFieldDelegate------------
- (void)textChanged:(UITextField *)sender {
    self.searchName=sender.text;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self getServiceDataFromServiceType:@"0" andPage:1 AndName:self.searchName andRefresh:YES];
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self makeKeyboardDisappear];
}
-(void)makeKeyboardDisappear
{
    [_textField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
