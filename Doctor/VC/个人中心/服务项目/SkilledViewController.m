//
//  SkilledViewController.m
//  YSProject
//
//  Created by MrZhang on 15/6/16.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "SkilledViewController.h"
#import "JSONKit.h"
#import "ZhangSkillViewCell.h"
#import "ZhangSkillViewTwoCell.h"
@interface SkilledViewController ()<UITextFieldDelegate>
{
    NSMutableDictionary *dataDic;
    CWHttpRequest *request;
    NSMutableArray *requestArray;
    UITextField *selfLabsField;
    NSMutableArray *finalArray;
}
@property (weak, nonatomic) IBOutlet UITableView *baseTable;
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UIButton *deleteCommiteButt;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;

@end

@implementation SkilledViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"擅长项目"];
    [self addBackButt];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
     self.edgesForExtendedLayout=UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets=NO;
    }
    [self creatUIItem];
    [self.baseTable registerNib:[UINib nibWithNibName:@"ZhangSkillViewCell" bundle:nil] forCellReuseIdentifier:@"ZhangSkillViewCell"];
    [self.baseTable registerNib:[UINib nibWithNibName:@"ZhangSkillViewTwoCell" bundle:nil] forCellReuseIdentifier:@"ZhangSkillViewTwoCell"];
    finalArray=[NSMutableArray array];
    [self creatTableFooterView];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [dataDic removeAllObjects];
    [requestArray removeAllObjects];
    [self getBaseUserInfoDic];
}
-(void)getBaseUserInfoDic
{
    if ([Reachability checkNetCanUse]){
        CWHttpRequest *_loginRequest = [[CWHttpRequest alloc] init];
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"username":[UserManager currentUserManager].loginName, @"password":[UserManager currentUserManager].password, @"userType": @"1",@"SessionID":sessionID};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [_loginRequest JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, Login_URL] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            [SVProgressHUD dismiss];
            NSLog(@"更新个人信息接口成功=======%@", responseObject);
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0) {
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
- (void)getDataFromService{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"id": @"30",@"SessionID":sessionID};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, Index_URL] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"登录接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
            NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0){
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                [userManager synchronize];
                requestArray=[[responseObject valueForKey:@"data"] mutableCopy];
                [requestArray addObjectsFromArray:[dataDic objectForKey:@"labsSelfList"]];
                
                [finalArray addObjectsFromArray:[dataDic objectForKey:@"labs"]];
                [finalArray addObjectsFromArray:[dataDic objectForKey:@"labsSelf"]];
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
    if ([[dataDic objectForKey:@"labsSelfList"]containsObject:[requestArray objectAtIndex:indexPath.row]]) {
      ZhangSkillViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ZhangSkillViewCell"];
        cell.deletButt.tag=indexPath.row+1000;
        cell.deletButt.hidden=NO;
        cell.selectButt.tag=indexPath.row+100;
        [cell.selectButt addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell.deletButt addTarget:self action:@selector(deleteCellData:) forControlEvents:UIControlEventTouchUpInside];
        cell.nameLabel.text=[[requestArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        for (NSDictionary *tempDic in finalArray) {
            if ([[tempDic objectForKey:@"id"] integerValue]==[[[requestArray objectAtIndex:indexPath.row] objectForKey:@"id"]integerValue]) {
                cell.selectButt.selected=YES;
                if (![finalArray containsObject:tempDic]) {
                    [finalArray addObject:tempDic];
                }
            }
        }
        return cell;
    }else
    {
        ZhangSkillViewTwoCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ZhangSkillViewTwoCell"];
          cell.selectButt.tag=indexPath.row+100;
          [cell.selectButt addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
        cell.nameLabel.text=[[requestArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        for (NSDictionary *tempDic in finalArray) {
            if ([[tempDic objectForKey:@"id"] integerValue]==[[[requestArray objectAtIndex:indexPath.row] objectForKey:@"id"]integerValue]) {
                cell.selectButt.selected=YES;
                if (![finalArray containsObject:tempDic]) {
                    [finalArray addObject:tempDic];
                }
            }
        }
        return cell;
    }
    
    //    UIButton *selectedButt=[UIButton buttonWithType:UIButtonTypeCustom];
    //    selectedButt.frame=CGRectMake(kSCREEN_WIDTH-40, 12, 20, 20);
    
    //    [cell.selectButt setBackgroundImage:[UIImage imageNamed:@"0_74"] forState:UIControlStateNormal];
    //    [selectedButt setBackgroundImage:[UIImage imageNamed:@"0_71"] forState:UIControlStateSelected];
  //    [self configerTableViewCell:cell withIndexPath:indexPath];
    
}
-(void)configerTableViewCell:(ZhangSkillViewCell*)cell withIndexPath:(NSIndexPath*)indexPath
{
//    UIButton *selectedButt=[UIButton buttonWithType:UIButtonTypeCustom];
//    selectedButt.frame=CGRectMake(kSCREEN_WIDTH-40, 12, 20, 20);
//     cell.selectButt.tag=indexPath.row+100;
//    [cell.selectButt setBackgroundImage:[UIImage imageNamed:@"0_74"] forState:UIControlStateNormal];
//    [selectedButt setBackgroundImage:[UIImage imageNamed:@"0_71"] forState:UIControlStateSelected];
//    [cell.selectButt addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
    for (NSDictionary *tempDic in finalArray) {
        if ([[tempDic objectForKey:@"id"] integerValue]==[[[requestArray objectAtIndex:indexPath.row] objectForKey:@"id"]integerValue]) {
            cell.selectButt.selected=YES;
            if (![finalArray containsObject:tempDic]) {
            [finalArray addObject:tempDic];
            }
        }
    }
    if ([[dataDic objectForKey:@"labsSelfList"]containsObject:[requestArray objectAtIndex:indexPath.row]]) {
          cell.deletButt.tag=indexPath.row+1000;
          cell.deletButt.hidden=NO;
        [cell.deletButt addTarget:self action:@selector(deleteCellData:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.nameLabel.text=[[requestArray objectAtIndex:indexPath.row] objectForKey:@"name"];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
//    UIButton *butt=(UIButton*)[cell.contentView viewWithTag:indexPath.row+100];
//    butt.selected=!butt.selected;
//    if (butt.selected) {
//        if (finalArray.count>10) {
//            [ShowViewCenterViewController showAlertViewWithTitle:nil message:@"最多可选择十个!" cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:nil cancelBlock:nil otherBlock:nil];
//            butt.selected=!butt.selected;
//            return;
//        }
//        [finalArray addObject:[requestArray objectAtIndex:indexPath.row]];
//    }else
//    {
//        for (int i=0; i<finalArray.count; i++) {
//            NSDictionary *dic=[finalArray objectAtIndex:i];
//            if ([[dic objectForKey:@"id"]integerValue]==[[[requestArray objectAtIndex:indexPath.row] objectForKey:@"id"]integerValue]) {
//                [finalArray removeObject:dic];
//            }
//        }
//    }
   self.view.frame=CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
   self.baseTable.frame=CGRectMake(0, 60, kSCREEN_WIDTH, kSCREEN_HEIGHT-60-80);
}
-(void)itemSelected:(id)sender
{
    UIButton *butt=(UIButton*)sender;
    butt.selected=!butt.selected;
    if (butt.selected){
        if (finalArray.count>10){
            [ShowViewCenterViewController showAlertViewWithTitle:nil message:@"最多可选择十个!" cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:nil cancelBlock:nil otherBlock:nil];
            butt.selected=!butt.selected;
        }else
        {
            if (![finalArray containsObject:[requestArray objectAtIndex:butt.tag-100]]) {
             [finalArray addObject:[requestArray objectAtIndex:butt.tag-100]];
            }
        }
    }else
    {
        for (int i=0; i<finalArray.count; i++) {
            NSDictionary *tempDic=[finalArray objectAtIndex:i];
            if ([[tempDic objectForKey:@"id"]integerValue]==[[[requestArray objectAtIndex:butt.tag-100] objectForKey:@"id"] integerValue]) {
                [finalArray removeObject:tempDic];
            }
        }
    }
}
-(void)deleteCellData:(UIButton *)butt
{
    self.alertView.hidden=NO;
    self.backView.hidden=NO;
    self.deleteCommiteButt.tag=butt.tag;
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
}
-(void)sureButtonAction
{
    /*
    for (NSDictionary *dic in [dataDic objectForKey:@"labs"]) {
        for (int i=0;i<finalArray.count;i++) {
            NSDictionary *tempDic=[finalArray objectAtIndex:i];
            if ([[dic objectForKey:@"id"]integerValue]==[[tempDic objectForKey:@"id"]integerValue]){
                [finalArray removeObjectAtIndex:i];
            }
        }
    }
    for (NSDictionary *dic in [dataDic objectForKey:@"labsSelf"]){
        for (int i=0;i<finalArray.count;i++) {
            NSDictionary *tempDic=[finalArray objectAtIndex:i];
            if ([[dic objectForKey:@"id"]integerValue]==[[tempDic objectForKey:@"id"]integerValue]) {
                [finalArray removeObjectAtIndex:i];
            }
        }
    }
     */
    NSMutableString *selfLabsString=[NSMutableString string];
    NSMutableString *labesString=[NSMutableString string];
    for ( NSDictionary *dic in finalArray) {
        if ([[dataDic objectForKey:@"labsSelfList"] containsObject:dic]) {
            [selfLabsString appendString:[NSString stringWithFormat:@"%@,",[dic objectForKey:@"id"]]];
        }else
        {
            [labesString appendString:[NSString stringWithFormat:@"%@,",[dic objectForKey:@"id"]]];
        }
    }
    [self setLabsRequest:labesString andSelfLabs:selfLabsString];
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
    NSString *selfLab = [selfLabsField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([selfLab length] == 0) {
        [ShowViewCenterViewController showAlertViewWithTitle:nil message:@"请输入您自定义项目名称" cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:nil cancelBlock:nil otherBlock:nil];
        return;
    }
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
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary= @{@"labs":labs,@"SessionID":sessionID,@"labsSelf":selfLabs};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, SetLabs] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"设置擅长自定义标签接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0) {
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"设置擅长自定义标签接口失败=======%@", responseObject);
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
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary= @{@"id":[NSNumber numberWithInteger:uid],@"SessionID":sessionID};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, DeletLabs] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"好友请求接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0) {
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
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
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary= @{@"id":[uid isEqualToString:@""]==YES?@"":uid,@"SessionID":sessionID,@"name":labs};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, AddAndEditlabs] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"添加自定义标签接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0){
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject valueForKeyWithOutNSNull:@"SessionID"];
                [userManager synchronize];
                 selfLabsField.text=nil;
                [self viewWillAppear:YES];
            }else
            {
                [SVProgressHUD showErrorWithStatus:[responseObject valueForKeyWithOutNSNull:@"text"]];
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
    self.baseTable.frame=CGRectMake(0, 60, kSCREEN_WIDTH, kSCREEN_HEIGHT-60-216);
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
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.view.frame.origin.y!=0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        }];
    }
}
- (IBAction)deleteCommitAction:(UIButton *)sender {
    self.alertView.hidden=YES;
    self.backView.hidden=YES;
    [self deleteLabsRequest:[[[requestArray objectAtIndex:sender.tag-1000] objectForKey:@"id"] integerValue]];
    for (int i=0; i<finalArray.count; i++) {
        if ([[[finalArray objectAtIndex:i]objectForKey:@"id"]integerValue]==[[[requestArray objectAtIndex:sender.tag-1000] objectForKey:@"id"] integerValue])
        {
            [finalArray removeObjectAtIndex:i];
        }
    }
    [requestArray removeObjectAtIndex:sender.tag-1000];
}
- (IBAction)cancelDeleteAction:(UIButton *)sender {
    self.alertView.hidden=YES;
    self.backView.hidden=YES;
}
/*
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([selfLabsField isFirstResponder]) {
        self.baseTable.frame=CGRectMake(0, 60, kSCREEN_WIDTH, kSCREEN_HEIGHT-60-216);
        self.baseTable.contentSize=CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT);
    }else
    {
        self.baseTable.frame=CGRectMake(0, 60, kSCREEN_WIDTH, kSCREEN_HEIGHT-60-80);
        self.baseTable.contentSize=CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT);
    }
   [self.view layoutIfNeeded];
}

-(void)updateViewConstraints
{
    [super updateViewConstraints];
    if ([selfLabsField isFirstResponder]) {
        self.view.frame=CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-216);
    }else
    {
        self.view.frame=CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    }
    [self.view layoutIfNeeded];
}
  */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.baseTable endEditing:YES];
    if (self.view.frame.origin.y!=0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
            self.backView.frame=CGRectMake(0, 60, kSCREEN_WIDTH, kSCREEN_HEIGHT-60-80);
        }];
    }
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
