//
//  SearchPatientController.m
//  Doctor
//
//  Created by MrZhang on 15/6/23.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "SearchPatientController.h"
#import "PatientCell.h"
#import "UIImageView+WebCache.h"
#import "UIBlockAlertView.h"
#import "EaseMob.h"
#import "ChatViewController.h"
@interface SearchPatientController ()<UITextFieldDelegate>
{
    CWHttpRequest *request;
    NSMutableArray *dataArray;
    NSDictionary *statusDic;
    //moreData
    NSInteger morePage;
    NSInteger totalDataNum;
}
@property (weak, nonatomic) IBOutlet UITableView *baseTable;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property(nonatomic,strong)UITextField *textField;
@property (strong,nonatomic)NSString *searchName;
@end

@implementation SearchPatientController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:nil];
    [self addBackButt];
    self.view.backgroundColor=[CWNSFileUtil colorWithHexString:@"#e5e5e5"];
    self.noDataView.hidden=YES;
    self.baseTable.hidden=YES;
    morePage=1;
    [self creatSearchView];
    
      statusDic=@{@"-99":@"已取消",@"-2":@"已拒绝",@"-1":@"已拒绝",@"0":@"待确认",@"1":@"已确认",@"3":@"已确认",@"99":@"已完成",@"2":@"待确认"};
     [self.baseTable registerNib:[UINib nibWithNibName:@"PatientCell" bundle:nil] forCellReuseIdentifier:@"PatientCell"];
    [self.baseTable addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [self.baseTable addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

}
-(void)refreshData
{
   [self getPatientListFromService:YES page:1];
}
-(void)loadMoreData
{
    morePage++;
    if (dataArray.count==totalDataNum){
        [self.baseTable.footer noticeNoMoreData];
    }else
    {
        [self getPatientListFromService:NO page:morePage];
    }
}

-(void)creatSearchView
{
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(40, 20, kSCREEN_WIDTH-80, 30)];
    _textField.borderStyle=UITextBorderStyleNone;
    _textField.background=[UIImage imageNamed:@"sousuo_03"];
    [_textField addTarget:self action:@selector(searchTextChanged:) forControlEvents:UIControlEventEditingChanged];
    _textField.placeholder=@"请输入患者姓名";
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
-(void)searchTextChanged:(UITextField*)textField
{
    self.searchName=textField.text;
}
-(void)clearTextfieldText
{
    _textField.text=nil;
}
-(void)beginSearchAction
{
    [self getPatientListFromService:YES page:1];
}
-(void)getPatientListFromService:(BOOL)refresh page:(NSInteger)page
{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        if (self.searchName==nil) {
            [SVProgressHUD showErrorWithStatus:@"请输入你要搜索的内容"];
            return;
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
       NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"page":[NSNumber numberWithInteger:page],@"SessionID":sessionID,@"size":@5,@"name":self.searchName};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, GetFiend] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"病人列表接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            totalDataNum=[[[responseObject objectForKey:@"data"] objectForKey:@"total"]integerValue];
            if (totalDataNum==0) {
                self.noDataView.hidden=NO;
                self.baseTable.hidden=YES;
            }
            if ([code integerValue]==0) {
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                if (refresh){
                    [dataArray removeAllObjects];
                    dataArray =[[[responseObject objectForKey:@"data"]  objectForKey:@"rs"]mutableCopy];
                     morePage=1;
                    if (dataArray.count==0) {
                        self.baseTable.hidden=YES;
                        self.noDataView.hidden=NO;
                    }else
                    {
                        self.baseTable.hidden=NO;
                        self.noDataView.hidden=YES;
                    }
                    [self.baseTable.header endRefreshing];
                    [self.baseTable.footer resetNoMoreData];
                }else
                {
                    [dataArray addObjectsFromArray:[[responseObject objectForKey:@"data"]  objectForKey:@"rs"]];
                    [self.baseTable.footer endRefreshing];
                }
                [self.baseTable reloadData];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"病人列表接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}
-(void)getSpicfyUserInfo:(NSString*)uid
{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary= @{@"uid":uid,@"SessionID":sessionID};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, GetSpecialUserInfo] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"好友请求接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0){
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                ChatViewController *chatController = [[ChatViewController alloc]initWithChatter:[[responseObject objectForKey:@"data"] objectForKey:@"uid"] conversationType:eConversationTypeChat];
                chatController.hidesBottomBarWhenPushed = YES;
                chatController.titleName = [[responseObject objectForKey:@"data"] objectForKey:@"nickname"];
                chatController.extDictionary=[responseObject objectForKey:@"data"];
                [self.navigationController pushViewController:chatController animated:YES];
            }else
            {
                [SVProgressHUD showErrorWithStatus:[responseObject valueForKeyWithOutNSNull:@"text"]];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"好友请求接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PatientCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PatientCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"picUrl"]] placeholderImage:[UIImage imageNamed:@"0_201"] options:SDWebImageDelayPlaceholder];
    [cell.nameButt setTitle:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"name" ]forState:UIControlStateNormal];
    cell.sexLabel.text=[[[dataArray objectAtIndex:indexPath.row] objectForKey:@"sex"] integerValue]==0?@"女":@"男";
   cell.ageLabel.text=[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"age"]];
    
    UIButton *deletButt=[UIButton buttonWithType:UIButtonTypeCustom];
    deletButt.frame=CGRectMake(kSCREEN_WIDTH, 0, kSCREEN_WIDTH, 65);
    [deletButt setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [deletButt setImage:[UIImage imageNamed:@"0_26"] forState:UIControlStateNormal];
    [deletButt setTitle:@"删除" forState:UIControlStateNormal];
    deletButt.imageEdgeInsets=UIEdgeInsetsMake(0, 25, 0, 0);
    deletButt.titleEdgeInsets=UIEdgeInsetsMake(0, 25, 0, 0);
    [deletButt setBackgroundColor:[CWNSFileUtil colorWithHexString:@"#eeeeee"]];
    [cell.contentView addSubview:deletButt];
    tableView.tableFooterView=[UIView new];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self getSpicfyUserInfo:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"uid"]];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"真的删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIBlockAlertView *alerView=[[UIBlockAlertView alloc]initWithTitle:@"" message:@"确定删除该好友？" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" cancelblock:^{
            [self.baseTable reloadData];
        } otherBlock:^{
            [self deleteFriendFromServiceWith:[[[dataArray objectAtIndex:indexPath.row] objectForKey:@"uid"]integerValue]];
            //删除对应数据的cell
            [dataArray removeObjectAtIndex:[indexPath row]];  //删除数组里的数据
            [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        [alerView show];
    }

}
-(void)deleteFriendFromServiceWith:(NSInteger)patientID
{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"uid":[NSNumber numberWithInteger:patientID],@"SessionID":sessionID};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, DeletFriend] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"病人列表接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0) {
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                [self.baseTable reloadData];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"病人列表接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}

#pragma mark----textFieldDelegate------------
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self getPatientListFromService:YES page:1];
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
