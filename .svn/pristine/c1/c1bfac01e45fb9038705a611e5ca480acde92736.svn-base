//
//  DrawingView.m
//  txdai
//  绘制虚线+绘制圆圈
//  Created by MrZhang on 14/11/5.
//  Copyright (c) 2014年 zhangyong. All rights reserved.
//

#import "DrawingView.h"
#define PI 3.14159265358979323846
@implementation DrawingView
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]){
     
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{
    if (!_circle) {
        self.backgroundColor=[UIColor clearColor];
        CGContextRef context =UIGraphicsGetCurrentContext();
        CGContextBeginPath(context);
        CGContextSetLineWidth(context, 1.0);
        CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);

        CGFloat lengths[] = {3,1};
        CGContextSetLineDash(context, 0, lengths,2);

      
        CGContextSetLineDash(context, 0,lengths,2);

        CGContextMoveToPoint(context, 0.0, 1.0);
        CGContextAddLineToPoint(context, rect.size.width-10,1.0);
        CGContextStrokePath(context);
    }else
    {
//        int selfPercent=(int)([self.percent floatValue]*100);
        CGContextRef context =UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 0.5);
        CGContextAddArc(context, self.bounds.origin.x+(self.bounds.size.width)/2, self.bounds.origin.y+(self.bounds.size.height)/2, (self.bounds.size.width-1)/2, 0, 2*PI, 0);
        CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
        CGContextDrawPath(context, kCGPathFill);
        
//        CGContextSetLineWidth(context, 5);
//        CGContextAddArc(context, self.bounds.origin.x+(self.bounds.size.width)/2, self.bounds.origin.y+(self.bounds.size.height)/2, (self.bounds.size.width-11)/2, -PI/2, (selfPercent*2*PI)/100-PI/2, 0);
//        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//        CGContextDrawPath(context, kCGPathStroke);
        
//        UILabel *percentLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height)];
//        percentLabel.text=[NSString stringWithFormat:@"%d%%",(int)(selfPercent)];
//        percentLabel.backgroundColor=[UIColor clearColor];
//        percentLabel.textColor=[UIColor redColor];
//        if (selfPercent==0) {
//            percentLabel.textColor=[UIColor redColor];
//        }
//        percentLabel.font=[UIFont systemFontOfSize:10];
//        percentLabel.textAlignment=NSTextAlignmentCenter;
//        [self addSubview:percentLabel];
        
        /*
        CGContextSetLineWidth(context, 0.5);
        CGContextAddArc(context, self.bounds.origin.x+(self.bounds.size.width)/2, self.bounds.origin.y+(self.bounds.size.height)/2, (self.bounds.size.width-15)/2, 0, 2*PI, 0);
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextDrawPath(context, kCGPathStroke);

        CGContextSetLineWidth(context, 0.5);
        CGContextAddArc(context, self.bounds.origin.x+(self.bounds.size.width)/2, self.bounds.origin.y+(self.bounds.size.height)/2, (self.bounds.size.width-5)/2, 0, 2*PI, 0);
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextDrawPath(context, kCGPathStroke);
        */
    }
 
}

@end
