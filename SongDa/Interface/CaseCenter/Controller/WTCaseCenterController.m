//
//  WTCaseCenterController.m
//  SongDa
//
//  Created by Fancy on 2018/3/27.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseCenterController.h"
#import "WTCaseCenterCell.h"
#import "WTCaseDetailController.h"
#import "WTCaseCenterViewModel.h"
#import "WTCaseCenterModel.h"
#import "WTCaseCenterRegionsViewModel.h"
#import "WTCaseRegionModel.h"
#import "WTCaseCenterMapController.h"
#import "WTCaseCenterArrivedCell.h"

#import "WTRegionPickObj.h"
#import "WTRegionManager.h"
#import "WTRegionModel.h"
#import "WTLoginController.h"
#import "WTNavigationController.h"


#define kSearchHeight       50
#define kItemHeight         44

#warning hyx_cityName
#define kLocalName          @"成都市"
//#define kLocalName          @"昆明市"

@interface WTCaseCenterController () <UITableViewDelegate,UITableViewDataSource,WTCaseCenterCellDelegate,WTRegionPickObjDelegate>
/** 状态按钮 */
@property (strong, nonatomic) UIButton          *titleBtn;
/** 地区按钮 */
@property (strong, nonatomic) UIButton          *zoneBtn;
@property (strong, nonatomic) UITableView       *tableView;
@property (strong, nonatomic) WTTotalModel      *totalModel;
//@property (strong, nonatomic) UITableView       *regionTableView;
@property (strong, nonatomic) WTTotalModel      *regionTotalModel;
@property (strong, nonatomic) WTPlaceholderView *placeholderView;
@property (strong, nonatomic) WTRegionPickObj   *regionPickObj;
/** 送达状态view */
@property (strong, nonatomic) UIView            *statusView;
@property (strong, nonatomic) UIView            *statusContainView;
@property (strong, nonatomic) UIView            *blackBackView;
/** 当前送达状态按钮 */
@property (strong, nonatomic) UIButton          *statusBtn;
/** tabBar栏 蒙版 */
@property (strong, nonatomic) UIView            *filterView;
/** 是否存在地区tableView */
@property (assign, nonatomic) BOOL              isExitReginView;
/** 是否存在送达选项view */
@property (assign, nonatomic) BOOL              isExitSendView;
/** 头部搜索框 */
@property (strong, nonatomic) UIView            *headerView;
/** 搜索输入框 */
@property (strong, nonatomic) UITextField       *searchTextField;

/** 当前请求的数据的页码 */
@property (assign, nonatomic) NSUInteger        currentPage;
/** regionId */
@property (copy, nonatomic) NSString            *regionId;

@property (strong, nonatomic) NSArray <WTRegionModel *> *regionData;
@end

@implementation WTCaseCenterController

static NSString * const ID = @"caseCenterCell";
static NSString * const arrivedID = @"caseCenterArrivedCell";
static NSString * const regionID = @"regionID";

- (WTPlaceholderView *)placeholderView
{
    if (_placeholderView == nil) {
        _placeholderView = [[WTPlaceholderView alloc] initWithFrame:CGRectMake(0, kSearchHeight, self.tableView.width, self.tableView.height-kSearchHeight)];
        _placeholderView.backgroundColor = [UIColor clearColor];
    }
    return _placeholderView;
}

- (WTRegionPickObj *)regionPickObj{
    if (!_regionPickObj) {
        _regionPickObj = [WTRegionPickObj new];
        _regionPickObj.delegate = self;
        _regionPickObj.tableView.frame = CGRectMake(0, 0, HYXScreenW, HYXScreenH * .7);
    }
    
    return _regionPickObj;
}

- (UIButton *)statusBtn
{
    if (_statusBtn == nil) {
        _statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _statusBtn.tag = 20;
    }
    return _statusBtn;
}
- (UIView *)filterView
{
    if (_filterView == nil) {
        _filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HYXScreenW, IPhoneX_TabBar_Height)];
        _filterView.backgroundColor = [UIColor blackColor];
        _filterView.alpha = 0.00;
        _filterView.bottom = HYXScreenH;
        [_filterView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideStatusView)]];
    }
    return _filterView;
}

- (UIView *)blackBackView
{
    if (_blackBackView == nil) {
        _blackBackView = [[UIView alloc] initWithFrame:self.tableView.bounds];
        self.blackBackView.backgroundColor = [UIColor blackColor];
        self.blackBackView.alpha = 0.0;
        [self.blackBackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideStatusView)]];
    }
    return _blackBackView;
}

- (UIView *)statusView
{
    if (_statusView == nil) {
        _statusView = [[UIView alloc] initWithFrame:self.tableView.bounds];
        _statusView.backgroundColor = [UIColor clearColor];
        
        self.statusContainView = [[UIView alloc] init];
        self.statusContainView.backgroundColor = [UIColor whiteColor];
        self.statusContainView.size = CGSizeMake(HYXScreenW, kItemHeight*2);
        self.statusContainView.bottom = 0;
        [_statusView addSubview:self.statusContainView];
        
        NSArray *titles = @[@"已完成",@"待上门"];
        NSArray *tags = @[@30,@20];
        for (NSInteger i = 0; i < titles.count; i++) {
            UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            itemBtn.size = CGSizeMake(HYXScreenW, kItemHeight);
            [itemBtn setTitle:titles[i] forState:UIControlStateNormal];
            [itemBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
            itemBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            itemBtn.y = i*(itemBtn.height+0.5);
            itemBtn.tag = [tags[i] integerValue];
            [itemBtn addTarget:self action:@selector(statusSeleted:) forControlEvents:UIControlEventTouchUpInside];
            [self.statusContainView addSubview:itemBtn];
            
            if (i == 0) {
                UIView *separateLine = [[UIView alloc] init];
                separateLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
                separateLine.size = CGSizeMake(HYXScreenW, 0.5);
                separateLine.y = itemBtn.height;
                [self.statusContainView addSubview:separateLine];
            }
        }
    }
    
    self.blackBackView.y = 0;
    [_statusView insertSubview:self.blackBackView atIndex:0];
    
    return _statusView;
}

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor clearColor];
        _headerView.size = CGSizeMake(self.tableView.width, kSearchHeight);
        
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        searchBtn.backgroundColor = [UIColor colorWithHexString:@"12a09c"];
        [searchBtn setTitle:@"查找" forState:UIControlStateNormal];
        searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        searchBtn.size = CGSizeMake(59, 30);
        searchBtn.right = _headerView.width-10;
        searchBtn.centerY = _headerView.height*0.5;
        searchBtn.layer.cornerRadius = 4;
        searchBtn.layer.masksToBounds = YES;
        [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:searchBtn];
        
        UIView *searchView = [[UIView alloc] init];
        searchView.backgroundColor = [UIColor whiteColor];
        searchView.size = CGSizeMake(searchBtn.x-2*10, 30);
        searchView.x = 10;
        searchView.y = 10;
        searchView.layer.cornerRadius = 4;
        searchView.layer.masksToBounds = YES;
        [_headerView addSubview:searchView];
        
        UIImageView *iconImgView = [[UIImageView alloc] initWithImage:HYXImage(@"caseCenter_search")];
        [iconImgView sizeToFit];
        iconImgView.x = 10;
        iconImgView.centerY = searchView.height*0.5;
        [searchView addSubview:iconImgView];
        
        CGFloat textX = CGRectGetMaxX(iconImgView.frame)+10;
        UITextField *textField = [[UITextField alloc] init];
        textField.x = textX;
        textField.size = CGSizeMake(searchView.width-textX, searchView.height);
        textField.placeholder = @"案号/送达人员";
        textField.font = [UIFont systemFontOfSize:14];
        textField.textColor = [UIColor colorWithHexString:@"333333"];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        [searchView addSubview:textField];
        self.searchTextField = textField;
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _isExitReginView = NO;
    _isExitSendView = NO;
    
    [self setupNav];
    [self setupTableView];
    [self loadNewData];
    [self loadRegions];
    self.definesPresentationContext = YES;
}

- (void)setupNav {
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleBtn setImage:HYXImage(@"caseCenter_sendStatus") forState:UIControlStateNormal];
    titleBtn.adjustsImageWhenHighlighted = NO;
    [titleBtn setTitle:@"待上门" forState:UIControlStateNormal];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [titleBtn sizeToFit];
    titleBtn.width += 20;
    [titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -(titleBtn.imageView.width+2), 0, titleBtn.imageView.width+2)];
    [titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, titleBtn.titleLabel.width+2, 0, -(titleBtn.titleLabel.width+2))];
    [titleBtn addTarget:self action:@selector(titleClick) forControlEvents:UIControlEventTouchUpInside];
    self.titleBtn = titleBtn;
    self.navigationItem.titleView = self.titleBtn;
    
    UIButton *zoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [zoneBtn setImage:HYXImage(@"caseCenter_zone_next") forState:UIControlStateNormal];
    zoneBtn.adjustsImageWhenHighlighted = NO;
    NSString * city = [WTRegionManager getRegionByRegionID:[WTAccountManager sharedManager].courtCity].local_name;
    
    [zoneBtn setTitle:city?city:[WTLocationManager shareInstance].currentCity?[WTLocationManager shareInstance].currentCity:kLocalName forState:UIControlStateNormal];
//    self.regionId = [WTAccountManager sharedManager].courtCity;
//    if (!self.regionId) {
//        self.regionId = @([WTRegionManager getRegionByLocalName:zoneBtn.titleLabel.text].region_id).stringValue;
//    }
    
    zoneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [zoneBtn sizeToFit];
    zoneBtn.width += 5;
    [zoneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -(zoneBtn.imageView.width+2), 0, zoneBtn.imageView.width+2)];
    [zoneBtn setImageEdgeInsets:UIEdgeInsetsMake(0, zoneBtn.titleLabel.width+2, 0, -(zoneBtn.titleLabel.width+2))];
    [zoneBtn addTarget:self action:@selector(zoneClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:zoneBtn];
    self.zoneBtn = zoneBtn;

}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, HYXScreenW, HYXScreenH-IPhoneX_Nav_Height-IPhoneX_TabBar_Height)];
    tableView.backgroundColor = WTGlobalBG;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    adjustsScrollViewInsets(tableView);
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    tableView.tableFooterView = [UIView new];
    
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WTCaseCenterCell class]) bundle:nil] forCellReuseIdentifier:ID];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WTCaseCenterArrivedCell class]) bundle:nil] forCellReuseIdentifier:arrivedID];
}


- (void)loadNewData {
    WTWeakSelf;
    if (self.totalModel.data.count) {
        self.tableView.mj_footer.hidden = NO;
        [self.tableView.mj_footer endRefreshing];
    }
    [SVProgressHUD show];
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"page"] = @1;
    paras[@"size"] = @10;
    paras[@"userId"] = [WTAccountManager sharedManager].userId;
    paras[@"serviceRecordState"] = @(self.statusBtn.tag);
    paras[@"regions"] = self.regionId;
    if (![self.searchTextField.text isEmpty]) {
        paras[@"keyword"] = self.searchTextField.text;
    }
    
    __weak typeof(_placeholderView) weakPlaceholderView = _placeholderView;
    [[[WTCaseCenterViewModel alloc] init] dataByParameters:paras success:^(WTTotalModel *totalModel) {
        
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
        weakSelf.currentPage = 1;
        if (totalModel.data.count) {
            if (weakPlaceholderView) {
                [weakSelf.placeholderView removeFromSuperview];
            }
            weakSelf.tableView.tableHeaderView = weakSelf.headerView;
            if (totalModel.data.count < 10) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            weakSelf.placeholderView.hintText = kRequestErrorTypeNoData;
            [weakSelf.tableView addSubview:weakSelf.placeholderView];
        }
        
        [SVProgressHUD dismiss];
    } failure:^(NSError *error, NSString *message) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.currentPage = 1;
        if (error.code == kRequestErrorCodeNoNet) {
            weakSelf.placeholderView.hintText = kRequestErrorTypeNoNet;
            [weakSelf.tableView addSubview:weakSelf.placeholderView];
        } else {
            weakSelf.placeholderView.hintText = kRequestErrorTypeNoData;
            [weakSelf.tableView addSubview:weakSelf.placeholderView];
        }
        HYXLog(@"error  %@",error);
        
        [SVProgressHUD dismiss];
    }];
}
- (void)loadMoreData {
    WTWeakSelf;
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"page"] = @(self.currentPage+1);
    paras[@"size"] = @10;
    paras[@"userId"] = [WTAccountManager sharedManager].userId;
    paras[@"serviceRecordState"] = @(self.statusBtn.tag);
    if (self.regionId.length) {
        paras[@"regions"] = self.regionId;
    }
//    paras[@"regions"] = @"3192";
    if (![self.searchTextField.text isEmpty]) {
        paras[@"keyword"] = [self.searchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    [[[WTCaseCenterViewModel alloc] init] dataByParameters:paras success:^(WTTotalModel *totalModel) {
        
        if (totalModel.code == 2) {
            [SVProgressHUD showErrorWithStatus:totalModel.message];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self logout];
            });
            
            return ;
        }
        
        if (totalModel.data.count) {
            [weakSelf.totalModel.data addObjectsFromArray:totalModel.data];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
            weakSelf.currentPage++;
            if (totalModel.data.count < 10) { // 如果小于请求的条数，说明当前页为最后一页
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error, NSString *message) {
        if (error.code == kRequestErrorCodeNoData) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        HYXLog(@"error  %@",error);
    }];
}

//TODO:网络请求加载地区
- (void)loadRegions {

//    WTWeakSelf;
//    NSDictionary *paras = @{@"userId" : [WTAccountManager sharedManager].userId};
//    [[[WTCaseCenterRegionsViewModel alloc] init] dataByParameters:paras success:^(WTTotalModel *totalModel) {
//        weakSelf.regionTotalModel = totalModel;
//        [weakSelf.regionTableView reloadData];
//    } failure:^(NSError *error, NSString *message) {
//        HYXLog(@"error %@",error);
//    }];
 
    NSString * city = [WTRegionManager getRegionByRegionID:[WTAccountManager sharedManager].courtCity].local_name;
    if (!city) {
        city = [WTLocationManager shareInstance].currentCity;
    }
    
    if (city) {
        _regionData = [WTRegionManager getRegion:city isProvince:NO];
        self.regionPickObj.dataSource = _regionData;
        [self.regionPickObj.tableView reloadData];
    }
    else if ([WTLocationManager shareInstance].currentProvince){
        _regionData = [WTRegionManager getRegion:[WTLocationManager shareInstance].currentCity isProvince:YES];
        self.regionPickObj.dataSource = _regionData;
        [self.regionPickObj.tableView reloadData];
    }
    else{
        [SVProgressHUD showInfoWithStatus:@"正在定位中..."];
//        _regionData = [WTRegionManager getRegion:kLocalName isProvince:NO];
//        self.regionPickObj.dataSource = _regionData;
//        [self.regionPickObj.tableView reloadData];
    }

}

- (void)logout{
    [[WTAccountManager sharedManager] loginWithDictionary:[NSDictionary dictionary]];
    WTLoginController *loginVc = [[WTLoginController alloc] init];
    WTNavigationController *navVc = [[WTNavigationController alloc] initWithRootViewController:loginVc];
    [UIApplication sharedApplication].keyWindow.rootViewController = navVc;
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
}

- (void)titleClick {
    if (self.isExitReginView) {
//        self.titleBtn.selected = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.filterView.alpha = 0.0;
            self.blackBackView.alpha = 0.0;
            self.regionPickObj.tableView.height = 0;
            self.zoneBtn.imageView.transform = CGAffineTransformMakeRotation(0);
        } completion:^(BOOL finished) {
            [self statusViewTransform];
        }];
    } else {
        [self statusViewTransform];
    }
}

- (void)statusViewTransform {
    self.titleBtn.selected = !self.titleBtn.selected;
    if (self.titleBtn.selected) {
        self.blackBackView.alpha = 0.0;
        self.blackBackView.y = 0;
        
        self.statusContainView.y = -2*kItemHeight;
        self.statusView.y = 0;
        [self.view addSubview:self.statusView];
        
        self.filterView.alpha = 0.0;
        [HYXRootViewController.view addSubview:self.filterView];
        [UIView animateWithDuration:0.2 animations:^{
            self.filterView.alpha = 0.3;
            self.blackBackView.alpha = 0.3;
            self.statusContainView.y = 0;
            self.titleBtn.imageView.transform = CGAffineTransformRotate(self.titleBtn.imageView.transform, M_PI);
        }];
        
        self.isExitSendView = YES;
    } else {
        [self hideStatusView];
    }
}

//TODO:点击选择地区
- (void)zoneClick {
    if (_regionData.count) {
        self.regionPickObj.dataSource = _regionData;
        [_regionPickObj.tableView reloadData];
        if (self.isExitSendView) {
            self.zoneBtn.selected = NO;
            [UIView animateWithDuration:0.2 animations:^{
                self.filterView.alpha = 0.0;
                self.blackBackView.alpha = 0.0;
                self.statusContainView.y = -self.statusContainView.height;
                self.titleBtn.imageView.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                [self zoneViewTransform];
            }];
        } else {
            [self zoneViewTransform];
        }
    } else {
        [self loadRegions];
    }
}
- (void)zoneViewTransform {
    self.zoneBtn.selected = !self.zoneBtn.selected;
    if (self.zoneBtn.selected) {
        self.blackBackView.alpha = 0.0;
        self.blackBackView.y = 0;
        [self.view addSubview:self.blackBackView];
        
        self.regionPickObj.tableView.height = 0;
        self.regionPickObj.tableView.y = 0;
        [self.view addSubview:self.regionPickObj.tableView];
        
        self.filterView.alpha = 0.0;
        [HYXRootViewController.view addSubview:self.filterView];
        [UIView animateWithDuration:0.2 animations:^{
            self.filterView.alpha = 0.3;
            self.blackBackView.alpha = 0.3;

            self.regionPickObj.tableView.height = _regionData.count * 44 > HYXScreenH * .7?HYXScreenH * .7:_regionData.count * 44;

            self.zoneBtn.imageView.transform = CGAffineTransformRotate(self.zoneBtn.imageView.transform, M_PI);
        }];
        
        self.isExitReginView = YES;
    } else {
        [self hideStatusView];
    }
}

- (void)hideStatusView {
    self.titleBtn.selected = NO;
    self.zoneBtn.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        if (self.isExitSendView) {
            self.statusContainView.y = -self.statusContainView.height;
            self.titleBtn.imageView.transform = CGAffineTransformMakeRotation(0);
        }
        if (self.isExitReginView) {
            self.regionPickObj.tableView.height = 0;
            self.zoneBtn.imageView.transform = CGAffineTransformMakeRotation(0);
        }
        self.filterView.alpha = 0.0;
        self.blackBackView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        if (self.isExitSendView) {
            [self.statusView removeFromSuperview];
            self.isExitSendView = NO;
        }
        if (self.isExitReginView) {
            [self.regionPickObj.tableView removeFromSuperview];
            self.isExitReginView = NO;
        }
        [self.blackBackView removeFromSuperview];
        [self.filterView removeFromSuperview];
    }];
}
- (void)searchClick {
    [SVProgressHUD show];
    [self loadNewData];
}

- (void)statusSeleted:(UIButton *)button {
    self.statusBtn = button;
    [self hideStatusView];
    [self.tableView setContentOffset:CGPointZero animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadNewData];
    });
    
    if (button.tag == 30) {
        [self.titleBtn setTitle:@"已完成" forState:UIControlStateNormal];
    } else if (button.tag == 20) {
        [self.titleBtn setTitle:@"待上门" forState:UIControlStateNormal];
    }
}

- (void)textFieldChange:(UITextField *)textField {
    if ([textField.text isEmpty]) {
        [self loadNewData];
    }
}

#pragma mark - <datasource delegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        self.tableView.mj_footer.hidden = self.totalModel.data.count == 0;
        return self.totalModel.data.count;
    } else {
        return self.regionTotalModel.data.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {
        if ([self.titleBtn.currentTitle isEqualToString:@"待上门"]) {
            WTCaseCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            cell.centerModel = self.totalModel.data[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        } else {
            WTCaseCenterArrivedCell *cell = [tableView dequeueReusableCellWithIdentifier:arrivedID];
            cell.centerModel = self.totalModel.data[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    } else {
        WTCaseRegionModel *regionModel = self.regionTotalModel.data[indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:regionID];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = regionModel.localName;
        cell.textLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
        if ([self.titleBtn.currentTitle isEqualToString:@"待上门"]) {
            return 270;
        } else {
            return 265;
        }
    } else {
        return kItemHeight;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
        WTCaseCenterModel *model = self.totalModel.data[indexPath.row];
        WTCaseDetailController *caseDetailVc = [[UIStoryboard storyboardWithName:@"WTCaseDetailController" bundle:nil] instantiateViewControllerWithIdentifier:@"caseDetailId"];
        caseDetailVc.caseId = model.caseId;
        if ([self.titleBtn.currentTitle isEqualToString:@"已完成"]) {
            caseDetailVc.isFromArrived = YES;
        } else {
            caseDetailVc.isFromArrived = NO;
        }
        [self.navigationController pushViewController:caseDetailVc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchTextField resignFirstResponder];
}

#pragma mark - <WTCaseCenterCellDelegate>
- (void)didClickDelivererCurrentLocation:(WTCaseCenterCell *)cell {
    WTCaseCenterMapController *mapVc = [[WTCaseCenterMapController alloc] init];
    mapVc.caseModel = cell.centerModel;
    [self.navigationController pushViewController:mapVc animated:YES];
}

#pragma mark - WTRegionPickObjDelegate
- (void)yc_regionPickObj:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withModel:(WTRegionModel *)model{
    
    [self hideStatusView];
    [self.tableView setContentOffset:CGPointZero animated:YES];
   
    self.regionId = @(model.region_id).stringValue;
    [self.zoneBtn setTitle:model.local_name forState:UIControlStateNormal];
    [self.zoneBtn sizeToFit];
    self.zoneBtn.width = self.zoneBtn.width > 120 ? 120 :self.zoneBtn.width+5;
    
    [self.zoneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -(self.zoneBtn.imageView.width+2), 0, self.zoneBtn.imageView.width+2)];
    [self.zoneBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.zoneBtn.titleLabel.width+2, 0, -(self.zoneBtn.titleLabel.width+2))];
    [self loadNewData];
}

@end