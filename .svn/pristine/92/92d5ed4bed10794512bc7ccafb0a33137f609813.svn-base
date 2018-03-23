//
//  RegisterViewController.m
//  YSProject
//
//  Created by cuiw on 15/5/20.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterProtocalViewController.h"
#import "RegisterSecondViewController.h"

@interface RegisterViewController ()
{
    int _time;
    NSTimer *_timer;
    CWHttpRequest *_codeRequest;
    CWHttpRequest *_regRequest;
}
@property (weak, nonatomic) IBOutlet CWTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet CWTextField *codeTextField;
@property (weak, nonatomic) IBOutlet CWTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet CWTextField *passwordConfirmTextField;
@property (weak, nonatomic) IBOutlet UIButton *tipButton;
@property (weak, nonatomic) IBOutlet UIButton *protocalButton;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation RegisterViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets=NO;
    UIImage *bgImage = [UIImage imageNamed:@"buttonBg"];
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(16, 20, 16, 20)];
    [_codeButton setBackgroundImage:bgImage forState:UIControlStateNormal];
    UIImage *disBgImage =[UIImage imageNamed:@"buttonDisBg"];
    disBgImage = [disBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(16, 20, 16, 20)];
    [_codeButton setBackgroundImage:disBgImage forState:UIControlStateDisabled];
    _tipButton.selected=YES;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"《用户注册协议》"];
    NSRange strRange = {0, [str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(53, 93, 116) range:strRange];
    [_protocalButton setAttributedTitle:str forState:UIControlStateNormal];
}



- (IBAction)codeButtonAction:(id)sender {
    NSString *phone = [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![ValidationUtil isMobileNumber:phone]) {
        [ShowViewCenterViewController showAlertViewWithTitle:nil message:@"请输入正确的手机号" cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:nil cancelBlock:nil otherBlock:nil];
        return;
    }
    [self sendSMSCodeRequest];
}

- (void)getCode {
    _time = 60;
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)countDown{
     _time--;
    if (_time > 0){
        _codeButton.enabled = NO;
        [_codeButton setTitle:[NSString stringWithFormat:@"重新发送(%d)", _time] forState:UIControlStateDisabled];
    } else {
        [self.timer setFireDate:[NSDate distantFuture]];
        _codeButton.enabled = YES;
        [_codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
    }
}

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (IBAction)circleButton:(UIButton *)sender {
    sender.selected=!sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"0_104"] forState:UIControlStateNormal];
    }else
    {
      [sender setImage:[UIImage imageNamed:@"0_106"] forState:UIControlStateNormal];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonAction:(id)sender {
    if (_timer && [_timer isValid]) {
        [_timer invalidate];//销毁定时器
        _timer = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registerProtocalButtonAction:(id)sender {
    RegisterProtocalViewController *registerProtocalViewController = [[RegisterProtocalViewController alloc] init];
    [self.navigationController pushViewController:registerProtocalViewController animated:YES];
}

- (IBAction)nextButtonAction:(id)sender {
    [self.backView endEditing:YES];
    if (self.view.frame.origin.y!=0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        }];
    }
    NSString *phone = [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([phone length] == 0) {
        [ShowViewCenterViewController showAlertViewWithTitle:nil message:@"请输入您的手机号" cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:nil cancelBlock:nil otherBlock:nil];
        return;
    }
    NSString *code = [_codeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([code length] == 0) {
        [ShowViewCenterViewController showAlertViewWithTitle:nil message:@"请输入验证码" cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:nil cancelBlock:nil otherBlock:nil];
        return;
    }
    NSString *password = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([password length] == 0) {
        [ShowViewCenterViewController showAlertViewWithTitle:nil message:@"请输入密码" cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:nil cancelBlock:nil otherBlock:nil];
        return;
    }
    NSString *passwordConfirm = [_passwordConfirmTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([passwordConfirm length] == 0) {
        [ShowViewCenterViewController showAlertViewWithTitle:nil message:@"请输入确认密码" cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:nil cancelBlock:nil otherBlock:nil];
        return;
    }
    if (![password isEqualToString:passwordConfirm]) {
        [ShowViewCenterViewController showAlertViewWithTitle:nil message:@"两次输入的密码不一致" cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:nil cancelBlock:nil otherBlock:nil];
        return;
    }
    if (!_tipButton.selected) {
        [ShowViewCenterViewController showAlertViewWithTitle:nil message:@"请先阅读并同意《用户注册协议》" cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:nil cancelBlock:nil otherBlock:nil];
        return;
    }
    
    [self sendRegRequest];
}

#pragma mark - 发送短信验证码接口
- (void)sendSMSCodeRequest {
    if ([Reachability checkNetCanUse]) {
        if (!_codeRequest) {
            _codeRequest = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"请稍候..." maskType:SVProgressHUDMaskTypeClear];
        NSString *phone = [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSDictionary *jsonDictionary = @{@"mobile": phone, @"type": @"1"};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [_codeRequest JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, SendCode_URL] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0){
                [self getCode];
            }else
            {
                [SVProgressHUD showErrorWithStatus:[responseObject valueForKeyWithOutNSNull:@"text"]];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"发送短信验证码接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}

#pragma mark - 注册1接口
- (void)sendRegRequest {
    if ([Reachability checkNetCanUse]) {
        if (!_regRequest) {
            _regRequest = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"请稍候..." maskType:SVProgressHUDMaskTypeClear];
        NSString *phone = [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *code = [_codeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *password = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSDictionary *jsonDictionary = @{@"username": phone, @"smscode": code, @"password": password};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [_regRequest JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, Reg_URL] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0){
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                [userManager synchronize];
                NSDictionary *loginDic=@{@"phone":phone,@"password":password};
                RegisterSecondViewController *registerSecondViewController = [[RegisterSecondViewController alloc] init];
                registerSecondViewController.loginDic=loginDic;
                [self.navigationController pushViewController:registerSecondViewController animated:YES];
            }else
            {
                [SVProgressHUD showErrorWithStatus:[responseObject valueForKeyWithOutNSNull:@"text"]];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"发送注册信息接口1失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   self.backScrollView.frame=CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-216);
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
    [self sendRegRequest];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.backView endEditing:YES];
    self.backScrollView.frame=CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
}
@end
