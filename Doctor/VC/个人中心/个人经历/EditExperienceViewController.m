//
//  EditExperienceViewController.m
//  YSProject
//
//  Created by MrZhang on 15/6/16.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "EditExperienceViewController.h"
#import "UIImageView+WebCache.h"
#import "EditDetailViewController.h"
#import "AddCaseViewController.h"
@interface EditExperienceViewController ()
{
    NSMutableDictionary *dataDic;
    NSArray *caseLabelArray;
    CWHttpRequest *request;
}
@property (weak, nonatomic) IBOutlet UITableView *baseTable;
@property (weak, nonatomic) IBOutlet UIView *backGrayView;
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UIButton *commitButt;
@property (weak, nonatomic) IBOutlet UIButton *cancelButt;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;
@end

@implementation EditExperienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"个人背景"];
    [self addBackButt];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self creatUIItem];
    caseLabelArray=@[@"术前",@"术中",@"术后"];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [dataDic removeAllObjects];
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
    [itemButt setImage:[UIImage imageNamed:@"0_173"] forState:UIControlStateNormal];
    [itemButt setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    [itemButt addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [OneButtImageView addSubview:itemButt];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2-20, 60, 40, 20)];
    titleLabel.text=@"确认";
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:10];
    [OneButtImageView addSubview:titleLabel];
}
-(void)editButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
-(void)deleteExperience:(UIButton*)butt
{
    NSInteger section=butt.tag/100;
    if (section==0) {
     self.remindLabel.text=@"您确认删除此教育经历？";
    }if (section==1) {
     self.remindLabel.text=@"您确认删除此工作经历？";
    }if (section==2) {
      self.remindLabel.text=@"您确认删除此案例？";
    }
    self.backGrayView.hidden=NO;
    self.alertView.hidden=NO;
    self.commitButt.tag=butt.tag;
}
- (void)deleteExperienceWithID:(NSString*)idString andType:(NSString*)type{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
       NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"SessionID":sessionID,@"id":[NSNumber numberWithInteger:[idString integerValue]]};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, type] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"服务项目接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            NSString *text = [responseObject valueForKeyWithOutNSNull:@"text"];
            if ([code integerValue]==0) {
             UserManager *userManager=[UserManager currentUserManager];
                 userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            }
            [self.baseTable reloadData];
            NSLog(@"text====%@",text);
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"服务项目接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
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
        return [[dataDic objectForKey:@"eduList"] count]+1;
    }else if (section==1)
    {
        if ([[dataDic objectForKey:@"workList"] count]==0) {
            return 1;
        }
        return [[dataDic objectForKey:@"workList"] count]+1;
    }else
    {
        if ([[dataDic objectForKey:@"caseList"] count]==0) {
            return 1;
        }
        return [[dataDic objectForKey:@"caseList"] count]+1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if ([[dataDic objectForKey:@"eduList"] count]==indexPath.row) {
                return 44;
            }else
            {
                NSString *testHeightString=[[[dataDic objectForKey:@"eduList"] objectAtIndex:indexPath.row] objectForKey:@"content"];
                CGFloat height=[testHeightString boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-60, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
                return height+44;
            }
        }
            break;
        case 1:
        {
            if ([[dataDic objectForKey:@"workList"] count]==indexPath.row) {
                return 44;
            }
            else{
                NSString *testHeightString=[[[dataDic objectForKey:@"workList"] objectAtIndex:indexPath.row] objectForKey:@"content"];
                CGFloat height=[testHeightString boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-60, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
                return height+44;
            }
        }
            break;
        case 2:
        {
            if ([[dataDic objectForKey:@"caseList"] count]==indexPath.row) {
                return 44;
            }
            NSString *testHeightString=[[[dataDic objectForKey:@"caseList"] objectAtIndex:indexPath.row] objectForKey:@"content"];
            CGFloat height=[testHeightString boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-60, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
            return (kSCREEN_WIDTH-40)/3+height+100;
        }
            break;
        default:
            break;
    }
    return 0;
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
    tableView.tableFooterView=[UIView new];
    return cell;
}
-(void)configerTableViewCell:(UITableViewCell*)cell withIndexPath:(NSIndexPath*)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if ([[dataDic objectForKey:@"eduList"] count]==indexPath.row) {
                UIButton *addButt=[UIButton buttonWithType:UIButtonTypeCustom];
                addButt.frame=CGRectMake(20, 7, 70, 30);
                addButt.tag=indexPath.section;
                [addButt setBackgroundImage:[UIImage imageNamed:@"0_285"] forState:UIControlStateNormal];
               [addButt addTarget:self action:@selector(goEditDetailViewController:) forControlEvents:UIControlEventTouchUpInside];
                [addButt setTitle:@"新增" forState:UIControlStateNormal];
                [cell.contentView addSubview:addButt];
            }else{
                
                NSString *testHeightString=[[[dataDic objectForKey:@"eduList"] objectAtIndex:indexPath.row] objectForKey:@"content"];
                CGFloat height=[testHeightString boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-60, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
                
                UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(20, 7, kSCREEN_WIDTH-40, height+30)];
                backView.layer.cornerRadius=5.0f;
                backView.layer.borderColor=[CWNSFileUtil colorWithHexString:@"#c3e3ee"].CGColor;
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
                
                
                UIButton *deletButt=[UIButton buttonWithType:UIButtonTypeCustom];
                deletButt.frame=CGRectMake(CGRectGetWidth(backView.frame)-10, CGRectGetHeight(backView.frame)-10, 10, 10);
                [deletButt setBackgroundImage:[UIImage imageNamed:@"0_265"] forState:UIControlStateNormal];
                deletButt.tag=(indexPath.section*100)+indexPath.row;
                [deletButt addTarget:self action:@selector(deleteExperience:) forControlEvents:UIControlEventTouchUpInside];
                [backView addSubview:deletButt];
            }
        }
            break;
        case 1:
        {
            if ([[dataDic objectForKey:@"workList"] count]==indexPath.row) {
                UIButton *addButt=[UIButton buttonWithType:UIButtonTypeCustom];
                addButt.frame=CGRectMake(20, 7, 70, 30);
                addButt.tag=indexPath.section;
                [addButt setBackgroundImage:[UIImage imageNamed:@"0_285"] forState:UIControlStateNormal];
                [addButt addTarget:self action:@selector(goEditDetailViewController:) forControlEvents:UIControlEventTouchUpInside];
                [addButt setTitle:@"新增" forState:UIControlStateNormal];
                [cell.contentView addSubview:addButt];
            }else{
                
                NSString *testHeightString=[[[dataDic objectForKey:@"workList"] objectAtIndex:indexPath.row] objectForKey:@"content"];
                CGFloat height=[testHeightString boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-60, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
                
                UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(20, 7, kSCREEN_WIDTH-40, height+30)];
                backView.layer.cornerRadius=5.0f;
                backView.layer.borderColor=[CWNSFileUtil colorWithHexString:@"#c3e3ee"].CGColor;
                backView.layer.borderWidth=1.0f;
                [cell.contentView addSubview:backView];
                
                UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 2, 130, 21)];
                NSString *timeString=[NSString stringWithFormat:@"%@-%@",[[[dataDic objectForKey:@"workList"] objectAtIndex:indexPath.row] valueForKey:@"year1"],[[[dataDic objectForKey:@"workList"] objectAtIndex:indexPath.row] valueForKey:@"year2"]];
                timeLabel.text=timeString;
                timeLabel.textColor=[UIColor hexColor:@"#81c7e9"];
                timeLabel.textAlignment=NSTextAlignmentLeft;
                timeLabel.font=[UIFont systemFontOfSize:14];
                [backView addSubview:timeLabel];
                
                UILabel *locationLabel=[[UILabel alloc]initWithFrame:CGRectMake(150, 2, 130, 21)];
                locationLabel.text=[[[dataDic objectForKey:@"workList"] objectAtIndex:indexPath.row] valueForKey:@"name"];
                locationLabel.textColor=[UIColor hexColor:@"#81c7e9"];
                locationLabel.textAlignment=NSTextAlignmentLeft;
                locationLabel.font=[UIFont systemFontOfSize:14];
                [backView addSubview:locationLabel];
                
                UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, kSCREEN_WIDTH-60, height)];
                contentLabel.text=[[[dataDic objectForKey:@"workList"] objectAtIndex:indexPath.row] valueForKey:@"content"];
                contentLabel.textColor=[UIColor lightGrayColor];
                contentLabel.textAlignment=NSTextAlignmentLeft;
                contentLabel.font=[UIFont systemFontOfSize:14];
                contentLabel.numberOfLines=0;
                contentLabel.lineBreakMode=NSLineBreakByWordWrapping;
                [backView addSubview:contentLabel];
                
                UIButton *deletButt=[UIButton buttonWithType:UIButtonTypeCustom];
                deletButt.frame=CGRectMake(CGRectGetWidth(backView.frame)-10, CGRectGetHeight(backView.frame)-10, 10, 10);
                [deletButt setBackgroundImage:[UIImage imageNamed:@"0_265"] forState:UIControlStateNormal];
                deletButt.tag=(indexPath.section*100)+indexPath.row;
                [deletButt addTarget:self action:@selector(deleteExperience:) forControlEvents:UIControlEventTouchUpInside];
                [backView addSubview:deletButt];
            }
        }
            break;
        case 2:
        {
            if ([[dataDic objectForKey:@"caseList"] count]==indexPath.row) {
                UIButton *addButt=[UIButton buttonWithType:UIButtonTypeCustom];
                addButt.frame=CGRectMake(kSCREEN_WIDTH/2-40 , 7, 80, 30);
                addButt.tag=indexPath.section;
                [addButt setBackgroundImage:[UIImage imageNamed:@"0_285"] forState:UIControlStateNormal];
                [addButt addTarget:self action:@selector(goEditDetailViewController:) forControlEvents:UIControlEventTouchUpInside];
                [addButt setTitle:@"新增" forState:UIControlStateNormal];
                [cell.contentView addSubview:addButt];
            }else{
//                UILabel *titLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 150, 20)];
//                titLabel.text=@"案例";
//                [cell.contentView addSubview:titLabel];
                
                NSString *testHeightString=[[[dataDic objectForKey:@"caseList"] objectAtIndex:indexPath.row] objectForKey:@"content"];
                CGFloat height=[testHeightString boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-60, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
                
                UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 30, kSCREEN_WIDTH-60, height)];
                contentLabel.text=[[[dataDic objectForKey:@"caseList"] objectAtIndex:indexPath.row] valueForKey:@"content"];
                contentLabel.textColor=[UIColor lightGrayColor];
                contentLabel.textAlignment=NSTextAlignmentLeft;
                contentLabel.font=[UIFont systemFontOfSize:14];
                contentLabel.numberOfLines=0;
                contentLabel.lineBreakMode=NSLineBreakByWordWrapping;
                [cell.contentView addSubview:contentLabel];
                
                UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(contentLabel.frame)+10, 170, 21)];
                timeLabel.text=[NSString stringWithFormat:@"上传于:%@",[[[dataDic objectForKey:@"caseList"] objectAtIndex:indexPath.row] valueForKey:@"createTime"]];
                timeLabel.textColor=[UIColor lightGrayColor];
                timeLabel.textAlignment=NSTextAlignmentLeft;
                timeLabel.font=[UIFont systemFontOfSize:14];
                [cell.contentView addSubview:timeLabel];
                
                UIButton *deletButt=[UIButton buttonWithType:UIButtonTypeCustom];
                deletButt.frame=CGRectMake(CGRectGetMaxX(timeLabel.frame)+50,CGRectGetMinY(timeLabel.frame), 20, 20);
                [deletButt setBackgroundImage:[UIImage imageNamed:@"0_26"] forState:UIControlStateNormal];
                deletButt.tag=(indexPath.section*100)+indexPath.row;
                [deletButt addTarget:self action:@selector(deleteExperience:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:deletButt];
                 CGFloat imageWidth=(kSCREEN_WIDTH-80)/3;
                for (int i=0; i<3; i++) {
                    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*(imageWidth+20)+20,CGRectGetMaxY(timeLabel.frame)+10, imageWidth, imageWidth)];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:[[[dataDic objectForKey:@"caseList"] objectAtIndex:indexPath.row]  objectForKey:[NSString stringWithFormat:@"pic%dUrl",i+1]]] placeholderImage:nil options:SDWebImageDelayPlaceholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        imageView.image=image;
                    }];
                    [cell.contentView addSubview:imageView];
                    
                    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(i*(imageWidth+20)+20,CGRectGetMaxY(imageView.frame)+10, imageWidth, 21)];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   /*
    if (indexPath.section==0&&[[dataDic objectForKey:@"eduList"] count]!=0)
    {
         if (indexPath.row<[[dataDic objectForKey:@"eduList"] count]) {
        EditDetailViewController *editCotroller=[[EditDetailViewController alloc]init];
        editCotroller.comingType=1;
        editCotroller.dataDic=[[dataDic objectForKey:@"eduList"] objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:editCotroller animated:YES];
         }
    }if(indexPath.section==1&&[[dataDic objectForKey:@"workList"] count]!=0)
    {
        if (indexPath.row<[[dataDic objectForKey:@"workList"] count]) {
            EditDetailViewController *editCotroller=[[EditDetailViewController alloc]init];
            editCotroller.comingType=0;
            editCotroller.dataDic=[[dataDic objectForKey:@"workList"] objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:editCotroller animated:YES];
        }
    }
     */
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section==0){
       if (indexPath.row<[[dataDic objectForKey:@"eduList"] count]) {
           UIButton *butt=(UIButton*)[cell.contentView viewWithTag:indexPath.row];
           [self deleteExperience:butt];
       }

    }if (indexPath.section==1) {
        if (indexPath.row<[[dataDic objectForKey:@"workList"] count]) {
            NSInteger buttTag=indexPath.section*100+indexPath.row;
            UIButton *butt=(UIButton*)[cell.contentView viewWithTag:buttTag];
            [self deleteExperience:butt];
        }
    }
    [self.baseTable reloadData];
    /*
    if(indexPath.section==2&&[[dataDic objectForKey:@"caseList"] count]!=0)
    {
        if (indexPath.row<[[dataDic objectForKey:@"caseList"] count]) {
            AddCaseViewController *addCaseController=[[AddCaseViewController alloc]init];
            addCaseController.dataDic=[[dataDic objectForKey:@"workList"] objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:addCaseController animated:YES];
        }
    }
     */
}

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
        return @"教育背景";
    }else if (section==1)
    {
        return @"工作背景";
    }else
    {
        return @"案例:";
    }
}
-(void)goEditDetailViewController:(id)sender
{
    UIButton *tempButt=(UIButton*)sender;
    if (tempButt.tag==0) {
        EditDetailViewController *editDetailController=[[EditDetailViewController alloc]init];
        editDetailController.comingType=1;
        [self.navigationController pushViewController:editDetailController animated:YES];
    }else if (tempButt.tag==1)
    {
        EditDetailViewController *editDetailController=[[EditDetailViewController alloc]init];
        editDetailController.comingType=2;
        [self.navigationController pushViewController:editDetailController animated:YES];
    }else
    {
        AddCaseViewController *addCaseController=[[AddCaseViewController alloc]init];
        [self.navigationController pushViewController:addCaseController animated:YES];
    }
}
- (IBAction)commitButtAction:(UIButton *)sender {
    NSInteger section=sender.tag/100;
    NSInteger row=sender.tag%100;
    if (section==0) {
        [self deleteExperienceWithID:[[[dataDic objectForKey:@"eduList"] objectAtIndex:row] valueForKey:@"id"] andType:DeletEducationInfo];
        NSMutableArray *tempArray=[[dataDic objectForKey:@"eduList"] mutableCopy];
        [tempArray removeObjectAtIndex:row];
        [dataDic setObject:tempArray forKey:@"eduList"];
    }if (section==1) {
        [self deleteExperienceWithID:[[[dataDic objectForKey:@"workList"] objectAtIndex:row ]valueForKey:@"id"] andType:DeletWorkInfo];
        NSMutableArray *tempArray=[[dataDic objectForKey:@"workList"] mutableCopy];
        [tempArray removeObjectAtIndex:row];
        [dataDic setObject:tempArray forKey:@"workList"];
    }if (section==2) {
        [self deleteExperienceWithID:[[[dataDic objectForKey:@"caseList"] objectAtIndex:row ]valueForKey:@"id"] andType:DeletCase];
        NSMutableArray *tempArray=[[dataDic objectForKey:@"caseList"] mutableCopy];
        [tempArray removeObjectAtIndex:row];
        [dataDic setObject:tempArray forKey:@"caseList"];
    }
    self.backGrayView.hidden=YES;
    self.alertView.hidden=YES;
 }
- (IBAction)cancelButtAction:(UIButton *)sender {
    self.alertView.hidden=YES;
    self.backGrayView.hidden=YES;
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
