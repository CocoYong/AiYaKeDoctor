//
//  AboutViewController.m
//  YSProject
//
//  Created by cuiw on 15/5/31.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"关于我们"];
    [self addBackButt];
    self.textView.scrollEnabled=NO;
}
- (IBAction)dialTelephone:(UIButton *)sender {
    [self dialTelephoneNum];
}
-(void)dialTelephoneNum
{
    NSString *device = [UIDevice currentDevice].model;
    if ([device isEqualToString:@"iPhone"] ) {
        
        UIWebView * callWebView;
        NSString *phoneNum = nil;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
            phoneNum = @"telprompt://021-64680065";
        } else {
            phoneNum = @"tel://021-64680065";// 电话号码
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
        } else {
            UIWebView *callPhoneWebVw = [[UIWebView alloc] initWithFrame:CGRectZero];
            callWebView = callPhoneWebVw;
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:phoneNum]];
            [ callWebView loadRequest:request];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"您的设备不能打电话"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
