//
//  TabBarViewController.h
//  YSProject
//
//  Created by MrZhang on 15/6/12.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarViewController : UITabBarController
@property(nonatomic,strong)UIImageView *tabbarImageView;
-(void)selectItemIndex:(NSInteger)index;
@end
