//
//  Dock.m
//  
//
//  Created by cuiwei on 14-7-9.
//  Copyright (c) 2014年 Creditease. All rights reserved.
//

#import "Dock.h"
//#import "LoginVC.h"

@interface Dock()
{
    // 当前选中了哪个item
    DockItem *_currentItem;
}
@end
static Dock *dock;
@implementation Dock

+ (Dock *)sharedDock
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dock = [[Dock alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - kDOCK_HEIGHT, kSCREEN_WIDTH, kDOCK_HEIGHT)];
        dock.backgroundColor = RGBCOLOR(115, 189, 225);
        dock.clipsToBounds = NO;
        [dock createDockItem];
    });
    return dock;
}

#pragma mark 创建DockItem
- (void)createDockItem
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5)];
    line.backgroundColor = RGBCOLOR(183, 193, 198);
    [self addSubview:line];
    NSArray *imageArray = @[@"tab0_narmal",@"tab1_narmal",@"tab2_narmal",@"tab3_narmal"];
    for (int i = 0; i < imageArray.count; i++) {
        DockItem *item = [DockItem buttonWithType:UIButtonTypeCustom];
        item.tag = i;
        if (i == 0) {
            item.selected = YES;
            _currentItem = item;
        }
        item.frame = CGRectMake(i * (kSCREEN_WIDTH/4.0f), CGRectGetHeight(line.frame), (kSCREEN_WIDTH/4.0f), kDOCK_HEIGHT - CGRectGetHeight(line.frame));
        [item setImageSelected:imageArray[i]];
        [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
    }
}

#pragma mark 点击了某个item
- (void)itemClick:(DockItem *)item
{
//    if (item.tag == 1) {
//        if ([UserManager isLogin]) {
//            [self setSelectedItem:item];
//        }else{
//            LoginVC *loginVC = [[LoginVC alloc] init];
//            loginVC.completionBlock = ^{
//                [self setSelectedItem:item];
//            };
//            UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//            [self.superVC presentViewController:loginNav animated:YES completion:nil];
//        }
//    }else{
//        [self setSelectedItem:item];
//    }
    [self setSelectedItem:item];
}
- (void)setSelectedItem:(DockItem *)item
{
    // 1.让当前的item取消选中
    _currentItem.selected = NO;
    
    // 2.让新的item选中
    item.selected = YES;
    
    // 3.让新的item变为当前选中
    _currentItem = item;
    
    // 4.调用block
    if (_itemClickBlock) {
        _itemClickBlock((int)item.tag);
    }
}
#pragma mark 重写设置选中索引的方法
- (void)setSelectedIndex:(int)selectedIndex
{
    // 1.条件过滤
    if (selectedIndex < 0 || selectedIndex >= self.subviews.count) return;
    
    // 2.赋值给成员变量
    _selectedIndex = selectedIndex;
    
    // 3.对应的item
    DockItem *item = (DockItem *)dock.subviews[selectedIndex+1];//0，为line，故加1
    
    // 4.相当于点击了这个item
   [self itemClick:item];
}
@end
