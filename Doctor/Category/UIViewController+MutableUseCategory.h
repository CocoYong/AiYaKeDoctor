//
//  UIViewController+MutableUseCategory.h
//  YSProject
//
//  Created by MrZhang on 15/6/12.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MutableUseCategory)
-(void)creatNavgationBarWithTitle:(NSString*)title;
-(void)addBackButt;
-(void)hiddenTabbbarImageView:(BOOL)hidden;
@end
