//
//  MyEvaluatPatientCell.m
//  Doctor
//
//  Created by MrZhang on 15/6/23.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "MyEvaluatPatientCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SDWebImageDownloader.h"
@implementation MyEvaluatPatientCell

- (void)awakeFromNib {
    self.backView.layer.cornerRadius=5.0f;
    self.photoImage.layer.cornerRadius=25;
    self.photoImage.clipsToBounds=YES;
    self.photoImage.layer.borderWidth=1.0f;
    self.photoImage.layer.borderColor=[UIColor whiteColor].CGColor;
}
-(void)configeCellData:(NSDictionary *)dicData
{
    self.nameLabel.text=[NSString stringWithFormat:@"%@",[[dicData objectForKey:@"uName"] isEqualToString:@""]?[dicData objectForKey:@"name"]:[dicData objectForKey:@"uName"]];
    self.expandLabel.text=[dicData objectForKey:@"uComment"];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[dicData objectForKey:@"uPicUrl"]] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (image) {
          self.photoImage.image=image;
        }else
        {
            self.photoImage.image=[UIImage imageNamed:@"doctorDefault"];
        }
       
    }];
    self.starImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"star%@",[dicData objectForKey:@"uGrade"]]];
    self.timeLabel.text=[dicData objectForKey:@"uCommentTime"];
}
/*
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.expandButt.selected) {
        if (CGRectGetHeight(_expandLabel.frame)<=43) {
            CGRect backRect=self.backView.frame;
            backRect.size.height=98+5;
            self.backView.frame=backRect;
            
            CGRect cellFrame=self.frame;
            cellFrame.size.height=CGRectGetMaxY(_backView.frame)+10;
            self.frame=cellFrame;
 
        }else
        {
            CGRect backRect=self.backView.frame;
            backRect.size.height=CGRectGetMaxY(_expandLabel.frame)+5;
            self.backView.frame=backRect;
            
            CGRect cellFrame=self.frame;
            cellFrame.size.height=CGRectGetMaxY(_backView.frame)+10;
            self.frame=cellFrame;
        }
    }else
    {
        CGRect backRect=self.backView.frame;
        backRect.size.height=CGRectGetMaxY(_noExpandLabel.frame)+5;
        self.backView.frame=backRect;
        
        CGRect cellFrame=self.frame;
        cellFrame.size.height=CGRectGetMaxY(_backView.frame)+10;
        self.frame=cellFrame;
    }
}
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
