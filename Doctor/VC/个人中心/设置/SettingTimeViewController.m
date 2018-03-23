//
//  SettingTimeViewController.m
//  YSProject
//
//  Created by cuiw on 15/6/4.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "SettingTimeViewController.h"
#import "TimeModel.h"
#import "CalenderViewController.h"
#import "NSDate+FSExtension.h"
#import "JSONKit.h"
#import "ZhangSettingTimeCell.h"
#import "UIBlockAlertView.h"
@interface SettingTimeViewController ()<DateDelegate>
{
    NSArray *_timeArray;
    CWHttpRequest *request;
    NSMutableArray *dataArray;
    NSMutableArray *finalArray;
}

@property (weak, nonatomic) IBOutlet UITableView *timeTableView;
@property (weak, nonatomic) IBOutlet CWTextField *startTimeField;
@property (weak, nonatomic) IBOutlet CWTextField *endTimeField;
@property (nonatomic,assign) NSInteger goInType;

@end

@implementation SettingTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"设置预约时间"];
    [self addBackButt];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    finalArray=[NSMutableArray array];
    [self.timeTableView registerNib:[UINib nibWithNibName:@"ZhangSettingTimeCell" bundle:nil] forCellReuseIdentifier:@"ZhangSettingTimeCell"];
    if (self.editOrNot) {
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat=@"yyyy-MM-dd";
        NSDate *date1=[formatter dateFromString:[_dictionary objectForKey:@"date1"]];
        NSDate *date2=[formatter dateFromString:[_dictionary objectForKey:@"date2"]];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *date11= [formatter  stringFromDate:date1];
        NSString *date22= [formatter  stringFromDate:date2];
        self.startTimeField.text=date11;
        self.endTimeField.text=date22;
        for (int i=0; i<[[_dictionary objectForKey:@"time"] count]; i++) {
            NSDictionary *dic=[[_dictionary objectForKey:@"time"] objectAtIndex:i];
            [finalArray addObject:@{@"time1":[dic objectForKey:@"time1"],@"time2":[dic objectForKey:@"time2"]}];
        }
    }
    [self getDoctorWorkTime];
    [self createTableHeaderView];
    [self setTextFieldRightButt];
   
}



-(void)setTextFieldRightButt
{
    UIButton *startbutt=[UIButton buttonWithType:UIButtonTypeCustom];
    startbutt.frame=CGRectMake(0, 5, 30, 20);
    [startbutt setImage:[UIImage imageNamed:@"uc_setting_icon_time"] forState:UIControlStateNormal];
    startbutt.tag=100;
     [startbutt addTarget:self action:@selector(goSettingDateController:) forControlEvents:UIControlEventTouchUpInside];
    startbutt.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 10);
    self.startTimeField.rightView=startbutt;
    self.startTimeField.rightViewMode=UITextFieldViewModeAlways;

    
    UIButton *endbutt=[UIButton buttonWithType:UIButtonTypeCustom];
    endbutt.frame=CGRectMake(0, 5, 30, 20);
    [endbutt setImage:[UIImage imageNamed:@"uc_setting_icon_time"] forState:UIControlStateNormal];
    endbutt.tag=200;
    [endbutt addTarget:self action:@selector(goSettingDateController:) forControlEvents:UIControlEventTouchUpInside];
    endbutt.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 10);
    self.endTimeField.rightView=endbutt;
    self.endTimeField.rightViewMode=UITextFieldViewModeAlways;
}
-(void)goSettingDateController:(UIButton*)butt
{
    if (butt.tag==100) {
        self.goInType=100;
        CalenderViewController *calenderController=[[CalenderViewController alloc]init];
        calenderController.titleString=@"设置开始时间";
        calenderController.delegate=self;
        [self.navigationController pushViewController:calenderController animated:YES];
    }else
    {
        self.goInType=200;
        CalenderViewController *calenderController=[[CalenderViewController alloc]init];
        calenderController.titleString=@"设置结束时间";
        calenderController.delegate=self;
        [self.navigationController pushViewController:calenderController animated:YES];
    }
}
-(void)createTableHeaderView
{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 30)];
    headerLabel.text=@"选择时段";
    [headerView addSubview:headerLabel];
    self.timeTableView.tableHeaderView=headerView;
}
//获得医生工作时间段 按照日期
- (void)getDoctorWorkTime{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"SessionID":sessionID};
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, WorkTimeData] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"时间段接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0){
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                [userManager synchronize];
                dataArray=[[responseObject objectForKey:@"data"] mutableCopy];
                [self.timeTableView reloadData];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"时间段接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}
- (void)setWorkTime:(NSString*)date1 andDate:(NSString*)date2 andOldDate1:(NSString*)oldDate1 andOldDate2:(NSString*)oldDate2 andwTimes:(NSMutableArray*)timesArray andDtype:(NSInteger)type{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSString *arrayString=[timesArray JSONString];
        NSDictionary *jsonDictionary;
        if (date1==nil||date2==nil) {
            [SVProgressHUD showErrorWithStatus:@"请选择日期"];
            return;
        }else
        {
            if (oldDate1==nil){
                jsonDictionary = @{@"date1":date1,@"date2":date2,@"SessionID":sessionID,@"dType":[NSNumber numberWithInteger:type],@"wTimes":arrayString};
            }else
            {
                jsonDictionary = @{@"date1":date1,@"date2":date2,@"SessionID":sessionID,@"oldDate1":oldDate1,@"oldDate2":oldDate2,@"dType":[NSNumber numberWithInteger:type],@"wTimes":arrayString};
            }
        }
        NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, SetWorkTime] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"添加编辑工作时间接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0){
                [[UpdateUserData shareInstance] updateUserInfo];
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                [SVProgressHUD showErrorWithStatus:[responseObject valueForKeyWithOutNSNull:@"text"] duration:5];
                NSLog(@"%@",[responseObject valueForKeyWithOutNSNull:@"text"]);
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"添加编辑工作时间接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}
- (void)checkHadOrder:(NSString*)date1 andDate:(NSString*)date2  andTime1:(NSString*)time1 andTime2:(NSString*)time2{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"day1":date1,@"day2":date2,@"SessionID":sessionID,@"did":[UserManager currentUserManager].user.uid};
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
                    [SVProgressHUD showErrorWithStatus:@"修改失败，请先处理待确认预约"];
                }else
                {
                    if ([[[responseObject objectForKey:@"data"]objectForKey:@"val2"] boolValue]) {
                        UIBlockAlertView *alertView=[[UIBlockAlertView alloc]initWithTitle:nil message:@"您的时间已被预定，您确认使用新的时间设置吗？" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" cancelblock:^{
                            [self.navigationController popViewControllerAnimated:YES];
                        } otherBlock:^{
                            NSDate *tempDate1=[NSDate dateFromString:_startTimeField.text format:@"YYYY年MM月dd日"];
                            NSDate *tempDate2=[NSDate dateFromString:_endTimeField.text format:@"YYYY年MM月dd日"];
                            NSString *newDate1=[tempDate1  fs_stringWithFormat:@"YYYY-MM-dd"];
                            NSString *newDate2=[tempDate2 fs_stringWithFormat:@"YYYY-MM-dd"];
                            [self setWorkTime:newDate1 andDate:newDate2 andOldDate1:date1 andOldDate2:date2 andwTimes:finalArray andDtype:1];
                        }];
                        [alertView show];
                    }else
                    {
                        NSDate *tempDate1=[NSDate dateFromString:_startTimeField.text format:@"YYYY年MM月dd日"];
                        NSDate *tempDate2=[NSDate dateFromString:_endTimeField.text format:@"YYYY年MM月dd日"];
                        NSString *newDate1=[tempDate1  fs_stringWithFormat:@"YYYY-MM-dd"];
                        NSString *newDate2=[tempDate2 fs_stringWithFormat:@"YYYY-MM-dd"];
                        [self setWorkTime:newDate1 andDate:newDate2 andOldDate1:date1 andOldDate2:date2 andwTimes:finalArray andDtype:1];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZhangSettingTimeCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ZhangSettingTimeCell"];
    cell.selectButt.tag=indexPath.row+1;
    [cell.selectButt addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
     cell.timeLabel.text = [NSString stringWithFormat:@"%@-%@",[dataArray[indexPath.row]  objectForKey:@"time1"],[dataArray[indexPath.row]  objectForKey:@"time2"]];
        if ([finalArray containsObject:dataArray[indexPath.row]]) {
            cell.selectButt.selected=YES;
        }else{
            cell.selectButt.selected=NO;
        }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
      UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        UIButton *butt=(UIButton*)[cell.contentView viewWithTag:indexPath.row+1];
        butt.selected=!butt.selected;
        if (butt.selected){
            NSDictionary *tempDic=@{@"time1":[dataArray[indexPath.row]  objectForKey:@"time1"],@"time2":[dataArray[indexPath.row]objectForKey:@"time2"]};
            [finalArray addObject:tempDic];
        }else
        {
            if ([finalArray containsObject:@{@"time1":[dataArray[indexPath.row]  objectForKey:@"time1"],@"time2":[dataArray[indexPath.row]objectForKey:@"time2"]}]) {
                [finalArray removeObject:@{@"time1":[dataArray[indexPath.row]  objectForKey:@"time1"],@"time2":[dataArray[indexPath.row]objectForKey:@"time2"]}];
            }
        }
}
-(void)itemSelected:(UIButton*)butt
{
        butt.selected=!butt.selected;
        if (butt.selected){
            if (![finalArray containsObject:@{@"time1":[dataArray[butt.tag-1]  objectForKey:@"time1"],@"time2":[dataArray[butt.tag-1]objectForKey:@"time2"]}]) {
                NSDictionary *tempDic=@{@"time1":[dataArray[butt.tag-1]  objectForKey:@"time1"],@"time2":[dataArray[butt.tag-1]objectForKey:@"time2"]};
                [finalArray addObject:tempDic];
            }else
            {
                return;
            }
        }else
        {
            if ([finalArray containsObject:@{@"time1":[dataArray[butt.tag-1]  objectForKey:@"time1"],@"time2":[dataArray[butt.tag-1]objectForKey:@"time2"]}]) {
                [finalArray removeObject:@{@"time1":[dataArray[butt.tag-1]  objectForKey:@"time1"],@"time2":[dataArray[butt.tag-1]objectForKey:@"time2"]}];
            }
        }
}
- (IBAction)commitButtAction:(UIButton *)sender {
    if (self.editOrNot) {
        [self checkHadOrder:[_dictionary objectForKey:@"date1"] andDate:[_dictionary objectForKey:@"date2"]andTime1:[[finalArray objectAtIndex:0] objectForKey:@"time1"] andTime2:[[finalArray lastObject] objectForKey:@"time2"]];
    }else
    {
        NSDate *tempDate1=[NSDate dateFromString:_startTimeField.text format:@"YYYY年MM月dd日"];
        NSDate *tempDate2=[NSDate dateFromString:_endTimeField.text format:@"YYYY年MM月dd日"];
        NSString *newDate1=[tempDate1  fs_stringWithFormat:@"YYYY-MM-dd"];
        NSString *newDate2=[tempDate2 fs_stringWithFormat:@"YYYY-MM-dd"];
         [self setWorkTime:newDate1 andDate:newDate2 andOldDate1:nil andOldDate2:nil andwTimes:finalArray andDtype:0];
    }
}
-(void)passRetureDate:(NSDate *)date
{
     NSString *dateString=[NSDate stringFromDate:date format:@"YYYY年MM月dd日"];
    if (self.goInType==100) {
       self.startTimeField.text=dateString;
    }if (self.goInType==200) {
        self.endTimeField.text=dateString;
    }
    /*
    NSDate *tempDate1=[NSDate dateFromString:_startTimeField.text format:@"YYYY年MM月dd日"];
    NSDate *tempDate2=[NSDate dateFromString:_endTimeField.text format:@"YYYY年MM月dd日"];
    if ([tempDate1 compare:tempDate2]==NSOrderedDescending) {
        [ShowViewCenterViewController showAlertViewWithTitle:nil message:@"工作结束时间早于工作开始时间" cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:nil cancelBlock:nil otherBlock:nil];
        self.endTimeField.text=nil;
        return;
    }
    for (NSDictionary *tempDic in _recieveDataArray) {
        NSDate *date1=[NSDate fs_dateFromString:[tempDic objectForKey:@"date1"] format:@"yyyy-MM-dd"];
        NSDate *date2=[NSDate fs_dateFromString:[tempDic objectForKey:@"date2"] format:@"yyyy-MM-dd"];
        if ([tempDate1 compare:date2]==NSOrderedDescending||[tempDate2 compare:date1]==NSOrderedAscending){
            return;
        }else
        {
            [ShowViewCenterViewController showAlertViewWithTitle:nil message:@"设置工作时间冲突，请重新选择日期!" cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:nil cancelBlock:nil otherBlock:nil];
            self.startTimeField.text=nil;
            self.endTimeField.text=nil;
            return;
        }
    }
     */
}

- (IBAction)beginJumpSelectedDate:(id)sender {
    self.goInType=100;
    CalenderViewController *calenderController=[[CalenderViewController alloc]init];
    calenderController.titleString=@"设置开始时间";
    calenderController.delegate=self;
    [self.navigationController pushViewController:calenderController animated:YES];
}

- (IBAction)overJumpSelectedDate:(id)sender {
    self.goInType=200;
    CalenderViewController *calenderController=[[CalenderViewController alloc]init];
    calenderController.titleString=@"设置结束时间";
    calenderController.delegate=self;
    [self.navigationController pushViewController:calenderController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
