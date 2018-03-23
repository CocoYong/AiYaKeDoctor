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
#import "ServiceModel.h"
@interface ProjectViewController ()
{
    UserModel * userModel;
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
    return [userModel.serviceList count]+3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        if ([userModel.labs count]<=4) {
            return 44;
        }else
        {
        NSArray *labsArray=userModel.labs;
         NSInteger numLines=labsArray.count%4==0?labsArray.count/4:labsArray.count/4+1;
            return numLines*(7+30)+7;
        }
    }else if (indexPath.row==0||indexPath.row==2)
    {
        return 44;
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
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [self configerTableViewCell:cell withIndexPath:indexPath];
    return cell;
}
-(void)configerTableViewCell:(UITableViewCell*)cell withIndexPath:(NSIndexPath*)indexPath
{
       if(indexPath.row==0){
            cell.textLabel.text=@"擅长科目(最多可选10项):";
         }
      else if  (indexPath.row==1)
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
            }else
            {
              numLines=labsArray.count/4+1;
                for (int i=0; i<numLines; i++) {
                    for (int j=0; j<4; j++) {
                        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(j*(width+10)+10, i*(height+space)+space, width, height)];
                        imageView.tag=j+i*4;
                        imageView.image=[UIImage imageNamed:@"labs"];
                        [cell.contentView addSubview:imageView];
                        UILabel *textLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, width, 20)];
                        textLabel.text=[[labsArray objectAtIndex:imageView.tag] objectForKey:@"name"];
                        textLabel.textAlignment=NSTextAlignmentCenter;
                        textLabel.backgroundColor=[UIColor clearColor];
                        textLabel.font=[UIFont systemFontOfSize:10];
                        [imageView addSubview:textLabel];
                   }
                }

            }
        }
        else if(indexPath.row==2){
         cell.textLabel.text=@"服务项目";
        }else
        {
          UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(10, 5, kSCREEN_WIDTH-20, 90)];
            backView.layer.cornerRadius=5.0f;
            backView.layer.borderColor=[UIColor lightGrayColor].CGColor;
            backView.layer.borderWidth=1.0f;
            [cell.contentView addSubview:backView];
            
            UILabel *typeName=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 150, 21)];
            typeName.text=[[userModel.serviceList objectAtIndex:indexPath.row-3] valueForKey:@"typeName"];
            typeName.font=[UIFont systemFontOfSize:17];
            [backView addSubview:typeName];
            
            
            ServiceModel *serviceModel=[userModel.serviceList objectAtIndex:indexPath.row-3];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
