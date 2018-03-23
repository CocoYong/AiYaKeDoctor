//
//  GalleryDetailView.h
//  WISP_PUBTRAFFIC_IOS
//
//  Created by XJY on 15-1-26.
//  Copyright (c) 2015年 rjsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryDetailView : UIView 

@property (nonatomic, copy) NSString *placeHolderImageName;

@property (nonatomic, assign) CGFloat maximumZoomScale;//default is 2.0
@property (nonatomic, assign) CGFloat minimumZoomScale;//default is 1.0
@property (nonatomic,readwrite) NSInteger currentNum;
- (void)addImages:(NSArray *)images;

- (void)addImages:(NSArray *)images placeHolderImageName:(NSString *)imageName;

- (void)setBeginIndex:(NSInteger)beginIndex;//从0开始

@end
