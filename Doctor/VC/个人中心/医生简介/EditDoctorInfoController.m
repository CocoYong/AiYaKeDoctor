//
//  EditDoctorInfoController.m
//  YSProject
//
//  Created by MrZhang on 15/6/15.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "EditDoctorInfoController.h"
#import "UIImageView+WebCache.h"
#import "PhotoLibaryViewController.h"
#import "SDWebImageDownloader.h"
#import "UpdateUserData.h"
#import "UploadImageObject.h"
#import "UploadImageManager.h"
#import "JSONKit.h"
#import "UserModel.h"
@interface EditDoctorInfoController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableDictionary *dataDic;
    CWHttpRequest *request;
    UIView *grayWindow;
    UIView *popUpWindow;
    NSMutableArray *areaArray;
    UIView * pickBackView;
    UserModel *userModel;

}
@property (weak, nonatomic) IBOutlet UITableView *baseTable;
@property (strong,nonatomic) UITextView *contentView;
@property (strong,nonatomic) UITextField *telField;
@property (strong,nonatomic) UITextField *companyField;
@property (strong,nonatomic) UITextField *areaField;
@property (strong,nonatomic) UITextField *addressField;
@property (nonatomic,strong) NSString *areaID;
@end

@implementation EditDoctorInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"编辑医师简介"];
    [self addBackButt];
    [self creatUIItem];
    [self getAreaDataFromService];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    
    userModel=[UserManager currentUserManager].user;
    NSLog(@"username==%@",userModel.username);
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [dataDic removeAllObjects];
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
            if ([code integerValue]==0){
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
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
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
#pragma mark------dataReqest------
- (void)changeUserInfo{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
       NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"company":_companyField.text,@"tel":_telField.text,@"area3":_areaID,@"address":_addressField.text,@"content":_contentView.text==nil?@"":_contentView.text,@"SessionID":sessionID};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, EditUserInfo] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"服务项目接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0) {
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                
                [userManager synchronize];
                [[UpdateUserData shareInstance] updateUserInfo];
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
          return 70*((licenseArray.count)/4+1);
        }else
        {
            if (licenseArray.count<4) {
                return 70;
            }else
            {
            return 70*((licenseArray.count)/4+1);
            }
        }
    }
    else if (indexPath.row==12) {
        return 90;
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
    switch (indexPath.row) {
        case 0:
        {
            UILabel *titleLabl=[[UILabel alloc]initWithFrame:CGRectMake(10, 4, 300, 26)];
            titleLabl.textAlignment=NSTextAlignmentLeft;
            [cell.contentView addSubview:titleLabl];
            titleLabl.textColor=[UIColor hexColor:@"#959595"];
            titleLabl.text=[NSString stringWithFormat:@"真实姓名:%@",[dataDic objectForKey:@"name"]==nil?@"":[dataDic objectForKey:@"name"]];
        }
        break;
        case 1:
        {
            UILabel *titleLabl=[[UILabel alloc]initWithFrame:CGRectMake(10, 4, 300, 26)];
            titleLabl.textAlignment=NSTextAlignmentLeft;
            [cell.contentView addSubview:titleLabl];
            titleLabl.textColor=[UIColor hexColor:@"#959595"];
            if ([[dataDic objectForKey:@"sex"] isEqualToString:@"0"]) {
                 titleLabl.text=[NSString stringWithFormat:@"性别:%@",@"女"];
            }else
            {
                 titleLabl.text=[NSString stringWithFormat:@"性别:%@",@"男"];
            }
        }
            break;
        case 2:
        {
            UILabel *titleLabl=[[UILabel alloc]initWithFrame:CGRectMake(10, 4, 300, 26)];
            titleLabl.textAlignment=NSTextAlignmentLeft;
            [cell.contentView addSubview:titleLabl];
              titleLabl.textColor=[UIColor hexColor:@"#959595"];
            titleLabl.text=[NSString stringWithFormat:@"医师职业证书号:%@",[dataDic objectForKey:@"certCode"]==nil?@"":[dataDic objectForKey:@"certCode"]];
        }
            break;
        case 3:
        {
            UILabel *titleLabl=[[UILabel alloc]initWithFrame:CGRectMake(10, 4, 300, 26)];
            titleLabl.textAlignment=NSTextAlignmentLeft;
            [cell.contentView addSubview:titleLabl];
              titleLabl.textColor=[UIColor hexColor:@"#959595"];
            titleLabl.text=[NSString stringWithFormat:@"职称:%@",[dataDic objectForKey:@"titleName"]==nil?@"":[dataDic objectForKey:@"titleName"]];
        }
            break;
        case 4:
        {
            UILabel *titleLabl=[[UILabel alloc]initWithFrame:CGRectMake(10, 4, 300, 26)];
            titleLabl.textAlignment=NSTextAlignmentLeft;
            [cell.contentView addSubview:titleLabl];
              titleLabl.textColor=[UIColor hexColor:@"#959595"];
            titleLabl.text=[NSString stringWithFormat:@"医师职业证书照片:"];
           
        }
            break;
        case 5:
        {
            NSArray *licenseArray=[dataDic objectForKey:@"licenseList"];
            float padding = 20;
            float y = 10;
            float imageW = 60;
            float offW= (kSCREEN_WIDTH-40-240)/3;
            for (int i=0;i <[licenseArray count]+1; i++) {
                if (i==licenseArray.count) {
                    UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
                    addButton.frame=CGRectMake(i%4*(offW+imageW) + padding, y + floor(i/4)*(10+imageW),imageW, imageW);
                    [addButton setImage:[UIImage imageNamed:@"0_395"] forState:UIControlStateNormal];
                    [addButton addTarget:self action:@selector(addImageFromCamera) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:addButton];
                }else
                {
                    UIImageView *imageView = [[UIImageView alloc]init];
                    imageView.userInteractionEnabled=YES;
                    imageView.tag=i;
                    imageView.frame = CGRectMake(i%4*(offW+imageW) + padding, y + floor(i/4)*(10+imageW) , imageW, imageW);
                    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[dataDic objectForKey:@"licenseList"] objectAtIndex:i]objectForKey:@"picUrl"]]] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize){
                        NSLog(@"receivedSize===%ld,expectedSize===%ld",(long)receivedSize,(long)expectedSize);
                    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                        imageView.image=image;
                    }];
                    [cell.contentView addSubview:imageView];
                    UIButton *imageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
                    [imageBtn setBackgroundImage:[UIImage imageNamed:@"border"] forState:UIControlStateNormal];
                    imageBtn.frame=CGRectMake(-1,  -1 , imageW+2, imageW+2);
                    [imageBtn addTarget:self action:@selector(BrowserImages:) forControlEvents:UIControlEventTouchUpInside];
                    imageBtn.tag=i;
                    [imageView addSubview:imageBtn];
                }
//                if (i ==[licenseArray count]-1) {
//                    int j = i+1;
//                    addButton.frame = CGRectMake(j%4*(offW+imageW) + x, y + floor(j/4)*(offW+imageW) , imageW, imageW);
//                }
            }
        }
            break;
        case 6:
        {
            UIImageView *backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, kSCREEN_WIDTH-20, 34)];
            backImageView.image=[UIImage imageNamed:@"textFieldBg"];
            backImageView.userInteractionEnabled=YES;
            [cell.contentView addSubview:backImageView];
            UITextField *inputField=[[UITextField alloc]initWithFrame:CGRectMake(65, 4, 200, 26)];
            [backImageView addSubview:inputField];
            inputField.enabled=NO;
            UILabel *titleLabl=[[UILabel alloc]initWithFrame:CGRectMake(10, 4, 60, 26)];
            titleLabl.textAlignment=NSTextAlignmentLeft;
            [backImageView addSubview:titleLabl];
            titleLabl.textColor=[UIColor hexColor:@"#959595"];
            titleLabl.text=[NSString stringWithFormat:@"手机号:"];
            inputField.text=[dataDic objectForKey:@"username"];
            
        }
            break;
        case 7:
        {
            UIImageView *backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, kSCREEN_WIDTH-20, 34)];
            backImageView.image=[UIImage imageNamed:@"textFieldBg"];
            backImageView.userInteractionEnabled=YES;
            [cell.contentView addSubview:backImageView];
            _companyField=[[UITextField alloc]initWithFrame:CGRectMake(85, 4, 200, 26)];
            [_companyField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
            [backImageView addSubview:_companyField];
            _companyField.delegate=self;
            _companyField.textColor=[UIColor hexColor:@"#959595"];
            UILabel *titleLabl=[[UILabel alloc]initWithFrame:CGRectMake(10, 4, 80, 26)];
            titleLabl.textAlignment=NSTextAlignmentLeft;
            [backImageView addSubview:titleLabl];
              titleLabl.textColor=[UIColor hexColor:@"#959595"];
            titleLabl.text=[NSString stringWithFormat:@"门诊名称:"];
            _companyField.text=[dataDic objectForKey:@"company"];
        }
            break;
        case 8:
        {
            UIImageView *backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, kSCREEN_WIDTH-20, 34)];
            backImageView.image=[UIImage imageNamed:@"textFieldBg"];
            backImageView.userInteractionEnabled=YES;
            [cell.contentView addSubview:backImageView];
            
            _telField=[[UITextField alloc]initWithFrame:CGRectMake(85, 4, 200, 26)];
            [_telField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
            [backImageView addSubview:_telField];
            _telField.delegate=self;
            _telField.textColor=[UIColor hexColor:@"#959595"];
            _telField.keyboardType=UIKeyboardTypeNumberPad;
            UILabel *titleLabl=[[UILabel alloc]initWithFrame:CGRectMake(10, 4, 80, 26)];
            titleLabl.textAlignment=NSTextAlignmentLeft;
            [backImageView addSubview:titleLabl];
              titleLabl.textColor=[UIColor hexColor:@"#959595"];
            titleLabl.text=[NSString stringWithFormat:@"门诊电话:"];
            _telField.text=[dataDic objectForKey:@"tel"];
        }
        
            break;
        case 9:
        {
            UIImageView *backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, kSCREEN_WIDTH-20, 34)];
            backImageView.image=[UIImage imageNamed:@"textFieldBg"];
            backImageView.userInteractionEnabled=YES;
            [cell.contentView addSubview:backImageView];
            
            _areaField=[[UITextField alloc]initWithFrame:CGRectMake(85, 4, 200, 26)];
            [_areaField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
            [backImageView addSubview:_areaField];
            _areaField.delegate=self;
            _areaField.textColor=[UIColor hexColor:@"#959595"];
            UILabel *titleLabl=[[UILabel alloc]initWithFrame:CGRectMake(10, 4, 80, 26)];
            titleLabl.textAlignment=NSTextAlignmentLeft;
            [backImageView addSubview:titleLabl];
              titleLabl.textColor=[UIColor hexColor:@"#959595"];
            titleLabl.text=[NSString stringWithFormat:@"所在地区:"];
            for (NSDictionary *dic in areaArray) {
                if ([[dic objectForKey:@"id"] isEqualToString:[dataDic objectForKey:@"area3"]]) {
                    _areaField.text=[dic objectForKey:@"name"];
                }
            }
           
        }
            break;
        case 10:
        {
            UIImageView *backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, kSCREEN_WIDTH-20, 34)];
            backImageView.image=[UIImage imageNamed:@"textFieldBg"];
            backImageView.userInteractionEnabled=YES;
            [cell.contentView addSubview:backImageView];
            _addressField=[[UITextField alloc]initWithFrame:CGRectMake(85, 4, 200, 26)];
            [_addressField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
            [backImageView addSubview:_addressField];
            _addressField.delegate=self;
            _addressField.textColor=[UIColor hexColor:@"#959595"];
            UILabel *titleLabl=[[UILabel alloc]initWithFrame:CGRectMake(10, 4, 80, 26)];
            titleLabl.textAlignment=NSTextAlignmentLeft;
            [backImageView addSubview:titleLabl];
              titleLabl.textColor=[UIColor hexColor:@"#959595"];
            titleLabl.text=[NSString stringWithFormat:@"门诊地址:"];
            _addressField.text=[dataDic objectForKey:@"address"];
        }
            break;
        case 11:
        {
            UILabel *titleLabl=[[UILabel alloc]initWithFrame:CGRectMake(10, 4, 300, 26)];
            titleLabl.textAlignment=NSTextAlignmentLeft;
            [cell.contentView addSubview:titleLabl];
              titleLabl.textColor=[UIColor hexColor:@"#959595"];
            titleLabl.text=[NSString stringWithFormat:@"医生简介:"];
        }
            break;
        case 12:
        {
          
            _contentView=[[UITextView  alloc]initWithFrame:CGRectMake(10, 2, kSCREEN_WIDTH-20, 80)];
            _contentView.delegate=self;
            _contentView.text=[dataDic objectForKey:@"content"];
            _contentView.layer.cornerRadius=5.0f;
            _contentView.layer.borderColor=[UIColor lightGrayColor].CGColor;
            _contentView.layer.borderWidth=1.0f;
            _contentView.textColor=[UIColor hexColor:@"#959595"];
            _contentView.font=[UIFont systemFontOfSize:17];
            [cell.contentView addSubview:_contentView];
        }
            break;
        default:
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.baseTable endEditing:YES];
    if (self.view.frame.origin.y!=0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        }];
    }
}
-(void)textFieldTextChange:(UITextField*)textField
{
    if (textField==_companyField){
     [dataDic setObject:textField.text forKey:@"company"];
    }else if (textField==_telField)
    {
     [dataDic setObject:textField.text forKey:@"tel"];
    }else if (textField==_areaField)
    {
      [dataDic setObject:textField.text forKey:@"area3"];
    }else
    {
      [dataDic setObject:textField.text forKey:@"address"];
    }
}
-(void)addImageFromCamera
{
    grayWindow=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    grayWindow.backgroundColor=[UIColor lightGrayColor];
    grayWindow.alpha=0.5f;
    [self.view addSubview:grayWindow];
    
    popUpWindow=[[UIView alloc]initWithFrame:CGRectMake(30, self.view.center.y-65, kSCREEN_WIDTH-60, 130)];
    popUpWindow.backgroundColor=[UIColor whiteColor];
    popUpWindow.layer.cornerRadius=5.0f;
    [self.view addSubview:popUpWindow];
   
    
    UIButton *cancelButt=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelButt.frame=CGRectMake(popUpWindow.frame.size.width-40, 0, 40, 40);
    [cancelButt setImage:[UIImage imageNamed:@"0_373"] forState:UIControlStateNormal];
    [cancelButt addTarget:self action:@selector(dismissPopWindow) forControlEvents:UIControlEventTouchUpInside];
    [popUpWindow addSubview:cancelButt];
    
    UIButton *takePhoto=[UIButton buttonWithType:UIButtonTypeCustom];
    takePhoto.frame=CGRectMake((popUpWindow.frame.size.width-160)/3, 10, 80, 80);
    [takePhoto setImage:[UIImage imageNamed:@"0_387"] forState:UIControlStateNormal];
    [takePhoto addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    [popUpWindow addSubview:takePhoto];
    
    UIButton *photoLib=[UIButton buttonWithType:UIButtonTypeCustom];
    photoLib.frame=CGRectMake((popUpWindow.frame.size.width-160)*2/3+80, 10, 80, 80);
    [photoLib addTarget:self action:@selector(goPhotoLibary) forControlEvents:UIControlEventTouchUpInside];
    [photoLib setImage:[UIImage imageNamed:@"0_389"] forState:UIControlStateNormal];
    [popUpWindow addSubview:photoLib];
    
    
    UILabel *takePhotoLabel=[[UILabel alloc]initWithFrame:CGRectMake((popUpWindow.frame.size.width-160)/3, 100, 80, 20)];
     takePhotoLabel.text=@"拍照";
     takePhotoLabel.textAlignment=NSTextAlignmentCenter;
    [popUpWindow addSubview:takePhotoLabel];
    
    UILabel *photoLibLabel=[[UILabel alloc]initWithFrame:CGRectMake((popUpWindow.frame.size.width-160)*2/3+80, 100, 80, 20)];
    photoLibLabel.text=@"从相册选";
    photoLibLabel.textAlignment=NSTextAlignmentCenter;
    [popUpWindow addSubview:photoLibLabel];
}
-(void)dismissPopWindow
{
     [popUpWindow removeFromSuperview];
     [grayWindow removeFromSuperview];
}
-(void)takePicture
{
    [popUpWindow removeFromSuperview];
    [grayWindow removeFromSuperview];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.allowsEditing = NO;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }

}
-(void)goPhotoLibary
{
    [popUpWindow removeFromSuperview];
    [grayWindow removeFromSuperview];
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}
-(void)BrowserImages:(UIButton*)sender
{
    
    PhotoLibaryViewController *photoController=[[PhotoLibaryViewController alloc]init];
    photoController.imageDataArray=[dataDic objectForKey:@"licenseList"];
    [self.navigationController pushViewController:photoController animated:YES];
    
//    UIViewController *rootController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
//    MJPhotoBrowser *photoBrower=[[MJPhotoBrowser alloc]init];
//    photoBrower.photos=imageArray;
//    UINavigationController *navigationController=[[UINavigationController alloc]initWithRootViewController:photoBrower];
//    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [rootController presentViewController:navigationController animated:YES completion:nil];
    
    
//    [photoBrowser reloadData];
//    [[MessageReadManager defaultManager] showBrowserWithImages:imageArray];
//    [self deleteLicenseImageWith:[[[[dataDic objectForKey:@"licenseList"] objectAtIndex:sender.tag] objectForKey:@"id"] integerValue]];
//    NSMutableArray *tempArray=[[dataDic objectForKey:@"licenseList"] mutableCopy];
//    [tempArray removeObjectAtIndex:sender.tag];
//    [dataDic setObject:tempArray forKey:@"licenseList"];
}
#pragma mark - MWPhotoBrowserDelegate
//
//- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
//{
//    return [imageArray count];
//}
//
//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
//{
//    if (index < imageArray.count)
//    {
//        return [imageArray objectAtIndex:index];
//    }
//    return nil;
//}


-(void)creatUIItem
{
    UIImageView* OneButtImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-80, kSCREEN_WIDTH, 80)];
    OneButtImageView.image=[UIImage imageNamed:@"0_359"];
    [self.view addSubview:OneButtImageView];
    OneButtImageView.userInteractionEnabled=YES;
    UIButton *itemButt=[UIButton buttonWithType:UIButtonTypeCustom];
    itemButt.frame=CGRectMake(kSCREEN_WIDTH/2-20, 20, 40, 40);
    [itemButt setImage:[UIImage imageNamed:@"0_173"] forState:UIControlStateNormal];
    [itemButt addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [OneButtImageView addSubview:itemButt];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2-20, 60, 40, 20)];
    titleLabel.text=@"确定";
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:10];
    [OneButtImageView addSubview:titleLabel];
}
-(void)sureAction
{
    if (self.view.frame.origin.y!=0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        }];
    }
    NSString *company= [_companyField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([company length] == 0) {
        [ShowViewCenterViewController showAlertViewWithTitle:nil message:@"请输入门诊名称" cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:nil cancelBlock:nil otherBlock:nil];
        return;
    }
    NSString *telephone = [_telField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([telephone length] == 0) {
        [ShowViewCenterViewController showAlertViewWithTitle:nil message:@"请输入门诊电话" cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:nil cancelBlock:nil otherBlock:nil];
        return;
    }
    NSString *area = [_areaField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (_areaID==nil) {
        for (NSDictionary *dic in areaArray) {
            if ([area isEqualToString:[dic objectForKey:@"name"]]) {
                _areaID=[dic objectForKey:@"id"];
            }
        }
    }
    if ([area length] == 0) {
        [ShowViewCenterViewController showAlertViewWithTitle:nil message:@"请输入所在地区" cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:nil cancelBlock:nil otherBlock:nil];
        return;
    }
    NSString *address = [_addressField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([address length] == 0) {
        [ShowViewCenterViewController showAlertViewWithTitle:nil message:@"请输入门诊地址" cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:nil cancelBlock:nil otherBlock:nil];
        return;
    }
    NSString *content = [_contentView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([content length] == 0) {
        [ShowViewCenterViewController showAlertViewWithTitle:nil message:@"请输入医生简介" cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:nil cancelBlock:nil otherBlock:nil];
        return;
    }
    [self changeUserInfo];
}

#pragma mark---textFieldDelegate----textViewDelegate------
-(void)resignKeyboard
{
    [self.view endEditing:YES];
    if (self.view.frame.origin.y!=0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame=CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        }];
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.baseTable.frame=CGRectMake(0, 60, kSCREEN_WIDTH, kSCREEN_HEIGHT-60-216);
    if (textField==_areaField) {
        [_companyField resignFirstResponder];
        [_telField resignFirstResponder];
        [_areaField resignFirstResponder];
        [_addressField resignFirstResponder];
        [_contentView resignFirstResponder];
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   if (textField==_areaField) {
     [_areaField resignFirstResponder];
     [self creatPickViewWith:1];
   }
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
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.baseTable.frame=CGRectMake(0, 60, kSCREEN_WIDTH, kSCREEN_HEIGHT-60-216);
    self.baseTable.contentOffset=CGPointMake(0, self.baseTable.contentSize.height-self.baseTable.frame.size.height);
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
   self.baseTable.frame=CGRectMake(0, 60, kSCREEN_WIDTH, kSCREEN_HEIGHT-140);
    [dataDic setObject:textView.text forKey:@"content"];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.baseTable endEditing:YES];
    self.baseTable.frame=CGRectMake(0, 60, kSCREEN_WIDTH, kSCREEN_HEIGHT-140);
}

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
   
        return areaArray.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return [[areaArray objectAtIndex:row] objectForKey:@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.areaID=[[areaArray objectAtIndex:row] objectForKey:@"id"];
    _areaField.text=[[areaArray objectAtIndex:row]objectForKey:@"name"];
}
#pragma mark----imagePickerControllerDelegate----
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *imageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *imageEdit = [info objectForKey:UIImagePickerControllerEditedImage];
        UploadImageObject *imageObject = [[UploadImageObject alloc] init];
//        imageObject.originalImage =  [CWNSFileUtil imageCompressForSize:imageOriginal targetSize:CGSizeMake(320, 320*1.5)];
//        imageObject.smallImage = [CWNSFileUtil imageCompressForSize:imageOriginal targetSize:CGSizeMake(120, 120*1.5)];
        imageObject.originalImage =imageOriginal;
        imageObject.smallImage =imageEdit;
        NSString *urlString = [NSString stringWithFormat:@"%@",[info objectForKey:UIImagePickerControllerReferenceURL]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *newTempUrl = @"";
        NSRange range = [urlString rangeOfString:@"PNG"];
        if (range.length) {
            newTempUrl = [NSString stringWithFormat:@"%@.png",str];
            imageObject.type=@"image/png";
        }else{
            newTempUrl = [NSString stringWithFormat:@"%@.jpg",str];
            imageObject.type=@"image/jpg";
        }
        imageObject.imageName = newTempUrl;
        [self updateUserPhotoImage:imageObject];
    }];
}
#pragma mark----imagePickerControllerDelegate----
- (void)updateUserPhotoImage:(UploadImageObject*)object {
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSData *imageData=[CWNSFileUtil image2DataURL:object.smallImage];
        NSDictionary *jsonDictionary = @{@"type":@"pic",@"file":object.smallImage,@"SessionID":sessionID};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request imageUploadWithUrl:[NSString stringWithFormat:@"%@",HOST_URL] fillPath:Post_Interface
                         parameters:jsonDictionary
                            andData:imageData
                           mimeType:object.type
                           fileName:object.imageName
                       successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                           [SVProgressHUD dismiss];
                           NSString *jsonString=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                           id recieveObject=[jsonString objectFromJSONString];
                           NSString *code =[NSString stringWithFormat:@"%@",[recieveObject valueForKeyWithOutNSNull:@"code"]];
                           if ([code integerValue]==0) {
                               UserManager *userManager=[UserManager currentUserManager];
                                userManager.sessionID=[recieveObject objectForKey:@"SessionID"];
                               [userManager synchronize];
                               [self synchronPhotoImage:[[recieveObject valueForKeyWithOutNSNull:@"data"] objectForKey:@"filePath"]];
                           }else
                           {
                               [SVProgressHUD showErrorWithStatus:[recieveObject valueForKeyWithOutNSNull:@"text"]];
                           }
                       } failBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"更新用户图像接口失败=======%@", error);
                           [ShowViewCenter netError];
                       }];
        
    }else
    {
        [ShowViewCenter netNotAvailable];
    }
}
- (void)synchronPhotoImage:(NSString*)urlString {
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"SessionID":sessionID,@"pic":urlString};
         NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, AddLicence] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"更新用户图像接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
               NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0) {
                UserManager *userManager=[UserManager currentUserManager];
                 userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                [userManager synchronize];
                [self viewWillAppear:YES];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"更新用户图像接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.baseTable.frame=CGRectMake(0, 60, kSCREEN_WIDTH, kSCREEN_HEIGHT-140);
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
