//
//  NotificationViewController.m
//  YSProject
//
//  Created by cuiw on 15/5/31.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationTableViewCell.h"
#import "AnnouncementTableViewCell.h"
#import "NotificationDetailViewController.h"
#import "AnnouncementDetailViewController.h"
#import "TabBarViewController.h"
@interface NotificationViewController ()
{
    BOOL _flag;
    UIButton *_leftButton;
    UIButton *_rightButton;
}
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"消息通知"];
     [self addBackButt];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50)];
    headerView.backgroundColor = [UIColor lightGrayColor];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton setTitle:@"私人医生请求" forState:UIControlStateNormal];
    _leftButton.frame = CGRectMake(0, 10, kSCREEN_WIDTH/2, 30);
    [_leftButton addTarget:self action:@selector(segmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH/2 - 1, 15, 1, 20)];
    lineView.backgroundColor = [UIColor grayColor];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setTitle:@"公告" forState:UIControlStateNormal];
    _rightButton.frame = CGRectMake(kSCREEN_WIDTH/2, 10, kSCREEN_WIDTH/2 - 1, 30);
    [_rightButton addTarget:self action:@selector(segmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    [headerView addSubview:_leftButton];
    [headerView addSubview:lineView];
    [headerView addSubview:_rightButton];
    _contentTableView.tableHeaderView = headerView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(TabBarViewController*)self.tabBarController  tabbarImageView].hidden=YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentButtonAction:(UIButton *)button {
    if (_leftButton == button &&  _flag) {
        _flag = !_flag;
        [_contentTableView reloadData];
    } else if (_rightButton == button && !_flag) {
        _flag = !_flag;
        [_contentTableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_flag) {
        static NSString *CellIdentifier = @"NotificationTableViewCell";
        NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"NotificationTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        return cell;
    } else {
        static NSString *CellIdentifier = @"AnnouncementTableViewCell";
        AnnouncementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"AnnouncementTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_flag) {
        return 115;
    } else {
        return 90;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!_flag) {
        NotificationDetailViewController *notificationDetailVC = [[NotificationDetailViewController alloc] init];
        [self.navigationController pushViewController:notificationDetailVC animated:YES];
    } else {
        AnnouncementDetailViewController *announcementDetailVC = [[AnnouncementDetailViewController alloc] init];
        [self.navigationController pushViewController:announcementDetailVC animated:YES];
    }
}
@end
