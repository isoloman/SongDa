//
//  WTMyCaseArrivedController.m
//  SongDa
//
//  Created by Fancy on 2018/4/13.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTMyCaseArrivedController.h"
#import "WTCaseArrivedCell.h"
#import "WTCaseArrivedModel.h"
#import "WTCaseArrivedViewModel.h"
#import "WTCaseDetailController.h"
#import "WTLoginController.h"
#import "WTNavigationController.h"

#define kTitleViewH         44
#define kItemHeight         44
#define kDeliverTimeArray    @[@"送达日期最新",@"送达日期最旧"]

@interface WTMyCaseArrivedController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) WTTotalModel *totalModel;
@property (strong, nonatomic) WTPlaceholderView *placeholderView;
@property (strong, nonatomic) UIButton *currentBtn;
@property (strong, nonatomic) UIView *titleView;
/** 排序view */
@property (strong, nonatomic) UIView *sortView;
/** 当前排序按钮 */
@property (strong, nonatomic) UIButton *sortBtn;
@end

@implementation WTMyCaseArrivedController

static NSString * const ID = @"caseArrivedCell";

- (WTPlaceholderView *)placeholderView
{
    if (_placeholderView == nil) {
        _placeholderView = [[WTPlaceholderView alloc] initWithFrame:CGRectMake(0, -10, self.tableView.width, self.tableView.height+10)];
        _placeholderView.backgroundColor = [UIColor whiteColor];
    }
    return _placeholderView;
}

- (UIView *)sortView
{
    if (_sortView == nil) {
        _sortView = [[UIView alloc] initWithFrame:HYXScreenBounds];
        _sortView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [_sortView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSortView)]];
        [_sortView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(removeSortView)]];
        
        UIImageView *shadowImgView = [[UIImageView alloc] initWithImage:HYXImage(@"caseArrive_shadow")];
        [shadowImgView sizeToFit];
        shadowImgView.x = 10;
        shadowImgView.y = IPhoneX_Nav_Height+kTitleViewH-5;
        shadowImgView.userInteractionEnabled = YES;
        [_sortView addSubview:shadowImgView];
        
        UIImageView *containView = [[UIImageView alloc] initWithImage:HYXImage(@"caseArrive_back")];
        [containView sizeToFit];
        containView.x = shadowImgView.x+8;
        containView.y = shadowImgView.y+8;
        containView.userInteractionEnabled = YES;
        [_sortView addSubview:containView];
        
        for (NSInteger i = 0; i < kDeliverTimeArray.count; i++) {
            UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [itemBtn setTitle:kDeliverTimeArray[i] forState:UIControlStateNormal];
            [itemBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
            itemBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [itemBtn sizeToFit];
            itemBtn.height = kItemHeight;
            itemBtn.centerX = containView.width*0.5;
            itemBtn.y = 10+i*(itemBtn.height+3);
            itemBtn.tag = i;
            [itemBtn addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
            [containView addSubview:itemBtn];
        }
    }
    return _sortView;
}
- (UIButton *)sortBtn
{
    if (_sortBtn == nil) {
        _sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sortBtn.tag = 0;
    }
    return _sortBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"已完成";
    
    [self setupTitleView];
    [self setupTableView];
    [self loadData];
}

- (void)setupTitleView {
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor whiteColor];
    titleView.size = CGSizeMake(HYXScreenW, kTitleViewH);
    [self.view addSubview:titleView];
    self.titleView = titleView;
    
    NSArray *titles = @[@"排序",@"送达不成功",@"送达成功"];
    CGFloat width = HYXScreenW/titles.count;
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:WTBrownColor forState:UIControlStateDisabled];
        [button setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.width = width;
        button.height = titleView.height;
        button.x = i*width;
        button.tag = i-1;
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:button];
        if (i != -1) {
            UIView *separateLine = [[UIView alloc] init];
            separateLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
            separateLine.size = CGSizeMake(0.5, kTitleViewH*0.5);
            separateLine.x = button.x-0.5;
            separateLine.centerY = titleView.height*0.5;
            [titleView addSubview:separateLine];
            
            if (i == titles.count-1) {
                button.enabled = NO;
                self.currentBtn = button;
            }
        }
    }
    
    UIView *separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    separateLine.size = CGSizeMake(HYXScreenW, 0.5);
    separateLine.y = titleView.height-separateLine.height;
    [titleView addSubview:separateLine];
}
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTitleViewH, HYXScreenW, HYXScreenH-IPhoneX_Nav_Height-kTitleViewH)];
    tableView.backgroundColor = WTGlobalBG;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self.view bringSubviewToFront:self.titleView];
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    
    adjustsScrollViewInsets(tableView);
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    tableView.mj_header.ignoredScrollViewContentInsetTop = 10;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WTCaseArrivedCell class]) bundle:nil] forCellReuseIdentifier:ID];
}

- (void)loadData {
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"userId"] = [WTAccountManager sharedManager].userId;
    paras[@"isArrived"] = @(self.currentBtn.tag);
    paras[@"order"] = @"VISIT_TIME";
    paras[@"desc"] = self.sortBtn.tag == 0 ? @"desc" : @"asc";

    WTWeakSelf;
    __weak typeof(_placeholderView) weakPlaceholderView = _placeholderView;
    [[[WTCaseArrivedViewModel alloc] init] dataByParameters:paras success:^(WTTotalModel *totalModel) {
        
        if (totalModel.code == 2) {
            [SVProgressHUD showErrorWithStatus:totalModel.message];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self logout];
            });
            
            return ;
        }
        
        weakSelf.totalModel = totalModel;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        if (totalModel.data.count) {
            if (weakPlaceholderView) {
                [weakSelf.placeholderView removeFromSuperview];
            }
        } else {
            weakSelf.placeholderView.hintText = kRequestErrorTypeNoData;
            [weakSelf.tableView addSubview:weakSelf.placeholderView];
        }
    } failure:^(NSError *error, NSString *message) {
        if ([weakSelf.tableView.mj_header isRefreshing]) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        if (error.code == kRequestErrorCodeNoNet) {
            weakSelf.placeholderView.hintText = kRequestErrorTypeNoNet;
        } else {
            weakSelf.placeholderView.hintText = kRequestErrorTypeError;
        }
        [weakSelf.tableView addSubview:weakSelf.placeholderView];
        HYXLog(@"error  %@",error);
    }];
}

- (void)logout{
    [[WTAccountManager sharedManager] loginWithDictionary:[NSDictionary dictionary]];
    WTLoginController *loginVc = [[WTLoginController alloc] init];
    WTNavigationController *navVc = [[WTNavigationController alloc] initWithRootViewController:loginVc];
    [UIApplication sharedApplication].keyWindow.rootViewController = navVc;
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
}

- (void)titleClick:(UIButton *)button {
    if (button.tag == -1) { //弹出时间排序
        [HYXRootViewController.view addSubview:self.sortView];
        [UIView animateWithDuration:0.25 animations:^{
            self.sortView.alpha = 1.0;
        }];
    } else {
        self.currentBtn.enabled = YES;
        button.enabled = NO;
        self.currentBtn = button;
        
        [self loadData];
        CGPoint offset = self.tableView.contentOffset;
        offset.y = -self.tableView.contentInset.top;
        [self.tableView setContentOffset:offset animated:YES];
    }
}

- (void)sortClick:(UIButton *)button {
    self.sortBtn = button;
    [self removeSortView];
    [self loadData];
    CGPoint offset = self.tableView.contentOffset;
    offset.y = -self.tableView.contentInset.top;
    [self.tableView setContentOffset:offset animated:YES];
}
- (void)removeSortView {
    [UIView animateWithDuration:0.25 animations:^{
        self.sortView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.sortView removeFromSuperview];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.totalModel.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTCaseArrivedCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.arrivedModel = self.totalModel.data[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    WTCaseArrivedModel *arriveModel = self.totalModel.data[indexPath.row];
    WTCaseDetailController *detailVc = [[UIStoryboard storyboardWithName:@"WTCaseDetailController" bundle:nil] instantiateViewControllerWithIdentifier:@"caseDetailId"];
    detailVc.caseId = arriveModel.caseId;
    detailVc.isFromArrived = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 255;
}

@end
