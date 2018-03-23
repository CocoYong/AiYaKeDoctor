//
//  ZhangPatientListCell.h
//  Doctor
//
//  Created by MrZhang on 15/7/22.
//  Copyright (c) 2015年 Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhangPatientListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
