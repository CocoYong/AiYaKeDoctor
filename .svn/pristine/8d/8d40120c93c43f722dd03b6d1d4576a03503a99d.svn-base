//
//  MineViewController.m
//  YSProject
//
//  Created by cuiw on 15/5/27.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "MineViewController.h"
#import "PersonalViewController.h"
#import "ScheduleViewController.h"
#import "PatientViewController.h"
#import "EvaluateViewController.h"
#import "NotificationViewController.h"
#import "SettingViewController.h"
#import "TabBarViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UploadImageManager.h"
#import "UIImageView+WebCache.h"
#import "UserModel.h"
#import "JSONKit.h"
#import "UIBlockAlertView.h"
@interface MineViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableDictionary *dataDic;
    CWHttpRequest *request;
    NSTimer *timer;

}
@property (weak, nonatomic) IBOutlet UIView *backGrayView;
@property (weak, nonatomic) IBOutlet UIView *loginOutAlertView;

@property (weak, nonatomic) IBOutlet UIView *photoAlertView;

@property (weak, nonatomic) IBOutlet UIImageView *starOne;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UIButton *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *evaluatLabel;
@property (weak, nonatomic) IBOutlet UILabel *followLabel;
@property (weak, nonatomic) IBOutlet UILabel *pendingLabel;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"个人中心"];
    UITapGestureRecognizer *tapGestureRecgniz=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headButtonAction)];
    [self.photoImageView addGestureRecognizer:tapGestureRecgniz];
    
//    dataDic=[[CWNSFileUtil sharedInstance] getNSModelFromUserDefaultsWithKey:@"userData"];
    UIButton  *loginOutbutt=[UIButton buttonWithType:UIButtonTypeCustom];
    loginOutbutt.frame=CGRectMake(kSCREEN_WIDTH-50, 10, 40, 40);
    [loginOutbutt setImage:[UIImage imageNamed:@"0_280"] forState:UIControlStateNormal];
    [loginOutbutt addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginOutbutt];
    [self.view bringSubviewToFront:loginOutbutt];
    timer=[NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(checkHadOtherPeopleLogin) userInfo:nil repeats:YES];
    timer.fireDate=[NSDate distantPast];
}
-(void)checkHadOtherPeopleLogin
{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"SessionID": sessionID};
        NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, IsOnline] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😍😍😍😍😍😍😍😍😍=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0){
                UserManager *usermanager=[UserManager currentUserManager];
                usermanager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [usermanager synchronize];
                if (![[[responseObject objectForKey:@"data"] objectForKey:@"val"] boolValue]){
                    [SVProgressHUD showSuccessWithStatus:@"你的帐号在其他手机登录，你被迫下线" duration:3];
                    [self sureLoginOut:nil];
                }else
                {
                    return ;
                }
            }else
            {
                [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"text"]];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"登录接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}

-(void)settingUIData
{
    //测试
    self.nameLabel.text=[dataDic objectForKey:@"name"];
    if ([[dataDic objectForKey:@"isWorkTime"] integerValue]==1) {
        [self.stateLabel setBackgroundImage:[UIImage imageNamed:@"忙碌中"] forState:UIControlStateNormal];
    }else
    {
        [self.stateLabel setBackgroundImage:[UIImage imageNamed:@"空闲中"] forState:UIControlStateNormal];
    }
    self.starOne.image=[UIImage imageNamed:[NSString stringWithFormat:@"star%@",[dataDic objectForKey:@"totalGrade"]]];
    self.evaluatLabel.text=[NSString stringWithFormat:@"%@评价",[dataDic objectForKey:@"totalCommentNum"]];
    self.followLabel.text=[NSString stringWithFormat:@"%@人气",[dataDic objectForKey:@"Order99Num"]];
    self.pendingLabel.text=[NSString stringWithFormat:@"%@次预约",[dataDic objectForKey:@"totalOrderNum"]];
    
    [self.photoImageView  sd_setImageWithURL:[NSURL URLWithString:[dataDic objectForKey:@"picUrl"]] placeholderImage:[UIImage imageNamed:@"0_277"] options:SDWebImageHighPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image){
        self.photoImageView.image=image;
        }else
        {
        self.photoImageView.image=[UIImage imageNamed:@"doctorDefault"];
        }
    }];
}
-(void)loginOut
{
    self.backGrayView.hidden=NO;
    self.loginOutAlertView.hidden=NO;
}
- (IBAction)sureLoginOut:(id)sender {
    timer.fireDate=[NSDate distantFuture];
    [[CWNSFileUtil sharedInstance] setNSModelToUserDefaults:@"" withKey:@"SessionID"];
    NSLog(@"调用退出登录了。。。。。。。。");
    
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (!error) {
             [UserManager logout];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            if (appDelegate.rootVC==nil) {
                LoginViewController *vc = [[LoginViewController alloc] init];
                UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:vc];
                navigationVC.interactivePopGestureRecognizer.enabled = YES;
                appDelegate.window.rootViewController = navigationVC;
            }else
            {
                appDelegate.window.rootViewController=appDelegate.rootVC;
            }
        }
    } onQueue:nil];
    
}

- (IBAction)cancelLoginOut:(id)sender {
    self.backGrayView.hidden=YES;
    self.loginOutAlertView.hidden=YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
    [(TabBarViewController*)self.tabBarController  tabbarImageView].hidden=NO;
    [self getBaseUserInfoDic];
//     [self getDataFromService];
}
- (IBAction)menuButtonAction:(id)sender {
    UIButton *button = sender;
    switch (button.tag) {
        case 101:
        {
            PersonalViewController *personalVC = [[PersonalViewController alloc] init];
            personalVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:personalVC animated:YES];
        }
            break;
        case 102:
        {
            ScheduleViewController *scheduleVC = [[ScheduleViewController alloc] init];
            scheduleVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:scheduleVC animated:YES];
        }
            break;
        case 103:
        {
            PatientViewController *patientVC = [[PatientViewController alloc] init];
            patientVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:patientVC animated:YES];
        }
            break;
        case 104:
        {
            EvaluateViewController *evaluateVC = [[EvaluateViewController alloc] init];
            evaluateVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:evaluateVC animated:YES];
        }
            break;
        case 105:
        {
            NotificationViewController *notificationVC = [[NotificationViewController alloc] init];
            notificationVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:notificationVC animated:YES];
        }
            break;
        case 106:
        {
            SettingViewController *settingVC = [[SettingViewController alloc] init];
            settingVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:settingVC animated:YES];
        }
            break;
        default:
            break;
    }
}

-(IBAction)takePicture:(id)sender
{
    self.photoAlertView.hidden=YES;
    self.backGrayView.hidden=YES;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.allowsEditing = YES;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}
-(IBAction)goPhotoLibary
{
    self.photoAlertView.hidden=YES;
    self.backGrayView.hidden=YES;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}
- (IBAction)dissmissPhotoAlertView:(id)sender {
    self.backGrayView.hidden=YES;
    self.photoAlertView.hidden=YES;
}
-(void)headButtonAction{
    self.backGrayView.hidden=NO;
    self.photoAlertView.hidden=NO;
}
//职称
- (void)getDataFromService {
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"id": @"9",@"SessionID":sessionID};
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, Index_URL] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"普通字段接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID👿👿👿👿👿👿😃😃😃😃😃😃=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0) {
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                for (NSDictionary *dic in [responseObject valueForKeyWithOutNSNull:@"data"]) {
                    if ([[dic objectForKey:@"id"] integerValue]==[[dataDic objectForKey:@"title"] integerValue]) {
                     self.jobLabel.text=[dic objectForKey:@"name"];
                    }
                }
                [self settingUIData];
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

-(void)getBaseUserInfoDic
{
    if ([Reachability checkNetCanUse]) {
        CWHttpRequest *_loginRequest = [[CWHttpRequest alloc] init];
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSLog(@"%@",[UserManager currentUserManager].loginName);
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
                dataDic=[[responseObject objectForKey:@"data"] mutableCopy];
                [self getDataFromService];
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

#pragma mark----imagePickerControllerDelegate----
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *imageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *imageEdit = [info objectForKey:UIImagePickerControllerEditedImage];
        UploadImageObject *imageObject = [[UploadImageObject alloc] init];
//        imageObject.originalImage =  [CWNSFileUtil imageCompressForSize:imageOriginal targetSize:CGSizeMake(320, 320*1.5)];
//        imageObject.smallImage = [CWNSFileUtil imageCompressForSize:imageOriginal targetSize:CGSizeMake(120, 120*1.5)];
        imageObject.originalImage =imageOriginal;
        imageObject.smallImage =imageEdit;
        NSString *urlString = [NSString stringWithFormat:@"%@",[info objectForKey:UIImagePickerControllerReferenceURL]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *newTempUrl = @"";
        NSRange range = [urlString rangeOfString:@"PNG"];
        if (range.length) {
            newTempUrl = [NSString stringWithFormat:@"%@.png",str];
            imageObject.type=@"image/png";
        }else{
            newTempUrl = [NSString stringWithFormat:@"%@.jpg",str];
            imageObject.type=@"image/jpg";
        }
         imageObject.imageName = newTempUrl;
        [[UploadImageManager share] addImageObject:imageObject];
        [self performSelector:@selector(updateUserPhotoImage:) withObject:imageObject afterDelay:3];
        }];
}
- (void)updateUserPhotoImage:(UploadImageObject*)object {
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
      [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
       NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSData *imageData=[CWNSFileUtil image2DataURL:object.smallImage];
        NSDictionary *jsonDictionary = @{@"type":@"pic",@"file":object.smallImage,@"SessionID":sessionID};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request imageUploadWithUrl:[NSString stringWithFormat:@"%@",HOST_URL] fillPath:Post_Interface
                         parameters:jsonDictionary
                            andData:imageData
                           mimeType:object.type
                            fileName:object.imageName
                       successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
           [SVProgressHUD dismiss];
           NSString *jsonString=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            id recieveObject=[jsonString objectFromJSONString];
            NSString *code =[NSString stringWithFormat:@"%@",[recieveObject valueForKeyWithOutNSNull:@"code"]];
            if ([code integerValue]==0) {
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[recieveObject objectForKey:@"SessionID"];
                userManager.globalSessionID=[recieveObject objectForKey:@"SessionID"];
                [userManager synchronize];
                self.photoImageView.image=object.smallImage;
                [self synchronPhotoImage:[[recieveObject valueForKeyWithOutNSNull:@"data"] objectForKey:@"filePath"] andImageObject:object];
            }else
            {
                [SVProgressHUD showErrorWithStatus:[recieveObject valueForKeyWithOutNSNull:@"text"]];
            }
        } failBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"更新用户图像接口失败=======%@", error);
            [ShowViewCenter netError];
        }];
    }else
    {
     [ShowViewCenter netNotAvailable];
    }
}
- (void)synchronPhotoImage:(NSString*)urlString andImageObject:(UploadImageObject*)Object {
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
       NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"SessionID":sessionID,@"pic":urlString};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, Update_UserImage] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"更新用户图像接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0) {
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                [userManager synchronize];
                self.photoImageView.image=Object.smallImage;
            }else
            {
                [SVProgressHUD showErrorWithStatus:[responseObject valueForKeyWithOutNSNull:@"text"]];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"更新用户图像接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
