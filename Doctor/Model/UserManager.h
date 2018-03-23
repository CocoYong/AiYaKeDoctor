//
//  UserManager.h
//  YSProject
//
//  Created by cuiw on 15/6/8.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

// 用户登录状态
typedef enum {
    UserStateLogout = 0,// 用户未登录
    UserStateLogin// 用户登录
} UserState;

@interface UserManager : NSObject
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, assign) UserState userState;
@property (nonatomic, copy) NSString *sessionID;
@property (nonatomic, copy) NSString *globalSessionID;
@property (nonatomic,copy) NSString *loginName;
@property (nonatomic,copy) NSString *password;
+ (UserManager *)currentUserManager;
- (void)synchronize;
+ (BOOL)isLogin;
+ (void)logout;
@end
