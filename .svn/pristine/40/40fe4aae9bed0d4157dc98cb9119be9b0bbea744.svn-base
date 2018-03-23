//
//  EvaluatePatientViewController.h
//  YSProject
//
//  Created by MrZhang on 15/6/19.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol evaluatPatientDelegate<NSObject>
-(void)passEvaluatPatientDataToFrontController:(NSDictionary*)dic;
@end
@interface EvaluatePatientViewController : UIViewController
@property(nonatomic,assign)id<evaluatPatientDelegate>delegate;
@property(nonatomic,strong)NSDictionary *orderDic;
@end
