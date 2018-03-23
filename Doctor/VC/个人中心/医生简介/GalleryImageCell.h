//
//  GalleryImageCell.h
//  demo
//
//  Created by XJY on 15-1-29.
//  Copyright (c) 2015年 XJY. All rights reserved.
//

#import <UIKit/UIKit.h>

#define imageCellIdentifier @"imageCell"

@interface GalleryImageCell : UITableViewCell 

@property (nonatomic, assign) CGFloat maximumZoomScale;//default is 2.0
@property (nonatomic, assign) CGFloat minimumZoomScale;//default is 1.0

- (void)addImageForPath:(NSString *)imagePath;

- (void)addImageForUrl:(NSString *)imageUrl placeHolderImageName:(NSString *)placeHolderImageName;
    
@end
