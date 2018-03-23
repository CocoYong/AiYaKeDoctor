//
//  ShowViewCenterViewController.m
//  
//
//  Created by cuiw on 10/21/14.
//  Copyright (c) 2014 Creditease. All rights reserved.
//

#import "ShowViewCenterViewController.h"
#import "UIBlockAlertView.h"
#import "UIBlockActionSheet.h"

@interface ShowViewCenterViewController ()
{
    @private
    UIAlertAction *_otherAction;
}
@end

@implementation ShowViewCenterViewController

+ (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSString *)otherButtonTitle
                            delegate:(id)delegate
                   cancelBlock:(TouchBlock)cancelBlock
                    otherBlock:(TouchBlock)otherBlock {
    if (cancelBlock == nil) {
        cancelBlock = ^ {};
    }
    if (otherBlock == nil) {
        otherBlock = ^ {};
    }
    if (IOSVERSION >= 8.0) {
        if (title == nil) {
            title = @"";
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        if (cancelButtonTitle && cancelButtonTitle.length > 0) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                cancelBlock();
            }];
            [alertController addAction:cancelAction];
        }
        
        if (otherButtonTitle && otherButtonTitle.length > 0) {
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                otherBlock();
            }];
            [alertController addAction:otherAction];
        }
        if (delegate) {
            [delegate presentViewController:alertController animated:YES completion:nil];
        } else {
            UIWindow *window = [[UIApplication sharedApplication] windows][0];
            if (!window) {
                window = [[UIApplication sharedApplication] keyWindow];
            }
            [window.rootViewController presentViewController:alertController animated:YES completion:nil];
        }
    } else {
        UIBlockAlertView *alertView = [[UIBlockAlertView alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle cancelblock:cancelBlock otherBlock:otherBlock];
        [alertView show];
    }
}

+ (void)showActionSheetWithTitle:(NSString *)title
             cancelButtonTitle:(NSString *)cancelButtonTitle
                      otherButtonTitles:(NSString *)otherButtonTitle
                      delegate:(id)delegate
                   cancelBlock:(TouchBlock)cancelBlock
                    otherBlock:(TouchBlock)otherBlock {
    if (cancelBlock == nil) {
        cancelBlock = ^ {};
    }
    if (otherBlock == nil) {
        otherBlock = ^ {};
    }
    if (IOSVERSION >= 8.0) {
        if (title == nil) {
            title = @"";
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        if (cancelButtonTitle && cancelButtonTitle.length > 0) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                cancelBlock();
            }];
            [alertController addAction:cancelAction];
        }
        
        if (otherButtonTitle && otherButtonTitle.length > 0) {
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                otherBlock();
            }];
            [alertController addAction:otherAction];
        }
        if (delegate) {
            [delegate presentViewController:alertController animated:YES completion:nil];
        } else {
            UIWindow *window = [[UIApplication sharedApplication] windows][0];
            [window.rootViewController presentViewController:alertController animated:YES completion:nil];
        }
    } else {
        UIBlockActionSheet *actionSheet = [[UIBlockActionSheet alloc] initWithTitle:title cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle delegate:delegate cancelBlock:cancelBlock otherBlock:otherBlock];
        UIWindow *window = [[UIApplication sharedApplication] windows][0];
        [actionSheet showInView:window.rootViewController.view];
    }
}

- (id)initTextInputTypeAlertViewWithTitle:(NSString *)title
                                  message:(NSString *)message
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                        otherButtonTitles:(NSString *)otherButtonTitle
                          secureTextEntry:(BOOL)secureTextEntry
                              placeholder:(NSString *)placeholder
                                 delegate:(id)delegate
                              cancelBlock:(ActionBlock)cancelBlock
                               otherBlock:(ActionBlock)otherBlock {
    self = [super init];
    if (self) {
        if (cancelBlock == nil) {
            cancelBlock = ^ (UITextField *textField) {};
        }
        if (otherBlock == nil) {
            otherBlock = ^ (UITextField *textField) {};
        }
        if (title.length == 0) {
            title = @"";
        }
        if (IOSVERSION >= 8.0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//                textField.backgroundColor = [UIColor clearColor];
                textField.borderStyle = UITextBorderStyleNone;
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
                textField.secureTextEntry = secureTextEntry;
                textField.placeholder = placeholder;
                textField.clearButtonMode = YES;
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
                cancelBlock(alertController.textFields.firstObject);
            }];
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
                otherBlock(alertController.textFields.firstObject);
            }];
            
            otherAction.enabled = NO;
            _otherAction = otherAction;
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            [delegate presentViewController:alertController animated:YES completion:nil];
        } else {
            if (secureTextEntry) {
                UIBlockAlertView *alertView = [[UIBlockAlertView alloc] initTextInputTypeWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle alertViewStyle:UIAlertViewStyleSecureTextInput placeholder:placeholder cancelblock:cancelBlock otherBlock:otherBlock];
                [alertView show];
            } else {
                UIBlockAlertView *alertView = [[UIBlockAlertView alloc] initTextInputTypeWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle alertViewStyle:UIAlertViewStylePlainTextInput placeholder:placeholder cancelblock:cancelBlock otherBlock:otherBlock];
                [alertView show];
            }
        }
    }
    return self;
}

- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
    UITextField *textField = notification.object;
    _otherAction.enabled = textField.text.length > 0;
}
@end
