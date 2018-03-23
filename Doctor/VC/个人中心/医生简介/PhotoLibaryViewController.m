//
//  PhotoLibaryViewController.m
//  YSProject
//
//  Created by MrZhang on 15/6/15.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "PhotoLibaryViewController.h"
#import "JSONKit.h"
#import "UploadImageManager.h"
#import "UploadImageObject.h"
#import "MessageReadManager.h"
#import "GalleryDetailView.h"
#import "GalleryImageCell.h"
@interface PhotoLibaryViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    GalleryDetailView *photoDetailView;
    CWHttpRequest *request;
    NSMutableArray *imageUrlArray;
}
@end

@implementation PhotoLibaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"相册"];
    [self addBackButt];
    
    
    UIButton *deleteButt=[UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButt setTitle:@"删除" forState:UIControlStateNormal];
    deleteButt.frame=CGRectMake(kSCREEN_WIDTH-50, 20, 40, 20);
    [deleteButt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteButt.titleLabel.font=[UIFont systemFontOfSize:14];
    [deleteButt addTarget:self action:@selector(deleteImageIndex) forControlEvents:UIControlEventTouchUpInside];
    [[self.view viewWithTag:10000] addSubview:deleteButt];
    
    
//    [self creatUIItem];
    imageUrlArray=[NSMutableArray array];
    for (NSDictionary *dic in _imageDataArray) {
        [imageUrlArray addObject:[dic objectForKey:@"picUrl"]];
    }
    self.view.backgroundColor=[UIColor blackColor];
    photoDetailView=[[GalleryDetailView alloc]initWithFrame:CGRectMake(0, 60, kSCREEN_WIDTH, kSCREEN_HEIGHT-60)];
    [photoDetailView setBackgroundColor:[UIColor blackColor]];
    photoDetailView.minimumZoomScale=1.0f;
    photoDetailView.maximumZoomScale=10.0f;
    [self.view addSubview:photoDetailView];
    
    [photoDetailView addImages:imageUrlArray];
    [photoDetailView setBeginIndex:0];
    
//    imageView=[[NLImageCropperView alloc]initWithFrame:CGRectMake(0, 60, kSCREEN_WIDTH, kSCREEN_HEIGHT-140)];
//    [imageView setImage:self.imageObject.originalImage];
//    [self.view addSubview:imageView];
//    [imageView setCropRegionRect:imageView.frame];
//    [imageView setFrame:CGRectMake(0, 60, kSCREEN_WIDTH, kSCREEN_HEIGHT-140)];
}
/*
-(void)creatUIItem
{
    UIImageView* OneButtImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-80, kSCREEN_WIDTH, 80)];
    OneButtImageView.image=[UIImage imageNamed:@"0_359"];
    [self.view addSubview:OneButtImageView];
    OneButtImageView.userInteractionEnabled=YES;
    NSArray *imageArray=@[@"0_353",@"0_356"];
    NSArray *titleArray=@[@"预览",@"上传"];
    for (int i=0; i<2; i++) {
        UIButton *itemButt=[UIButton buttonWithType:UIButtonTypeCustom];
        itemButt.tag=(i+1)*100;
        itemButt.frame=CGRectMake(i*kSCREEN_WIDTH/2, 20, kSCREEN_WIDTH/2, 40);
        [itemButt setImage:[UIImage imageNamed:[imageArray objectAtIndex:i]] forState:UIControlStateNormal];
        [itemButt addTarget:self action:@selector(twoButtAction:) forControlEvents:UIControlEventTouchUpInside];
        [OneButtImageView addSubview:itemButt];
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(itemButt.center.x-40, 60, 80, 20)];
        titleLabel.text=[titleArray objectAtIndex:i];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.font=[UIFont systemFontOfSize:10];
        [OneButtImageView addSubview:titleLabel];
   
    }
}
 */
-(void)deleteImageIndex
{
    NSInteger index=[[[_imageDataArray objectAtIndex:photoDetailView.currentNum] objectForKey:@"id"] integerValue];
    [self deleteLicenseImageWith:index];
}
- (void)deleteLicenseImageWith:(NSInteger)uid{
    if ([Reachability checkNetCanUse]) {
        if (!request) {
            request = [[CWHttpRequest alloc] init];
        }
        [SVProgressHUD showWithStatus:@"正在请求数据..." maskType:SVProgressHUDMaskTypeClear];
        NSString *sessionID=[UserManager currentUserManager].sessionID;
        NSDictionary *jsonDictionary = @{@"id":[NSNumber numberWithInteger:uid],@"SessionID":sessionID};
        NSLog(@"jsonDictionary====%@",jsonDictionary);
        [request JSONRequestOperationWithURL:[NSString stringWithFormat:@"%@%@", HOST_URL, DeletLicence] path:nil parameters:jsonDictionary successBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
            NSLog(@"删除照片接口成功%@", responseObject);
            [SVProgressHUD dismiss];
            NSString *code = [responseObject valueForKeyWithOutNSNull:@"code"];
            NSLog(@"sessionID😳😳😳😳😳😳😳😳😳😳=======%@",[responseObject valueForKeyWithOutNSNull:@"SessionID"]);
            if ([code integerValue]==0) {
                UserManager *userManager=[UserManager currentUserManager];
                userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                [userManager synchronize];
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                [SVProgressHUD showErrorWithStatus:[responseObject valueForKeyWithOutNSNull:@"text"]];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"删除照片接口失败=======%@", responseObject);
            [ShowViewCenter netError];
        }];
    } else {
        [ShowViewCenter netNotAvailable];
    }
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
                           id object=[jsonString objectFromJSONString];
                           NSString *code =[NSString stringWithFormat:@"%@",[object valueForKeyWithOutNSNull:@"code"]];
                           if ([code integerValue]==0) {
                               UserManager *userManager=[UserManager currentUserManager];
                               userManager.sessionID=[responseObject objectForKey:@"SessionID"];
                               [userManager synchronize];
                               [self synchronPhotoImage:[[object valueForKeyWithOutNSNull:@"data"] objectForKey:@"filePath"]];
                           }else
                           {
                               [SVProgressHUD showErrorWithStatus:[responseObject valueForKeyWithOutNSNull:@"text"]];
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
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failBlock:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
            NSLog(@"更新用户图像接口失败=======%@", responseObject);
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
