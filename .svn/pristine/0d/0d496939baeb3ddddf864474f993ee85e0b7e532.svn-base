//
//  UIBlockAlertView.h
//  UIBlockAlertView
//
//  Created by cuiwei on 14-8-26.
//  Copyright (c) 2014年 Creditease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBlockAlertView : UIAlertView
@property (nonatomic, copy) TouchBlock otherBlock;
@property (nonatomic, copy) TouchBlock cancelBlock;
@property (nonatomic, copy) ActionBlock cancelActionBlock;
@property (nonatomic, copy) ActionBlock otherActionBlock;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitle
        cancelblock:(TouchBlock)cancelBlock
          otherBlock:(TouchBlock)otherBlock;

- (id)initTextInputTypeWithTitle:(NSString *)title
                         message:(NSString *)message
               cancelButtonTitle:(NSString *)cancelButtonTitle
               otherButtonTitles:(NSString *)otherButtonTitle
                  alertViewStyle:(UIAlertViewStyle)alertViewStyle
                     placeholder:(NSString *)placeholder
                     cancelblock:(ActionBlock)cancelBlock
                      otherBlock:(ActionBlock)otherBlock;

@end
