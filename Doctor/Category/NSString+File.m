//
//  NSString+File.m
//  
//
//  Created by cuiwei on 14-7-10.
//  Copyright (c) 2014年 Creditease. All rights reserved.
//

#import "NSString+File.h"

@implementation NSString (File)
- (NSString *)filenameAppend:(NSString *)append
{
    // 1.获取没有拓展名的文件名
    NSString *filename = [self stringByDeletingPathExtension];
    
    // 2.拼接append
    filename = [filename stringByAppendingString:append];
    
    // 3.拼接拓展名
    NSString *extension = [self pathExtension];
    
    // 4.生成新的文件名
    return [filename stringByAppendingPathExtension:extension];
}

- (BOOL)containsString:(NSString *)aString
{
	NSRange range = [[self lowercaseString] rangeOfString:[aString lowercaseString]];
	return range.location != NSNotFound;
}

- (NSString*)telephoneWithReformat
{
    
    NSString *str=self;
    NSString * PHS = @"^0\\d{2,3}-\\d{7,8}$";
    BOOL flag;
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    flag=[regextestct evaluateWithObject:str];
    if (flag) {
        return str;
    }
    
    if ([self containsString:@"-"])
    {
        str = [self stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    if ([self containsString:@"+86"]) {
        str = [self stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    }
    if ([self containsString:@" "])
    {
        str = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    if ([self containsString:@"("])
    {
        str = [self stringByReplacingOccurrencesOfString:@"(" withString:@""];
    }
    
    if ([self containsString:@")"])
    {
        str = [self stringByReplacingOccurrencesOfString:@")" withString:@""];
    }
    return str;
}

+ (NSString *)formatDigitalString:(NSString *)str
{
    NSString *formattedNumberString;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:1];
    [numberFormatter setMinimumFractionDigits:0];
    [numberFormatter setMaximumFractionDigits:2];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehaviorDefault];
    formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[str doubleValue]]];
    return formattedNumberString;
}
+ (NSString *)formatBankCardString:(NSString *)str
{
    NSMutableString *bankCard = [NSMutableString stringWithString:str];
    NSInteger length = bankCard.length;
    for (int i = 1; i <= length/4; i++) {
        [bankCard insertString:@" " atIndex: 4 * i + (i - 1)];
    }
    return (NSString *)bankCard;
}
- (NSString *)formatTimeString
{
    if (self.length == 0 || [self isEqualToString:@" "]) {
        return @"";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:ss"];
    [dateFormatter setDateFormat:@"YYYY.MM.dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]/1000];
    NSString *strTime = [dateFormatter stringFromDate:date];
    return strTime;
}
@end
