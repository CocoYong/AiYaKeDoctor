//
//  SelfAlertView.h
//  Doctor
//
//  Created by MrZhang on 15/6/24.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelfAlertView : UIAlertView
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;
@end
