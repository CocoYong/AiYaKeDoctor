//
//  CustomTabBar.m
//  YSProject
//
//  Created by MrZhang on 15/6/12.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "CustomTabBar.h"

@implementation CustomTabBar
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self drawRect:frame];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context=UIGraphicsGetCurrentContext();
  CGContextDrawImage(context, rect, [UIImage imageNamed:@"0_359@2x"].CGImage);
     UITabBarItem *itemOne=[[UITabBarItem alloc]initWithTitle:@"主页" image:[UIImage imageNamed:@"tab0_narmal@2x"] selectedImage:[UIImage imageNamed:@"tab0_selected@2x"]];
     UITabBarItem *itemTwo=[[UITabBarItem alloc]initWithTitle:@"我的预约" image:[UIImage imageNamed:@"tab1_normal@2x"] selectedImage:[UIImage imageNamed:@"tab1_selected@2x"]];
     UITabBarItem *itemThree=[[UITabBarItem alloc]initWithTitle:@"我的消息" image:[UIImage imageNamed:@"tab2_narmal@2x"] selectedImage:[UIImage imageNamed:@"tab2_selected@2x"]];
     UITabBarItem *itemFour=[[UITabBarItem alloc]initWithTitle:@"个人中心" image:[UIImage imageNamed:@"tab3_narmal@2x"] selectedImage:[UIImage imageNamed:@"tab3_selected@2x"]];
    self.items=@[itemOne,itemTwo,itemThree,itemFour];
}
@end
