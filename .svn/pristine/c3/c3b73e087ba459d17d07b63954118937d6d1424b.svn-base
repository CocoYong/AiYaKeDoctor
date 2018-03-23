//
//  SettingTimeViewController.m
//  YSProject
//
//  Created by cuiw on 15/6/4.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "SettingTimeViewController.h"

@interface SettingTimeViewController ()
{
    NSArray *_timeArray;
}
@property (weak, nonatomic) IBOutlet UITableView *timeTableView;

@end

@implementation SettingTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:@"设置预约时间"];
    [self addBackButt];
    _timeArray = @[@"08:00 - 08:30", @"08:30 - 09:00", @"09:00 - 09:30", @"09:30 - 10:00", @"10:00 - 10:30", @"10:30 - 11:00", @"11:00 - 11:30", @"11:30 - 12:00", @"12:00 - 12:30", @"12:30 - 13:00", @"13:00 - 13:30", @"13:30 - 14:00", @"14:00 - 14:30", @"14:30 - 15:00", @"15:00 - 10:30", @"15:30 - 16:00", @"16:00 - 16:30", @"16:30 - 17:00", @"17:00 - 17:30", @"17:30 - 18:00", @"18:00 - 18:30", @"18:30 - 19:00"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_timeArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor redColor]];
        [button setFrame:CGRectMake(0, 0, 30, 30)];
        cell.accessoryView = button;
    }
    
    cell.textLabel.text = _timeArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
