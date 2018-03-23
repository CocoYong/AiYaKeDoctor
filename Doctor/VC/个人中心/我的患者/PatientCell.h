//
//  PatientCell.h
//  Doctor
//
//  Created by MrZhang on 15/6/23.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UIButton *nameButt;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@end
