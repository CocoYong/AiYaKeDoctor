//
//  PendingDetailViewController.m
//  YSProject
//
//  Created by cuiw on 15/5/26.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "PendingDetailViewController.h"
#import "TabBarViewController.h"
#import "ChangeWaitingPendingTimeController.h"
#import "RefuseViewController.h"
#import "EvaluatePatientViewController.h"
@interface PendingDetailViewController ()<refuseDelegate,evaluatPatientDelegate,changeTimeDelegate>
{
    UIView *grayWindow;
    UIView *popUpWindow;
    CWHttpRequest *request;
    NSMutableDictionary *_orderDic;
}
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *serviceProjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pendingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *customNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *customSexLabel;
@property (weak, nonatomic) IBOutlet UILabel *customAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *customTelephoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *customContentLabel;

//三个view
@property (weak, nonatomic) IBOutlet UIView *patientEvaluatMe;
@property (weak, nonatomic) IBOutlet UIView *meEvaluatPatient;
@property (weak, nonatomic) IBOutlet UIView *refuseBackView;
//两个button
@property (weak, nonatomic) IBOutlet UIButton *completButt;
@property (weak, nonatomic) IBOutlet UIButton *evaluatPatientButt;
//patientEvaluatMe
@property (weak, nonatomic) IBOutlet UIImageView *serviceStar;
@property (weak, nonatomic) IBOutlet UIImageView *skillStar;
@property (weak, nonatomic) IBOutlet UIImageView *environmentStar;
@property (weak, nonatomic) IBOutlet UILabel *patientEvaluatMeLabel;
//meEvaluatePatient

@property (weak, nonatomic) IBOutlet UIImageView *totalStar;
@property (weak, nonatomic) IBOutlet UILabel *meEvaluatPatientLabel;
//refuseCause
@property (weak, nonatomic) IBOutlet UILabel *refuseCause;

//patientEvaluateMe------Height
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *evaluatMeViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottom;

@property (assign,nonatomic) NSInteger type;


@end

@implementation PendingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"预约详情"];
    [self addBackButt];
    self.edgesForExtendedLayout=UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets=NO;
    _orderDic=[_recieveDic mutableCopy];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(TabBarViewController*)self.tabBarController  tabbarImageView].hidden=YES;
    [self creatTabBarButtWith:[[_orderDic objectForKey:@"status"] integerValue]];
    [self configeDataForUI];
}
-(void)configeDataForUI
{
    self.serviceProjectLabel.attributedText=[self getAttributStringFromString:[NSString stringWithFormat:@"治疗项目:%@",[_orderDic objectForKey:@"itemsName"]] andRange:NSMakeRange(0, 5)];
    if ([[_orderDic objectForKey:@"status"] integerValue]==2) {
        self.serviceDateLabel.attributedText=[self getAttributStringFromString:[NSString stringWithFormat:@"预约日期:%@",[_orderDic objectForKey:@"dDay"]] andRange:NSMakeRange(0, 5)];
        self.pendingTimeLabel.attributedText=[self getAttributStringFromString:[NSString stringWithFormat:@"预约时段:%@-%@",[_orderDic objectForKey:@"dTime1"],[_orderDic objectForKey:@"dTime2"]] andRange:NSMakeRange(0, 5)];
    }else
    {
        self.serviceDateLabel.attributedText=[self getAttributStringFromString:[NSString stringWithFormat:@"预约日期:%@",[_orderDic objectForKey:@"uDay"]] andRange:NSMakeRange(0, 5)];
        self.pendingTimeLabel.attributedText=[self getAttributStringFromString:[NSString stringWithFormat:@"预约时段:%@-%@",[_orderDic objectForKey:@"uTime1"],[_orderDic objectForKey:@"uTime2"]] andRange:NSMakeRange(0, 5)];
    }
    self.serviceDateLabel.attributedText=[self getAttributStringFromString:[NSString stringWithFormat:@"预约日期:%@",[_orderDic objectForKey:@"uDay"]] andRange:NSMakeRange(0, 5)];
    self.pendingTimeLabel.attributedText=[self getAttributStringFromString:[NSString stringWithFormat:@"预约时段:%@-%@",[_orderDic objectForKey:@"uTime1"],[_orderDic objectForKey:@"uTime2"]] andRange:NSMakeRange(0, 5)];
    self.orderIDLabel.attributedText=[self getAttributStringFromString:[NSString stringWithFormat:@"订单号:%@",[_orderDic objectForKey:@"id"]] andRange:NSMakeRange(0, 4)];
    self.customNameLabel.attributedText=[self getAttributStringFromString:[NSString stringWithFormat:@"客户姓名:%@",[_orderDic objectForKey:@"name"]] andRange:NSMakeRange(0, 5)];

    self.customSexLabel.attributedText=[self getAttributStringFromString:[NSString stringWithFormat:@"客户性别:%@",[[_orderDic objectForKey:@"sex"] integerValue]==0?@"女":@"男"] andRange:NSMakeRange(0, 5)];
    self.customAgeLabel.attributedText=[self getAttributStringFromString:[NSString stringWithFormat:@"客户年龄:%@",[_orderDic objectForKey:@"age"]] andRange:NSMakeRange(0, 5)];
    self.customTelephoneLabel.attributedText=[self getAttributStringFromString:[NSString stringWithFormat:@"联系电话:%@",[_orderDic objectForKey:@"tel"]] andRange:NSMakeRange(0, 5)];
    NSMutableAttributedString *contentAttributString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"病情描述:%@",[_orderDic objectForKey:@"remark"]]];
    [contentAttributString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
    [contentAttributString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 5)];
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];;
    paragraphStyle.lineSpacing=10;
    [contentAttributString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentAttributString length])];
    self.customContentLabel.attributedText=contentAttributString;
}
-(NSMutableAttributedString*)getAttributStringFromString:(NSString*)textString andRange:(NSRange)range
{
    NSMutableAttributedString *contentAttributString=[[NSMutableAttributedString alloc]initWithString:textString];
    [contentAttributString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    [contentAttributString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:range];
    return contentAttributString;
}
-(void)creatTabBarButtWith:(NSInteger)type
{
    self.type=type;
    switch (type) {
        case -99://已取消
            self.statusImageView.image=[UIImage imageNamed:@"已取消"];
            self.completButt.hidden=YES;
            self.refuseBackView.hidden=YES;
            self.patientEvaluatMe.hidden=YES;
            self.meEvaluatPatient.hidden=YES;
            self.evaluatPatientButt.hidden=YES;
            break;
        case 1:
        case 3://已确认
            self.statusImageView.image=[UIImage imageNamed:@"0_192"];
            self.completButt.hidden=NO;
            self.refuseBackView.hidden=YES;
            self.patientEvaluatMe.hidden=YES;
            self.meEvaluatPatient.hidden=YES;
            self.meEvaluatPatient.hidden=YES;
            if ([self.view viewWithTag:1000]) {
              [[self.view viewWithTag:1000] removeFromSuperview];
            }
            break;
        case 0://待确认
            self.statusImageView.image=[UIImage imageNamed:@"待确认"];
            [self createThreeUIItem];
            self.completButt.hidden=YES;
            self.refuseBackView.hidden=YES;
            self.patientEvaluatMe.hidden=YES;
            self.evaluatPatientButt.hidden=YES;
            self.meEvaluatPatient.hidden=YES;
            break;
        case 2://待确认
            self.statusImageView.image=[UIImage imageNamed:@"待确认"];
            self.completButt.hidden=YES;
            self.refuseBackView.hidden=YES;
            self.patientEvaluatMe.hidden=YES;
            self.evaluatPatientButt.hidden=YES;
            self.meEvaluatPatient.hidden=YES;
            break;
        case 99://已完成
            self.statusImageView.image=[UIImage imageNamed:@"0_176"];
            self.completButt.hidden=YES;
            self.refuseBackView.hidden=YES;
            if ([[_orderDic objectForKey:@"dIsComment"] integerValue]==1&&[[_orderDic objectForKey:@"uIsComment"] integerValue]==1) {
              self.patientEvaluatMe.hidden=NO;
              self.meEvaluatPatient.hidden=NO;
              self.evaluatPatientButt.hidden=YES;
              self.serviceStar.image=[UIImage imageNamed:[NSString stringWithFormat:@"star%@",[_orderDic objectForKey:@"dGrade1"]]];
              self.skillStar.image=[UIImage imageNamed:[NSString stringWithFormat:@"star%@",[_orderDic objectForKey:@"dGrade2"]]];
              self.environmentStar.image=[UIImage imageNamed:[NSString stringWithFormat:@"star%@",[_orderDic objectForKey:@"dGrade3"]]];
              self.patientEvaluatMeLabel.text=[_orderDic objectForKey:@"dComment"];
              self.meEvaluatPatientLabel.text=[_orderDic objectForKey:@"uComment"];
              self.totalStar.image=[UIImage imageNamed:[NSString stringWithFormat:@"star%@",[_orderDic objectForKey:@"uGrade"]]];
            }if([[_orderDic objectForKey:@"dIsComment"] integerValue]==0&&[[_orderDic objectForKey:@"uIsComment"] integerValue]==1)
            {
                self.patientEvaluatMe.hidden=YES;
                self.meEvaluatPatient.hidden=NO;
                self.evaluatPatientButt.hidden=YES;
                self.meEvaluatPatientLabel.text=[_orderDic objectForKey:@"uComment"];
                self.totalStar.image=[UIImage imageNamed:[NSString stringWithFormat:@"star%@",[_orderDic objectForKey:@"uGrade"]]];
            }
            if([[_orderDic objectForKey:@"dIsComment"] integerValue]==1&&[[_orderDic objectForKey:@"uIsComment"] integerValue]==0)
            {
                self.patientEvaluatMe.hidden=NO;
                self.meEvaluatPatient.hidden=YES;
                self.evaluatPatientButt.hidden=NO;
                self.serviceStar.image=[UIImage imageNamed:[NSString stringWithFormat:@"star%@",[_orderDic objectForKey:@"dGrade1"]]];
                self.skillStar.image=[UIImage imageNamed:[NSString stringWithFormat:@"star%@",[_orderDic objectForKey:@"dGrade2"]]];
                self.environmentStar.image=[UIImage imageNamed:[NSString stringWithFormat:@"star%@",[_orderDic objectForKey:@"dGrade3"]]];
                self.patientEvaluatMeLabel.text=[_orderDic objectForKey:@"dComment"];
            }if([[_orderDic objectForKey:@"dIsComment"] integerValue]==0&&[[_orderDic objectForKey:@"uIsComment"] integerValue]==0)
            {
                self.patientEvaluatMe.hidden=YES;
                self.meEvaluatPatient.hidden=YES;
                self.evaluatPatientButt.hidden=NO;
            }
            break;
        case -2:
        case -1://已拒绝
            self.statusImageView.image=[UIImage imageNamed:@"0_186"];
            self.completButt.hidden=YES;
            self.refuseBackView.hidden=NO;
            self.patientEvaluatMe.hidden=YES;
            self.evaluatPatientButt.hidden=YES;
            self.meEvaluatPatient.hidden=YES;
            self.refuseCause.text=[_orderDic objectForKey:@"dRefuse"];
            break;
        default:
            break;
    }
    
}

-(void)createThreeUIItem
{
        UIImageView* OneButtImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-80, kSCREEN_WIDTH, 80)];
        OneButtImageView.image=[UIImage imageNamed:@"0_359"];
        OneButtImageView.tag=1000;
        [self.view addSubview:OneButtImageView];
        OneButtImageView.userInteractionEnabled=YES;
        NSArray *imageArray=@[@"0_219",@"0_173",@"0_222"];
        NSArray *titleArray=@[@"修改预约时间",@"确定",@"拒绝"];
        for (int i=0; i<3; i++) {
            UIButton *itemButt=[UIButton buttonWithType:UIButtonTypeCustom];
            itemButt.tag=(i+1)*100;
            itemButt.frame=CGRectMake(i*kSCREEN_WIDTH/3, 20, kSCREEN_WIDTH/3, 40);
            [itemButt setImage:[UIImage imageNamed:[imageArray objectAtIndex:i]] forState:UIControlStateNormal];
            [itemButt addTarget:self action:@selector(threeButtAction:) forControlEvents:UIControlEventTouchUpInside];
            [OneButtImageView addSubview:itemButt];
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(itemButt.center.x-40, 60, 80, 20)];
            titleLabel.text=[titleArray objectAtIndex:i];
            titleLabel.textColor=[UIColor whiteColor];
            titleLabel.textAlignment=NSTextAlignmentCenter;
            titleLabel.font=[UIFont systemFontOfSize:10];
            [OneButtImageView addSubview:titleLabel];
        }
}
-(void)threeButtAction:(id)butt
{
    UIButton *tempButt=(UIButton*)butt;
    switch (tempButt.tag) {
        case 100:
        {
            ChangeWaitingPendingTimeController *changePendingTimeController=[[ChangeWaitingPendingTimeController alloc]init];
            changePendingTimeController.delegate=self;
            changePendingTimeController.orderDictionary=self.recieveDic;
            [self.navigationController pushViewController:changePendingTimeController animated:YES];
        }
            break;
        case 200:
        {
            [self doOrderRequest];
        }
            break;
        case 300:
        {
            RefuseViewController *refuseController=[[RefuseViewController alloc]init];
            refuseController.delegate=self;
            refuseController.orderDic=_orderDic;
            [self.navigationController pushViewController:refuseController animated:YES];
        }
            break;
            
        default:
            break;
    }
}
-(void)popUpAlertView
{
    grayWindow=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    grayWindow.backgroundColor=[UIColor lightGrayColor];
    grayWindow.alpha=0.5f;
    [self.view addSubview:grayWindow];
    
    popUpWindow=[[UIView alloc]initWithFrame:CGRectMake(30, self.view.center.y-65, kSCREEN_WIDTH-60, 130)];
    popUpWindow.backgroundColor=[UIColor whiteColor];
    popUpWindow.layer.cornerRadius=5.0f;
    [self.view addSubview:popUpWindow];
    
    
    UIButton *cancelButt=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelButt.frame=CGRectMake((popUpWindow.frame.size.width-30)/2+20, 90, (popUpWindow.frame.size.width-30)/2, 30);
    [cancelButt setBackgroundImage:[UIImage imageNamed:@"0_117"] forState:UIControlStateNormal];
    [cancelButt setTitle:@"取消" forState:UIControlStateNormal];
     [cancelButt addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [popUpWindow addSubview:cancelButt];
    
    UIButton *sureButt=[UIButton buttonWithType:UIButtonTypeCustom];
    sureButt.frame=CGRectMake(10, 90, (popUpWindow.frame.size.width-30)/2, 30);
    [sureButt setBackgroundImage:[UIImage imageNamed:@"0_117"] forState:UIControlStateNormal];
    [sureButt setTitle:@"确定" forState:UIControlStateNormal];
    [sureButt addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [popUpWindow addSubview:sureButt];
    
    
    
    UILabel *takePhotoLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 40, popUpWindow.frame.size.width-20, 20)];
    takePhotoLabel.text=@"您确定此预约已经完成了吗?";
    takePhotoLabel.textAlignment=NSTextAlignmentCenter;
    [popUpWindow addSubview:takePhotoLabel];
}
-(void)cancelAction
{
    [popUpWindow removeFromSuperview];
    [grayWindow removeFromSuperview];
}
-(void)sureAction
{
    [popUpWindow removeFromSuperview];
    [grayWindow removeFromSuperview];
    [self finishOrderRequest];
}
- (IBAction)evaluatPatientAction:(UIButton *)sender {
    EvaluatePatientViewController *evaluatPatientController=[[EvaluatePatientViewController alloc]init];
    evaluatPatientController.delegate=self;
    evaluatPatientController.orderDic=_orderDic;
    [self.navigationController pushViewController:evaluatPatientController animated:YES];
}
- (IBAction)completedAction:(UIButton *)sender {
    [self popUpAlertView];
}
-(void)finishOrderRequest
{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
       NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"id":[_orderDic objectForKey:@"id"], @"SessionID": sessionID};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, FinishOrder] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0){
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                NSLog(@"responseDic====%@",responseObject);
                [_orderDic setObject:@"99" forKey:@"status"];
                [self viewWillAppear:YES];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"完成订单接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}
-(void)doOrderRequest
{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
       NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"id":[_orderDic objectForKey:@"id"], @"SessionID": sessionID,@"status":@"1"};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, DealOrder] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0){
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                NSLog(@"responseDic====%@",responseObject);
                [_orderDic setObject:@"1" forKey:@"status"];
                [[self.backGroundView viewWithTag:1000]removeFromSuperview];
                [self viewWillAppear:YES];
            }else
            {
                [SVProgressHUD showErrorWithStatus:[responseObject valueForKeyWithOutNSNull:@"text"]];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"完成订单接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}
-(void)passRefuseDataToFrontController:(NSDictionary *)dic
{
    [[self.view viewWithTag:1000] removeFromSuperview];
    [_orderDic setObject:[dic objectForKey:@"status"] forKey:@"status"];
    [_orderDic setObject:[dic objectForKey:@"refuseContent"] forKey:@"dRefuse"];
}
-(void)passEvaluatPatientDataToFrontController:(NSDictionary *)dic
{
    [_orderDic setObject:[dic objectForKey:@"uGrade"] forKey:@"uGrade"];
    [_orderDic setObject:[dic objectForKey:@"uComment"] forKey:@"uComment"];
    [_orderDic  setObject:@"1" forKey:@"uIsComment"];
}
-(void)passChangeTimeStatusAndDictionary:(NSDictionary *)passDic
{
    [[self.view viewWithTag:1000] removeFromSuperview];
    [_orderDic setObject:[passDic objectForKey:@"status"] forKey:@"status"];
    [_orderDic setObject:[passDic objectForKey:@"dDay"] forKey:@"dDay"];
    [_orderDic setObject:[passDic objectForKey:@"dTime1"] forKey:@"dTime1"];
    [_orderDic setObject:[passDic objectForKey:@"dTime2"] forKey:@"dTime2"];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.type==0||self.type==2) {
     self.scrollViewBottom.constant=80;
     self.backScrollView.contentSize=CGSizeMake(kSCREEN_WIDTH, CGRectGetMaxY(self.customContentLabel.frame)+20);
    }
    if (self.type==99){
       if ([[_orderDic objectForKey:@"dIsComment"] integerValue]==1&&[[_orderDic objectForKey:@"uIsComment"] integerValue]==1) {
           self.evaluatMeViewHeight.constant=CGRectGetHeight(self.meEvaluatPatient.frame)+20;
           self.backScrollView.contentSize=CGSizeMake(kSCREEN_WIDTH, CGRectGetMaxY(self.patientEvaluatMe.frame)+20);
       }if([[_orderDic objectForKey:@"dIsComment"] integerValue]==1&&[[_orderDic objectForKey:@"uIsComment"] integerValue]==0)
       {
          self.evaluatMeViewHeight.constant=CGRectGetHeight(self.evaluatPatientButt.frame)+50;
          self.backScrollView.contentSize=CGSizeMake(kSCREEN_WIDTH, CGRectGetMaxY(self.patientEvaluatMe.frame)+20);
       }if([[_orderDic objectForKey:@"dIsComment"] integerValue]==0&&[[_orderDic objectForKey:@"uIsComment"] integerValue]==1){
         self.backScrollView.contentSize=CGSizeMake(kSCREEN_WIDTH,CGRectGetMaxY(self.meEvaluatPatient.frame)+20);
       }if([[_orderDic objectForKey:@"dIsComment"] integerValue]==0&&[[_orderDic objectForKey:@"uIsComment"] integerValue]==0)
       {
          self.backScrollView.contentSize=CGSizeMake(kSCREEN_WIDTH,CGRectGetMaxY(self.customContentLabel.frame)+20);
       }
    }
    if (self.type==-1||self.type==-2) {
     self.backScrollView.contentSize=CGSizeMake(kSCREEN_WIDTH, CGRectGetMaxY(self.refuseBackView.frame)+20);
    }
    if (self.type==1||self.type==3) {
     self.scrollViewBottom.constant=0;
     self.backScrollView.contentSize=CGSizeMake(kSCREEN_WIDTH, CGRectGetMaxY(self.completButt.frame)+20);
    }
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
