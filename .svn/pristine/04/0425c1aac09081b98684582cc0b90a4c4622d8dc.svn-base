//
//  GalleryDetailView.m
//  WISP_PUBTRAFFIC_IOS
//
//  Created by XJY on 15-1-26.
//  Copyright (c) 2015年 rjsoft. All rights reserved.
//

#import "GalleryDetailView.h"
#import "GalleryImageCell.h"

#define LABELSIZE(text, font) ([text length] > 0 ? [text sizeWithFont:font] : CGSizeZero)

@interface GalleryDetailView() <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    UITableView *galleryTableView;
    UILabel *pageNumberLabel;
    
    NSArray *imagesArr;
    
    CGFloat cellHeight;
    int totalPageCount;
    NSInteger currentPageNumber;
}

@end

@implementation GalleryDetailView

@synthesize placeHolderImageName;

#pragma -mark init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
        [self addPageNumberLabel];
        [self addGalleryTableView];
        [self updateFrame];
    }
    return self;
}

- (void)initialize {
    [self setBackgroundColor:[UIColor clearColor]];
    
    placeHolderImageName = @"";
    totalPageCount = 0;
    currentPageNumber = 1;
    
    _maximumZoomScale = 2.0;
    _minimumZoomScale = 1.0;
}

- (void)addPageNumberLabel {
    pageNumberLabel = [[UILabel alloc] init];
    [pageNumberLabel setBackgroundColor:[UIColor clearColor]];
    [pageNumberLabel setTextAlignment:NSTextAlignmentCenter];
    [pageNumberLabel setTextColor:[UIColor whiteColor]];
    [pageNumberLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [pageNumberLabel setText:@"0/0"];
    [self addSubview:pageNumberLabel];
}

- (void)addGalleryTableView {
    galleryTableView = [[UITableView alloc] init];
    [galleryTableView setDelaysContentTouches:NO];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        for (id view in galleryTableView.subviews) {
            if ([NSStringFromClass([view class]) isEqualToString:@"UITableViewWrapperView"]) {
                [view setDelaysContentTouches:NO];
            }
        }
    }
    [galleryTableView setBackgroundColor:[UIColor clearColor]];
    [galleryTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [galleryTableView setPagingEnabled:YES];
    [galleryTableView setClipsToBounds:YES];
    [galleryTableView setShowsHorizontalScrollIndicator:NO];
    [galleryTableView setShowsVerticalScrollIndicator:NO];
    [galleryTableView registerClass:[GalleryImageCell class] forCellReuseIdentifier:imageCellIdentifier];
    [galleryTableView setDelegate:self];
    [galleryTableView setDataSource:self];
    [self addSubview:galleryTableView];
    [galleryTableView setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
}

#pragma -mark updateFrame

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateFrame];
}

- (void)updateFrame {
    [self updatePageNumberLabelFrame];
    [self updateGalleryTableViewFrame];
}

- (void)updatePageNumberLabelFrame {
    CGSize pageNumberLabelSize = LABELSIZE(pageNumberLabel.text, pageNumberLabel.font);
    CGFloat pageNumberLabelWidth = pageNumberLabelSize.width;
    CGFloat pageNumberLabelHeight = pageNumberLabelSize.height;
    CGFloat pageNumberLabelX = (self.frame.size.width - pageNumberLabelWidth) * 1.0 / 2;
    CGFloat pageNumberLabelY = self.frame.size.height - pageNumberLabelHeight;
    [pageNumberLabel setFrame:CGRectMake(pageNumberLabelX, pageNumberLabelY, pageNumberLabelWidth, pageNumberLabelHeight)];
}

- (void)updateGalleryTableViewFrame {
    CGRect galleryTableViewFrame = galleryTableView.frame;
    galleryTableViewFrame.origin.x = 0;
    galleryTableViewFrame.origin.y = 0;
    galleryTableViewFrame.size.width = self.frame.size.width;
    galleryTableViewFrame.size.height = self.frame.size.height - pageNumberLabel.frame.size.height;
    cellHeight = galleryTableViewFrame.size.width;
    [galleryTableView setFrame:galleryTableViewFrame];
}

#pragma -mark set Content Method

- (void)addImages:(NSArray *)images {
    imagesArr = images;
    totalPageCount = (int)imagesArr.count;
    [galleryTableView reloadData];
}

- (void)addImages:(NSArray *)images placeHolderImageName:(NSString *)imageName {
    placeHolderImageName = imageName;
    [self addImages:images];
}

- (void)setPageNumber:(NSInteger)pageNumber {
    if (pageNumber > imagesArr.count) {
        pageNumber = (int)imagesArr.count;
    } else if (pageNumber < 1) {
        pageNumber = 1;
    }
    NSString *text = [[NSString stringWithFormat:@"%d", (int)pageNumber] stringByAppendingString:@"/"];
    text = [text stringByAppendingString:[NSString stringWithFormat:@"%d", totalPageCount]];
    [pageNumberLabel setText:text];
}

- (void)setBeginIndex:(NSInteger)beginIndex {
    currentPageNumber = beginIndex + 1;
    [self setPageNumber:currentPageNumber];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:beginIndex inSection:0];
    [galleryTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (BOOL)isEmptyArray:(NSArray *)array {
    if (array != nil && array.count > 0) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark TableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sectionsCount = 0;
    if ([self isEmptyArray:imagesArr] == NO) {
        sectionsCount = 1;
    }
    return sectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCountForSection;
    if ([self isEmptyArray:imagesArr] == NO) {
        rowCountForSection = imagesArr.count;
    } else {
        rowCountForSection = 0;
    }
    return rowCountForSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GalleryImageCell *cell = nil;
    if ([self isEmptyArray:imagesArr] == NO) {
        cell = [tableView dequeueReusableCellWithIdentifier:imageCellIdentifier forIndexPath:indexPath];
        [cell setMaximumZoomScale:_maximumZoomScale];
        [cell setMinimumZoomScale:_minimumZoomScale];
        
        NSString *imagePath = [imagesArr objectAtIndex:indexPath.row];
        if ([imagePath rangeOfString:@"http://"].location == NSNotFound) {
            [cell addImageForPath:imagePath];
        } else {
            [cell addImageForUrl:imagePath placeHolderImageName:placeHolderImageName];
        }
    }
    return cell;
}

#pragma mark TableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = 0;
    if ([self isEmptyArray:imagesArr] == NO) {
        rowHeight = cellHeight;
    }
    return rowHeight;
}

#pragma mark UIScrollView Delegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat galleryScrollViewWidth = galleryTableView.frame.size.width;
    int offsetX = scrollView.contentOffset.y;
    currentPageNumber = offsetX/galleryScrollViewWidth + 1;
    self.currentNum=currentPageNumber-1;
    [self setPageNumber:currentPageNumber];
}
@end
