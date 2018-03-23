//
//  SkilledViewController.m
//  YSProject
//
//  Created by MrZhang on 15/6/16.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "SkilledViewController.h"

@interface SkilledViewController ()<UITextFieldDelegate>
{
    NSDictionary *dataDic;
    CWHttpRequest *request;
    NSMutableArray *requestArray;
    UITextField *selfLabsField;
}
@property (weak, nonatomic) IBOutlet UITableView *baseTable;

@end

@implementation SkilledViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"擅长项目"];
    [self addBackButt];
    [self creatUIItem];
    [self creatTableFooterView];
    NSDictionary *userDic=(NSDictionary*)[[CWNSFileUtil sharedInstance]getNSModelFromUserDefaultsWithKey:@"userData"];
    dataDic=[userDic objectForKey:@"data"];
    [self getDataFromService];
    
    
    
}
- (void)getDataFromService {
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSDictionary *jsonDictionary = @{@"id": @"30"};
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, Index_URL] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"登录接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
            if ([code integerValue]==0) {
                requestArray=[[responseObject valueForKey:@"data"] mutableCopy];
                [requestArray addObjectsFromArray:[dataDic objectForKey:@"labsSelfList"]];
                [self.baseTable reloadData];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"登录接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}

#pragma mark----tableViewDelegate-------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier=@"cellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    [self configerTableViewCell:cell withIndexPath:indexPath];
    return cell;
}
-(void)configerTableViewCell:(UITableViewCell*)cell withIndexPath:(NSIndexPath*)indexPath
{
    UIButton *selectedButt=[UIButton buttonWithType:UIButtonTypeCustom];
    selectedButt.frame=CGRectMake(kSCREEN_WIDTH-40, 12, 20, 20);
    [selectedButt setBackgroundImage:[UIImage imageNamed:@"0_74"] forState:UIControlStateNormal];
    [selectedButt setBackgroundImage:[UIImage imageNamed:@"0_71"] forState:UIControlStateSelected];
    [selectedButt addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:selectedButt];
    for (NSDictionary *tempDic in [dataDic objectForKey:@"labs"]) {
        if ([[tempDic objectForKey:@"id"] integerValue]==[[[requestArray objectAtIndex:indexPath.row] objectForKey:@"id"]integerValue]) {
            selectedButt.selected=YES;
        }
    }
    for (NSDictionary *tempDic in [dataDic objectForKey:@"labsSelf"]) {
        if ([[tempDic objectForKey:@"id"] integerValue]==[[[requestArray objectAtIndex:indexPath.row] objectForKey:@"id"]integerValue]) {
            selectedButt.selected=YES;
        }
    }
    if ([[dataDic objectForKey:@"labsSelfList"]containsObject:[requestArray objectAtIndex:indexPath.row]]) {
        UIButton *deletButt=[UIButton buttonWithType:UIButtonTypeCustom];
        deletButt.frame=CGRectMake(200, 7, 30, 30);
        [deletButt setBackgroundImage:[UIImage imageNamed:@"0_26"] forState:UIControlStateNormal];
        deletButt.tag=indexPath.row;
//        [deletButt setBackgroundImage:[UIImage imageNamed:@"0_71"] forState:UIControlStateSelected];
        [deletButt addTarget:self action:@selector(deleteCellData:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:deletButt];
    }
    cell.textLabel.text=[[requestArray objectAtIndex:indexPath.row] objectForKey:@"name"];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.baseTable endEditing:YES];
    if (self.view.frame.origin.y!=0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        }];
    }
}
-(void)itemSelected:(id)sender
{
    UIButton *butt=(UIButton*)sender;
    butt.selected=!butt.selected;
}
-(void)deleteCellData:(UIButton *)butt
{
    [self deleteLabsRequest:[[[requestArray objectAtIndex:butt.tag] objectForKey:@"id"] integerValue]];
    [requestArray removeObjectAtIndex:butt.tag];
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
-(void)creatTableFooterView
{
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 80)];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(10, 0, kSCREEN_WIDTH, 0.5)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [footerView addSubview:lineView];
    
    selfLabsField=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, kSCREEN_WIDTH-85, 30)];
    selfLabsField.delegate=self;
    selfLabsField.borderStyle=UITextBorderStyleRoundedRect;
    selfLabsField.placeholder=@"添加自定义项目";
    [footerView addSubview:selfLabsField];
    
    UIButton *addButt=[UIButton buttonWithType:UIButtonTypeCustom];
    addButt.frame=CGRectMake(kSCREEN_WIDTH-70, 10, 60, 30);
    [addButt setBackgroundImage:[UIImage imageNamed:@"0_149"] forState:UIControlStateNormal];
    [addButt setTitle:@"添加" forState:UIControlStateNormal];
    [addButt addTarget:self action:@selector(addSelfLabsItem) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:addButt];
    self.baseTable.tableFooterView=footerView;
}
-(void)addSelfLabsItem
{
    [self adddOrEditLabsRequest:@"" andName:selfLabsField.text];
}
//设置擅长项目标签5.16 user/doctor/setSCLabs 设置擅长标签
-(void)setLabsRequest:(NSString *)labs andSelfLabs:(NSString*)selfLabs
{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[[CWNSFileUtil sharedInstance] getNSModelFromUserDefaultsWithKey:@"SessionID"];
        NSDictionary *jsonDictionary= @{@"labs":labs,@"SessionID":sessionID,@"labsSelf":selfLabs};
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, SetLabs] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"好友请求接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
            [[CWNSFileUtil sharedInstance] setNSModelToUserDefaults:[responseObject objectForKey:@"SessionID"] withKey:@"SessionID"];
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
//删除项目标签5.15 user/doctor/delLabs删除擅长标签
-(void)deleteLabsRequest:(NSInteger)uid
{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[[CWNSFileUtil sharedInstance] getNSModelFromUserDefaultsWithKey:@"SessionID"];
        NSDictionary *jsonDictionary= @{@"id":[NSNumber numberWithInteger:uid],@"SessionID":sessionID};
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, DealFriend] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"好友请求接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
            [[CWNSFileUtil sharedInstance] setNSModelToUserDefaults:[responseObject objectForKey:@"SessionID"] withKey:@"SessionID"];
            if ([code integerValue]==0) {
                [self.baseTable reloadData];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"好友请求接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}
//5.14 user/doctor/labs添加/编辑自定义擅长标签
-(void)adddOrEditLabsRequest:(NSString*)uid andName:(NSString*)labs
{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[[CWNSFileUtil sharedInstance] getNSModelFromUserDefaultsWithKey:@"SessionID"];
        NSDictionary *jsonDictionary= @{@"id":[uid isEqualToString:@""]==YES?@"":uid,@"SessionID":sessionID,@"name":labs};
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, AddAndEditlabs] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"添加自定义标签接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
            [[CWNSFileUtil sharedInstance] setNSModelToUserDefaults:[responseObject objectForKey:@"SessionID"] withKey:@"SessionID"];
            if ([code integerValue]==0){
                NSDictionary *selfLabsDic=@{@"id":[[responseObject objectForKey:@"data"] objectForKey:@"val"],@"name":selfLabsField.text};
                [requestArray addObject:selfLabsDic];
                [self.baseTable reloadData];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"添加自定义标签接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame=CGRectMake(0, -216, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    }];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    if (self.view.frame.origin.y!=0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        }];
    }
    [self adddOrEditLabsRequest:@"" andName:textField.text];
    return YES;
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
