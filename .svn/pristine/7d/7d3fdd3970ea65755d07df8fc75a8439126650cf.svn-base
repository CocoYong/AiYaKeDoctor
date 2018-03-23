//
//  ChangeWaitingPendingTimeController.h
//  YSProject
//
//  Created by MrZhang on 15/6/15.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol changeTimeDelegate<NSObject>
-(void)passChangeTimeStatusAndDictionary:(NSDictionary*)passDic;
@end
@interface ChangeWaitingPendingTimeController : UIViewController
@property (nonatomic,strong)NSDictionary *orderDictionary;
@property (nonatomic,assign) id<changeTimeDelegate>delegate;
@end
