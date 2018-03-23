//
//  EditDetailViewController.m
//  YSProject
//
//  Created by MrZhang on 15/6/16.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "EditDetailViewController.h"
#import "UIPlaceHolderTextView.h"
@interface EditDetailViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *defaultYearArray;
    NSMutableArray *defaultMonthArray;
    UIView *pickBackView;
    CWHttpRequest *request;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *yearOneButt;
@property (weak, nonatomic) IBOutlet UIButton *monthOneButt;
@property (weak, nonatomic) IBOutlet UIButton *yearTwoButt;
@property (weak, nonatomic) IBOutlet UIButton *monthTwoButt;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *contentView;
@property (nonatomic,strong) NSString *timeType;

@end

@implementation EditDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defaultViewSetting];
    
}
-(void)defaultViewSetting
{
     UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.nameTextField.leftView=view;
    self.nameTextField.leftViewMode=UITextFieldViewModeAlways;
    if (self.comingType==1) {
        if (_dataDic) {
            self.nameTextField.text=[_dataDic objectForKey:@"name"];
            [_yearOneButt setTitle:[_dataDic objectForKey:@"year1"] forState:UIControlStateNormal];
            [_yearTwoButt setTitle:[_dataDic objectForKey:@"year2"] forState:UIControlStateNormal];
            [_monthOneButt setTitle:[_dataDic objectForKey:@"month1"] forState:UIControlStateNormal];
            [_monthTwoButt setTitle:[_dataDic objectForKey:@"month2"] forState:UIControlStateNormal];
            _contentView.placeholder=nil;
            _contentView.text=[_dataDic objectForKey:@"content"];
        }else
        {
            self.nameTextField.placeholder=@"院校名称";
        }
        [self creatNavgationBarWithTitle:@"教育背景"];
    }else
    {
        [self creatNavgationBarWithTitle:@"工作背景"];
        if (_dataDic) {
            self.nameTextField.text=[_dataDic objectForKey:@"name"];
            [_yearOneButt setTitle:[_dataDic objectForKey:@"year1"] forState:UIControlStateNormal];
            [_yearTwoButt setTitle:[_dataDic objectForKey:@"year2"] forState:UIControlStateNormal];
            [_monthOneButt setTitle:[_dataDic objectForKey:@"month1"] forState:UIControlStateNormal];
            [_monthTwoButt setTitle:[_dataDic objectForKey:@"month2"] forState:UIControlStateNormal];
            _contentView.placeholder=nil;
            _contentView.text=[_dataDic objectForKey:@"content"];
        }else
        {
            self.nameTextField.placeholder=@"单位名称";
        }
    }
    
    [self addBackButt];
    [self creatUIItem];
    defaultYearArray=[NSMutableArray array];
    for (int i=1960; i<2100; i++) {
        [defaultYearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    defaultMonthArray=[NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
}
#pragma mark-----serviceInterAction----------
- (void)addOrEditEducationExperience:(NSString*)idString{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
       NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"year1":_yearOneButt.titleLabel.text,@"month1":_monthOneButt.titleLabel.text,@"year2": _yearTwoButt.titleLabel.text,@"month2":_monthTwoButt.titleLabel.text,@"content":_contentView.text,@"SessionID":sessionID,@"name":_nameTextField.text,@"id":idString==nil?@"":idString};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, AddEducationInfo] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"服务项目接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0) {
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"服务项目接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}
- (void)addWorkOrEditExperience:(NSString*)idString{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
       NSString *sessionID=[UserManager currentUserManager].sessionID;
       NSDictionary *jsonDictionary = @{@"year1":_yearOneButt.titleLabel.text,@"month1":_monthOneButt.titleLabel.text,@"year2": _yearTwoButt.titleLabel.text,@"month2":_monthTwoButt.titleLabel.text,@"content":_contentView.text,@"SessionID":sessionID,@"name":_nameTextField.text,@"id":idString==nil?@"":idString};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, AddAndEditWorkInfo] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"服务项目接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0) {
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
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
    
    self.contentView.layer.cornerRadius=5.0f;
    self.contentView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.contentView.layer.borderWidth=1.0f;
}
-(void)sureButtonAction
{
    if (self.comingType==1){
        if (_dataDic) {
        [self addOrEditEducationExperience:[_dataDic objectForKey:@"id"]];
        }else
        {
            [self addOrEditEducationExperience:nil];
        }
    }else
    {
        if (_dataDic) {
        [self addWorkOrEditExperience:[_dataDic objectForKey:@"id"]];
        }else
        {
            [self addWorkOrEditExperience:nil];
        }
    }
}
- (IBAction)firstYearAction:(UIButton *)sender {
    self.timeType=@"year";
    [self creatPickViewWith:sender.tag];
}
- (IBAction)firstMonthAction:(UIButton *)sender {
    self.timeType=@"month";
    [self creatPickViewWith:sender.tag];
}
- (IBAction)secondYearAction:(UIButton *)sender {
    self.timeType=@"year";
    [self creatPickViewWith:sender.tag];
}

- (IBAction)secondMonthAction:(UIButton *)sender {
    self.timeType=@"month";
    [self creatPickViewWith:sender.tag];
}
#pragma mark-----UIPickerView-------
-(void)creatPickViewWith:(NSInteger)tag
{
    if (IOSVERSION>=8.0) {
  UIAlertController*alertController=[UIAlertController alertControllerWithTitle:
                                     @"\n\n\n\n" message:@"\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    UIPickerView *pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 5,CGRectGetWidth(alertController.view.frame)-20, 162)];
    pickerView.tag=tag;
    NSLog(@"pickerViewHeight==%f",CGRectGetHeight(pickerView.frame));
    pickerView.dataSource=self;
    pickerView.delegate=self;
    pickerView.backgroundColor=[UIColor hexColor:@"#f2f7f8"];
    [pickerView selectRow:55 inComponent:0 animated:NO];
    [alertController.view addSubview:pickerView];
   [self presentViewController:alertController animated:YES completion:^{
       NSLog(@"完事了不出事。。。。。。");
   }];
    }else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"取  消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"确  定", nil];
        [actionSheet showInView:self.view];
        UIPickerView *pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(10, 5,CGRectGetWidth(actionSheet.frame)-20, 162)];
        pickerView.tag=tag;
        NSLog(@"pickerViewHeight==%f",CGRectGetHeight(pickerView.frame));
        pickerView.dataSource=self;
        pickerView.delegate=self;
        pickerView.backgroundColor=[UIColor hexColor:@"#f2f7f8"];
        [pickerView selectRow:55 inComponent:0 animated:NO];
        [actionSheet addSubview:pickerView];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if ([_timeType isEqualToString:@"year"]) {
     return defaultYearArray.count;
    }
    return defaultMonthArray.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([_timeType isEqualToString:@"year"]){
        return [defaultYearArray objectAtIndex:row];
    }
    return [defaultMonthArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 100:
            [self.yearOneButt setTitle:[defaultYearArray objectAtIndex:row] forState:UIControlStateNormal];
            break;
        case 101:
             [self.monthOneButt setTitle:[defaultMonthArray objectAtIndex:row] forState:UIControlStateNormal];
            break;
        case 102:
             [self.yearTwoButt setTitle:[defaultYearArray objectAtIndex:row] forState:UIControlStateNormal];
            break;
        case 103:
             [self.monthTwoButt setTitle:[defaultMonthArray objectAtIndex:row] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self makeKeyboardDisappear];
}
-(void)makeKeyboardDisappear
{
    [_contentView resignFirstResponder];
    [_nameTextField resignFirstResponder];
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
