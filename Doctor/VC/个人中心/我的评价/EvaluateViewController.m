//
//  EvaluateViewController.m
//  YSProject
//
//  Created by cuiw on 15/5/31.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "EvaluateViewController.h"
#import "MyEvaluatPatientCell.h"
#import "MyEvaluatPatientNoExpandCell.h"

#import "MyRecieveEvaluateCell.h"
#import "MyRecieveEvaluatNoExpandCell.h"
#import "OneSpecialCell.h"
#import "UserModel.h"
#import "TabBarViewController.h"
#import "SDWebImageDownloader.h"
@interface EvaluateViewController ()
{
    UIView *_headerView;
    UIButton *_leftButton;
    UIButton *_rightButton;
    UIButton *detailButt;
    CWHttpRequest *request;
    NSInteger LeftTotalDataNum;
    NSInteger rightTotalDataNum;
    NSInteger morePage;
    NSMutableArray *leftDataArray;
    NSMutableArray *rightDataArray;
    NSIndexPath *index;
    NSMutableDictionary *dataDic;
    
}
@property(nonatomic,strong)UserModel *userModel;
@property(nonatomic,strong)MyRecieveEvaluateCell *evaluatHeightCell;
@end

@implementation EvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"患者评价"];
    [self addBackButt];
    self.edgesForExtendedLayout=UIRectEdgeNone;
//    _userDic=[[CWNSFileUtil sharedInstance] getNSModelFromUserDefaultsWithKey:@"userData"];
    _userModel=[UserManager currentUserManager].user;
    [_contentTableView registerNib:[UINib nibWithNibName:@"MyRecieveEvaluateCell" bundle:nil] forCellReuseIdentifier:@"MyRecieveEvaluateCell"];
    [_contentTableView registerNib:[UINib nibWithNibName:@"MyRecieveEvaluatNoExpandCell" bundle:nil] forCellReuseIdentifier:@"MyRecieveEvaluatNoExpandCell"];
    
    [_contentTableView registerNib:[UINib nibWithNibName:@"MyEvaluatPatientCell" bundle:nil] forCellReuseIdentifier:@"MyEvaluatPatientCell"];
     [_contentTableView registerNib:[UINib nibWithNibName:@"MyEvaluatPatientNoExpandCell" bundle:nil] forCellReuseIdentifier:@"MyEvaluatPatientNoExpandCell"];
    
    [_contentTableView registerNib:[UINib nibWithNibName:@"OneSpecialCell" bundle:nil] forCellReuseIdentifier:@"OneSpecialCell"];
    NSLog(@"sessionID===%@",[UserManager currentUserManager].sessionID);
    //实例化一个cell
    self.evaluatHeightCell=[[MyRecieveEvaluateCell alloc]init];
    [self creatTableHeaderView];
    [self getEvaluateMeServiceDataFromServicePage:1 andRefresh:YES];
    [self getMeEvaluatPatientServiceDataFromServicePage:1 andRefresh:YES];
    _leftButton.selected=YES;
    _rightButton.selected=NO;
}
-(void)getEvaluateMeServiceDataFromServicePage:(NSInteger)page andRefresh:(BOOL)refresh
{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
       NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"stype":@"0", @"SessionID": sessionID,@"page":[NSNumber numberWithInteger:page],@"size":@"5",@"dIsComment":[NSNumber numberWithInteger:1]};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, SearchOrder] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            NSLog(@"评价接口成功=======%@", responseObject);
            if ([code integerValue]==0){
                UserManager *userManager=[UserManager currentUserManager];
                 userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                LeftTotalDataNum=[[[responseObject objectForKey:@"data"] objectForKey:@"total"] integerValue];
                [_leftButton setTitle:[NSString stringWithFormat:@"我收到的评价(%@)",[[responseObject objectForKey:@"data"] objectForKey:@"total"]] forState:UIControlStateNormal];
                if (refresh) {
                    [leftDataArray removeAllObjects];
                    leftDataArray=[[[responseObject objectForKey:@"data"] objectForKey:@"rs"] mutableCopy];
                    morePage=1;
                    [self.contentTableView.header endRefreshing];
                    [self.contentTableView.footer resetNoMoreData];
                }else
                {
                    [leftDataArray addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"rs"]];
                    [self.contentTableView.footer endRefreshing];
                }
                [self.contentTableView reloadData];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"评价接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}
-(void)getMeEvaluatPatientServiceDataFromServicePage:(NSInteger)page andRefresh:(BOOL)refresh
{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"stype":@"0", @"SessionID": sessionID,@"page":[NSNumber numberWithInteger:page],@"size":@"5",@"uIsComment":[NSNumber numberWithInteger:1]};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, SearchOrder] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            NSLog(@"评价接口成功=======%@", responseObject);
            if ([code integerValue]==0){
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                rightTotalDataNum=[[[responseObject objectForKey:@"data"] objectForKey:@"total"] integerValue];
                [_rightButton setTitle:[NSString stringWithFormat:@"我给出的评价(%@)",[[responseObject objectForKey:@"data"] objectForKey:@"total"]] forState:UIControlStateNormal];
                if (refresh) {
                    [rightDataArray removeAllObjects];
                    rightDataArray=[[[responseObject objectForKey:@"data"] objectForKey:@"rs"] mutableCopy];
                    morePage=1;
                    [self.contentTableView.header endRefreshing];
                    [self.contentTableView.footer resetNoMoreData];
                }else
                {
                    [rightDataArray addObjectsFromArray:[[responseObject objectForKey:@"data"] objectForKey:@"rs"]];
                     [self.contentTableView.footer endRefreshing];
                }
                [self.contentTableView reloadData];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject){
            NSLog(@"评价接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(TabBarViewController*)self.tabBarController  tabbarImageView].hidden=YES;
    [dataDic removeAllObjects];
    [self getBaseUserInfoDic];
}
-(void)getBaseUserInfoDic
{
    if ([Reachability checkNetCanUse]) {
        CWHttpRequest *_loginRequest = [[CWHttpRequest alloc] init];
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"username":[UserManager currentUserManager].loginName, @"password":[UserManager currentUserManager].password, @"userType": @"1",@"SessionID":sessionID};
        NSLog(@"jsonDictionary====%@",jsonDictionary);
        [_loginRequest JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, Login_URL] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            [SVProgressHUD dismiss];
            NSLog(@"更新个人信息接口成功=======%@", responseObject);
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
            NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0) {
                [[CWNSFileUtil sharedInstance] setNSModelToUserDefaults:responseObject withKey:@"userData"];
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                [userManager synchronize];
                dataDic=[[responseObject objectForKey:@"data"] mutableCopy];
                [self.contentTableView reloadData];
            }else
            {
                [SVProgressHUD showErrorWithStatus:[responseObject valueForKeyWithOutNSNull:@"text"]];
            }
            NSLog(@"respinseDic===%@",[responseObject objectForKey:@"text"]);
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject){
            NSLog(@"登录接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}
-(void)creatTableHeaderView
{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50)];
    _headerView.backgroundColor = [CWNSFileUtil colorWithHexString:@"#eeeeee"];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton setTitle:@"我收到的评价()" forState:UIControlStateNormal];
    _leftButton.frame = CGRectMake(0, 10, kSCREEN_WIDTH/2, 30);
    _leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_leftButton addTarget:self action:@selector(segmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH/2 - 1, 15, 1, 20)];
    lineView.backgroundColor = [UIColor grayColor];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setTitle:@"我给出的评价()" forState:UIControlStateNormal];
    _rightButton.frame = CGRectMake(kSCREEN_WIDTH/2, 10, kSCREEN_WIDTH/2 - 1, 30);
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_rightButton addTarget:self action:@selector(segmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_leftButton];
    [_headerView addSubview:_rightButton];
    [_headerView addSubview:lineView];
    _contentTableView.tableHeaderView = _headerView;
    
    [self.contentTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [self.contentTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
-(void)refreshData
{
    if (_leftButton.selected) {
        [self getBaseUserInfoDic];
        [self getEvaluateMeServiceDataFromServicePage:1 andRefresh:YES];
    }else
    {
        [self getMeEvaluatPatientServiceDataFromServicePage:1 andRefresh:YES];
    }
    
}
-(void)loadMoreData
{
    morePage++;
    if (leftDataArray.count==LeftTotalDataNum||rightDataArray.count==rightTotalDataNum){
        [self.contentTableView.footer noticeNoMoreData];
    }else
    {
        if (_leftButton.selected) {
            [self getEvaluateMeServiceDataFromServicePage:morePage andRefresh:NO];
        }
        if (_rightButton.selected) {
            [self getMeEvaluatPatientServiceDataFromServicePage:morePage andRefresh:NO];
        }
    }
}
- (void)segmentButtonAction:(UIButton *)button {
    if (button==_leftButton) {
        if (!button.selected) {
          button.selected=!button.selected;
            _rightButton.selected=NO;
            [self getEvaluateMeServiceDataFromServicePage:1 andRefresh:YES];
        }
    }if (button==_rightButton) {
        if (!button.selected) {
            button.selected=!button.selected;
            _leftButton.selected=NO;
            [self getMeEvaluatPatientServiceDataFromServicePage:1 andRefresh:YES];
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_leftButton.selected) {
        return leftDataArray.count+1;
    }else{
        return rightDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_leftButton.selected){
        if (indexPath.row==0) {
            if (_expand) {
                OneSpecialCell*  cell = [tableView dequeueReusableCellWithIdentifier:@"OneSpecialCell"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.controller=self;
                [cell configeCellDataWith:dataDic];
                return cell;
            }else
            {
                UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
                if (!cell) {
                    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                }else
                {
                    for (id view in cell.contentView.subviews) {
                        [view removeFromSuperview];
                    }
                }
                cell.backgroundColor=[CWNSFileUtil colorWithHexString:@"#eeeeee"];
                UILabel *mainLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 56, 13)];
                mainLabel.text=@"总体评价:";
                mainLabel.font=[UIFont systemFontOfSize:13];
                [cell.contentView addSubview:mainLabel];
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(77, 10, 85, 13)];
                imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"star%@",[dataDic objectForKey:@"totalGrade"]]];
                [cell.contentView addSubview:imageView];
                UILabel *scoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(170, 10, 40, 13)];
                scoreLabel.text=[NSString stringWithFormat:@"%@分",[dataDic objectForKey:@"totalGrade"]];
                [cell.contentView addSubview:scoreLabel];
                
                
                detailButt=[UIButton buttonWithType:UIButtonTypeCustom];
                detailButt.frame=CGRectMake(kSCREEN_WIDTH-70, 10, 50, 21);
                [detailButt setBackgroundImage:[UIImage imageNamed:@"0_152"] forState:UIControlStateNormal];
                [detailButt setBackgroundImage:[UIImage imageNamed:@"0_152"] forState:UIControlStateSelected];
                [detailButt setTitle:@"详情" forState:UIControlStateNormal];
                detailButt.titleLabel.font=[UIFont systemFontOfSize:14];
                [detailButt addTarget:self action:@selector(expandButtAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:detailButt];
                return cell;
            }
        }else
        {
             if ([[[leftDataArray objectAtIndex:indexPath.row-1] objectForKey:@"expand"]isEqualToString:@"1"]) {
              MyRecieveEvaluateCell * cell= [tableView dequeueReusableCellWithIdentifier:@"MyRecieveEvaluateCell"];
                 cell.expandButt.tag=indexPath.row;
                 [cell configeCellData:[leftDataArray objectAtIndex:indexPath.row-1]];
                [cell.expandButt addTarget:self action:@selector(cellExpandButtAction:) forControlEvents:UIControlEventTouchUpInside];
                 return cell;
             }else
             {
                MyRecieveEvaluatNoExpandCell * cell= [tableView dequeueReusableCellWithIdentifier:@"MyRecieveEvaluatNoExpandCell"];
                 cell.expandButt.tag=indexPath.row;
                  [cell configeCellData:[leftDataArray objectAtIndex:indexPath.row-1]];
                  [cell.expandButt addTarget:self action:@selector(cellNoExpandButtAction:) forControlEvents:UIControlEventTouchUpInside];
                 return cell;
             }
        }
     }else {
          if ([[[rightDataArray objectAtIndex:indexPath.row] objectForKey:@"expand"]isEqualToString:@"1"]) {
              MyEvaluatPatientCell *cell= [tableView dequeueReusableCellWithIdentifier:@"MyEvaluatPatientCell"];
              [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
              cell.expandButt.tag=indexPath.row;
              [cell configeCellData:[rightDataArray objectAtIndex:indexPath.row]];
              [cell.expandButt addTarget:self action:@selector(meEvaluatePatientCellExpandButtAction:) forControlEvents:UIControlEventTouchUpInside];
              [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                return cell;
          }else{
              MyEvaluatPatientNoExpandCell *cell= [tableView dequeueReusableCellWithIdentifier:@"MyEvaluatPatientNoExpandCell"];
             
              cell.expandButt.tag=indexPath.row;
              [cell configeCellData:[rightDataArray objectAtIndex:indexPath.row]];
              [cell.expandButt addTarget:self action:@selector(meEvaluatePatientCellNoExpandButtAction:) forControlEvents:UIControlEventTouchUpInside];
               [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
              [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
              return cell;
          }
      }
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_leftButton.selected) {
        if (indexPath.row==0) {
            if (_expand) {
                return 103;
            }else
            {
             return 33;
            }
        }else
        {
            if ([[[leftDataArray objectAtIndex:indexPath.row-1] objectForKey:@"expand"]isEqualToString:@"1"]) {
                NSString *string=[[leftDataArray objectAtIndex:indexPath.row-1] objectForKey:@"dComment"];
                CGRect  rect=[string boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-40, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
                  return   rect.size.height+130;
            }else
            {
                return 121;
            }
        }
    } else {
        if ([[[rightDataArray objectAtIndex:indexPath.row] objectForKey:@"expand"]isEqualToString:@"1"]) {
            NSString *string=[[rightDataArray objectAtIndex:indexPath.row] objectForKey:@"uComment"];
            CGRect  rect=[string boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-85, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
            NSLog(@"rect.size.height==%f",rect.size.height);
            if (rect.size.height<=43) {
                return 124;
            }else
            {
             return   rect.size.height+85;
            }
        }else
        {
            return 124;
        }
    }
}
- (void)cellExpandButtAction:(UIButton *)sender{
    NSMutableDictionary *dic=[[leftDataArray objectAtIndex:sender.tag-1] mutableCopy];
    [dic setObject:@"0" forKey:@"expand"];
    [leftDataArray replaceObjectAtIndex:sender.tag-1 withObject:dic];
    [self.contentTableView reloadData];
}
-(void)cellNoExpandButtAction:(UIButton*)sender
{
    NSMutableDictionary *dic=[[leftDataArray objectAtIndex:sender.tag-1] mutableCopy];
    [dic setObject:@"1" forKey:@"expand"];
    [leftDataArray replaceObjectAtIndex:sender.tag-1 withObject:dic];
    [self.contentTableView reloadData];
}
-(void)meEvaluatePatientCellExpandButtAction:(UIButton*)sender
{
    NSMutableDictionary *dic=[[rightDataArray objectAtIndex:sender.tag] mutableCopy];
    [dic setObject:@"0" forKey:@"expand"];
    [rightDataArray replaceObjectAtIndex:sender.tag withObject:dic];
    [self.contentTableView reloadData];
}
-(void)meEvaluatePatientCellNoExpandButtAction:(UIButton*)sender
{
    NSMutableDictionary *dic=[[rightDataArray objectAtIndex:sender.tag] mutableCopy];
    [dic setObject:@"1" forKey:@"expand"];
    [rightDataArray replaceObjectAtIndex:sender.tag withObject:dic];
    [self.contentTableView reloadData];
}
-(void)expandButtAction:(UIButton*)butt
{
    self.expand=YES;
    [self.contentTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
