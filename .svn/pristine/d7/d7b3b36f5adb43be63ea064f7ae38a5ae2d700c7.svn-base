//
//  AddServiceViewController.m
//  YSProject
//
//  Created by MrZhang on 15/6/16.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "AddServiceViewController.h"
#import "SelectesItemTypeViewController.h"
@interface AddServiceViewController ()
{
    CWHttpRequest *request;
}
@property (weak, nonatomic) IBOutlet UITextField *selectedTypeField;
@property (weak, nonatomic) IBOutlet UIButton *selectedItemButt;
@property (weak, nonatomic) IBOutlet UITextField *feeMinField;
@property (weak, nonatomic) IBOutlet UITextField *feeMaxField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextview;
@end

@implementation AddServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"添加服务项目"];
    [self addBackButt];
    [self creatUIItem];
    
}
- (IBAction)selectedAction:(id)sender {
    
    SelectesItemTypeViewController *selectedItemController=[[SelectesItemTypeViewController alloc]init];
    [self.navigationController pushViewController:selectedItemController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)creatUIItem
{
    UIImageView* OneButtImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-80, kSCREEN_WIDTH, 80)];
    OneButtImageView.image=[UIImage imageNamed:@"0_359"];
    [self.view addSubview:OneButtImageView];
    
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
}
-(void)sureButtonAction
{
    
}
-(void)addOrEditServiceProjectRequest:(NSInteger)uid andType:(NSInteger)type andMinFree:(NSInteger)minfree andMaxFree:(NSInteger)maxFree andContent:(NSString*)detail
{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary= @{@"id":[NSNumber numberWithInteger:uid],@"SessionID":sessionID,@"feeMin":[NSNumber numberWithInteger:minfree],@"feeMax":[NSNumber numberWithInteger:maxFree],@"content":detail};
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, AddAndEditService] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"好友请求接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
            [UserManager currentUserManager].sessionID=[responseObject objectForKey:@"SessionID"];
            if ([code integerValue]==0) {
            
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"好友请求接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
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
