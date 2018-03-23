//
//  RefuseViewController.h
//  YSProject
//
//  Created by MrZhang on 15/6/15.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol refuseDelegate<NSObject>
-(void)passRefuseDataToFrontController:(NSDictionary*)dic;
@end
@interface RefuseViewController : UIViewController
@property(nonatomic,assign)id<refuseDelegate>delegate;
@property(nonatomic,strong)NSDictionary *orderDic;
@end
