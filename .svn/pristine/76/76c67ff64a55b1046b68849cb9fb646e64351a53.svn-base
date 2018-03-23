//
//  RegisterSecondViewController.m
//  YSProject
//
//  Created by cuiw on 15/5/21.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "RegisterSecondViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TabBarViewController.h"
#import "ParserCenter.h"
#import "AppDelegate.h"
@interface RegisterSecondViewController ()
@property (weak, nonatomic) IBOutlet UIView *backGrayView;
@property (weak, nonatomic) IBOutlet UIView *popUpView;

@property (weak, nonatomic) IBOutlet CWTextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet CWTextField *conpanyTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;

@end

@implementation RegisterSecondViewController
{
    CWHttpRequest *request;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _maleButton.selected=YES;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.popUpView.layer.cornerRadius=5.0f;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
}
-(void)resignKeyboard
{
    [_nameTextField resignFirstResponder];
    [_conpanyTextField resignFirstResponder];
    if (self.view.frame.origin.y!=0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        }];
    }
}


- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sexButtonAction:(id)sender {
    UIButton *tempbutt=(UIButton*)sender;
    if (tempbutt==_maleButton) {
        [tempbutt setImage:[UIImage imageNamed:@"0_104"] forState:UIControlStateNormal];
        [_femaleButton setImage:[UIImage imageNamed:@"0_106"] forState:UIControlStateNormal];
    }else
    {
        [tempbutt setImage:[UIImage imageNamed:@"0_104"] forState:UIControlStateNormal];
        [_maleButton setImage:[UIImage imageNamed:@"0_106"] forState:UIControlStateNormal];
    }
}

- (IBAction)submitButtonAction:(id)sender {
    NSString *name = [_nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([name length] == 0) {
        [ShowViewCenterViewController showAlertViewWithTitle:nil message:@"请输入真实姓名" cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:nil cancelBlock:nil otherBlock:nil];
        return;
    }
     NSString *company = [_conpanyTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([company length]==0) {
        [ShowViewCenterViewController showAlertViewWithTitle:nil message:@"请输入医疗机构名称" cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:nil cancelBlock:nil otherBlock:nil];
        return;
    }
    self.backGrayView.hidden=NO;
    self.popUpView.hidden=NO;
    [self.view endEditing:YES];
    if (self.view.frame.origin.y!=0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        }];
    }
}
- (IBAction)popUpDismiss:(id)sender {
    self.backGrayView.hidden=YES;
    self.popUpView.hidden=YES;
    [self sendReg_TwoRequest];
}
- (void)sendReg_TwoRequest {
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"请稍候..." maskType:SVProgressHUDMaskTypeClear];
        NSString *realName = [_nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *company = [_conpanyTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSNumber *sex;
        if (_maleButton.selected){
            sex=@1;
        }if (_femaleButton.selected) {
            sex=@0;
        }
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"name": realName, @"sex": sex, @"company": company,@"SessionID":sessionID};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, Reg2_URL] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0){
                
                /*
                [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil userInfo:self.loginDic];
                [self.navigationController popToRootViewControllerAnimated:YES];
                 */
                [self sendLoginRequest];
            }else
            {
                [SVProgressHUD showErrorWithStatus:[responseObject valueForKeyWithOutNSNull:@"text"]];
            }
        NSLog(@"发送注册信息two接口失败=======%@", [responseObject objectForKey:@"text"]);
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"发送注册信息two接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}
- (void)sendLoginRequest {
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [UserManager logout];
        [SVProgressHUD showWithStatus:@"正在登录..." maskType:SVProgressHUDMaskTypeClear];
        NSString *account = [self.loginDic objectForKey:@"phone"];
        NSString *password = [self.loginDic objectForKey:@"password"];
        NSDictionary *jsonDictionary = @{@"username": account, @"password": password, @"userType": @"1"};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, Login_URL] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"登录接口=======%@", responseObject);
            NSLog(@"登录接口=======%@", [responseObject valueForKeyWithOutNSNull:@"text"]);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0) {
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                userManager.userState=UserStateLogin;
                userManager.loginName=account;
                userManager.password=password;
                [userManager synchronize];
                NSDictionary *tempDic=[responseObject objectForKey:@"data"];
                ParserCenter *parser=[[ParserCenter alloc]init];
                [parser parserUser:tempDic];
                [[CWNSFileUtil sharedInstance] setNSModelToUserDefaults:[responseObject objectForKey:@"data"] withKey:@"userData"];
                TabBarViewController *rootVC=[[TabBarViewController alloc]init];
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appDelegate.window.rootViewController = rootVC;
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
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
     self.backScrollView.frame=CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-216);
     self.backScrollView.contentSize=CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT);
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    if (self.view.frame.origin.y!=0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.backScrollView.frame=CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        }];
    }
    [self sendReg_TwoRequest];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.backScrollView endEditing:YES];
    self.backScrollView.frame=CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    self.backScrollView.contentSize=CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT);
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.backScrollView.frame=CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    self.backScrollView.contentSize=CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
