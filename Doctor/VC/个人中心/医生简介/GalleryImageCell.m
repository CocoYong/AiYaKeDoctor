//
//  GalleryImageCell.m
//  demo
//
//  Created by XJY on 15-1-29.
//  Copyright (c) 2015年 XJY. All rights reserved.
//

#import "GalleryImageCell.h"
#import "UIImageView+WebCache.h"
#define statusBarHeight ((floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) ? 20.0f : 0.0f)
@interface GalleryImageCell() <UIScrollViewDelegate> {
    UIScrollView *imageScrollView;
    UIImageView *imageView;
}

@end

@implementation GalleryImageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0 &&
            [[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
            for (UIView *view in self.subviews){
                if ([NSStringFromClass([view class]) isEqualToString:@"UITableViewCellScrollView"]) {
                    UIScrollView *sv = (UIScrollView *) view;
                    [sv setDelaysContentTouches:NO];
                    break;
                }
            }
        }
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _maximumZoomScale = 2.0;
        _minimumZoomScale = 1.0;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    CGRect rect = [[UIScreen mainScreen] bounds];
    frame.size.width = rect.size.height - statusBarHeight - 19;
    [super setFrame:frame];
    [self.contentView setFrame:frame];
}

- (void)addImageScrollView {
    imageScrollView = [[UIScrollView alloc] init];
    [imageScrollView setBackgroundColor:[UIColor clearColor]];
    [imageScrollView setShowsHorizontalScrollIndicator:NO];
    [imageScrollView setShowsVerticalScrollIndicator:NO];
    [imageScrollView setPagingEnabled:NO];
    [imageScrollView setDelegate:self];
    [imageScrollView setBounces:YES];
    [imageScrollView setDelaysContentTouches:NO];
    [imageScrollView setHidden:NO];
    [imageScrollView setBouncesZoom:YES];
    [imageScrollView setMaximumZoomScale:_maximumZoomScale];
    [imageScrollView setMinimumZoomScale:_minimumZoomScale];
    [imageScrollView setClipsToBounds:YES];
    [self.contentView addSubview:imageScrollView];
    [imageScrollView setTransform:CGAffineTransformMakeRotation(M_PI/2)];
}

- (void)updateScrollViewFrame {
    CGFloat scrollViewWidth = self.contentView.frame.size.width;
    CGFloat scrollViewHeight = self.contentView.frame.size.height;
    CGFloat scrollViewX = 0;
    CGFloat scrollViewY = 0;
    [imageScrollView setFrame:CGRectMake(scrollViewX, scrollViewY, scrollViewWidth, scrollViewHeight)];
    [imageScrollView setContentSize:CGSizeMake(scrollViewHeight, scrollViewWidth)];
    [imageScrollView setContentOffset:CGPointMake(0, 0)];
}

- (void)setMaximumZoomScale:(CGFloat)maximumZoomScale {
    _maximumZoomScale = maximumZoomScale;
    [imageScrollView setMaximumZoomScale:_maximumZoomScale];
}

- (void)setMinimumZoomScale:(CGFloat)minimumZoomScale {
    _minimumZoomScale = minimumZoomScale;
    [imageScrollView setMinimumZoomScale:_minimumZoomScale];
}

- (void)addImageView {
    imageView = [[UIImageView alloc] init];
    [imageView setUserInteractionEnabled:YES];
    [imageScrollView addSubview:imageView];
}

- (void)updateImageViewFrame {
    CGFloat imageViewWidth = 0;
    CGFloat imageViewHeight = 0;
    CGFloat imageViewX = 0;
    CGFloat imageViewY = 0;
    
    CGFloat imageWidth = imageView.image.size.width;
    CGFloat imageHeight = imageView.image.size.height;
    if (imageWidth == 0 || imageHeight == 0) {
        imageViewWidth = 0;
        imageViewHeight = 0;
        imageViewX = 0;
        imageViewY = 0;
    } else {
        CGFloat scrollViewWidth = imageScrollView.frame.size.height;
        CGFloat scrollViewHeight = imageScrollView.frame.size.width;
        
        CGFloat widthScale = imageWidth*1.0/scrollViewWidth;
        CGFloat HeightScale = imageHeight*1.0/scrollViewHeight;
        CGFloat imageSizeScale = imageWidth * 1.0 / imageHeight;
        
        if (widthScale <= 1.0 && HeightScale <= 1.0) {
            imageViewWidth = imageWidth;
            imageViewHeight = imageHeight;
            imageViewX = (scrollViewWidth - imageViewWidth) * 1.0 / 2;
            imageViewY = (scrollViewHeight - imageViewHeight) * 1.0 / 2;
        } else {
            if (widthScale >= HeightScale) {
                imageViewWidth = scrollViewWidth;
                imageViewHeight = imageViewWidth * 1.0 / imageSizeScale;
                imageViewX = 0;
                imageViewY = (scrollViewHeight - imageViewHeight) * 1.0 / 2;
            } else {
                imageViewHeight = scrollViewHeight;
                imageViewWidth = imageViewHeight * imageSizeScale;
                imageViewX = (scrollViewWidth - imageViewWidth) * 1.0 / 2;
                imageViewY = 0;
            }
        }
    }
    [imageView setFrame:CGRectMake(imageViewX, imageViewY, imageViewWidth, imageViewHeight)];
}

- (void)initUI {
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    [self addImageScrollView];
    [self addImageView];
    [self updateScrollViewFrame];
    [self updateImageViewFrame];
}

- (void)addImageForPath:(NSString *)imagePath {
    [self initUI];
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    [imageView setImage:image];
    [self updateImageViewFrame];
}

- (void)addImageForUrl:(NSString *)imageUrl placeHolderImageName:(NSString *)placeHolderImageName {
    [self initUI];
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [loading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [loading setCenter:self.contentView.center];
    [self.contentView addSubview:loading];
    [loading startAnimating];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:placeHolderImageName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [loading stopAnimating];
        [self updateImageViewFrame];
    }];
}

- (void)setImageViewToCenter:(UIScrollView *)scrollView {
    CGFloat imageViewX = 0;
    CGFloat imageViewY = 0;
    if (imageView.frame.size.width < scrollView.frame.size.height) {
        imageViewX = (scrollView.frame.size.height - imageView.frame.size.width)*1.0/2;
    } else {
        imageViewX = 0;
    }
    if (imageView.frame.size.height < scrollView.frame.size.width) {
        imageViewY = (scrollView.frame.size.width - imageView.frame.size.height)*1.0/2;
    } else {
        imageViewY = 0;
    }

    CGRect imageViewFrame = imageView.frame;
    imageViewFrame.origin.x = imageViewX;
    imageViewFrame.origin.y = imageViewY;
    [imageView setFrame:imageViewFrame];
}

#pragma -mark UIScrollView Delegate Method

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setImageViewToCenter:scrollView];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    [self setImageViewToCenter:scrollView];
}

@end
