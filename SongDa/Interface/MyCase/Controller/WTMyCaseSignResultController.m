//
//  WTMyCaseSignResultController.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/10.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTMyCaseSignResultController.h"
#import "WTCaseSignSituationViewModel.h"
#import "WTMyCaseSignModel.h"

#define kDeliverResult      @[@"送达成功",@"送达不成功"]

@interface WTMyCaseSignResultController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) WTTotalModel *totalModel;
@end

@implementation WTMyCaseSignResultController

static NSString * const ID = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.isDeliverResult ? @"送达结果" : @"上门情况";
    
    [self setupTableView];
    if (!self.isDeliverResult) {
        [self loadDeliverSituation];
    }
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, HYXScreenW, HYXScreenH-IPhoneX_Nav_Height)];
    tableView.backgroundColor = WTGlobalBG;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    tableView.tableFooterView = [UIView new];
    
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    adjustsScrollViewInsets(tableView);
}
- (void)loadDeliverSituation {
    WTWeakSelf;
    [[[WTCaseSignSituationViewModel alloc] init] dataByParameters:nil success:^(WTTotalModel *totalModel) {
        weakSelf.totalModel = totalModel;
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error, NSString *message) {
        HYXLog(@"error %@",error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isDeliverResult) {
        return kDeliverResult.count;
    } else {
        return self.totalModel.data.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (self.isDeliverResult) {
        cell.textLabel.text = kDeliverResult[indexPath.row];
    } else {
        WTMyCaseSignModel *signModel = self.totalModel.data[indexPath.row];
        cell.textLabel.text = signModel.result;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    WTWeakSelf;
    if (weakSelf.deliverResult) {
        if (!weakSelf.isDeliverResult) {
            WTMyCaseSignModel *signModel = weakSelf.totalModel.data[indexPath.row];
            weakSelf.deliverResult(signModel.result,[signModel.resultId intValue]);
        } else {
            if (indexPath.row == 0) {//送达成功
                weakSelf.deliverResult(kDeliverResult[0], 1);
            } else if (indexPath.row == 1) {//送达失败
                weakSelf.deliverResult(kDeliverResult[1], 0);
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
