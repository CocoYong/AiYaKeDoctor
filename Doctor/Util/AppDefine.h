//
//  AppDefine.h
//  YSProject
//
//  Created by cuiw on 15/6/4.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#define DEBUG_MODE
#ifdef DEBUG_MODE
// 测试环境
//#define HOST_URL @"http://ayk.coolni.cn/api.php/"
//正式环境
#define HOST_URL @"http://123.57.254.75/api.php/"
// UMeng测试Appkey
#define UMENG_APPKEY @""
// AES测试key
#define DES_KEY @""

#else

// 正式环境
#define HOST_URL @""
// UMeng正式Appkey
#define UMENG_APPKEY @""

// AES正式key
#define DES_KEY @""

#endif


