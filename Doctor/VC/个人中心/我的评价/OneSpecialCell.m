//
//  OneSpecialCell.m
//  Doctor
//
//  Created by MrZhang on 15/6/23.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "OneSpecialCell.h"
@implementation OneSpecialCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
-(void)configeCellDataWith:(NSMutableDictionary*)userInfoDic
{
    self.totalScoreLabel.text=[NSString stringWithFormat:@"%@分",[userInfoDic objectForKey:@"totalGrade"]];
     self.serviceScoreLabel.text=[NSString stringWithFormat:@"%@分",[userInfoDic objectForKey:@"totalGrade1"]];
     self.skillScoreLabel.text=[NSString stringWithFormat:@"%@分",[userInfoDic objectForKey:@"totalGrade2"]];
     self.environmentLabel.text=[NSString stringWithFormat:@"%@分",[userInfoDic objectForKey:@"totalGrade3"]];
    
     self.totalEvaluateImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"star%@",[userInfoDic objectForKey:@"totalGrade"]]];
     self.serviceEvaluatImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"star%@",[userInfoDic objectForKey:@"totalGrade1"] ]];
     self.skillEvaluatImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"star%@",[userInfoDic objectForKey:@"totalGrade2"] ]];
     self.environmentImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"star%@",[userInfoDic objectForKey:@"totalGrade3"] ]];
}
- (IBAction)detailStatusAction:(UIButton *)sender {
    self.controller.expand=NO;
    [self.controller.contentTableView reloadData];
}
@end
