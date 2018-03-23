//
//  CWTextField.m
//  YSProject
//
//  Created by cuiw on 15/6/4.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "CWTextField.h"

@implementation CWTextField

//控制placeHolder的位置，左右缩20
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 16, 0);
}

//控制显示文本的位置
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 16, 0);
}

//控制编辑文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 16, 0);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage *bgImage = [UIImage imageNamed:@"textFieldBg"];
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(16, 30, 16, 30)];
    self.background = bgImage;
}

@end
