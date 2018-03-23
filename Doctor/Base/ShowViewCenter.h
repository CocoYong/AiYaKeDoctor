//
//  ShowViewCenter.h
//  UIBlockAlertView
//
//  Created by cuiwei on 14-8-26.
//  Copyright (c) 2014年 Creditease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowViewCenter : NSObject
+ (ShowViewCenter *)sharedInstance;

+ (void)netError;
+ (void)showSystemErrorFor:(id)delegate;
+ (void)netNotAvailable;

@end
