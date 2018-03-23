//
//  ExperienceViewController.m
//  YSProject
//
//  Created by cuiw on 15/5/30.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "ExperienceViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "EditExperienceViewController.h"
#import "UserModel.h"
#import "EduModel.h"
#import "WorkModel.h"
#import "CaseModel.h"
@interface ExperienceViewController ()
{
    NSMutableDictionary* dataDic;
    NSArray *caseLabelArray;
}
@property (weak, nonatomic) IBOutlet UITableView *baseTable;

@end

@implementation ExperienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"个人背景"];
    [self addBackButt];
     self.edgesForExtendedLayout = UIRectEdgeNone;
     self.automaticallyAdjustsScrollViewInsets=NO;
    [self creatUIItem];
  

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
    [dataDic removeAllObjects];
     caseLabelArray=@[@"术前",@"术中",@"术后"];
    [self getBaseUserInfoDic];
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
    EditExperienceViewController *editExperienceController=[[EditExperienceViewController alloc]init];
    [self.navigationController pushViewController:editExperienceController animated:YES];
}
#pragma mark----tableViewDelegate-------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        if ([[dataDic objectForKey:@"eduList"] count]==0) {
            return 1;
        }
        return [[dataDic objectForKey:@"eduList"] count];
    }else if (section==1)
    {
        if ([[dataDic objectForKey:@"workList"] count]==0) {
            return 1;
        }
      return [[dataDic objectForKey:@"workList"] count];
    }else
    {
        if ([[dataDic objectForKey:@"caseList"] count]==0) {
            return 1;
        }
     return [[dataDic objectForKey:@"caseList"] count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if ([[dataDic objectForKey:@"eduList"]count]==0) {
            return 120;
        }else
        {
        NSString *testHeightString=[[[dataDic objectForKey:@"eduList"] objectAtIndex:indexPath.row] objectForKey:@"content"];
        CGFloat height=[testHeightString boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-60, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
        return height+44;
        }
    }
    else if (indexPath.section==1) {
        if ([[dataDic objectForKey:@"workList"]count]==0) {
            return 120;
        }else
        {
        NSString *testHeightString=[[[dataDic objectForKey:@"workList"] objectAtIndex:indexPath.row] objectForKey:@"content"];
        CGFloat height=[testHeightString boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-60, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
        return height+44;
        }
    }
    else {
        if ([[dataDic objectForKey:@"caseList"]count]==0) {
            return 120;
        }else
        {
            NSString *testHeightString=[[[dataDic objectForKey:@"caseList"] objectAtIndex:indexPath.row] objectForKey:@"content"];
            CGFloat height=[testHeightString boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-60, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
            return (kSCREEN_WIDTH-40)/3+height+110;
        }
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
    tableView.tableFooterView=[UIView new];
    [self configerTableViewCell:cell withIndexPath:indexPath];
    return cell;
}
-(void)configerTableViewCell:(UITableViewCell*)cell withIndexPath:(NSIndexPath*)indexPath
{
    switch (indexPath.section) {
        case 0:
            {
                if ([[dataDic objectForKey:@"eduList"] count]==0) {
                    UIImageView *noDataImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 20, kSCREEN_WIDTH-40, 80)];
                    noDataImageView.image=[UIImage imageNamed:@"icon_no_data_bg"];
                    [cell.contentView addSubview:noDataImageView];
                     UILabel *noDataLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH-40, noDataImageView.frame.size.height)];
                    noDataLabel.textAlignment=NSTextAlignmentCenter;
                    noDataLabel.text=@"没有上传教育背景";
                    noDataLabel.textColor=[UIColor whiteColor];
                    noDataLabel.backgroundColor=[UIColor clearColor];
                    noDataLabel.font=[UIFont systemFontOfSize:36];
                    [noDataImageView addSubview:noDataLabel];
                }else{
                    
                    NSString *testHeightString=[[[dataDic objectForKey:@"eduList"] objectAtIndex:indexPath.row] objectForKey:@"content"];
                    CGFloat height=[testHeightString boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-60, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
                    
                    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(20, 7, kSCREEN_WIDTH-40, height+30)];
                    backView.layer.cornerRadius=5.0f;
                    backView.layer.borderColor=[UIColor hexColor:@"#c2e4f0"].CGColor;
                    backView.layer.borderWidth=1.0f;
                    [cell.contentView addSubview:backView];
                    
                    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 2, 130, 21)];
                    NSString *timeString=[NSString stringWithFormat:@"%@-%@",[[[dataDic objectForKey:@"eduList"] objectAtIndex:indexPath.row] objectForKey:@"year1"],[[[dataDic objectForKey:@"eduList"] objectAtIndex:indexPath.row] objectForKey:@"year2"]];
                    timeLabel.text=timeString;
                    timeLabel.textColor=[UIColor hexColor:@"#81c7e9"];
                    timeLabel.textAlignment=NSTextAlignmentLeft;
                    timeLabel.font=[UIFont systemFontOfSize:14];
                    [backView addSubview:timeLabel];
                    
                    UILabel *locationLabel=[[UILabel alloc]initWithFrame:CGRectMake(150, 2, 130, 21)];
                    locationLabel.text=[[[dataDic objectForKey:@"eduList"] objectAtIndex:indexPath.row] objectForKey:@"name"];
                    locationLabel.textColor=[UIColor hexColor:@"#81c7e9"];
                    locationLabel.textAlignment=NSTextAlignmentLeft;
                    locationLabel.font=[UIFont systemFontOfSize:14];
                    [backView addSubview:locationLabel];
                    
                    UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, kSCREEN_WIDTH-60, height)];
                    contentLabel.text=[[[dataDic objectForKey:@"eduList"] objectAtIndex:indexPath.row] objectForKey:@"content"];
                    contentLabel.textColor=[UIColor lightGrayColor];
                    contentLabel.textAlignment=NSTextAlignmentLeft;
                    contentLabel.font=[UIFont systemFontOfSize:14];
                    contentLabel.numberOfLines=0;
                    contentLabel.lineBreakMode=NSLineBreakByWordWrapping;
                    [backView addSubview:contentLabel];
                }
            }
            break;
        case 1:
            {
                if ([[dataDic objectForKey:@"workList"] count]==0) {
                    UIImageView *noDataImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 20, kSCREEN_WIDTH-40, 80)];
                    noDataImageView.image=[UIImage imageNamed:@"icon_no_data_bg"];
                    [cell.contentView addSubview:noDataImageView];
                    UILabel *noDataLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH-40, noDataImageView.frame.size.height)];
                    noDataLabel.textAlignment=NSTextAlignmentCenter;
                    noDataLabel.text=@"没有上传工作背景";
                    noDataLabel.textColor=[UIColor whiteColor];
                    noDataLabel.backgroundColor=[UIColor clearColor];
                    noDataLabel.font=[UIFont systemFontOfSize:36];
                    [noDataImageView addSubview:noDataLabel];
                }else{
                    
                    NSString *testHeightString=[[[dataDic objectForKey:@"workList"] objectAtIndex:indexPath.row] objectForKey:@"content"];
                    CGFloat height=[testHeightString boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-60, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
                    
                    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(20, 7, kSCREEN_WIDTH-40, height+30)];
                    backView.layer.cornerRadius=5.0f;
                    backView.layer.borderColor=[UIColor hexColor:@"#c2e4f0"].CGColor;
                    backView.layer.borderWidth=1.0f;
                    [cell.contentView addSubview:backView];
                    
                    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 2, 130, 21)];
                    NSString *timeString=[NSString stringWithFormat:@"%@-%@",[[[dataDic objectForKey:@"workList"] objectAtIndex:indexPath.row] objectForKey:@"year1"],[[[dataDic objectForKey:@"workList"] objectAtIndex:indexPath.row] objectForKey:@"year2"]];
                    timeLabel.text=timeString;
                    timeLabel.textColor=[UIColor hexColor:@"#81c7e9"];
                    timeLabel.textAlignment=NSTextAlignmentLeft;
                    timeLabel.font=[UIFont systemFontOfSize:14];
                    [backView addSubview:timeLabel];
                    
                    UILabel *locationLabel=[[UILabel alloc]initWithFrame:CGRectMake(150, 2, 130, 21)];
                    locationLabel.text=[[[dataDic objectForKey:@"workList"] objectAtIndex:indexPath.row] objectForKey:@"name"];
                    locationLabel.textColor=[UIColor hexColor:@"#81c7e9"];
                    locationLabel.textAlignment=NSTextAlignmentLeft;
                    locationLabel.font=[UIFont systemFontOfSize:14];
                    [backView addSubview:locationLabel];
                    
                    UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, kSCREEN_WIDTH-60, height)];
                    contentLabel.text=[[[dataDic objectForKey:@"workList"] objectAtIndex:indexPath.row] objectForKey:@"content"];
                    contentLabel.textColor=[UIColor lightGrayColor];
                    contentLabel.textAlignment=NSTextAlignmentLeft;
                    contentLabel.font=[UIFont systemFontOfSize:14];
                    contentLabel.numberOfLines=0;
                    contentLabel.lineBreakMode=NSLineBreakByWordWrapping;
                    [backView addSubview:contentLabel];
                }
            }
            break;
        case 2:
            {
                if ([[dataDic objectForKey:@"caseList"] count]==0) {
                    UIImageView *noDataImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 20, kSCREEN_WIDTH-40, 80)];
                    noDataImageView.image=[UIImage imageNamed:@"icon_no_data_bg"];
                    [cell.contentView addSubview:noDataImageView];
                    UILabel *noDataLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH-40, noDataImageView.frame.size.height)];
                    noDataLabel.textAlignment=NSTextAlignmentCenter;
                    noDataLabel.text=@"没有上传案例";
                    noDataLabel.textColor=[UIColor whiteColor];
                    noDataLabel.backgroundColor=[UIColor clearColor];
                    noDataLabel.font=[UIFont systemFontOfSize:36];
                    [noDataImageView addSubview:noDataLabel];
                }else{
                    
//                    UILabel *titLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, kSCREEN_WIDTH-100, 20)];
//                    titLabel.text=@"案例";
//                    [cell.contentView addSubview:titLabel];
                    
                    NSString *testHeightString=[[[dataDic objectForKey:@"caseList"] objectAtIndex:indexPath.row] objectForKey:@"content"];
                    CGFloat height=[testHeightString boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-60, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
                    
                    UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 30, kSCREEN_WIDTH-40, height)];
                    contentLabel.text=[[[dataDic objectForKey:@"caseList"] objectAtIndex:indexPath.row] objectForKey:@"content"];
                    contentLabel.textColor=[UIColor lightGrayColor];
                    contentLabel.textAlignment=NSTextAlignmentLeft;
                    contentLabel.font=[UIFont systemFontOfSize:14];
                    contentLabel.numberOfLines=0;
                    contentLabel.lineBreakMode=NSLineBreakByWordWrapping;
                    [cell.contentView addSubview:contentLabel];
                    
                    
                    
                    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(contentLabel.frame)+10, kSCREEN_WIDTH-100, 20)];
                    timeLabel.text=[NSString stringWithFormat:@"上传于%@",[[[dataDic objectForKey:@"caseList"] objectAtIndex:indexPath.row] objectForKey:@"createTime"]];
                    timeLabel.font=[UIFont systemFontOfSize:14];
                    timeLabel.textColor=[UIColor lightGrayColor];
                    [cell.contentView addSubview:timeLabel];
                    
                    
                    CGFloat imageWidth=(kSCREEN_WIDTH-80)/3;
                    for (int i=0; i<3; i++){
                        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*(imageWidth+20)+20,CGRectGetMaxY(timeLabel.frame)+10 , imageWidth, imageWidth)];
                        [imageView sd_setImageWithURL:[NSURL URLWithString:[[[dataDic objectForKey:@"caseList"] objectAtIndex:indexPath.row] objectForKey:[NSString stringWithFormat:@"pic%dUrl",i+1]]] placeholderImage:nil options:SDWebImageHighPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        }];
                        [cell.contentView addSubview:imageView];
                        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(i*(imageWidth+20)+20, CGRectGetMaxY(imageView.frame)+10, imageWidth, 21)];
                        label.text=[caseLabelArray objectAtIndex:i];
                        label.textAlignment=NSTextAlignmentCenter;
                        [cell.contentView addSubview:label];
                        if ([[[[dataDic objectForKey:@"caseList"] objectAtIndex:indexPath.row] objectForKey:[NSString stringWithFormat:@"pic%dUrl",i+1]] isEqualToString:@""]||[[[dataDic objectForKey:@"caseList"] objectAtIndex:indexPath.row] objectForKey:[NSString stringWithFormat:@"pic%dUrl",i+1]]==nil) {
                            label.hidden=YES;
                        }
                    }
                }
            }
            break;
            
        default:
            break;
    }
}
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&[[dataDic objectForKey:@"eduList"] count]==0)
    {
        
    }if(indexPath.section==1&&[[dataDic objectForKey:@"workList"] count]==0)
    {
        
    }if(indexPath.section==2&&[[dataDic objectForKey:@"caseList"] count]==0)
    {
        
    }
}
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return  nil;
    }
    UILabel * label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 0, 320, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor blackColor];
    label.font=[UIFont fontWithName:@"Arial" size:14];
    label.text = sectionTitle;
    
    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [sectionView setBackgroundColor:[UIColor hexColor:@"ffffff"]];
    [sectionView addSubview:label];
    return sectionView;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
      return @"教育背景:";
    }else if (section==1)
    {
      return @"工作背景:";
    }else
    {
      return @"案例:";
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
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
