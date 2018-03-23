//
//  ResetPwdSecondViewController.m
//  YSProject
//
//  Created by cuiw on 15/5/21.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "ResetPwdSecondViewController.h"

@interface ResetPwdSecondViewController ()
{
    CWHttpRequest *_codeRequest;
}
@property (weak, nonatomic) IBOutlet CWTextField *passwordOne;
@property (weak, nonatomic) IBOutlet CWTextField *passwordTwo;
@end

@implementation ResetPwdSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
}
- (IBAction)commitButtAction:(id)sender {
    if ([_passwordOne.text length]==0) {
        [ShowViewCenterViewController showAlertViewWithTitle:nil message:@"请输入密码" cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:nil cancelBlock:nil otherBlock:nil];
        return;
    }
    if ([_passwordTwo.text length] == 0) {
        [ShowViewCenterViewController showAlertViewWithTitle:nil message:@"请再次输入密码" cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:nil cancelBlock:nil otherBlock:nil];
        return;
    }if (![_passwordTwo.text isEqualToString:_passwordOne.text]) {
        [ShowViewCenterViewController showAlertViewWithTitle:nil message:@"两次输入密码不一致" cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:nil cancelBlock:nil otherBlock:nil];
        return;
    }
    [self sendPasswordRequest];
}

- (void)sendPasswordRequest {
    if ([Reachability checkNetCanUse]) {
        if (!_codeRequest) {
            _codeRequest = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"请稍候..." maskType:SVProgressHUDMaskTypeClear];
        NSString *passwordOne = [_passwordOne.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *passwordTwo = [_passwordOne.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"newpassword": passwordOne, @"newpasswordRe":passwordTwo,@"SessionID":sessionID};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [_codeRequest JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, ChangePassWord] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0){
                [self.navigationController popToRootViewControllerAnimated:YES];
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
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self makeKeyboardDisappear];
}
-(void)makeKeyboardDisappear
{
    [_passwordOne resignFirstResponder];
    [_passwordTwo resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
