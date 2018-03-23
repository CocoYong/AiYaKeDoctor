//
//  NotificationTableViewCell.h
//  YSProject
//
//  Created by cuiw on 15/6/1.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *agreeButt;
@property (weak, nonatomic) IBOutlet UIButton *refuseButt;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
//-(void)passCellData:(NSDictionary*)dic;
@end
