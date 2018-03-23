//
//  SelectesItemTypeViewController.m
//  YSProject
//
//  Created by MrZhang on 15/6/16.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "SelectesItemTypeViewController.h"

@interface SelectesItemTypeViewController ()
{
    CWHttpRequest *request;
    NSMutableArray *requestArray;
    NSMutableArray *selectedArray;
}
@property (weak, nonatomic) IBOutlet UITableView *baseTable;
@property(nonatomic,strong) UIButton *selectButt;
@property(nonatomic,strong)NSDictionary *passDic;
@end

@implementation SelectesItemTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"选择项目类型"];
    [self addBackButt];
    [self creatUIItem];
    [self getDataFromService];
    selectedArray=[NSMutableArray array];
    
}
- (void)getDataFromService {
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"id": @"31",@"SessionID":sessionID};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, Index_URL] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"服务项目接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0) {
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                requestArray=[[responseObject valueForKey:@"data"] mutableCopy];
                [self creatItemButtons];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"服务项目接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
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
-(void)creatItemButtons
{
    float width=(kSCREEN_WIDTH-40)/3;//横向两个label之间的间距设为10
    float height=30;
    float space=7;//竖向label间距为5
    for (int j=0; j<requestArray.count; j++) {
        UIButton *itemButt=[UIButton buttonWithType:UIButtonTypeCustom];
        itemButt.tag=j;
        itemButt.frame=CGRectMake((j%3)*(width+10)+10, 97+(height+space)*(j/3), width, height);
        [itemButt setBackgroundImage:[UIImage imageNamed:@"labs"] forState:UIControlStateNormal];
        [itemButt setBackgroundImage:[UIImage imageNamed:@"0_152"] forState:UIControlStateSelected];
        [itemButt setTitle:[[requestArray objectAtIndex:itemButt.tag] objectForKey:@"name"] forState:UIControlStateNormal];
        [itemButt addTarget:self action:@selector(itemButtAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:itemButt];
    }
}
-(void)sureButtonAction
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(projectPassDelegate:)])
    {
        [self.delegate projectPassDelegate:self.passDic];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark----tableViewDelegate-------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (requestArray.count%3==0) {
        return requestArray.count/3;
    }else
    {
        return requestArray.count/3+1;
    }
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
    
    float width=(kSCREEN_WIDTH-40)/3;//横向两个label之间的间距设为10
    float height=30;
    float space=7;//竖向label间距为5
    if ((indexPath.row+1)*3<=requestArray.count){
        for (int j=0; j<3; j++) {
            UIButton *itemButt=[UIButton buttonWithType:UIButtonTypeCustom];
            itemButt.frame=CGRectMake(j*(width+10)+10, space, width, height);
            itemButt.tag=(indexPath.row*3)+j;
            [itemButt setBackgroundImage:[UIImage imageNamed:@"labs"] forState:UIControlStateNormal];
            [itemButt setBackgroundImage:[UIImage imageNamed:@"0_152"] forState:UIControlStateSelected];
            [itemButt setTitle:[[requestArray objectAtIndex:itemButt.tag] objectForKey:@"name"] forState:UIControlStateNormal];
            [itemButt addTarget:self action:@selector(itemButtAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:itemButt];
        }
    }else
    {
        for (int j=0; j<requestArray.count%3; j++) {
            UIButton *itemButt=[UIButton buttonWithType:UIButtonTypeCustom];
            itemButt.frame=CGRectMake(j*(width+10)+10, space, width, height);
            itemButt.tag=(indexPath.row*3)+j;
            [itemButt setBackgroundImage:[UIImage imageNamed:@"labs"] forState:UIControlStateNormal];
            [itemButt setBackgroundImage:[UIImage imageNamed:@"0_152"] forState:UIControlStateSelected];
            [itemButt setTitle:[[requestArray objectAtIndex:itemButt.tag] objectForKey:@"name"] forState:UIControlStateNormal];
            [itemButt addTarget:self action:@selector(itemButtAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:itemButt];
        }
    }
}
 */
-(void)itemButtAction:(UIButton*)sender
{
    if (!sender. selected) {
        sender.selected=YES;
        self.selectButt.selected=NO;
        self.passDic=[requestArray objectAtIndex:sender.tag];
    }
    self.selectButt=sender;
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
