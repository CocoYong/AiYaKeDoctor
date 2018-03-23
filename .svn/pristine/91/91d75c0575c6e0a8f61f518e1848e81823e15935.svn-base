//
//  UIButton+Setting.m
//  
//
//  Created by cuiwei on 14-7-10.
//  Copyright (c) 2014年 Creditease. All rights reserved.
//

#import "UIButton+Setting.h"

@implementation UIButton (Setting)
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.exclusiveTouch = YES;
}

+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor highlightedTitleColor:(UIColor *)highlightedTitleColor selectedTitleColor:(UIColor *)selectedTitleColor disabledTitleColor:(UIColor *)disabledTitleColor image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage selectedImage:(UIImage *)selectedImage disabledImage:(UIImage *)disabledImage rect:(CGRect)rect {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
    [button setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    [button setTitleColor:disabledTitleColor forState:UIControlStateDisabled];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    [button setImage:selectedImage forState:UIControlStateSelected];
    [button setImage:disabledImage forState:UIControlStateDisabled];
    button.frame = rect;
    return button;
}

- (void)setEdgeInsets:(NSString *)title font:(UIFont *)font image:(UIImage *)image titleOriginX:(CGFloat)titleOriginX titleOriginY:(CGFloat)titleOriginY imageOriginX:(CGFloat)imageOriginX imageOriginY:(CGFloat)imageOriginY
{
    if (image != nil) {
        // 找出imageView最终的center
        CGFloat buttonImageViewWidth = CGImageGetWidth(image.CGImage) / 2;
        CGPoint endImageViewCenter = CGPointMake(imageOriginX + buttonImageViewWidth / 2, imageOriginY + CGRectGetMidY(self.bounds));
        // 取得imageView最初的center
        CGPoint startImageViewCenter = self.imageView.center;
        // 设置imageEdgeInsets
        CGFloat imageEdgeInsetsTop = endImageViewCenter.y - startImageViewCenter.y;
        CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
        CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
        CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
        self.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
    }
    
//    CGSize buttonTitleLabelSize = [title sizeWithFont:font];
//    CGPoint endTitleLabelCenter = CGPointMake(titleOriginX + buttonTitleLabelSize.width / 2, titleOriginY + CGRectGetMidY(self.bounds));
//    CGPoint startTitleLabelCenter = self.titleLabel.center;
//    // 设置titleEdgeInsets
//    CGFloat titleEdgeInsetsTop = endTitleLabelCenter.y - startTitleLabelCenter.y;
//    CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
//    CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
//    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, titleOriginX, titleOriginY, 0);
}

//- (void)setTitleOriginX:(CGFloat)titleOriginX titleOriginY:(CGFloat)titleOriginY image:(UIImage *)image imageOriginX:(CGFloat)imageOriginX imageOriginY:(CGFloat)imageOriginY {
//    if (image != nil) {
//        // 找出imageView最终的center
//        CGPoint endImageViewCenter = CGPointMake(imageOriginX + image.size.width / 2, imageOriginY + CGRectGetMidY(self.bounds));
//        // 取得imageView最初的center
//        CGPoint startImageViewCenter = self.imageView.center;
//        // 设置imageEdgeInsets
//        CGFloat imageEdgeInsetsTop = endImageViewCenter.y - startImageViewCenter.y;
//        CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
//        NSLog(@"=======%f",  imageEdgeInsetsLeft);
//        CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
//        CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
//        self.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
//    }
//    
//    NSString *title = self.titleLabel.text;
//    if (title != nil) {
//        UIFont *font = self.titleLabel.font;
//        CGSize buttonTitleLabelSize = [title sizeWithFont:font];
//        CGPoint endTitleLabelCenter = CGPointMake(titleOriginX + buttonTitleLabelSize.width / 2, titleOriginY + CGRectGetMidY(self.bounds));
//        CGPoint startTitleLabelCenter = self.titleLabel.center;
//        // 设置titleEdgeInsets
//        CGFloat titleEdgeInsetsTop = endTitleLabelCenter.y - startTitleLabelCenter.y;
//        CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
//        CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
//        CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
//        self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
//    }
//}

+ (UIButton *)submitButtonWithOrigin:(CGPoint)origin title:(NSString *)title target:(id)target selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect = CGRectMake(origin.x, origin.y, kSCREEN_WIDTH - 32, PUBLICBTN_HEIGHT);
    button.frame = rect;
    UIImage *normalImage = [UIImage imageNamed:@"Public_button_normal"];
    UIImage *highlightedImage = [UIImage imageNamed:@"Public_button_highlighted"];
    UIImage *disabledImage = [UIImage imageNamed:@"Public_button_disabled"];
    normalImage = [normalImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    highlightedImage = [highlightedImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    disabledImage = [disabledImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:disabledImage forState:UIControlStateDisabled];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateHighlighted];
    [button setTitleColor:RGBCOLOR(173, 184, 188) forState:UIControlStateDisabled];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (CGSize)setHighlightedStateWithImageName:(NSString *)name
{
    UIImage *normal = [UIImage stretchImageWithImageName:name];
    UIImage *highlighted = [UIImage stretchImageWithImageName:[name stringByReplacingOccurrencesOfString:@"normal" withString:@"highlighted"]];
    UIImage *disabled = [UIImage stretchImageWithImageName:[name stringByReplacingOccurrencesOfString:@"normal" withString:@"disabled"]];
    [self setBackgroundImage:normal forState:UIControlStateNormal];
    [self setBackgroundImage:highlighted forState:UIControlStateHighlighted];
    [self setBackgroundImage:disabled forState:UIControlStateDisabled];
    return normal.size;
}

- (CGSize)setSelectedStateWithImageName:(NSString *)name
{
    UIImage *normal = [UIImage imageNamed:name];
    UIImage *selected = [UIImage imageNamed:[name stringByReplacingOccurrencesOfString:@"normal" withString:@"selected"]];
    [self setBackgroundImage:normal forState:UIControlStateNormal];
    [self setBackgroundImage:selected forState:UIControlStateSelected];
    return normal.size;
}

- (CGSize)setImageSelected:(NSString *)name
{
    UIImage *normal = [UIImage imageNamed:name];
    UIImage *selected = [UIImage imageNamed:[name stringByReplacingOccurrencesOfString:@"normal" withString:@"selected"]];
    [self setImage:normal forState:UIControlStateNormal];
    [self setImage:selected forState:UIControlStateSelected];
    return normal.size;
}
@end
