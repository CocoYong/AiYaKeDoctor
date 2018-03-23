//
//  BaseNavigationController.m
//  YSProject
//
//  Created by cuiw on 15/5/26.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTheme];
}

#pragma mark 设置导航栏主题
- (void)setNavigationTheme {
    // 1.导航栏
    // 1.1.操作navBar相当操作整个应用中的所有导航栏
    UINavigationBar *navBar = [UINavigationBar appearance];
    // 1.2.设置导航栏背景
    [navBar setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(47, 92, 116)] forBarMetrics:UIBarMetricsDefault];
    // 1.3.设置导航栏的文字
    [navBar setTitleTextAttributes:@{
                                     NSForegroundColorAttributeName : [UIColor whiteColor],
                                     }];
    //    // 2.导航栏上面的item
    //    UIBarButtonItem *barItem =[UIBarButtonItem appearance];
    //    // 2.1 设置item的文字属性
    //    NSDictionary *barItemTextAttr = @{
    //                                      UITextAttributeTextColor : [UIColor clearColor],
    //                                      UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero],
    //                                      UITextAttributeFont : [UIFont systemFontOfSize:13.0]
    //                                      };
    //    [barItem setTitleTextAttributes:barItemTextAttr forState:UIControlStateNormal];
    //    [barItem setTitleTextAttributes:barItemTextAttr forState:UIControlStateHighlighted];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
