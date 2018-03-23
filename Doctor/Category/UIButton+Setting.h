//
//  UIButton+Setting.h
//  
//
//  Created by cuiwei on 14-7-10.
//  Copyright (c) 2014年 Creditease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Setting)
@property (nonatomic, assign) CGRect frame;
/**
 *  UIButton工厂方法
 *
 *  @param title
 *  @param font
 *  @param titleColor
 *  @param highlightedTitleColor
 *  @param selectedTitleColor
 *  @param disabledTitleColor
 *  @param image
 *  @param highlightedImage
 *  @param selectedImage
 *  @param disabledImage
 *  @param rect
 *
 *  @return UIButton
 */
+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor highlightedTitleColor:(UIColor *)highlightedTitleColor selectedTitleColor:(UIColor *)selectedTitleColor disabledTitleColor:(UIColor *)disabledTitleColor image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage selectedImage:(UIImage *)selectedImage disabledImage:(UIImage *)disabledImage rect:(CGRect)rect;

/**
 *  设置button EdgeInsets
 *
 *  @param title
 *  @param font
 *  @param image
 *  @param titleOriginX
 *  @param titleOriginY
 *  @param imageOriginX
 *  @param imageOriginY 
 */
- (void)setEdgeInsets:(NSString *)title font:(UIFont *)font image:(UIImage *)image titleOriginX:(CGFloat)titleOriginX titleOriginY:(CGFloat)titleOriginY imageOriginX:(CGFloat)imageOriginX imageOriginY:(CGFloat)imageOriginY;

// 提交按钮
+ (UIButton *)submitButtonWithOrigin:(CGPoint)origin title:(NSString *)title target:(id)target selector:(SEL)selector;

// 设置normal&highlighted状态的 BackgroundImage ，返回图片的尺寸
- (CGSize)setHighlightedStateWithImageName:(NSString *)name;

// 设置normal&selected状态的 BackgroundImage ，返回图片的尺寸
- (CGSize)setSelectedStateWithImageName:(NSString *)name;

// 设置normal&selected状态的 Image ，返回图片的尺寸
- (CGSize)setImageSelected:(NSString *)name;

//- (void)setTitleOriginX:(CGFloat)titleOriginX titleOriginY:(CGFloat)titleOriginY image:(UIImage *)image imageOriginX:(CGFloat)imageOriginX imageOriginY:(CGFloat)imageOriginY;
@end
