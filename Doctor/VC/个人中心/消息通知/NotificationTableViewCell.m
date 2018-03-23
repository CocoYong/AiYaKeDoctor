//
//  NotificationTableViewCell.m
//  YSProject
//
//  Created by cuiw on 15/6/1.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "NotificationTableViewCell.h"

@implementation NotificationTableViewCell

- (void)awakeFromNib {
    self.backView.layer.cornerRadius=5.0f;
    self.backgroundColor=[UIColor hexColor:@"#eeeeee"];
    self.backView.backgroundColor=[UIColor whiteColor];
}
-(void)passCellData:(NSDictionary*)dic
{
    self.nameLabel.text=[dic objectForKey:@"fromName"];
    self.timeLabel.text=[dic objectForKey:@"createTime"];
    self.contentLabel.text=[dic objectForKey:@"requestContent"];
    if ([[dic objectForKey:@"status"] integerValue]==1) {
        self.agreeButt.hidden=YES;
        self.refuseButt.hidden=YES;
        self.stateLabel.text=@"已同意";
        self.stateLabel.textColor=[UIColor greenColor];
    }else if ([[dic objectForKey:@"status"] integerValue]==-1)
    {
        self.agreeButt.hidden=YES;
        self.refuseButt.hidden=YES;
        self.stateLabel.text=@"已拒绝";
        self.stateLabel.textColor=[UIColor grayColor];
    }else
    {
        self.stateLabel.hidden=YES;
        self.agreeButt.hidden=NO;
        self.agreeButt.hidden=NO;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
