//
//  WBCalendarView.h
//  WBCalendarView
//
//  Created by wbitos on 15/7/22.
//  Copyright (c) 2015年 wbitos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBCalendarMonthView.h"
@interface WBCalendarView : UIView
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, weak) id <WBCalendarMonthViewDelegate> monthViewDelegate;
@property (nonatomic, strong) UIImage *selectImage;
- (void)reload;

- (IBAction)prevMonthAction:(id)sender;
- (IBAction)nextMonthAction:(id)sender;
@end
