//
//  RootViewController.h
//
//
//  Created by cuiwei on 14-7-9.
//  Copyright (c) 2014年 Creditease. All rights reserved.
//
//根视图

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController 
@property (nonatomic, strong, readonly) UINavigationController *selectedViewController;// 选中的控制器
- (void)selecteControllerAtIndex:(int)index;
- (void)addDockForControllerAtIndex:(int)index;
@end
