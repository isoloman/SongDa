//
//  WTMyCaseListView.m
//  SongDa
//
//  Created by Fancy on 2018/3/27.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTMyCaseListView.h"
#import "WTMyCaseCell.h"
#import "WTMyCaseModel.h"
#import "WTMyCaseViewModel.h"
#import "WTCaseDetailController.h"

#define kTitleViewH     44

@interface WTMyCaseListView () <UITableViewDelegate,UITableViewDataSource,WTMyCaseCellDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *currentBtn;
@property (strong, nonatomic) WTPlaceholderView *placeholderView;
/** 搜索输入框 */
@property (strong, nonatomic) UITextField *searchTextField;
/** 是否处于搜索状态 */
@property (assign, nonatomic) BOOL isSearchStatus;
/** 搜索状态下的数据源 */
@property (strong, nonatomic) NSMutableArray *searchDataArrM;
/** 定时器 */
@property (strong, nonatomic) YYTimer *timer;
/** 距离界面：下拉请求得到的新数据 */
@property (strong, nonatomic) WTTotalModel *distanceTotalModel;
@end

@implementation WTMyCaseListView

static NSString * const ID = @"myCaseCell";

- (WTPlaceholderView *)placeholderView
{
    if (_placeholderView == nil) {
        _placeholderView = [[WTPlaceholderView alloc] initWithFrame:CGRectMake(0, -10, self.tableView.width, self.tableView.height+10)];
        _placeholderView.backgroundColor = [UIColor whiteColor];
    }
    return _placeholderView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupTitleView];
        [self setupTableView];
        _isSearchStatus = NO;
        [self loadData];
    }
    return self;
}

- (void)dealloc {
    [self.timer invalidate];
}

- (void)setupTitleView {
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor whiteColor];
    titleView.size = CGSizeMake(HYXScreenW, kTitleViewH);
    [self addSubview:titleView];
    
    NSArray *titles = @[@"系统默认",@"距离我最近",@"最迟上门时间"];
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
        button.tag = i;
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:button];
        if (i == 0) {
            button.enabled = NO;
            self.currentBtn = button;
        } else {
            UIView *separateLine = [[UIView alloc] init];
            separateLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
            separateLine.size = CGSizeMake(0.5, kTitleViewH*0.5);
            separateLine.x = button.x-0.5;
            separateLine.centerY = titleView.height*0.5;
            [titleView addSubview:separateLine];
        }
    }
    
    UIView *separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    separateLine.size = CGSizeMake(HYXScreenW, 0.5);
    separateLine.y = titleView.height-separateLine.height;
    [titleView addSubview:separateLine];
}
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTitleViewH, HYXScreenW, self.height-kTitleViewH)];
    tableView.backgroundColor = WTGlobalBG;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    self.tableView = tableView;
    
    adjustsScrollViewInsets(tableView);
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    tableView.mj_header.ignoredScrollViewContentInsetTop = 7;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WTMyCaseCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
//    if (self.totalModel.data.count == 0) {
//        self.placeholderView.hintText = kRequestErrorTypeNoData;
//        [tableView addSubview:self.placeholderView];
//    }
    
    [self setupHeaderView];
}

- (void)setupHeaderView {
    // 头部：搜索框
    UIView *containView = [[UIView alloc] init];
    containView.backgroundColor = [UIColor clearColor];
    containView.size = CGSizeMake(self.tableView.width, 50);
    self.tableView.tableHeaderView = containView;
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.backgroundColor = [UIColor colorWithHexString:@"12a09c"];
    [searchBtn setTitle:@"查找" forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    searchBtn.size = CGSizeMake(59, 30);
    searchBtn.right = containView.width-10;
    searchBtn.centerY = containView.height*0.5;
    searchBtn.layer.cornerRadius = 4;
    searchBtn.layer.masksToBounds = YES;
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [containView addSubview:searchBtn];
    
    UIView *searchView = [[UIView alloc] init];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.size = CGSizeMake(searchBtn.x-2*10, 30);
    searchView.x = 10;
    searchView.y = 10;
    searchView.layer.cornerRadius = 4;
    searchView.layer.masksToBounds = YES;
    [containView addSubview:searchView];
    
    UIImageView *iconImgView = [[UIImageView alloc] initWithImage:HYXImage(@"caseCenter_search")];
    [iconImgView sizeToFit];
    iconImgView.x = 10;
    iconImgView.centerY = searchView.height*0.5;
    [searchView addSubview:iconImgView];
    
    CGFloat textX = CGRectGetMaxX(iconImgView.frame)+10;
    UITextField *textField = [[UITextField alloc] init];
    textField.x = textX;
    textField.size = CGSizeMake(searchView.width-textX, searchView.height);
    textField.placeholder = @"关键字查询";
    textField.font = [UIFont systemFontOfSize:14];
    textField.textColor = [UIColor colorWithHexString:@"333333"];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField addTarget:self action:@selector(searchFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [searchView addSubview:textField];
    self.searchTextField = textField;
}

- (void)loadData {
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"userId"] = [WTAccountManager sharedManager].userId;
    if (self.chosenDateStr.length&&self.currentBtn.tag != 0) {
        paras[@"dateString"] = self.chosenDateStr;
    }
    
    WTWeakSelf;
    [[[WTMyCaseViewModel alloc] init] dataByParameters:paras success:^(WTTotalModel *totalModel) {
        if (weakSelf.currentBtn.tag == 1) { // 按距离排序
            [weakSelf.timer invalidate];
            weakSelf.distanceTotalModel = totalModel;
            
            if (totalModel.data.count == 0) {
                [weakSelf.tableView.mj_header endRefreshing];
                return ;
            }
            
            NSInteger index1 = arc4random_uniform((int)totalModel.data.count);
            WTMyCaseModel *model1 = totalModel.data[index1];
            NSInteger index2 = arc4random_uniform((int)totalModel.data.count);
            WTMyCaseModel *model2 = totalModel.data[index2];
            if ([weakSelf isGeocodedWithModel1:model1 model2:model2]) { // 完成地理编码
                NSArray *sortArr = [totalModel.data sortedArrayUsingComparator:^NSComparisonResult(WTMyCaseModel   * _Nonnull obj1, WTMyCaseModel   * _Nonnull obj2) {
                    return [@(obj1.distance) compare:@(obj2.distance)];
                }];
                weakSelf.totalModel.data = [NSMutableArray arrayWithArray:sortArr];
                [weakSelf reloadData];
            } else {
                weakSelf.timer = [YYTimer timerWithTimeInterval:1.5 target:self selector:@selector(judgeIsGeocoded) repeats:YES];
                [weakSelf.timer fire];
            }
        } else {
            weakSelf.totalModel = totalModel;
            [weakSelf reloadData];
        }
        [weakSelf.tableView.mj_header endRefreshing];
    } failure:^(NSError *error, NSString *message) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (error.code == kRequestErrorCodeNoNet) {
            weakSelf.placeholderView.hintText = kRequestErrorTypeNoNet;
        } else {
            weakSelf.placeholderView.hintText = kRequestErrorTypeError;
        }
        [weakSelf.tableView addSubview:weakSelf.placeholderView];
        HYXLog(@"error  %@",error);
    }];
}

/**
 是否地理编码完成
 */
- (BOOL)isGeocodedWithModel1:(WTMyCaseModel *)model1 model2:(WTMyCaseModel *)model2 {
    return model1.lat != 0 && model1.lng != 0 && model2.lat != 0 && model2.lng != 0;
}
- (void)judgeIsGeocoded {
    NSInteger index1 = arc4random_uniform((int)self.distanceTotalModel.data.count);
    WTMyCaseModel *model1 = self.distanceTotalModel.data[index1];
    NSInteger index2 = arc4random_uniform((int)self.distanceTotalModel.data.count);
    WTMyCaseModel *model2 = self.distanceTotalModel.data[index2];
    if ([self isGeocodedWithModel1:model1 model2:model2]) {
        NSArray *sortArr = [self.distanceTotalModel.data sortedArrayUsingComparator:^NSComparisonResult(WTMyCaseModel   * _Nonnull obj1, WTMyCaseModel   * _Nonnull obj2) {
            return [@(obj1.distance) compare:@(obj2.distance)];
        }];
        self.totalModel.data = [NSMutableArray arrayWithArray:sortArr];
        [self reloadData];
        
        [self.timer invalidate];
    }
}

- (void)reloadData {
    [self.tableView reloadData];
    if (self.totalModel.data.count) {
        if (_placeholderView) {
            [self.placeholderView removeFromSuperview];
        }
    } else {
        self.placeholderView.hintText = kRequestErrorTypeNoData;
        [self.tableView addSubview:self.placeholderView];
    }
}

- (void)titleClick:(UIButton *)button {
    self.currentBtn.enabled = YES;
    if (self.currentBtn.tag == 2) {
        [self.currentBtn setTitleColor:WTBrownColor forState:UIControlStateDisabled];
        [self.currentBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    }
    button.enabled = NO;
    self.currentBtn = button;
    
    if (button.tag == 2) {
        if (self.dataChosenBlock) {
            self.dataChosenBlock();
        }
        [self.searchTextField resignFirstResponder];
        button.enabled = YES;
        [button setTitleColor:WTBrownColor forState:UIControlStateNormal];
    } else if (button.tag == 1) { // 按距离排序
        NSArray *sortArr = [self.totalModel.data sortedArrayUsingComparator:^NSComparisonResult(WTMyCaseModel   * _Nonnull obj1, WTMyCaseModel   * _Nonnull obj2) {
            return [@(obj1.distance) compare:@(obj2.distance)];
        }];
        self.totalModel.data = [NSMutableArray arrayWithArray:sortArr];
        self.totalModel.isSorted = YES;
        [self.tableView reloadData];
    } else {
        [self loadData];
    }
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

- (void)searchClick {
    if (![self.searchTextField.text isEmpty]) {
        [SVProgressHUD show];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    });
}
- (void)searchFieldDidChange:(UITextField *)textField {
    NSString *searchText = textField.text;
    if ([searchText isEmpty]) {
        self.isSearchStatus = NO;
        // 恢复原始总数据
        [self.tableView reloadData];
    } else {
        self.isSearchStatus = YES;
        self.searchDataArrM = [NSMutableArray array];
        for (WTMyCaseModel *caseModel in self.totalModel.data) {
            if ([caseModel.litigantName containsString:searchText] ||
                [caseModel.detailAddr containsString:searchText] ||
                [caseModel.fullAddress containsString:searchText] ||
                [caseModel.caseCode containsString:searchText] ||
                [caseModel.preCaseCode containsString:searchText]) {
                [self.searchDataArrM addObject:caseModel];
            }
        }
        [self.tableView reloadData];
    }
}

- (void)setTotalModel:(WTTotalModel *)totalModel {
    _totalModel = totalModel;
    
    self.searchTextField.text = nil;
    self.isSearchStatus = NO;
    [self.searchDataArrM removeAllObjects];
    
    if (totalModel.data.count) {
        [self.tableView reloadData];
        if (_placeholderView) {
            [self.placeholderView removeFromSuperview];
        }
    } else {
        [self.tableView addSubview:self.placeholderView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearchStatus) {
        return self.searchDataArrM.count;
    }
    return self.totalModel.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTMyCaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.isSortByDistance = self.currentBtn.tag == 1;
    if (self.isSearchStatus) {
        cell.caseModel = self.searchDataArrM[indexPath.row];
    } else {
        cell.caseModel = self.totalModel.data[indexPath.row];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    WTMyCaseModel *caseModel;
    if (self.isSearchStatus) {
        caseModel = self.searchDataArrM[indexPath.row];
    } else {
        caseModel = self.totalModel.data[indexPath.row];
    }
    WTCaseDetailController *caseDetailVc = [[UIStoryboard storyboardWithName:@"WTCaseDetailController" bundle:nil] instantiateViewControllerWithIdentifier:@"caseDetailId"];
    caseDetailVc.caseId = caseModel.caseId;
    [self.superview.superview.viewController.navigationController pushViewController:caseDetailVc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 246;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchTextField resignFirstResponder];
}

#pragma mark - <WTMyCaseCellDelegate>
- (void)transferCaseToMateInCell:(WTMyCaseCell *)cell {
    WTMyCaseModel *caseModel = cell.caseModel;
    if (_delegate && [_delegate respondsToSelector:@selector(transferCaseToMateInListView:currentModel:)]) {
        [_delegate transferCaseToMateInListView:self currentModel:caseModel];
    }
}
- (void)signCaseInCell:(WTMyCaseCell *)cell {
    WTMyCaseModel *caseModel = cell.caseModel;
    if (_delegate && [_delegate respondsToSelector:@selector(signCaseInListView:currentModel:)]) {
        [_delegate signCaseInListView:self currentModel:caseModel];
    }
}

@end
