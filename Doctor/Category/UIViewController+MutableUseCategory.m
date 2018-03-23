//
//  UIViewController+MutableUseCategory.m
//  YSProject
//
//  Created by MrZhang on 15/6/12.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "UIViewController+MutableUseCategory.h"
#import "TabBarViewController.h"
@implementation UIViewController (MutableUseCategory)
-(void)creatNavgationBarWithTitle:(NSString*)title
{
    self.navigationController.navigationBar.hidden=YES;
    UIImageView *navgationbarBack=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 60)];
    navgationbarBack.tag=10000;
    navgationbarBack.userInteractionEnabled=YES;
    navgationbarBack.image=[UIImage imageNamed:@"navBar"];
    [self.view addSubview:navgationbarBack];
    
    UILabel *selfTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2-100,15, 200, 30)];
    selfTitleLabel.text=title;
    selfTitleLabel.tag=20000;
    selfTitleLabel.textColor=[UIColor whiteColor];
    selfTitleLabel.textAlignment=NSTextAlignmentCenter;
    [navgationbarBack addSubview:selfTitleLabel];
}
-(void)addBackButt
{
    UIButton *backButt=[UIButton buttonWithType:UIButtonTypeCustom];
    backButt.frame=CGRectMake(5, 15, 30, 30);
    [backButt setImage:[UIImage imageNamed:@"0_212.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButt];
    [backButt addTarget:self action:@selector(backToFrontViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:backButt];
}
-(void)hiddenTabbbarImageView:(BOOL)hidden
{
    if (hidden) {
        self.hidesBottomBarWhenPushed=YES;
      [(TabBarViewController*)self.tabBarController  tabbarImageView].hidden=self.hidesBottomBarWhenPushed;
    }else{
        self.hidesBottomBarWhenPushed=NO;
     [(TabBarViewController*)self.tabBarController  tabbarImageView].hidden=self.hidesBottomBarWhenPushed;
    }
}
-(void)backToFrontViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
