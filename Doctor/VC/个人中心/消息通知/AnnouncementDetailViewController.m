//
//  AnnouncementDetailViewController.m
//  YSProject
//
//  Created by cuiw on 15/6/2.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "AnnouncementDetailViewController.h"

@interface AnnouncementDetailViewController ()
{
    CWHttpRequest *request;
}
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentData;

@end

@implementation AnnouncementDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"活动公告"];
    [self addBackButt];
    [self readMessageRequest:[[_dataDic objectForKey:@"mid"] integerValue]];
    self.timeLabel.text=[_dataDic objectForKey:@"createTime"];
    self.contentData.text=[_dataDic objectForKey:@"content"];
}

//4.16 user/index/readMsg读取公告(设置公告记录为已经读状态
-(void)readMessageRequest:(NSInteger)uid
{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
       NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary= @{@"mid":[NSNumber numberWithInteger:uid],@"SessionID":sessionID};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, ReadMsg] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"好友请求接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0) {
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                [userManager synchronize];
                [SVProgressHUD showSuccessWithStatus:@"读取公告成功"];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"好友请求接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
