//
//  ProjectViewController.m
//  YSProject
//
//  Created by cuiw on 15/5/30.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "ProjectViewController.h"
#import "EditProjectViewController.h"
#import "UserModel.h"
@interface ProjectViewController ()
{
    NSMutableDictionary * dataDic;
    NSMutableArray *allLabsArray;
}
@property (weak, nonatomic) IBOutlet UITableView *baseTable;

@end

@implementation ProjectViewController

- (void)viewDidLoad {
     [super viewDidLoad];
     [self creatNavgationBarWithTitle:@"服务项目"];
     [self addBackButt];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self creatUIItem];
    allLabsArray=[NSMutableArray array];
//    NSDictionary *userDic=(NSDictionary*)[[CWNSFileUtil sharedInstance]getNSModelFromUserDefaultsWithKey:@"userData"];
//    dataDic=[userDic objectForKey:@"data"];
    

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
    return [[dataDic objectForKey:@"serviceList"] count]+3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        if ([allLabsArray count]%4==0&&allLabsArray.count>=4) {
            return (allLabsArray.count/4)*(7+30)+7;
        }else if([allLabsArray count]<4)
        {
            return 44;
        }else
        {
            NSInteger numLines=allLabsArray.count/4+1;
            return numLines*(7+30)+7;
        }
    }else if (indexPath.row==0||indexPath.row==2)
    {
        return 30;
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
       if(indexPath.row==0){
           UILabel *textLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, kSCREEN_WIDTH-40, 20)];
           textLabel.text=@"擅长项目(最多可选10项):";
           textLabel.textAlignment=NSTextAlignmentLeft;
           textLabel.backgroundColor=[UIColor clearColor];
           textLabel.font=[UIFont systemFontOfSize:17];
           [cell.contentView addSubview:textLabel];
         }
      else if  (indexPath.row==1)
        {
            float width=(kSCREEN_WIDTH-50)/4;//横向两个label之间的间距设为10
            float height=30;
            float space=7;//竖向label间距为5
            for (int i=0; i<allLabsArray.count; i++) {
                    UIImageView *imageView=[[UIImageView alloc]init];
                    imageView.tag=i;
                    imageView.frame=CGRectMake((width+10)*(i%4)+10, ((space+height)*(i/4))+space, width, height);
                    imageView.layer.cornerRadius=5.0f;
                    imageView.image=[UIImage imageNamed:@"labs"];
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
        else if(indexPath.row==2){
            UILabel *textLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, kSCREEN_WIDTH-40, 20)];
            textLabel.text=@"服务项目:";
            textLabel.textAlignment=NSTextAlignmentLeft;
            textLabel.backgroundColor=[UIColor clearColor];
            textLabel.font=[UIFont systemFontOfSize:17];
            [cell.contentView addSubview:textLabel];
        }else
        {
            NSString *text=[[[dataDic objectForKey:@"serviceList"] objectAtIndex:indexPath.row-3] objectForKey:@"content"];
            CGFloat height=[text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
            
          UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(10, 5, kSCREEN_WIDTH-20, height+34)];
            backView.layer.cornerRadius=5.0f;
            backView.layer.borderColor=[UIColor hexColor:@"eeeeee"].CGColor;
            backView.layer.borderWidth=1.0f;
            [cell.contentView addSubview:backView];
            
            UILabel *typeName=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 150, 21)];
            typeName.text=[[[dataDic objectForKey:@"serviceList"] objectAtIndex:indexPath.row-3] valueForKey:@"typeName"];
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
-(void)creatUIItem
{
    UIImageView* OneButtImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-80, kSCREEN_WIDTH, 80)];
    OneButtImageView.image=[UIImage imageNamed:@"0_359"];
    [self.view addSubview:OneButtImageView];
    OneButtImageView.userInteractionEnabled=YES;
    UIButton *itemButt=[UIButton buttonWithType:UIButtonTypeCustom];
    itemButt.frame=CGRectMake(kSCREEN_WIDTH/2-20, 20, 40, 40);
    [itemButt setImage:[UIImage imageNamed:@"0_310"] forState:UIControlStateNormal];
    [itemButt addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [OneButtImageView addSubview:itemButt];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2-20, 60, 40, 20)];
    titleLabel.text=@"更换";
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:10];
    [OneButtImageView addSubview:titleLabel];
}
-(void)editButtonAction
{
    EditProjectViewController *editProjectController=[[EditProjectViewController alloc]init];
    [self.navigationController pushViewController:editProjectController animated:YES];
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
