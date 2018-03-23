//
//  NotificationViewController.m
//  YSProject
//
//  Created by cuiw on 15/5/31.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationTableViewCell.h"
#import "AnnouncementTableViewCell.h"
#import "NotificationDetailViewController.h"
#import "AnnouncementDetailViewController.h"
#import "TabBarViewController.h"
@interface NotificationViewController ()
{
    NSMutableArray   *dataArray;
    UIButton *_leftButton;
    UIButton *_rightButton;
    CWHttpRequest *request;
    CWHttpRequest *gonggaoRequest;
    CWHttpRequest *friendNumRequest;
    CWHttpRequest *friendRequest;
    NSInteger totalDataNum;
    NSInteger morePage;
    UIImageView *rightImageView;
    UIImageView *leftImageView;
}
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (strong ,nonatomic)UILabel *leftNumLabel;
@property (nonatomic,strong) UILabel *rightNumLabel;
@end

@implementation NotificationViewController



#pragma  mark----------------getDataFromService-------------
-(void)getMessageListFromService:(BOOL)refresh page:(NSInteger)page andtype:(NSInteger)type
{
    if ([Reachability checkNetCanUse]) {
        if (!gonggaoRequest) {
            gonggaoRequest = [[CWHttpRequest alloc] init];
        }
        
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
       NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary;
        if (type==2) {
        jsonDictionary = @{@"page":[NSNumber numberWithInteger:page],@"SessionID":sessionID,@"size":@5};
        }else
        {
        jsonDictionary = @{@"page":[NSNumber numberWithInteger:page],@"SessionID":sessionID,@"size":@5,@"isRead":[NSNumber numberWithInteger:type]};
        }
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [gonggaoRequest JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, GetMsg] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"病人列表接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0) {
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                if (refresh) {
                    [dataArray removeAllObjects];
                     totalDataNum=[[[responseObject objectForKey:@"data"] objectForKey:@"total"] integerValue];
                    dataArray =[[[responseObject objectForKey:@"data"]  objectForKey:@"rs"]mutableCopy];
                    morePage=1;
                    [self.contentTableView.header endRefreshing];
                    [self.contentTableView.footer resetNoMoreData];
                }else
                {
                    [dataArray addObjectsFromArray:[[responseObject objectForKey:@"data"]  objectForKey:@"rs"]];
                    [self.contentTableView.footer endRefreshing];
                }
                [self.contentTableView reloadData];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"病人列表接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}
//获取好友请求记录
-(void)getRequestFriendFromService:(BOOL)refresh page:(NSInteger)page andtype:(NSInteger)type
{
    if ([Reachability checkNetCanUse]){
        if (!friendRequest){
            friendRequest = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
       NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary;
        if (type==2) {
            jsonDictionary = @{@"page":[NSNumber numberWithInteger:page],@"SessionID":sessionID,@"size":@5};
        }else
        {
            jsonDictionary = @{@"page":[NSNumber numberWithInteger:page],@"SessionID":sessionID,@"size":@5,@"status":[NSNumber numberWithInteger:type]};
        }
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [friendRequest JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, GetReqFriend] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"请求好友列表接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0) {
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                if (refresh) {
                    [dataArray removeAllObjects];
                     totalDataNum=[[[responseObject objectForKey:@"data"] objectForKey:@"total"] integerValue];
                    dataArray =[[[responseObject objectForKey:@"data"]  objectForKey:@"rs"]mutableCopy];
                    morePage=1;
                    [self.contentTableView.header endRefreshing];
                    [self.contentTableView.footer resetNoMoreData];
                }else
                {
                    [dataArray addObjectsFromArray:[[responseObject objectForKey:@"data"]  objectForKey:@"rs"]];
                    [self.contentTableView.footer endRefreshing];
                }
                [self.contentTableView reloadData];
                [self requesFriendNumberRequest];
            }else
            {
                [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"text"]];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"好友请求列表接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}
-(void)dealFriendRequest:(NSInteger)uid andFriendStatus:(NSInteger)status andRufusecause:(NSString *)refuse
{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
       NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary= @{@"id":[NSNumber numberWithInteger:uid],@"SessionID":sessionID,@"status":[NSNumber numberWithInteger:status]};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, DealFriend] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"好友请求接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0) {
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
              [self requesFriendNumberRequest];
              [self getRequestFriendFromService:YES page:1 andtype:2];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"好友请求接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}
//4.15 user/index/unreadMsgNum获取未读公告数
-(void)unreadMessageNumberRequest
{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
       NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary= @{@"SessionID":sessionID};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, UnreadMsgNum] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"获取未读公告数接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0) {
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                if ([[[responseObject objectForKey:@"data"] objectForKey:@"val"] integerValue]==0) {
                    rightImageView.hidden=YES;
                }else
                {
                    rightImageView.hidden=NO;
                    self.rightNumLabel.text=[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"val"]];
                }
            }else
            {
                [SVProgressHUD showErrorWithStatus:[responseObject valueForKeyWithOutNSNull:@"text"]];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"获取未读公告数接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}
-(void)requesFriendNumberRequest
{
    if ([Reachability checkNetCanUse]) {
        if (!friendNumRequest) {
            friendNumRequest = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
       NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary= @{@"SessionID":sessionID};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [friendNumRequest JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, ReqFriendNewNum] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"获取好友请求数接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code integerValue]==0) {
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                [userManager synchronize];
                if ([[[responseObject objectForKey:@"data"] objectForKey:@"val"] integerValue]==0) {
                    leftImageView.hidden=YES;
                }else
                {
                    leftImageView.hidden=NO;
                    self.leftNumLabel.text=[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"val"]];
                }
                [self unreadMessageNumberRequest];
            }else
            {
                [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"text"]];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"获取好友请求数接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"消息通知"];
    [self addBackButt];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [_contentTableView registerNib:[UINib nibWithNibName:@"NotificationTableViewCell" bundle:nil] forCellReuseIdentifier:@"NotificationTableViewCell"];
    [_contentTableView registerNib:[UINib nibWithNibName:@"AnnouncementTableViewCell" bundle:nil] forCellReuseIdentifier:@"AnnouncementTableViewCell"];
    [self creatHeaderView];
    _leftButton.selected=YES;
    _rightButton.selected=NO;
   
    
  
}
-(void)creatHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, kSCREEN_WIDTH, 40)];
    headerView.backgroundColor = [UIColor hexColor:@"#eeeeee"];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton setTitle:@"私人医生请求" forState:UIControlStateNormal];
    [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _leftButton.frame = CGRectMake(0, 5, kSCREEN_WIDTH/2, 30);
     leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftButton.frame)-_leftButton.frame.size.width/4+10,CGRectGetMinY(_leftButton.frame)+5, 20, 20)];
    leftImageView.image=[UIImage imageNamed:@"0_125"];
    _leftNumLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    _leftNumLabel.tag=1000;
    _leftNumLabel.textColor=[UIColor whiteColor];
    _leftNumLabel.textAlignment=NSTextAlignmentCenter;
    [leftImageView addSubview:_leftNumLabel];
    
    [_leftButton addTarget:self action:@selector(segmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH/2 - 1, 10, 1, 20)];
    lineView.backgroundColor = [UIColor grayColor];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setTitle:@"公告" forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _rightButton.frame = CGRectMake(kSCREEN_WIDTH/2, 5, kSCREEN_WIDTH/2 - 1, 30);
    [_rightButton addTarget:self action:@selector(segmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH*3/4+20, CGRectGetMinY(_rightButton.frame)+5, 20, 20)];
    rightImageView.image=[UIImage imageNamed:@"0_125"];
    _rightNumLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    _rightNumLabel.textAlignment=NSTextAlignmentCenter;
    _rightNumLabel.tag=2000;
    _rightNumLabel.textColor=[UIColor whiteColor];
    [rightImageView addSubview:_rightNumLabel];
    
    [headerView addSubview:rightImageView];
    [headerView addSubview:leftImageView];
    [headerView addSubview:_leftButton];
    [headerView addSubview:lineView];
    [headerView addSubview:_rightButton];
    [self.view addSubview:headerView];
    [self.contentTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [self.contentTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
-(void)refreshData
{
    if (_leftButton.selected) {
     [self getRequestFriendFromService:YES page:1 andtype:2];
    }
    if (_rightButton.selected) {
     [self getMessageListFromService:YES page:1 andtype:2];
    }
}
-(void)loadMoreData
{
    morePage++;
    if ([dataArray count]==totalDataNum) {
        [self.contentTableView.footer noticeNoMoreData];
    }else
    {
        if (_leftButton.selected) {
        [self getRequestFriendFromService:NO page:morePage andtype:2];
        }else
        {
          [self getMessageListFromService:NO page:morePage andtype:2];
        }
       
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(TabBarViewController*)self.tabBarController  tabbarImageView].hidden=YES;
    [dataArray removeAllObjects];
    [self requesFriendNumberRequest];
    [self refreshData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentButtonAction:(UIButton *)button {
    if (button==_leftButton) {
        _leftButton.selected=YES;
        _rightButton.selected=NO;
        [self getRequestFriendFromService:YES page:1 andtype:2];
    }
    if (button==_rightButton) {
        _rightButton.selected=YES;
        _leftButton.selected=NO;
        [self getMessageListFromService:YES page:1 andtype:2];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_leftButton.selected){
        NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationTableViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.nameLabel.text=[[dataArray objectAtIndex:indexPath.row] objectForKey:@"fromName" ];
        cell.contentLabel.text=[[dataArray objectAtIndex:indexPath.row] objectForKey:@"requestContent"];
        cell.timeLabel.text=[[dataArray objectAtIndex:indexPath.row] objectForKey:@"createTime"];
        if ([[[dataArray objectAtIndex:indexPath.row] objectForKey:@"status"] intValue]==0) {
            cell.stateLabel.hidden=YES;
            cell.agreeButt.hidden=NO;
            cell.refuseButt.hidden=NO;
            cell.agreeButt.tag=indexPath.row*2+0;
            cell.refuseButt.tag=indexPath.row*2+1;
            [cell.agreeButt addTarget:self action:@selector(dealFriendRequestAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.refuseButt addTarget:self action:@selector(dealFriendRequestAction:) forControlEvents:UIControlEventTouchUpInside];
        }if ([[[dataArray objectAtIndex:indexPath.row] objectForKey:@"status"] intValue]==1) {
            cell.stateLabel.hidden=NO;
            cell.stateLabel.text=@"已同意";
            cell.stateLabel.textColor=[UIColor hexColor:@"0ac8a2"];
            cell.agreeButt.hidden=YES;
            cell.refuseButt.hidden=YES;
        }
        if ([[[dataArray objectAtIndex:indexPath.row] objectForKey:@"status"] intValue]==-1) {
            cell.stateLabel.hidden=NO;
            cell.stateLabel.text=@"已拒绝";
            cell.stateLabel.textColor=[UIColor hexColor:@"9d9d9d"];
            cell.agreeButt.hidden=YES;
            cell.refuseButt.hidden=YES;
        }
        return cell;
    }if(_rightButton.selected){
        AnnouncementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnnouncementTableViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backView.layer.cornerRadius=5.0f;
        if ([[[dataArray objectAtIndex:indexPath.row] objectForKey:@"isRead"] integerValue]==1)
        {
            cell.redPointView.hidden=YES;
        }
        cell.titleLabel.text=[[dataArray objectAtIndex:indexPath.row] objectForKey:@"title" ];
        cell.contentLabel.text=[[dataArray objectAtIndex:indexPath.row] objectForKey:@"content"];
        cell.timeLabel.text=[[dataArray objectAtIndex:indexPath.row] objectForKey:@"createTime"];
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_leftButton.selected) {
        return 141;
    } else {
        return 90;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_leftButton.selected) {
        NotificationDetailViewController *notificationDetailVC = [[NotificationDetailViewController alloc] init];
        notificationDetailVC.dataDic=[dataArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:notificationDetailVC animated:YES];
    } else {
        AnnouncementDetailViewController *announcementDetailVC = [[AnnouncementDetailViewController alloc] init];
         announcementDetailVC.dataDic=[dataArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:announcementDetailVC animated:YES];
    }
}
-(void)dealFriendRequestAction:(UIButton*)butt
{
    NSInteger row=butt.tag/2;
    if (butt.tag%2==0) {
        [self dealFriendRequest:[[[dataArray objectAtIndex:row] objectForKey:@"id"] integerValue] andFriendStatus:1 andRufusecause:nil];
    }if (butt.tag%2==1) {
     [self dealFriendRequest:[[[dataArray objectAtIndex:row] objectForKey:@"id"] integerValue] andFriendStatus:-1 andRufusecause:nil];
    }
}
@end
