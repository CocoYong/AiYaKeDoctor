//
//  NSDate+Extension.h
//  WBCalendarView
//
//  Created by wbitos on 15/7/22.
//  Copyright (c) 2015年 wbitos. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    SInt32 year;
    SInt8 month;
    SInt8 day;
    SInt8 hour;
    SInt8 minute;
    double second;
} WBGregorianDate;

static NSInteger const kOneDayTimeInterval = 86400;


@interface NSDate (Extension)
- (WBGregorianDate)gDate;
+ (NSDate *)firstDateWithYear:(NSInteger)year month:(NSInteger)month;
- (NSInteger)weekday;
+ (NSInteger)daysInYear:(NSInteger)year month:(NSInteger)month;

- (WBGregorianDate)prevMonth;
- (WBGregorianDate)nextMonth;

- (NSDate *)prevMonthFirstDate;
- (NSDate *)nextMonthFirstDate;
@end
