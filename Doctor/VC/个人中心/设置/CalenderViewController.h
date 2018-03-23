//
//  CalenderViewController.h
//  Doctor
//
//  Created by MrZhang on 15/7/3.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DateDelegate<NSObject>
-(void)passRetureDate:(NSDate*)date;
@end
@interface CalenderViewController : UIViewController
@property(nonatomic,strong)NSString *titleString;
@property(nonatomic,assign)id<DateDelegate>delegate;
@end
