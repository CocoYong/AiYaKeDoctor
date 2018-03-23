//
//  Globals.h
//  YSProject
//
//  Created by cuiw on 15/5/26.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#ifndef YSProject_Globals_h
#define YSProject_Globals_h
//============================================================================
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define kDarkGrayColor       RGBCOLOR(51, 51, 51)
#define kGrayColor           RGBCOLOR(153, 153, 153)
#define kLightGrayColor      RGBCOLOR(185, 185, 185)
//============================================================================
#define IOSVERSION [[[UIDevice currentDevice] systemVersion] doubleValue]

#define IS_IPHONE4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
// 1125/2001 6p的放大屏幕尺寸
#define IS_IPHONE6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) ||CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size): NO)

#define ud [[NSUserDefaults alloc] init]
#define tokenString [ud objectForKey:@"LoginToken"]
#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
//============================================================================
//屏幕尺寸
#define kSCREEN_BOUNDS [UIScreen mainScreen].bounds
#define kSCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define kSCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)
#define kDOCK_HEIGHT 49
#define kNAVBAR_HEIGHT 0
#define PUBLICBTN_HEIGHT 44
#define kTileWidth (kSCREEN_WIDTH - 20.0f)/7.f
#define kTileHeight 48.f
//============================================================================
// 网络超时时间
#define kTIME_OUT_SEC 10
// SV动画时间
#define TOASTTIME 1.5f


//NSUSERDEFAULTS
#define MYSETNSUSERDEFAULTSDEFINE(a,b) [[NSUserDefaults standardUserDefaults]setObject:(a) forKey:(b)]
#define MYGETNSUSERDEFAULTSDEFINE(a) [[NSUserDefaults standardUserDefaults]objectForKey:(a)]
//登录状态
#define LOGINSETNSUSERDEFAULTSDEFINE(a)  MYSETNSUSERDEFAULTSDEFINE(a,@"LOGINSTATUS")
#define LOGINGETNSUSERDEFAULTSDEFINE  MYGETNSUSERDEFAULTSDEFINE(@"LOGINSTATUS")

#define  APPLICATIONDELEGATE  (AppDelegate *)[UIApplication sharedApplication].delegate

#endif
