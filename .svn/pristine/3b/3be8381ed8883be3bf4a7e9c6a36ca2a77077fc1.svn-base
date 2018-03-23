//
//  DockItem.m
//
//
//  Created by cuiwei on 14-7-9.
//  Copyright (c) 2014年 Creditease. All rights reserved.
//


#import "DockItem.h"

@implementation DockItem

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 1.设置文字属性
//        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        self.titleLabel.font = [UIFont systemFontOfSize:12.0];
//        [self setTitleColor:RGBCOLOR(89, 89, 89) forState:UIControlStateNormal];
//        [self setTitleColor:RGBCOLOR(240, 98, 73) forState:UIControlStateSelected];
        // 2.设置图片属性
//        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

#pragma mark 重写父类的方法（覆盖父类在高亮时所作的行为）
- (void)setHighlighted:(BOOL)highlighted {}

//#pragma mark 返回是按钮内部UILabel的边框
//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    CGFloat titleX = 0;
//    CGFloat titleY = 30;
//    CGFloat titleHeight = contentRect.size.height - titleY;
//    return CGRectMake(titleX, titleY, contentRect.size.width - titleX, titleHeight);
//}

#pragma mark 返回是按钮内部UIImageView的边框
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width-self.currentImage.size.width)/2, (contentRect.size.height-self.currentImage.size.height)/2, self.currentImage.size.width, self.currentImage.size.height);
}

@end
