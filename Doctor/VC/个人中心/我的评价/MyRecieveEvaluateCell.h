//
//  MyRecieveEvaluateCell.h
//  Doctor
//
//  Created by MrZhang on 15/6/23.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRecieveEvaluateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fuwuTaiduLabel;
@property (weak, nonatomic) IBOutlet UILabel *fuwuTaiduFen;
@property (weak, nonatomic) IBOutlet UILabel *zhuanyeShuipinLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhuanyeShuiPinFen;
@property (weak, nonatomic) IBOutlet UILabel *jiuyiHuanJingLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiuyiHuanJingFen;
@property (weak, nonatomic) IBOutlet UIButton *expandButt;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *expandDetailLabel;

@property (nonatomic,strong) NSDictionary *dicData;
-(void)configeCellData:(NSDictionary *)dicData;
@end
