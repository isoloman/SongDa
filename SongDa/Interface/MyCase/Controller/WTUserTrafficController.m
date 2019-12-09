//
//  WTUserTrafficController.m
//  SongDa
//
//  Created by Fancy on 2018/4/17.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTUserTrafficController.h"

#define kTraffics   @[@"驾车",@"公交",@"骑行",@"步行"]

@interface WTUserTrafficController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation WTUserTrafficController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"交通工具选择";
    
    [self setupTableView];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.backgroundColor = WTGlobalBG;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    adjustsScrollViewInsets(tableView);
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.tableFooterView = [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kTraffics.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = kTraffics[indexPath.row];
    if (indexPath.row == [WTAccountManager sharedManager].traffic) {
        cell.textLabel.textColor = WTBlueColor;
    } else {
        cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case 0:
            [[WTAccountManager sharedManager] resetTraffic:WTTrafficTypeCar];
            break;
        case 1:
            [[WTAccountManager sharedManager] resetTraffic:WTTrafficTypeBus];
            break;
        case 2:
            [[WTAccountManager sharedManager] resetTraffic:WTTrafficTypeBike];
            break;
        case 3:
            [[WTAccountManager sharedManager] resetTraffic:WTTrafficTypeWalk];
            break;
        default:
            break;
    }
    
    [tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end
