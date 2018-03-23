//
//  WBCalendarView.h
//  WBCalendarView
//
//  Created by wbitos on 15/7/22.
//  Copyright (c) 2015年 wbitos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBCalendarMonthView;

@protocol WBCalendarMonthViewDelegate <NSObject>
- (void)calendarViewDidChangeToYear:(NSInteger)year month:(NSInteger)month;
- (void)calendarMonthView:(WBCalendarMonthView *)monthView didSelectedDate:(NSDate *)date;
- (NSString *)calendarMonthView:(WBCalendarMonthView *)monthView titleForDate:(NSDate *)date;
//- (NSDate*)calenderMonthViewSelectedDate;
@end

@interface WBCalendarMonthView : UIView
@property (nonatomic, assign) BOOL sundayFirst;
@property (nonatomic, assign) CGFloat edgePadding;

@property (nonatomic, strong) UIColor *weekEndColor;
@property (nonatomic, strong) UIColor *weekDayColor;
@property (nonatomic, strong) UIColor *otherMonthDayColor;

@property (nonatomic, strong) UIFont *dayFont;
@property (nonatomic, strong) UIFont *subTitleFont;
@property (nonatomic, strong) UIImage *selectImage;


@property (nonatomic, readonly) NSInteger year;
@property (nonatomic, readonly) NSInteger month;

@property (nonatomic, weak) id <WBCalendarMonthViewDelegate> delegate;

- (void)setYear:(NSInteger)year month:(NSInteger)month;
@end
