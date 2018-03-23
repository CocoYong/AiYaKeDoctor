//
//  MyRecieveEvaluatNoExpandCell.m
//  Doctor
//
//  Created by MrZhang on 15/7/15.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "MyRecieveEvaluatNoExpandCell.h"
#import "SDWebImageDownloader.h"
@implementation MyRecieveEvaluatNoExpandCell

- (void)awakeFromNib {
    self.backView.layer.cornerRadius=5.0f;
    self.photoImage.layer.cornerRadius=25;
    self.photoImage.clipsToBounds=YES;
    self.photoImage.layer.borderWidth=1.0f;
    self.photoImage.layer.borderColor=[UIColor whiteColor].CGColor;
}
-(void)configeCellData:(NSDictionary *)dicData
{
    self.noExpandDetailLabel.text=[dicData objectForKey:@"dComment"];
    self.nameLabel.text=[NSString stringWithFormat:@"%@",[dicData objectForKey:@"uName"]];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[dicData objectForKey:@"dPicUrl"]] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        self.photoImage.image=image;
    }];
    self.starImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"star%@",[dicData objectForKey:@"dGrade"]]];
    self.timeLabel.text=[dicData objectForKey:@"dCommentTime"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
