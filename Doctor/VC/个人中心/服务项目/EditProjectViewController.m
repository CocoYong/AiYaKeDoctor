//
//  EditProjectViewController.m
//  YSProject
//
//  Created by MrZhang on 15/6/16.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "EditProjectViewController.h"
#import "SkilledViewController.h"
#import "AddServiceViewController.h"

@interface EditProjectViewController ()
{
    NSMutableDictionary  * dataDic;
    CWHttpRequest *request;
    NSMutableArray *allLabsArray;
}
@property (weak, nonatomic) IBOutlet UITableView *baseTable;
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UIButton *deleteCommitButt;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation EditProjectViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"编辑服务项目"];
    [self addBackButt];
    allLabsArray=[NSMutableArray array];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self creatUIItem];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [allLabsArray removeAllObjects];
    [self getBaseUserInfoDic];
  
}
-(void)getBaseUserInfoDic
{
    if ([Reachability checkNetCanUse]) {
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
                [allLabsArray addObjectsFromArray:[dataDic objectForKey:@"labs"]];
                [allLabsArray addObjectsFromArray:[dataDic objectForKey:@"labsSelf"]];
                [self.baseTable reloadData];
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

#pragma mark----tableViewDelegate-------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dataDic objectForKey:@"serviceList"] count]+4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count=[[dataDic objectForKey:@"serviceList"] count];
    if (indexPath.row==0||indexPath.row==2||indexPath.row==count+3) {
        return 44;
    }else if (indexPath.row==1)
    {
        if ([allLabsArray count]%4==0) {
            return (allLabsArray.count/4+1)*44;
        }else if([allLabsArray count]<4)
        {
            return 44;
        }else
        {
            NSInteger numLines=allLabsArray.count/4+1;
            return numLines*44;
        }
    }else
    {
       NSString *text=[[[dataDic objectForKey:@"serviceList"] objectAtIndex:indexPath.row-3] objectForKey:@"content"];
        CGFloat height=[text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
        return height+44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier=@"cellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }else
    {
        for (id view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [self configerTableViewCell:cell withIndexPath:indexPath];
    return cell;
}
-(void)configerTableViewCell:(UITableViewCell*)cell withIndexPath:(NSIndexPath*)indexPath
{
    NSInteger count=[[dataDic objectForKey:@"serviceList"] count];
    if (indexPath.row==0) {
        UILabel *textLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, kSCREEN_WIDTH-40, 20)];
        textLabel.text=@"擅长项目(最多可选10项):";
        textLabel.textAlignment=NSTextAlignmentLeft;
        textLabel.backgroundColor=[UIColor clearColor];
        textLabel.font=[UIFont systemFontOfSize:17];
        [cell.contentView addSubview:textLabel];
    }else if(indexPath.row==1)
    {
        float width=(kSCREEN_WIDTH-50)/4;//横向两个label之间的间距设为10
        float height=30;
        float space=7;//竖向label间距为5
        for (int i=0; i<allLabsArray.count+1; i++) {
            if (i==allLabsArray.count) {
                UIButton *editButt=[UIButton buttonWithType:UIButtonTypeCustom];
                editButt.frame=CGRectMake((width+10)*(i%4)+10, ((space+height)*(i/4))+space, width, height);
                [editButt setBackgroundImage:[UIImage imageNamed:@"0_152"] forState:UIControlStateNormal];
                [editButt setTitle:@"编辑" forState:UIControlStateNormal];
                [editButt addTarget:self action:@selector(addSkillItems) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:editButt];
            }else
            {
                UIImageView *imageView=[[UIImageView alloc]init];
                imageView.tag=i;
                imageView.frame=CGRectMake((width+10)*(i%4)+10, ((space+height)*(i/4))+space, width, height);
                imageView.image=[UIImage imageNamed:@"labs"];
                 imageView.layer.cornerRadius=5.0f;
                [cell.contentView addSubview:imageView];
                UILabel *textLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, width, 20)];
                textLabel.text=[[allLabsArray objectAtIndex:i] valueForKey:@"name"];
                textLabel.textAlignment=NSTextAlignmentCenter;
                textLabel.backgroundColor=[UIColor clearColor];
                textLabel.font=[UIFont systemFontOfSize:14];
                textLabel.textColor=[UIColor hexColor:@"#44708d"];
                [imageView addSubview:textLabel];
            }
         }
    }else if (indexPath.row==2)
    {
        UILabel *textLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, kSCREEN_WIDTH-40, 20)];
        textLabel.text=@"服务项目:";
        textLabel.textAlignment=NSTextAlignmentLeft;
        textLabel.backgroundColor=[UIColor clearColor];
        textLabel.font=[UIFont systemFontOfSize:17];
        [cell.contentView addSubview:textLabel];
    }else if (indexPath.row==count+3)
    {
        UIButton *editButt=[UIButton buttonWithType:UIButtonTypeCustom];
        editButt.frame=CGRectMake(10, 7, 80, 30);
        [editButt setBackgroundImage:[UIImage imageNamed:@"0_152"] forState:UIControlStateNormal];
        [editButt setTitle:@"新增" forState:UIControlStateNormal];
        [editButt addTarget:self action:@selector(addServiceItems) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:editButt];
    }else
    {
        NSString *text=[[[dataDic objectForKey:@"serviceList"] objectAtIndex:indexPath.row-3] objectForKey:@"content"];
        CGFloat height=[text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
        
        UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(10, 5, kSCREEN_WIDTH-20, height+34)];
        backView.layer.borderColor=[CWNSFileUtil colorWithHexString:@"#ffaf06"].CGColor;
        backView.layer.cornerRadius=5.0f;
        backView.layer.borderWidth=1.0f;
        [cell.contentView addSubview:backView];
        
        UIButton *deletButt=[UIButton buttonWithType:UIButtonTypeCustom];
        deletButt.frame=CGRectMake(backView.frame.size.width-10, backView.frame.size.height-10, 10, 10);
        deletButt.tag=indexPath.row;
        [deletButt setBackgroundImage:[UIImage imageNamed:@"0_265"] forState:UIControlStateNormal];
        [deletButt addTarget:self action:@selector(deleteExperience:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:deletButt];
        
        UILabel *typeName=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 150, 21)];
        typeName.text=[[[dataDic objectForKey:@"serviceList"] objectAtIndex:indexPath.row-3] objectForKey:@"typeName"];
        typeName.textColor=[UIColor hexColor:@"#44708d"];
        typeName.font=[UIFont systemFontOfSize:17];
        [backView addSubview:typeName];
        
        
        UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(backView.frame.size.width-150, 5, 145, 21)];
        moneyLabel.textAlignment=NSTextAlignmentRight;
        NSString *moneyString=[NSString stringWithFormat:@"￥%@-￥%@",[[[dataDic objectForKey:@"serviceList"] objectAtIndex:indexPath.row-3] objectForKey:@"feeMin"],[[[dataDic objectForKey:@"serviceList"] objectAtIndex:indexPath.row-3] objectForKey:@"feeMax"]];
        moneyLabel.text=moneyString;
        moneyLabel.textColor=[UIColor hexColor:@"#faac02"];
        moneyLabel.font=[UIFont systemFontOfSize:17];
        [backView addSubview:moneyLabel];
        
        
        UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 30, backView.frame.size.width-10, height)];
        contentLabel.textAlignment=NSTextAlignmentLeft;
        contentLabel.text=[[[dataDic objectForKey:@"serviceList"] objectAtIndex:indexPath.row-3] objectForKey:@"content"];
        contentLabel.textColor=[UIColor grayColor];
        contentLabel.numberOfLines=0;
        contentLabel.lineBreakMode=NSLineBreakByWordWrapping;
        contentLabel.font=[UIFont systemFontOfSize:14];
        [backView addSubview:contentLabel];
    }
}
/*  编辑
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>=3&&indexPath.row<[[dataDic objectForKey:@"serviceList"] count]+3) {
        AddServiceViewController *addServiceController=[[AddServiceViewController alloc]init];
        addServiceController.type=1;
        addServiceController.edittingDic=[[dataDic objectForKey:@"serviceList"] objectAtIndex:indexPath.row-3];
        [self.navigationController pushViewController:addServiceController animated:YES];
    }else
    {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
}
*/
-(void)deleteExperience:(UIButton*)sender
{
    self.alertView.hidden=NO;
    self.backView.hidden=NO;
    self.deleteCommitButt.tag=sender.tag;
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
-(void)addSkillItems
{
    SkilledViewController *skillController=[[SkilledViewController alloc]init];
    [self.navigationController pushViewController:skillController animated:YES];
}
-(void)addServiceItems
{
    AddServiceViewController *addServiceController=[[AddServiceViewController alloc]init];
    addServiceController.type=0;
    [self.navigationController pushViewController:addServiceController animated:YES];
}
-(void)sureButtonAction
{
    [self.navigationController popViewControllerAnimated:NO];
}
//删除服务项目记录
-(void)deleteServiceProjectRequest:(NSInteger)uid
{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
      [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
       NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary= @{@"id":[NSNumber numberWithInteger:uid],@"SessionID":sessionID};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, DeletService] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"好友请求接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0){
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                [self.baseTable reloadData];
            }else
            {
                [SVProgressHUD showErrorWithStatus:[responseObject valueForKeyWithOutNSNull:@"text"]];
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
//删除擅长标签
-(void)deleteSkillLabsRequest:(NSInteger)uid {
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
       NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary= @{@"id":[NSNumber numberWithInteger:uid],@"SessionID":sessionID};
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, DealFriend] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
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
 */
- (IBAction)cancelDeleteAction:(id)sender {
    self.alertView.hidden=YES;
    self.backView.hidden=YES;
}
- (IBAction)commitDeleteAction:(UIButton *)sender {
    self.alertView.hidden=YES;
    self.backView.hidden=YES;
    [self deleteServiceProjectRequest:[[[[dataDic objectForKey:@"serviceList"] objectAtIndex:sender.tag-3] objectForKey:@"id"] integerValue]];
    NSMutableArray *tempArray=[[dataDic objectForKey:@"serviceList"] mutableCopy];
    [tempArray removeObjectAtIndex:sender.tag-3];
    [dataDic setObject:tempArray forKey:@"serviceList"];
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
