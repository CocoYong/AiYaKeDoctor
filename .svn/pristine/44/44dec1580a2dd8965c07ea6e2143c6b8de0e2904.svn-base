//
//  SelfAlertView.m
//  Doctor
//
//  Created by MrZhang on 15/6/24.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "SelfAlertView.h"

@implementation SelfAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles
{
    if (self =[super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil]) {
       
        UIButton *leftButt=[UIButton buttonWithType:UIButtonTypeCustom];
        leftButt.frame=CGRectMake(10, 70, (kSCREEN_WIDTH-70)/2, 20);
        [leftButt setBackgroundImage:[UIImage imageNamed:@"0_156"] forState:UIControlStateNormal];
        [leftButt addTarget:self action:@selector(sureButtTap) forControlEvents:UIControlEventTouchUpInside];
        [leftButt setTitle:@"确定" forState:UIControlStateNormal];
        [self addSubview:leftButt];
        
        UIButton *rightButt=[UIButton buttonWithType:UIButtonTypeCustom];
        rightButt.frame=CGRectMake(10, 70, (kSCREEN_WIDTH-70)/2, 20);
        [rightButt setBackgroundImage:[UIImage imageNamed:@"0_156"] forState:UIControlStateNormal];
        [rightButt addTarget:self action:@selector(cancelButtTap) forControlEvents:UIControlEventTouchUpInside];
        [rightButt setTitle:@"取消" forState:UIControlStateNormal];
        [self addSubview:rightButt];

    }
    return self;
}
-(void)sureButtTap
{
    
}
-(void)cancelButtTap
{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
