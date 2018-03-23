//
//  SettingDateViewController.m
//  YSProject
//
//  Created by cuiw on 15/6/4.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "SettingDateViewController.h"
#import "EventKitDataSource.h"
#import "Kal.h"
#import "NSDate+Convenience.h"
#import "SettingTimeViewController.h"

@interface SettingDateViewController () <UITableViewDelegate, KalViewControllerDelegate>
{
    KalViewController *kal;
    //    id dataSource;
}

@end

@implementation SettingDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"设置预约时间"];
    [self addBackButt];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    kal = [[KalViewController alloc] initWithSelectionMode:KalSelectionModeSingle];
    kal.selectedDate = [NSDate dateStartOfDay:[[NSDate date] offsetDay:1]];
    kal.selectedDelegate = self;
    //    kal.delegate = self;
    //    dataSource = [[EventKitDataSource alloc] init];
    //    kal.dataSource = dataSource;
    kal.minAvailableDate = [NSDate dateStartOfDay:[[NSDate date] offsetDay:0]];
    kal.maxAVailableDate = [kal.minAvailableDate offsetDay:MAXFLOAT];
    //    [self.view addSubview:kal.view];
    self.view.backgroundColor = [UIColor brownColor];
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kSCREEN_WIDTH - 20, 308)];
    [contentView addSubview:kal.view];
    [self.view addSubview:contentView];
    
}

- (void)selectedData:(NSDate *)date {
    NSLog(@"selectedData----%@", date);
    SettingTimeViewController *settingTimeVC = [[SettingTimeViewController alloc] init];
    [self.navigationController pushViewController:settingTimeVC animated:YES];
}

@end
