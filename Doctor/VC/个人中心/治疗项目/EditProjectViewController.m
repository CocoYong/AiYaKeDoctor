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
#import "UserModel.h"
#import "ServiceModel.h"
@interface EditProjectViewController ()
{
    UserModel  * userModel;
    CWHttpRequest *request;
}
@property (weak, nonatomic) IBOutlet UITableView *baseTable;
@end

@implementation EditProjectViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"编辑服务项目"];
    [self addBackButt];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self creatUIItem];
//    NSDictionary *userDic=(NSDictionary*)[[CWNSFileUtil sharedInstance]getNSModelFromUserDefaultsWithKey:@"userData"];
//    dataDic=[userDic objectForKey:@"data"];
    userModel=[UserManager currentUserManager].user;
    
}
#pragma mark----tableViewDelegate-------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [userModel.serviceList count]+4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count=[userModel.serviceList count];
    if (indexPath.row==0||indexPath.row==2||indexPath.row==count+3) {
        return 44;
    }else if (indexPath.row==1)
    {
        if ([userModel.labs count]<=4) {
            return 44;
        }else
        {
            NSArray *labsArray=userModel.labs;
            NSInteger numLines=labsArray.count%4==0?labsArray.count/4:labsArray.count/4+1;
            return numLines*(7+30)+7;
        }
    }else
    {
        return 100;
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
    NSInteger count=[userModel.serviceList count];
    if (indexPath.row==0) {
     cell.textLabel.text=@"擅长项目(最多可选10项)";
    }else if(indexPath.row==1)
    {
        NSArray *labsArray=userModel.labs;
        float width=(kSCREEN_WIDTH-50)/4;//横向两个label之间的间距设为10
        float height=30;
        float space=7;//竖向label间距为5
        NSInteger numLines;
        if (labsArray.count<4) {
            numLines=1;
            for (int i=0; i<numLines; i++) {
                for (int j=0; j<labsArray.count; j++) {
                    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(j*(width+10)+10, i*(height+space)+space, width, height)];
                    imageView.tag=j+i*4;
                    imageView.image=[UIImage imageNamed:@"labs"];
                    [cell.contentView addSubview:imageView];
                    UILabel *textLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, width, 20)];
                    textLabel.text=[[labsArray objectAtIndex:imageView.tag] valueForKey:@"name"];
                    textLabel.textAlignment=NSTextAlignmentCenter;
                    textLabel.backgroundColor=[UIColor clearColor];
                    textLabel.font=[UIFont systemFontOfSize:14];
                    [imageView addSubview:textLabel];
                }
            }
            UIButton *editButt=[UIButton buttonWithType:UIButtonTypeCustom];
            editButt.frame=CGRectMake(labsArray.count*(width+10)+10, 7, width, height);
            [editButt setBackgroundImage:[UIImage imageNamed:@"0_152"] forState:UIControlStateNormal];
            [editButt setTitle:@"编辑" forState:UIControlStateNormal];
            [editButt addTarget:self action:@selector(addSkillItems) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:editButt];
        }else
        {
            numLines=labsArray.count%4==0?labsArray.count/4:labsArray.count/4+1;
            for (int i=0; i<numLines; i++) {
                for (int j=0; j<4; j++) {
                    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(j*(width+10)+10, i*(height+space)+space, width, height)];
                    imageView.tag=j+i*4;
                    imageView.image=[UIImage imageNamed:@"labs"];
                    [cell.contentView addSubview:imageView];
                    UILabel *textLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, width, 20)];
                    textLabel.text=[[labsArray objectAtIndex:imageView.tag] valueForKey:@"name"];
                    textLabel.textAlignment=NSTextAlignmentCenter;
                    textLabel.backgroundColor=[UIColor clearColor];
                    textLabel.font=[UIFont systemFontOfSize:10];
                    [imageView addSubview:textLabel];
                    if (imageView.tag==labsArray.count-1) {
                        UIButton *editButt=[UIButton buttonWithType:UIButtonTypeCustom];
                        editButt.frame=CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+10, imageView.frame.origin.y, width, height);
                        [editButt setBackgroundImage:[UIImage imageNamed:@"0_152"] forState:UIControlStateNormal];
                        [editButt setTitle:@"编辑" forState:UIControlStateNormal];
                        [editButt addTarget:self action:@selector(addSkillItems) forControlEvents:UIControlEventTouchUpInside];
                        [cell.contentView addSubview:editButt];
                    }
                    
                }
            }
            
        }

    }else if (indexPath.row==2)
    {
     cell.textLabel.text=@"服务项目";;
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
        UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(10, 5, kSCREEN_WIDTH-20, 90)];
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
        
        ServiceModel *serviceModel=[userModel.serviceList objectAtIndex:indexPath.row-3];
        UILabel *typeName=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 150, 21)];
        typeName.text=serviceModel.typeName;
        typeName.font=[UIFont systemFontOfSize:17];
        [backView addSubview:typeName];
        
        UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(backView.frame.size.width-150, 5, 145, 21)];
        moneyLabel.textAlignment=NSTextAlignmentLeft;
        NSString *moneyString=[NSString stringWithFormat:@"￥%@-￥%@",serviceModel.feeMin,serviceModel.feeMax];
        moneyLabel.text=moneyString;
        moneyLabel.textColor=[UIColor blackColor];
        moneyLabel.font=[UIFont systemFontOfSize:17];
        [backView addSubview:moneyLabel];
        
        
        UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 30, backView.frame.size.width-10, 40)];
        contentLabel.textAlignment=NSTextAlignmentLeft;
        contentLabel.text=serviceModel.content;
        contentLabel.textColor=[UIColor grayColor];
        contentLabel.font=[UIFont systemFontOfSize:14];
        [backView addSubview:contentLabel];
    }
}
-(void)deleteExperience:(id)sender
{
    
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
-(void)addSkillItems
{
    SkilledViewController *skillController=[[SkilledViewController alloc]init];
    [self.navigationController pushViewController:skillController animated:YES];
}
-(void)addServiceItems
{
    AddServiceViewController *addServiceController=[[AddServiceViewController alloc]init];
    [self.navigationController pushViewController:addServiceController animated:YES];
}
-(void)sureButtonAction
{
    
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
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, DeletService] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
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
