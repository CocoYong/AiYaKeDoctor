//
//  OneSpecialCell.h
//  Doctor
//
//  Created by MrZhang on 15/6/23.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluateViewController.h"
#import "UserModel.h"
@interface OneSpecialCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *totalEvaluateImage;
@property (weak, nonatomic) IBOutlet UIImageView *serviceEvaluatImage;
@property (weak, nonatomic) IBOutlet UIImageView *skillEvaluatImage;
@property (weak, nonatomic) IBOutlet UIImageView *environmentImage;
@property (weak, nonatomic) IBOutlet UILabel *totalScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *environmentLabel;
@property (nonatomic,strong) EvaluateViewController *controller;
-(void)configeCellDataWith:(NSMutableDictionary*)userInfoDic;
@end
