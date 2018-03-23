//
//  HomeViewController.m
//  YSProject
//
//  Created by cuiw on 15/5/20.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "HomeViewController.h"
#import "GBSlideOutToUnlockView.h"
#import "PendingViewController.h"
#import "MessageListViewController.h"
#import "WaitingHandleViewController.h"
#import "TabBarViewController.h"
#import "EvaluateViewController.h"
#import "TTGlobalUICommon.h"
@interface HomeViewController () <GBSlideOutToUnlockViewDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *panView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorName;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self isBetweenFromHour:0 toHour:9]) {
        self.timeLabel.text=@"~早上好";
    }
    if ([self isBetweenFromHour:9 toHour:12]) {
        self.timeLabel.text=@"~上午好";
    }
    if ([self isBetweenFromHour:12 toHour:15]) {
        self.timeLabel.text=@"~中午好";
    }
    if ([self isBetweenFromHour:15 toHour:18]) {
        self.timeLabel.text=@"~下午好";
    }if ([self isBetweenFromHour:18 toHour:24]) {
        self.timeLabel.text=@"~晚上好";
    }
    self.doctorName.text=[NSString stringWithFormat:@"%@医生",[UserManager currentUserManager].user.name];
//    if (![[EaseMob sharedInstance].chatManager isLoggedIn] || ![[EaseMob sharedInstance].chatManager isAutoLoginEnabled]) {
//        [self loginEaseMob];
//    }
//    [self creatNavgationBarWithTitle:@"首页"];
//    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToSertainViewController:)];
//    [self.panView addGestureRecognizer:panGesture];
}
//-(void)loginEaseMob{
//    NSString *userid = [UserManager currentUserManager].user.uid;
//    NSString *password = [UserManager currentUserManager].user.hxPassword;
//    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userid
//                                                        password:password
//                                                      completion:
//     ^(NSDictionary *loginInfo, EMError *error) {
//         if (loginInfo && !error){
//             NSLog(@"😓😓😓😓😓😓😓😓😓😓😓😓😓😓😓😓😓😓😓😓😓😓====%@",loginInfo);
//             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
//             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
//         }else {
//             switch (error.errorCode) {
//                 case EMErrorServerNotReachable: {
//                     TTAlertNoTitle(@"连接服务器失败,无法正常聊天,请重新登录");
//                 }
//                     break;
//                 case EMErrorServerAuthenticationFailure: {
//                     TTAlertNoTitle(@"用户名或密码错误,无法正常聊天,请重新登录");
//                 }
//                     break;
//                 case EMErrorServerTimeout: {
//                     TTAlertNoTitle(@"连接服务器超时,无法正常聊天,请重新登录");
//                 }
//                     break;
//                 default:{
//                     //                     [self clearLocalData];
//                     TTAlertNoTitle(@"登录失败,无法正常聊天,请重新登录");
//                 }
//                     
//                     break;
//             }
//         }
//     } onQueue:nil];
//}
- (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour
{
    NSDate *date8 = [self getCustomDateWithHour:fromHour];
    NSDate *date23 = [self getCustomDateWithHour:toHour];
    
    NSDate *currentDate = [NSDate date];
    
    if ([currentDate compare:date8]==NSOrderedDescending && [currentDate compare:date23]==NSOrderedAscending)
    {
        return YES;
    }
    return NO;
}
- (NSDate *)getCustomDateWithHour:(NSInteger)hour
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [resultCalendar dateFromComponents:resultComps];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
    [(TabBarViewController*)self.tabBarController  tabbarImageView].hidden=NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonAction:(id)sender {
    UIButton *button = sender;
    NSInteger index = button.tag;
    switch (index) {
        case 100:
        {
            WaitingHandleViewController *waitHandleViewController = [[WaitingHandleViewController alloc] init];
            waitHandleViewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:waitHandleViewController animated:YES];
        }
            break;
        case 101:
        {
           TabBarViewController*tabbarController=(TabBarViewController*)self.tabBarController;
            [tabbarController selectItemIndex:1];

        }
            break;
        case 102:
        {
            TabBarViewController*tabbarController=(TabBarViewController*)self.tabBarController;
            [tabbarController selectItemIndex:2];
        }
            break;
        case 103:
        {
            EvaluateViewController *evaluateController=[[EvaluateViewController alloc]init];
            evaluateController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:evaluateController animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
