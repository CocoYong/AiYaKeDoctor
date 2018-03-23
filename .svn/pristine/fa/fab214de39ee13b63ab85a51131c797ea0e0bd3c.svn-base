//
//  MyRecieveEvaluateCell.m
//  Doctor
//
//  Created by MrZhang on 15/6/23.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "MyRecieveEvaluateCell.h"
#import <QuartzCore/QuartzCore.h> 
#import "SDWebImageDownloader.h"
@implementation MyRecieveEvaluateCell

- (void)awakeFromNib {
    self.backView.layer.cornerRadius=5.0f;
    self.photoImage.layer.cornerRadius=25;
    self.photoImage.clipsToBounds=YES;
    self.photoImage.layer.borderWidth=1.0f;
    self.photoImage.layer.borderColor=[UIColor whiteColor].CGColor;
    
}
-(void)configeCellData:(NSDictionary *)dicData
{

        self.fuwuTaiduFen.text=[NSString stringWithFormat:@"%@分",[dicData objectForKey:@"dGrade1"]];
        self.zhuanyeShuiPinFen.text=[NSString stringWithFormat:@"%@分",[dicData objectForKey:@"dGrade2"]];
        self.jiuyiHuanJingFen.text=[NSString stringWithFormat:@"%@分",[dicData objectForKey:@"dGrade3"]];
        self.expandDetailLabel.text=[dicData objectForKey:@"dComment"];
       self.nameLabel.text=[NSString stringWithFormat:@"%@",[dicData objectForKey:@"uName"]];
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[dicData objectForKey:@"dPicUrl"]] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            self.photoImage.image=image;
        }];
        self.starImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"star%@",[dicData objectForKey:@"dGrade"]]];
        self.timeLabel.text=[dicData objectForKey:@"dCommentTime"];
}


/*
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.expandButt.selected) {
        CGRect backRect=self.backView.frame;
        backRect.size.height=CGRectGetMaxY(_expandDetailLabel.frame)+5;
        self.backView.frame=backRect;
        
        CGRect cellFrame=self.frame;
        cellFrame.size.height=CGRectGetMaxY(_backView.frame)+10;
        self.frame=cellFrame;

    }else
    {
        CGRect backRect=self.backView.frame;
        backRect.size.height=CGRectGetMaxY(_noExpandDetailLabel.frame)+5;
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
