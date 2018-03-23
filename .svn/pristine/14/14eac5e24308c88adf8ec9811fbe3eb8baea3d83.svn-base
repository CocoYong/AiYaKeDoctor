//
//  ShowViewCenterViewController.h
//
//
//  Created by cuiw on 10/21/14.
//  Copyright (c) 2014 Creditease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowViewCenterViewController : UIViewController
/**
 *  封装的系统弹出框，根据系统判断使用UIAlertView或者UIAlertController，title = nil时转成空字符串
 *
 *  @param title             弹出框标题
 *  @param message           弹出框内容
 *  @param cancelButtonTitle 取消按钮标题
 *  @param otherButtonTitle  其他按钮标题
 *  @param delegate        代理对象
 *  @param cancelBlock       取消事件
 *  @param otherBlock        其他事件
 */
+ (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSString *)otherButtonTitle
                      delegate:(id)delegate
                   cancelBlock:(TouchBlock)cancelBlock
                    otherBlock:(TouchBlock)otherBlock;

/**
 *  封装的系统弹出框，带有输入框，根据系统判断使用UIAlertView或者UIAlertController，title = nil时转成空字符串
 *
 *  @param title             弹出框标题
 *  @param message           弹出框内容
 *  @param cancelButtonTitle 取消按钮标题
 *  @param otherButtonTitle  其他按钮标题
 *  @param secureTextEntry   输入内容是否加密
 *  @param placeholder       默认显示内容
 *  @param delegate        代理对象
 *  @param cancelBlock       取消事件
 *  @param otherBlock        其他事件
 */
- (id)initTextInputTypeAlertViewWithTitle:(NSString *)title
                                  message:(NSString *)message
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                        otherButtonTitles:(NSString *)otherButtonTitle
                          secureTextEntry:(BOOL)secureTextEntry
                              placeholder:(NSString *)placeholder
                                 delegate:(id)delegate
                              cancelBlock:(ActionBlock)cancelBlock
                               otherBlock:(ActionBlock)otherBlock;

+ (void)showActionSheetWithTitle:(NSString *)title
                     cancelButtonTitle:(NSString *)cancelButtonTitle
                     otherButtonTitles:(NSString *)otherButtonTitle
                              delegate:(id)delegate
                           cancelBlock:(TouchBlock)cancelBlock
                            otherBlock:(TouchBlock)otherBlock;
@end
