/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "NSDateAdditions.h"

@implementation NSDate (KalAdditions)

- (NSDate *)cc_dateByMovingToBeginningOfDay
{
  unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
  [parts setHour:0];
  [parts setMinute:0];
  [parts setSecond:0];
  return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

- (NSDate *)cc_dateByMovingToEndOfDay
{
  unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
  [parts setHour:23];
  [parts setMinute:59];
  [parts setSecond:59];
  return [[NSCalendar currentCalendar] dateFromComponents:parts];
}
//本月第一天
- (NSDate *)cc_dateByMovingToFirstDayOfTheMonth
{
  NSDate *d = nil;
  BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit startDate:&d interval:NULL forDate:self];
  NSAssert1(ok, @"Failed to calculate the first day the month based on %@", self);
  return d;
}
//上个月第一天
- (NSDate *)cc_dateByMovingToFirstDayOfThePreviousMonth
{
  NSDateComponents *c = [[NSDateComponents alloc] init];
  c.month = -1;
  return [[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheMonth];  
}
//下个月第一天
- (NSDate *)cc_dateByMovingToFirstDayOfTheFollowingMonth
{
  NSDateComponents *c = [[NSDateComponents alloc] init];
  c.month = 1;
  return [[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheMonth];
}
//返回年月日
- (NSDateComponents *)cc_componentsForMonthDayAndYear
{
  return [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
}
//返回星期几
- (NSUInteger)cc_weekday
{
  return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
}
//返回本月多少天
- (NSUInteger)cc_numberOfDaysInMonth
{
  return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}
//下一天
- (NSDate*)cc_dateByMovingToNextDay:(NSDate*)date
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.day = 1;
    NSDate  *tempDate=[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:date options:0];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"YYYY-MM-dd";
    NSString *dateString=[formatter stringFromDate:tempDate];
    return  [formatter dateFromString:dateString];
}
@end