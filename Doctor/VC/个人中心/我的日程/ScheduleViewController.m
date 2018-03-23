//
//  ScheduleViewController.m
//  YSProject
//
//  Created by cuiw on 15/5/31.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "ScheduleViewController.h"
#import "NSDate+Convenience.h"
#import "NSDateAdditions.h"
#import "NSDate+FSExtension.h"
#import "TabBarViewController.h"
#import "SettingDateViewController.h"
#import "ZhangPatientListController.h"
#import "WBCalendarView.h"
@interface ScheduleViewController ()<WBCalendarMonthViewDelegate>
{
    CWHttpRequest *request;
    int dataArrayIndex;
    NSMutableDictionary *dataDic;
    NSMutableArray *dataArray;
}
@property (weak, nonatomic) IBOutlet WBCalendarView *calender;


@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"我的日程"];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.calender.monthViewDelegate = self;
    dataArrayIndex=0;
//    _calender.appearance.cellStyle=FSCalendarCellStyleRectangle;
    [self addBackButt];
    [self creatUIItem];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(TabBarViewController*)self.tabBarController  tabbarImageView].hidden=YES;
     self.calender.selectedDate = [NSDate date];
}

-(void)creatUIItem
{
    UIImageView* OneButtImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-80, kSCREEN_WIDTH, 80)];
    OneButtImageView.image=[UIImage imageNamed:@"0_359"];
    [self.view addSubview:OneButtImageView];
    OneButtImageView.userInteractionEnabled=YES;
    UIButton *itemButt=[UIButton buttonWithType:UIButtonTypeCustom];
    itemButt.frame=CGRectMake(kSCREEN_WIDTH/2-20, 20, 40, 40);
    [itemButt setImage:[UIImage imageNamed:@"0_219"] forState:UIControlStateNormal];
    [itemButt setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    [itemButt addTarget:self action:@selector(settingTimeAction) forControlEvents:UIControlEventTouchUpInside];
    [OneButtImageView addSubview:itemButt];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2-70, 60, 140, 20)];
    titleLabel.text=@"设置预约时间";
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:10];
    [OneButtImageView addSubview:titleLabel];
    
    
//    _calender.appearance.headerMinimumDissolvedAlpha = 1.0;
//    _calender.appearance.headerDateFormat=@"yyyy年MM月";
//    _calender.appearance.headerTitleColor=[UIColor blackColor];
}
- (void)getWorkTimeDataBetweenDay1:(NSDate*)date1 andDate2:(NSDate*)date2{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSInteger uid=[[UserManager currentUserManager].user.uid integerValue];
        NSDictionary *jsonDictionary = @{@"did":[NSNumber numberWithInteger:uid],@"day1":date1,@"day2":date2,@"SessionID":sessionID};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, WorkTimeOrderNum] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"服务项目接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0) {
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                dataArray=[[responseObject objectForKey:@"data"] mutableCopy];
            }
             [_calender reload];
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"服务项目接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
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
                
                [userManager synchronize];
                dataDic=[[responseObject objectForKey:@"data"] mutableCopy];
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


-(void)getServiceDataFromServiceType:(NSString*)type andPage:(NSInteger)page AndDate:(NSDate*)date andRefresh:(BOOL)refresh
{
    if ([Reachability checkNetCanUse]){
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"stype":@"0",@"SessionID": sessionID,@"page":[NSNumber numberWithInteger:page],@"size":@"5",@"day":date};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, SearchOrder] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0){
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
               NSInteger  totalDataNum=[[[responseObject objectForKey:@"data"] objectForKey:@"total"] integerValue];
                if (totalDataNum!=0){
                    ZhangPatientListController *patientListController=[[ZhangPatientListController alloc]init];
                    patientListController.requestDate=date;
                    [self.navigationController pushViewController:patientListController animated:YES];
                }
                else
                {
                    [SVProgressHUD showSuccessWithStatus:@"没有数据" duration:2];
                }
            }else
            {
                [SVProgressHUD showErrorWithStatus:[responseObject valueForKeyWithOutNSNull:@"text"]];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"登录接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}
/*
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date{
   
}
- (void)calendarCurrentMonthDidChange:(FSCalendar *)calendar{
    NSDate *date1=[calendar.currentDate cc_dateByMovingToFirstDayOfTheMonth];
    NSDate *date2=[calendar.currentDate fs_lastDayOfMonth];
    [self getWorkTimeDataBetweenDay1:date1 andDate2:date2];
}
*/
-(void)settingTimeAction
{
    SettingDateViewController *settingDateController=[[SettingDateViewController alloc]init];
    [self.navigationController pushViewController:settingDateController animated:YES];
}




//wbDelegate-------------
- (void)calendarViewDidChangeToYear:(NSInteger)year month:(NSInteger)month
{
    NSDate *date1=[self.calender.selectedDate cc_dateByMovingToFirstDayOfTheMonth];
    NSDate *date2=[self.calender.selectedDate fs_lastDayOfMonth];
    [self getWorkTimeDataBetweenDay1:date1 andDate2:date2];
}
- (void)calendarMonthView:(WBCalendarMonthView *)monthView didSelectedDate:(NSDate *)date{
     [self getServiceDataFromServiceType:@"0" andPage:1 AndDate:date andRefresh:YES];
}
- (NSString *)calendarMonthView:(WBCalendarMonthView *)monthView titleForDate:(NSDate *)date{
    if (dataArray.count==0) {
        return nil;
    }
    NSDictionary *tempdic=[dataArray objectAtIndex:dataArrayIndex];
    if ([[NSDate stringFromDate:date format:@"yyyy-MM-dd"] isEqualToString:[tempdic objectForKey:@"uDay"]]){
        dataArrayIndex+=1;
        if (dataArrayIndex==dataArray.count) {
            dataArrayIndex=0;
        }
        return [tempdic objectForKey:@"num"];
    }else{
        return  nil;
    }

}
/*
- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    for (NSDictionary *dic in dataArray) {
        NSDate *eventDate=[NSDate dateFromString:[dic objectForKey:@"uDay"] format:@"yyy-MM-dd"];
        NSDate *calenderDate=[date fs_dateByIgnoringTimeComponents];
        if ([calenderDate isEqualToDate:eventDate]) {
            return [dic objectForKey:@"num"];
        }else{
            return nil;
        }
    }
    return nil;
}
 
- (UIImage *)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date{
//    for (NSDictionary *dic in dataArray) {
//        NSDate *eventDate=[NSDate dateFromString:[dic objectForKey:@"uDay"] format:@"yyy-MM-dd"];
//        if ([date isEqualToDate:eventDate]) {
//            return [UIImage imageNamed:@"0_198"];
//        }else{
//            return nil;
//        }
//    }
    return nil;
}
 */
/*
- (BOOL)calendar:(FSCalendar *)calendar hasEventForDate:(NSDate *)date{
    for (NSDictionary *dic in dataArray) {
        NSDate *eventDate=[NSDate dateFromString:[dic objectForKey:@"uDay"] format:@"yyy-MM-dd"];
        if ([date isEqualToDate:eventDate]) {
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
}
-(NSArray*)havePatientdateForCalender{

    return dataArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/
@end
