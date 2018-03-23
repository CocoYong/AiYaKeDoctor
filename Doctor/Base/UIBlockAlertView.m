//
//  UIBlockAlertView.m
//  UIBlockAlertView
//
//  Created by cuiwei on 14-8-26.
//  Copyright (c) 2014年 Creditease. All rights reserved.
//

#import "UIBlockAlertView.h"

@implementation UIBlockAlertView

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitle
              cancelblock:(TouchBlock)cancelBlock
              otherBlock:(TouchBlock)otherBlock {
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
    if (self) {
        self.cancelBlock = cancelBlock;
        self.otherBlock = otherBlock;
    }
    return self;
}

- (id)initTextInputTypeWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitle
      alertViewStyle:(UIAlertViewStyle)alertViewStyle
         placeholder:(NSString *)placeholder
        cancelblock:(ActionBlock)cancelBlock
         otherBlock:(ActionBlock)otherBlock {
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
    if (self) {
        self.alertViewStyle = alertViewStyle;
        UITextField *textField = [self textFieldAtIndex:0];
        textField.placeholder = placeholder;
        textField.clearButtonMode = YES;
        self.cancelActionBlock = cancelBlock;
        self.otherActionBlock = otherBlock;
    }
    return self;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //这里调用函数指针block(要传进来的参数);
    if (alertView.alertViewStyle == UIAlertViewStyleDefault) {
        if (buttonIndex == 0)
            _cancelBlock();
        else if (buttonIndex == 1)
            _otherBlock();
    } else {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if (buttonIndex == 0)
            _cancelActionBlock(textField);
        else if (buttonIndex == 1)
            _otherActionBlock(textField);
    }
}

@end
