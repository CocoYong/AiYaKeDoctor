//
//  RefuseViewController.m
//  YSProject
//
//  Created by MrZhang on 15/6/15.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "RefuseViewController.h"

@interface RefuseViewController ()<UITextViewDelegate>
{
    CWHttpRequest *request;
}
@property (weak, nonatomic) IBOutlet UITextView *refuseTextView;
@end

@implementation RefuseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"拒绝"];
    [self addBackButt];
    [self creatUIItem];
    self.refuseTextView.layer.cornerRadius=5.0f;
    self.refuseTextView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.refuseTextView.layer.borderWidth=1.0f;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboard)];
    [self.view addGestureRecognizer:tapGesture];

}
-(void)resignKeyboard
{
    [_refuseTextView resignFirstResponder];
    if (self.view.frame.origin.y!=0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        }];
    }
}
-(void)creatUIItem
{
    UIImageView* OneButtImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-80, kSCREEN_WIDTH, 80)];
    OneButtImageView.image=[UIImage imageNamed:@"0_359"];
    [self.view addSubview:OneButtImageView];
    OneButtImageView.userInteractionEnabled=YES;
    UIButton *itemButt=[UIButton buttonWithType:UIButtonTypeCustom];
    itemButt.frame=CGRectMake(kSCREEN_WIDTH/2-20, 20, 40, 40);
    [itemButt setImage:[UIImage imageNamed:@"0_173"] forState:UIControlStateNormal];
    [itemButt addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [OneButtImageView addSubview:itemButt];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2-20, 60, 40, 20)];
    titleLabel.text=@"确定";
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:10];
    [OneButtImageView addSubview:titleLabel];
    
//    self.contentView.layer.cornerRadius=5.0f;
//    self.contentView.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    self.contentView.layer.borderWidth=1.0f;
}
-(void)sureButtonAction
{
    [self doOrderRequest];
}
-(void)doOrderRequest
{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
       NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary;
        if (_refuseTextView.text==nil||[_refuseTextView.text isEqualToString:@""]) {
         jsonDictionary = @{@"id":[_orderDic objectForKey:@"id"], @"SessionID": sessionID,@"status":@"-1"};
        }else
        {
         jsonDictionary = @{@"id":[_orderDic objectForKey:@"id"], @"SessionID": sessionID,@"status":@"-1",@"dRefuse":_refuseTextView.text};
        }
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
                if (self.delegate&&[self.delegate respondsToSelector:@selector(passRefuseDataToFrontController:)]) {
                    NSDictionary *passDic=@{@"status":@"-1",@"refuseContent":_refuseTextView.text};
                    [self.delegate passRefuseDataToFrontController:passDic];
                    [self.navigationController popViewControllerAnimated:YES];
                }
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
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame=CGRectMake(0, -216, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    }];
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
