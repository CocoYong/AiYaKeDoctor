//
//  DoctorViewController.m
//  YSProject
//
//  Created by cuiw on 15/5/30.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "DoctorViewController.h"
#import "SDWebImageDownloader.h"
#import "EditDoctorInfoController.h"
#import  <QuartzCore/QuartzCore.h>
#import "UserModel.h"
@interface DoctorViewController ()
{
    NSMutableDictionary*dataDic;
    CWHttpRequest *request;
    NSMutableArray *areaArray;
    UserModel *userModel;
}
@property (weak, nonatomic) IBOutlet UITableView *baseTable;
@end

@implementation DoctorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"医师简介"];
    [self addBackButt];
    [self creatUIItem];
    [self getAreaDataFromService];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets=NO;
    userModel=[UserManager currentUserManager].user;
    NSLog(@"username==%@",userModel.username);
    userModel.username=@"woailuo";
    [[UserManager currentUserManager] synchronize];
    NSLog(@"username==%@",userModel.username);
    
    
    
}
- (void)getAreaDataFromService {
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"id": @"29",@"SessionID":sessionID};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, Index_URL] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"地区接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0) {
                UserManager *usermanager=[UserManager currentUserManager];
                usermanager.sessionID=[responseObject objectForKey:@"SessionID"];
                [usermanager synchronize];
                areaArray=[[responseObject objectForKey:@"data"] mutableCopy];
                [self.baseTable reloadData];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"地区接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [dataDic removeAllObjects];
    [self getBaseUserInfoDic];
//    dataDic=[[CWNSFileUtil sharedInstance]getNSModelFromUserDefaultsWithKey:@"userData"];
}
#pragma mark----tableViewDelegate-------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 13;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==5) {
        NSArray *licenseArray=[dataDic objectForKey:@"licenseList"];
        if (licenseArray.count%4==0) {
            if (licenseArray.count==0) {
                return 70;
            }else
            {
            return 70*((licenseArray.count)/4);
            }
        }else
        {
            if (licenseArray.count<4) {
                return 70;
            }else
            {
                return 70*((licenseArray.count/4)+1);
            }
        }
    }if (indexPath.row==12) {
        CGRect rect=[[dataDic objectForKey:@"content"] boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        return CGRectGetHeight(rect)+50;
    }else
    {
     return 44;   
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier=@"cellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [self configerTableViewCell:cell withIndexPath:indexPath];
    return cell;
}
-(void)configerTableViewCell:(UITableViewCell*)cell withIndexPath:(NSIndexPath*)indexPath
{
    switch (indexPath.row){
        case 0:
            cell.textLabel.text=[NSString stringWithFormat:@"真实姓名:%@",[dataDic objectForKey:@"name"]==nil?@"":[dataDic objectForKey:@"name"]];
            cell.textLabel.textColor=[UIColor hexColor:@"#959595"];
            break;
        case 1:
            if ([[dataDic objectForKey:@"sex"] isEqualToString:@"0"]) {
            cell.textLabel.text=[NSString stringWithFormat:@"性别:%@",@"女"];
                cell.textLabel.textColor=[UIColor hexColor:@"#959595"];
            }else
            {
            cell.textLabel.text=[NSString stringWithFormat:@"性别:%@",@"男"];
                cell.textLabel.textColor=[UIColor hexColor:@"#959595"];
            }
            break;
        case 2:
             cell.textLabel.text=[NSString stringWithFormat:@"医师职业证书号:%@",[dataDic objectForKey:@"certCode"]==nil?@"":[dataDic objectForKey:@"certCode"]];
            cell.textLabel.textColor=[UIColor hexColor:@"#959595"];
            break;
        case 3:
             cell.textLabel.text=[NSString stringWithFormat:@"职称:%@",[dataDic objectForKey:@"titleName"]==nil?@"":[dataDic objectForKey:@"titleName"]];
            cell.textLabel.textColor=[UIColor hexColor:@"#959595"];
            break;
        case 4:
             cell.textLabel.text=[NSString stringWithFormat:@"医师职业证书照片:"];
            cell.textLabel.textColor=[UIColor hexColor:@"#959595"];
            break;
        case 5:
        {
            NSArray *licenseArray=[dataDic objectForKey:@"licenseList"];
            float padding = 20;
            float y = 10;
            float imageW = 60;
            float offW=(kSCREEN_WIDTH-280)/3;
            if ([licenseArray count]== 0) {
                cell.hidden=YES;
            }else{
                cell.hidden = NO;
            }
              for (int i=0;i <[licenseArray count]; i++) {
                UIImageView *licenseImageView = [[UIImageView alloc]init];
                licenseImageView.tag = i;
                licenseImageView.frame = CGRectMake(i%4*(offW+imageW) + padding, y + floor(i/4)*(10+imageW) , imageW, imageW);
                NSString *urlString=[NSString stringWithFormat:@"%@",[[licenseArray objectAtIndex:i] objectForKey:@"picUrl"]];
                  [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                      licenseImageView.image=image;
                  }];
                [cell.contentView addSubview:licenseImageView];
            }
        }
            break;
        case 6:
            cell.textLabel.text=[NSString stringWithFormat:@"手机号:%@",[dataDic objectForKey:@"username"]];
            cell.textLabel.textColor=[UIColor hexColor:@"#959595"];
            break;
        case 7:
             cell.textLabel.text=[NSString stringWithFormat:@"门诊名称:%@",[dataDic objectForKey:@"company"]==nil?@"":[dataDic objectForKey:@"company"]];
            cell.textLabel.textColor=[UIColor hexColor:@"#959595"];
            break;
        case 8:
             cell.textLabel.text=[NSString stringWithFormat:@"门诊电话:%@",[dataDic objectForKey:@"tel"]==nil?@"":[dataDic objectForKey:@"tel"]];
            cell.textLabel.textColor=[UIColor hexColor:@"#959595"];
            break;
        case 9:
        {
            if ([dataDic objectForKey:@"area3"]==nil||[[dataDic objectForKey:@"area3"] isEqualToString:@""]) {
                cell.textLabel.text=@"所在地区:";
                cell.textLabel.textColor=[UIColor hexColor:@"#959595"];
            }else
            {
                for (NSDictionary *dic in areaArray) {
                    if ([[dic objectForKey:@"id"] isEqualToString:[dataDic objectForKey:@"area3"]]) {
                        cell.textLabel.text=[NSString stringWithFormat:@"所在地区:%@",[dic objectForKey:@"name"]];
                        cell.textLabel.textColor=[UIColor hexColor:@"#959595"];
                    }
                }
   
            }
        }
            break;
        case 10:
             cell.textLabel.text=[NSString stringWithFormat:@"门诊地址:%@",[dataDic objectForKey:@"address"]==nil?@"":[dataDic objectForKey:@"address"]];
            cell.textLabel.textColor=[UIColor hexColor:@"#959595"];
            break;
        case 11:
             cell.textLabel.text=[NSString stringWithFormat:@"医生简介:"];
            cell.textLabel.textColor=[UIColor hexColor:@"#959595"];
            break;
        case 12:{
            NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineSpacing=10;
            NSMutableAttributedString *attributString=[[NSMutableAttributedString alloc]initWithString:[dataDic objectForKey:@"content"]==nil?@"":[dataDic objectForKey:@"content"]];
            [attributString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributString length])];
            cell.textLabel.attributedText=attributString;
            cell.textLabel.numberOfLines=0;
            cell.textLabel.textColor=[UIColor hexColor:@"#959595"];
            cell.textLabel.lineBreakMode=NSLineBreakByWordWrapping;
           }
            break;
              default:
            break;
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
    [itemButt setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    [itemButt addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [OneButtImageView addSubview:itemButt];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2-20, 60, 40, 20)];
    titleLabel.text=@"编辑";
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:10];
    [OneButtImageView addSubview:titleLabel];
}
-(void)editButtonAction
{
    EditDoctorInfoController *editInfoOfDoctor=[[EditDoctorInfoController alloc]init];
    [self.navigationController pushViewController:editInfoOfDoctor animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
