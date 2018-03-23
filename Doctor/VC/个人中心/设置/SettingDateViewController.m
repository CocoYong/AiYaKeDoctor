//
//  SettingDateViewController.m
//  YSProject
//
//  Created by cuiw on 15/6/4.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "SettingDateViewController.h"
#import "SettingTimeViewController.h"
#import "NSDate+FSExtension.h"
#import "UIBlockAlertView.h"
@interface SettingDateViewController ()
{
    NSMutableArray *workListArray;
    CWHttpRequest *request;
    NSMutableArray *dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *baseTable;
@property (nonatomic,strong)NSIndexPath *indexPath;
@end

@implementation SettingDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self creatNavgationBarWithTitle:@"设置预约时间"];
    [self addBackButt];
    [self creatTableHeaderView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [workListArray removeAllObjects];
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
            if ([code integerValue]==0){
                [[CWNSFileUtil sharedInstance] setNSModelToUserDefaults:responseObject withKey:@"userData"];
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                workListArray=[[[responseObject objectForKey:@"data"] objectForKey:@"workTimeList"] mutableCopy];
                [self.baseTable reloadData];
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
#pragma mark----tableViewDelegate-------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [workListArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray*tempArray= [[workListArray objectAtIndex:indexPath.row] objectForKey:@"time"];
    return (tempArray.count+1)*30+30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier=@"cellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }else
    {
        for (id view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    cell.backgroundColor=[UIColor hexColor:@"#eeeeee"];
    [self configerTableViewCell:cell withIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    tableView.tableFooterView=[UIView new];
    return cell;
}
-(void)configerTableViewCell:(UITableViewCell*)cell withIndexPath:(NSIndexPath*)indexPath
{
    NSDictionary *timeDic=[workListArray objectAtIndex:indexPath.row];
    NSDate *date1=[NSDate fs_dateFromString:[timeDic objectForKey:@"date1"] format:@"yyyy-MM-dd"];
    NSDate *date2=[NSDate fs_dateFromString:[timeDic objectForKey:@"date2"] format:@"yyyy-MM-dd"];
    NSString *date11=[date1 fs_stringWithFormat:@"yyyy年MM月dd日"];
    NSString *date22=[date2 fs_stringWithFormat:@"yyyy年MM月dd日"];
  
    
    
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(10, 5, kSCREEN_WIDTH-20, ([[timeDic objectForKey:@"time"] count]+1)*30+20)];
    backView.tag=(indexPath.row+1)*100;
    backView.layer.cornerRadius=5.0f;
    backView.backgroundColor=[UIColor whiteColor];
    backView.autoresizesSubviews=YES;
    [cell.contentView addSubview:backView];
    
    /*
    UIButton *towardsButt=[UIButton buttonWithType:UIButtonTypeCustom];
    towardsButt.tag=indexPath.row*2;
    towardsButt.frame=CGRectMake(CGRectGetMaxX(backView.frame)-50, CGRectGetMidY(backView.frame)-15, 30, 30);

    [towardsButt setImage:[UIImage imageNamed:@"0_07"] forState:UIControlStateNormal];
    [towardsButt setImage:[UIImage imageNamed:@"0_09"] forState:UIControlStateSelected];
    [towardsButt addTarget:self action:@selector(towardsButtAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:towardsButt];
     */
    
    
    UIButton *deleteButt=[UIButton buttonWithType:UIButtonTypeCustom];
    deleteButt.frame=CGRectMake(kSCREEN_WIDTH, 0, kSCREEN_WIDTH, CGRectGetHeight(backView.frame)+10);
    [deleteButt setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    deleteButt.tag=indexPath.row*2+1;
    [deleteButt setImage:[UIImage imageNamed:@"0_26"] forState:UIControlStateNormal];
    [deleteButt setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [deleteButt setBackgroundColor:[CWNSFileUtil colorWithHexString:@"#eeeeee"]];
    deleteButt.imageEdgeInsets=UIEdgeInsetsMake(0, 25, 0, 0);
    deleteButt.titleEdgeInsets=UIEdgeInsetsMake(0, 25, 0, 0);
//    [deleteButt addTarget:self action:@selector(deleteCellWithIndex:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:deleteButt];
    
    
    UILabel *yearLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, kSCREEN_WIDTH-20, 20)];
    yearLabel.text=[NSString stringWithFormat:@"%@-%@",date11,date22];
    [backView addSubview:yearLabel];
    
    UILabel *shiduanLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 35, 40, 20)];
    shiduanLabel.text=@"时段:";
    [backView addSubview:shiduanLabel];
    
    for (int i=0; i<[[timeDic objectForKey:@"time"] count]; i++) {
        NSDictionary *tempDic=[[timeDic objectForKey:@"time"] objectAtIndex:i];
        UILabel *timeLabel=[[UILabel alloc]init];
        timeLabel.frame=CGRectMake(50, (5+25)*i+35, kSCREEN_WIDTH-70, 20);
        timeLabel.text=[NSString stringWithFormat:@"%@-%@",[tempDic objectForKey:@"time1"] ,[tempDic objectForKey:@"time2"]];
        [backView addSubview:timeLabel];
    }
}
//  编辑预约时间
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingTimeViewController *settingTimeController=[[SettingTimeViewController alloc]init];
    settingTimeController.editOrNot=YES;
    settingTimeController.dictionary=[workListArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:settingTimeController animated:YES];
}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"真的删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        UIBlockAlertView *alerView=[[UIBlockAlertView alloc]initWithTitle:@"" message:@"您的时间已被预定，您确认删除此时间设置吗？" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" cancelblock:^{
//            [self.baseTable reloadData];
//        } otherBlock:^{
            self.indexPath=indexPath;
            NSDictionary *timeDic=[workListArray objectAtIndex:indexPath.row];
            [self checkHadOrder:[timeDic objectForKey:@"date1"] andDate:[timeDic objectForKey:@"date2"]andTime1:[[[timeDic objectForKey:@"time"] objectAtIndex:0] objectForKey:@"time1"]  andTime2:[[[timeDic objectForKey:@"time"] lastObject] objectForKey:@"time2"]];
//        }];
//        [alerView show];
    }

}
/*
-(void)towardsButtAction:(UIButton*)towardsButt
{
    towardsButt.selected=!towardsButt.selected;
    UITableViewCell *cell=[_baseTable cellForRowAtIndexPath:[NSIndexPath indexPathForItem:towardsButt.tag/2 inSection:0]];
    UIView *backView=[cell.contentView viewWithTag:(towardsButt.tag/2+1)*100];
    if (towardsButt.selected) {
        backView.frame=CGRectMake(backView.frame.origin.x, backView.frame.origin.y, backView.frame.size.width-70, backView.frame.size.height);
        [cell.contentView viewWithTag:towardsButt.tag+1].hidden=NO;
        towardsButt.frame=CGRectMake(CGRectGetMaxX(backView.frame)-50, CGRectGetMidY(backView.frame)-15, 30, 30);
    }else
    {
        backView.frame=CGRectMake(backView.frame.origin.x, backView.frame.origin.y, backView.frame.size.width+70, backView.frame.size.height);
        towardsButt.frame=CGRectMake(CGRectGetMaxX(backView.frame)-50, CGRectGetMidY(backView.frame)-15, 30, 30);
        [cell.contentView viewWithTag:towardsButt.tag+1].hidden=YES;
    }
}

- (void)spesifyTimeCanOrder:(NSString*)time1 andTime:(NSString*)time2{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"date1":date1,@"date2":date2,@"SessionID":sessionID};
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, DeletWorkTime] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"删除工作时间接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
            if ([code integerValue]==0){
                UserManager *userManager=[UserManager currentUserManager];
                
                [userManager synchronize];
                [workListArray removeObjectAtIndex:self.indexPath.row];
                [self.baseTable reloadData];
            }else if([code integerValue]==2)
            {
                [SVProgressHUD showErrorWithStatus:[responseObject valueForKeyWithOutNSNull:@"text"]];
                [self.baseTable reloadData];
            }else
            {
                [SVProgressHUD showErrorWithStatus:[responseObject valueForKeyWithOutNSNull:@"text"]];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"删除工作时间接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}
 */

- (void)deleteWorkTime:(NSString*)date1 andDate:(NSString*)date2{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"date1":date1,@"date2":date2,@"SessionID":sessionID};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, DeletWorkTime] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"删除工作时间接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0){
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                [workListArray removeObjectAtIndex:self.indexPath.row];
                [self.baseTable reloadData];
            }else if([code integerValue]==2)
            {
                [SVProgressHUD showErrorWithStatus:[responseObject valueForKeyWithOutNSNull:@"text"]];
                [self.baseTable reloadData];
            }else
            {
                [SVProgressHUD showErrorWithStatus:[responseObject valueForKeyWithOutNSNull:@"text"]];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"删除工作时间接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}


- (void)checkHadOrder:(NSString*)date1 andDate:(NSString*)date2 andTime1:(NSString*)time1 andTime2:(NSString*)time2{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"day1":date1,@"day2":date2,@"SessionID":sessionID,@"did":[UserManager currentUserManager].user.uid,@"time1":time1,@"time2":time2};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, isOrder] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"删除工作时间接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0){
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                if ([[[responseObject objectForKey:@"data"]objectForKey:@"val"] boolValue]) {
                    [SVProgressHUD showErrorWithStatus:@"删除失败，请先处理待确认预约"];
                }else
                {
                    if ([[[responseObject objectForKey:@"data"]objectForKey:@"val2"] boolValue]) {
                        UIBlockAlertView *alertView=[[UIBlockAlertView alloc]initWithTitle:nil message:@"您的时间已被预定，您确认删除此时间设置吗？" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" cancelblock:^{
                            [alertView dismissWithClickedButtonIndex:0 animated:YES];
                        } otherBlock:^{
                            [self deleteWorkTime:date1 andDate:date2];
                        }];
                        [alertView show];
                    }else
                    {
                       [self deleteWorkTime:date1 andDate:date2];
                    }
                }
            }else
            {
               [SVProgressHUD showErrorWithStatus:[responseObject valueForKeyWithOutNSNull:@"text"]];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"删除工作时间接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}

-(void)creatTableHeaderView
{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
    headerView.backgroundColor=[UIColor hexColor:@"#eeeeee"];
    UIButton *addTimeButt=[UIButton buttonWithType:UIButtonTypeCustom];
    addTimeButt.frame=CGRectMake(20, 7, 150, 30);
    [addTimeButt setTitle:@"新建工作时间" forState:UIControlStateNormal];
    [addTimeButt setTitleColor:[CWNSFileUtil colorWithHexString:@"#3c6e87"] forState:UIControlStateNormal];
    [addTimeButt setImage:[UIImage imageNamed:@"0_20"] forState:UIControlStateNormal];
    [addTimeButt addTarget:self action:@selector(addWorkTime) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addTimeButt];
    self.baseTable.tableHeaderView=headerView;
}
-(void)addWorkTime
{
    SettingTimeViewController *settingTimeController=[[SettingTimeViewController alloc]init];
    settingTimeController.editOrNot=NO;
    settingTimeController.recieveDataArray=workListArray;
    [self.navigationController pushViewController:settingTimeController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
