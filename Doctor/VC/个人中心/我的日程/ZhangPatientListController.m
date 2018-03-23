//
//  ZhangPatientListController.m
//  Doctor
//
//  Created by MrZhang on 15/7/22.
//  Copyright (c) 2015年 Zhang. All rights reserved.
//

#import "ZhangPatientListController.h"
#import "ZhangPatientListCell.h"
#import "PendingDetailViewController.h"
@interface ZhangPatientListController ()
{
    NSInteger morePage;
    NSInteger totalDataNum;
    NSMutableArray *dataArray;
    CWHttpRequest *request;
}
@property (weak, nonatomic) IBOutlet UITableView *baseTable;
@end

@implementation ZhangPatientListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"预约列表"];
    [self addBackButt];
    morePage=1;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self.baseTable registerNib:[UINib nibWithNibName:@"ZhangPatientListCell" bundle:nil] forCellReuseIdentifier:@"ZhangPatientListCell"];
    [self.baseTable addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [self.baseTable addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
     [self getServiceDataFromServiceType:@"0" andPage:1 AndDate:self.requestDate andRefresh:YES];
}
-(void)refreshData
{
    [self getServiceDataFromServiceType:@"0" andPage:1 AndDate:self.requestDate andRefresh:YES];
}
-(void)loadMoreData
{
    morePage++;
    if (dataArray.count==totalDataNum){
        [self.baseTable.footer noticeNoMoreData];
    }else
    {
      [self getServiceDataFromServiceType:@"0" andPage:morePage AndDate:self.requestDate andRefresh:NO];
    }
}
-(void)getServiceDataFromServiceType:(NSString*)type andPage:(NSInteger)page AndDate:(NSDate*)date andRefresh:(BOOL)refresh
{
    if ([Reachability checkNetCanUse]){
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSString *stringDate=[NSDate stringFromDate:date format:@"yyyy-MM-dd"];
        NSDictionary *jsonDictionary = @{@"stype":@"0",@"SessionID": sessionID,@"page":[NSNumber numberWithInteger:page],@"size":@"5",@"day":stringDate};
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
                    morePage=1;
                    [self.baseTable.header endRefreshing];
                    [self.baseTable.footer resetNoMoreData];
                }else
                {
                    [dataArray addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"rs"]];
                    [self.baseTable.footer endRefreshing];
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
#pragma mark----tableViewDelegate-------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger height;
    NSString *string=[[dataArray objectAtIndex:indexPath.row] objectForKey:@"itemsName"];
    CGRect  rect=[string boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-40, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    if (rect.size.height<=39) {
        height=79;
    }else
    {
        height=rect.size.height+45;
    }
    return   height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZhangPatientListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ZhangPatientListCell"];
    [self configerTableViewCell:cell withIndexPath:indexPath];
    tableView.tableFooterView=[UIView new];
    return cell;
}
-(void)configerTableViewCell:(ZhangPatientListCell*)cell withIndexPath:(NSIndexPath*)indexPath
{
    cell.nameLabel.text=[[dataArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    NSString *timeString=[NSString stringWithFormat:@"%@-%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"uTime1"],[[dataArray objectAtIndex:indexPath.row] objectForKey:@"uTime2"]];
    cell.timeLabel.text=timeString;
    cell.contentLabel.text=[[dataArray objectAtIndex:indexPath.row] objectForKey:@"itemsName"];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PendingDetailViewController *pendingDetailVC = [[PendingDetailViewController alloc] init];
    pendingDetailVC.hidesBottomBarWhenPushed=YES;
    pendingDetailVC.recieveDic=[dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:pendingDetailVC animated:YES];
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
