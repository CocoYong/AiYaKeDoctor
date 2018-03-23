//
//  UIPlaceHolderTextView.m
//  MaiHome
//
//  Created by MrZhang on 15/5/29.
//  Copyright (c) 2015年 ZhangYong. All rights reserved.
//

#import "UIPlaceHolderTextView.h"

@implementation UIPlaceHolderTextView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self createPlaceHolderLabel];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self createPlaceHolderLabel];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame andPlaceholder:(NSString*)placeholder andLayerRadius:(CGFloat)radius andBorderColor:(UIColor*)color andBorderWidth:(CGFloat)width
{
    if (self=[super initWithFrame:frame]) {
        self.layer.borderColor=color.CGColor;
        self.layer.borderWidth=width;
        self.layer.cornerRadius=radius;
        self.placeholder=placeholder;
        [self createPlaceHolderLabel];
    }
    return self;
}
-(void)createPlaceHolderLabel
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    _placeHolderLabel=[[UILabel alloc]initWithFrame:CGRectMake(2, 4, CGRectGetWidth(self.frame)-4, 21)];
    _placeHolderLabel.text=self.placeholder?self.placeholder:self.text;
    _placeHolderLabel.textColor=self.placeholderColor?self.placeholderColor:[UIColor lightGrayColor];
    _placeHolderLabel.backgroundColor=[UIColor clearColor];
    self.layer.cornerRadius=_cornerRadius;
    self.layer.borderColor=_borderColor.CGColor;
    self.layer.borderWidth=_borderWith;
    [self addSubview:_placeHolderLabel];
}
-(void)setPlaceholder:(NSString *)placeholder
{
    if (placeholder.length==0||[placeholder isEqualToString:@""]) {
        _placeHolderLabel.hidden=YES;
    }else
    {
        _placeHolderLabel.text=placeholder;
        _placeholder=placeholder;
    }
}
-(void)textChanged:(NSNotification *)notification
{
    if (self.placeholder.length == 0 || [self.placeholder isEqualToString:@""]) {
        _placeHolderLabel.hidden=YES;
    }
    if (self.text.length > 0) {
        _placeHolderLabel.hidden=YES;
    }
    else{
        _placeHolderLabel.hidden=NO;
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_placeHolderLabel removeFromSuperview];
    _placeHolderLabel=nil;
    _placeholderColor=nil;
    _placeholder=nil;
}
@end
