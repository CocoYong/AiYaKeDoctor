//
//  ShowViewCenter.m
// 
//
//  Created by cuiwei on 14-8-26.
//  Copyright (c) 2014年 Creditease. All rights reserved.
//

#import "ShowViewCenter.h"

@implementation ShowViewCenter

static ShowViewCenter *_showViewCenter = nil;
+ (ShowViewCenter *) sharedInstance {
    @synchronized(self) {
        if (_showViewCenter == nil) {
            _showViewCenter = [[self alloc] init];
        }
    }
    return _showViewCenter;
}

+ (void)netError {
    [SVProgressHUD showErrorWithStatus:NETERRORSTRING];
}

+ (void)netNotAvailable {
    [SVProgressHUD showErrorWithStatus:NETNOTAVAILABLESTRING];
}

+ (void)showSystemErrorFor:(id)delegate {
    [SVProgressHUD dismiss];
    [ShowViewCenterViewController showAlertViewWithTitle:nil message:SYSTEMERRORSTRING cancelButtonTitle:@"确定" otherButtonTitles:nil delegate:delegate cancelBlock:nil otherBlock:nil];
}

@end
