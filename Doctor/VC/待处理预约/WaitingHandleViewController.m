//
//  WaitingHandleViewController.m
//  YSProject
//
//  Created by MrZhang on 15/6/12.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "WaitingHandleViewController.h"
#import "PendingTableViewCell.h"
#import "PendingDetailViewController.h"
#import "TabBarViewController.h"
@interface WaitingHandleViewController ()
{
    CWHttpRequest *request;
    NSDictionary *statusDic;
}
@property (weak, nonatomic) IBOutlet UITableView *baseTable;
@end

@implementation WaitingHandleViewController
{
    NSInteger morePage;
    NSInteger totalDataNum;
    NSMutableArray *dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"待预约列表"];
    [self addBackButt];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self refreshData];
    statusDic=@{@"-99":@"已取消",@"-2":@"已拒绝",@"-1":@"已拒绝",@"0":@"待确认",@"1":@"已确认",@"3":@"已确认",@"99":@"已完成",@"2":@"待确认"};
    [self.baseTable addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [self.baseTable addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
   
}
-(void)refreshData
{
    [self getServiceDataFromServiceType:@"4" andPage:1 AndName:nil anduIsComent:2 anddIsComment:2 andRefresh:YES];
}
-(void)loadMoreData
{
    morePage++;
    if (dataArray.count==totalDataNum){
        [self.baseTable.footer noticeNoMoreData];
    }else
    {
        [self getServiceDataFromServiceType:@"4" andPage:morePage AndName:nil anduIsComent:2 anddIsComment:2 andRefresh:NO];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(TabBarViewController*)self.tabBarController  tabbarImageView].hidden=YES;
}
#pragma mark----tableViewDelegate-------
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
-(void)getServiceDataFromServiceType:(NSString*)type andPage:(NSInteger)page AndName:(NSString*)name anduIsComent:(NSInteger)userComent anddIsComment:(NSInteger)docotorComent andRefresh:(BOOL)refresh
{
    if ([Reachability checkNetCanUse]){
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
       NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"stype":@"4", @"SessionID": sessionID,@"name":name==nil?@"":name,@"page":[NSNumber numberWithInteger:page],@"size":@"5"};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, SearchOrder] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0){
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                totalDataNum=[[[responseObject objectForKey:@"data"] objectForKey:@"total"] integerValue];
                if (refresh) {
                    [dataArray removeAllObjects];
                    dataArray=[[[responseObject objectForKey:@"data"] objectForKey:@"rs"] mutableCopy];
                    [self.baseTable.header endRefreshing];
                }else
                {
                    [dataArray addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"rs"]];
                }
                [self.baseTable reloadData];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"登录接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
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
