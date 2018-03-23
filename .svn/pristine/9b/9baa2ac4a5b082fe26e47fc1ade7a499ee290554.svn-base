//
//  PatientViewController.m
//  YSProject
//
//  Created by cuiw on 15/5/30.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "PatientViewController.h"
#import "TabBarViewController.h"
@interface PatientViewController ()
{
    NSMutableArray *_contentArray;
}
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@end

@implementation PatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 5)];
    _contentTableView.tableFooterView = footerView;
    _contentArray = [[NSMutableArray alloc] init];
    for (int i = 0; i< 20; i++) {
        [_contentArray addObject:@"adfsadf"];
    }
    [self creatNavgationBarWithTitle:[NSString stringWithFormat:@"我的患者(%lu)", (unsigned long)[_contentArray count]]];
    [self addBackButt];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(TabBarViewController*)self.tabBarController  tabbarImageView].hidden=YES;
}
#pragma mark - TableView Delegate and DataSource
- (void)viewDidLayoutSubviews {
    if ([_contentTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_contentTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_contentTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_contentTableView setLayoutMargins:UIEdgeInsetsZero];
    }
//    if ([_searchDisplayController.searchResultsTableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [_searchDisplayController.searchResultsTableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([_searchDisplayController.searchResultsTableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [_searchDisplayController.searchResultsTableView setLayoutMargins:UIEdgeInsetsZero];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.navigationItem.title = [NSString stringWithFormat:@"我的患者(%d)", [_contentArray count]];
    return [_contentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        //        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.imageView.image = [UIImage imageNamed:@"0_201"];
    cell.textLabel.text = @"张三";
    cell.detailTextLabel.text = @"男 / 29岁";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_contentArray removeObjectAtIndex:[indexPath row]];  //删除数组里的数据
        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
    }
}
@end
