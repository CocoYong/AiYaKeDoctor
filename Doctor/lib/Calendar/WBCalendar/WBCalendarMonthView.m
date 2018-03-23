//
//  WBCalendarView.m
//  WBCalendarView
//
//  Created by wbitos on 15/7/22.
//  Copyright (c) 2015年 wbitos. All rights reserved.
//

#import "WBCalendarMonthView.h"
#import "NSDate+Extension.h"
#import "UIColor+Extension.h"
#import "NSDate+FSExtension.h"
@interface WBCalendarMonthView ()
@property (nonatomic, strong) NSDate   *firstDate;
@property (nonatomic, assign) NSInteger totalRows;
@property (nonatomic, strong) NSParagraphStyle *style;
@property (nonatomic, strong) NSParagraphStyle *subTitleStyle;
@end

@implementation WBCalendarMonthView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupColor];
    }
    return self;
}

- (void)setupColor {
    self.edgePadding = 20;
    
    self.weekDayColor = RGBHex(0x98d1e9);
    self.weekEndColor = [UIColor blackColor];
    self.otherMonthDayColor = [UIColor clearColor];
    self.dayFont = [UIFont systemFontOfSize:15];
    self.subTitleFont = [UIFont systemFontOfSize:8];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    
    self.style = style;
    
    NSMutableParagraphStyle *subTitleStyle = [[NSMutableParagraphStyle alloc] init];
    subTitleStyle.alignment = NSTextAlignmentCenter;
    
    self.subTitleStyle = subTitleStyle;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGFloat w = (self.bounds.size.width - (self.edgePadding * 2)) / 7.0;
    CGFloat h = w;
    
    NSInteger totalDays = self.totalRows * 7;
    
    NSDate *today = [NSDate date];
    WBGregorianDate gToday = [today gDate];
    
    for (NSInteger idx = 0; idx < totalDays; idx++) {
        NSInteger row = idx / 7;
        NSInteger col = idx % 7;
        
        NSDate *date = [self.firstDate dateByAddingTimeInterval:kOneDayTimeInterval * idx];
        WBGregorianDate gDate = [date gDate];
        
        if (gToday.year == gDate.year && gToday.month == gDate.month && gToday.day == gDate.day) {
            CGRect rect = CGRectMake(self.edgePadding + col * w + 5, row * h + 5, w - 10, h - 10);
            
            UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:3.0f];
            [RGBHex(0xfeae08) set];
            [roundedRect stroke];
        }
        
        NSInteger weekDay = [date weekday];
        
        NSString *dayString = [NSString stringWithFormat:@"%d", gDate.day];
        
        UIColor *textColor = self.weekDayColor;
        
        if (gDate.month != self.month) {
            textColor = self.otherMonthDayColor;
        }
        else if (weekDay == 1 || weekDay == 7) {
            textColor = self.weekEndColor;
        }
        CGRect r = CGRectMake(self.edgePadding + col * w, row * h + 10, w, 15);
        [dayString drawInRect:r withAttributes:@{NSForegroundColorAttributeName: textColor, NSFontAttributeName: self.dayFont, NSParagraphStyleAttributeName: self.style}];
        

        if (gDate.month == self.month) {

            if (self.delegate && [self.delegate respondsToSelector:@selector(calendarMonthView:titleForDate:)]) {
                NSString *subTitle = [self.delegate calendarMonthView:self titleForDate:date];
                if (subTitle) {
                    CGRect subTitleRect = CGRectMake(self.edgePadding + col * w + 6, (row + 1) * h - 10, w - 12, 10);
                    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRect:subTitleRect];
                    [[UIColor hexColor:@"#ffac01"] setFill];
                    [roundedRect fillWithBlendMode:kCGBlendModeNormal alpha:0.5];
                                 [subTitle drawInRect:subTitleRect withAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],  NSFontAttributeName: self.subTitleFont, NSParagraphStyleAttributeName: self.subTitleStyle}];
                }
                else
                {
                    for (UIView *view in self.subviews) {
                        if ([view isKindOfClass:[UILabel class]]) {
                            [view removeFromSuperview];
                        }
                    }

                }
            }
        }
    }
}

- (void)setYear:(NSInteger)year month:(NSInteger)month {
    _year = year;
    _month = month;
    
    NSDate *firstMonthDate = [NSDate firstDateWithYear:self.year month:self.month];
    NSInteger firstMonthDateWeekday = [firstMonthDate weekday];
    self.firstDate = [firstMonthDate dateByAddingTimeInterval:-1 * kOneDayTimeInterval * (firstMonthDateWeekday - 1)];
    NSInteger daysInMonth = [NSDate daysInYear:self.year month:self.month];
    self.totalRows = ceil((daysInMonth + firstMonthDateWeekday - 1) / 7.0);
    
    [self setNeedsDisplay];
}

- (IBAction)tap:(UITapGestureRecognizer *)tapGestureRecognizer {
    CGPoint point = [tapGestureRecognizer locationInView:self];
    CGFloat w = (self.bounds.size.width - self.edgePadding * 2) / 7.0;
    CGFloat h = w;
    
    if (point.x >= self.edgePadding && point.x <= (self.bounds.size.width - self.edgePadding)) {
        point.x -= self.edgePadding;
        NSInteger col = floor(point.x / w);
        NSInteger row = floor(point.y / h);
        
        NSInteger idx = row * 7 + col;
        NSDate *date = [self.firstDate dateByAddingTimeInterval:kOneDayTimeInterval * idx];
        NSString *dateString=[date  fs_stringWithFormat:@"yyyy-MM-dd"];
        NSLog(@"datestring===%@",dateString);
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
        }
            CGRect  imageViewRect=CGRectMake(col*w+self.edgePadding, row*w+w/2, w, w/2);
            NSLog(@"imageViewRect===%@",NSStringFromCGRect(imageViewRect));
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:imageViewRect];
            imageView.image=[UIImage imageNamed:@"0_225"];
            [self addSubview:imageView];

        if (self.delegate && [self.delegate respondsToSelector:@selector(calendarMonthView:didSelectedDate:)]) {
            [self.delegate calendarMonthView:self didSelectedDate:date];
        }
    }
}
@end
