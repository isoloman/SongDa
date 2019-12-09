//
//  WTMyCaseController.m
//  SongDa
//
//  Created by Fancy on 2018/3/27.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTMyCaseController.h"
#import "WTMyCaseMapView.h"
#import "WTMyCaseListView.h"
#import "WTMyCaseUserView.h"
#import "WTModifyPwdController.h"
#import "WTLoginViewModel.h"
#import "WTMyCaseViewModel.h"
#import "WTMyCaseModel.h"
#import "WTMyCaseMessageController.h"
#import "WTCaseTransferCodeController.h"
#import "WTMyCaseSignController.h"
#import "WTMyCaseArrivedController.h"
#import "WTUserTrafficController.h"
#import "WTMyCaseNaviController.h"
#import "WTBusRouteModel.h"
#import "WTMyCaseByBusController.h"
#import "WTMessageManager.h"
#import "WTMessageModel.h"
#import "WTCaseDateView.h"
#import "WTLoginController.h"
#import "WTNavigationController.h"

#import "WTNavigationChooseObj.h"
#import "WTNavigationModel.h"
#import "KLCPopup.h"

#import <AMapSearchKit/AMapSearchKit.h>

static int geoCount = 0;

@interface WTMyCaseController () <UIScrollViewDelegate,WTMyCaseUserViewDelegate,WTMyCaseListViewDelegate,WTMyCaseMapViewDelegate,AMapSearchDelegate,WTNavigationChooseObjDelegate>
@property (strong, nonatomic) WTTotalModel      *totalModel;
@property (strong, nonatomic) WTMyCaseMapView   *mapView;
@property (strong, nonatomic) WTMyCaseListView  *listView;
@property (strong, nonatomic) WTMyCaseUserView  *userView;
/** 当前选中按钮 */
@property (strong, nonatomic) UIButton          *currentBtn;
/** 地图模式按钮 */
@property (strong, nonatomic) UIButton          *mapBtn;
/** 列表模式按钮 */
@property (strong, nonatomic) UIButton          *listBtn;
/** 指示器 */
@property (strong, nonatomic) UIView            *indicatorView;
@property (strong, nonatomic) UIScrollView      *contentView;
/** 要筛选的案件时间 */
@property (copy, nonatomic)   NSString          *chosenDateStr;

/** 个人中心button */
@property (strong, nonatomic) UIButton *userBtn;
/** 消息小红点 */
@property (strong, nonatomic) UIView            *msgRedView;

/** 地图搜索类 */
@property (strong, nonatomic) AMapSearchAPI     *search;

@property (strong, nonatomic) KLCPopup              *pop;
@property (strong, nonatomic) WTNavigationChooseObj * naviObj;
@end

@implementation WTMyCaseController{
    WTMyCaseModel * _caseModel;
}

- (WTNavigationChooseObj *)naviObj{
    if (!_naviObj) {
        _naviObj = [WTNavigationChooseObj new];
        _naviObj.delegate = self;
        _naviObj.tableView.frame = CGRectMake(0, 0, HYXScreenW, 44 * 2 + IPhoneX_Bottom_Safe_Height);
    }
    return _naviObj;
}

- (WTMyCaseMapView *)mapView
{
    MJWeakSelf;
    if (_mapView == nil) {
        _mapView = [[WTMyCaseMapView alloc] initWithFrame:self.contentView.bounds];
        _mapView.delegate = self;
        _mapView.dateChoseBlock = ^{
            [weakSelf setupDateView];
        };
    }
    return _mapView;
}

- (WTMyCaseListView *)listView
{
    MJWeakSelf;
    if (_listView == nil) {
        _listView = [[WTMyCaseListView alloc] initWithFrame:self.contentView.bounds];
        _listView.delegate = self;
        _listView.chosenDateStr = self.chosenDateStr;
        _listView.dataChosenBlock = ^{
            [weakSelf setupDateView];
        };
    }
    return _listView;
}

- (WTMyCaseUserView *)userView
{
    if (_userView == nil) {
        _userView = [[WTMyCaseUserView alloc] initWithFrame:CGRectMake(0, 0, HYXScreenW, HYXScreenH)];
        _userView.delegate = self;
    }
    return _userView;
}

- (AMapSearchAPI *)search
{
    if (_search == nil) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}

- (UIView *)msgRedView
{
    if (_msgRedView == nil) {
        _msgRedView = [[UIView alloc] init];
        _msgRedView.backgroundColor = [UIColor redColor];
        _msgRedView.size = CGSizeMake(6, 6);
        _msgRedView.layer.cornerRadius = _msgRedView.height*0.5;
        _msgRedView.layer.masksToBounds = YES;
    }
    return _msgRedView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self checkRedMsgView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self initDate];
    [self setupNav];
    [self setupContentView];
    [self loadData];
    [self configNotification];
  
}

- (void)initDate {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    self.chosenDateStr = [fmt stringFromDate:[NSDate date]];
}

- (void)setupNav {
    UIView *titleView = [[UIView alloc] init];
    titleView.height = 44;
    self.navigationItem.titleView = titleView;
    
    self.indicatorView = [[UIView alloc] init];
    self.indicatorView.backgroundColor = WTBrownColor;
    self.indicatorView.size = CGSizeMake(0, 2.5);
    self.indicatorView.layer.cornerRadius = self.indicatorView.height*0.5;
    self.indicatorView.layer.masksToBounds = YES;
    [titleView addSubview:self.indicatorView];
    
    CGFloat margin = 30;
    NSArray *titles = @[@"地图模式",@"列表模式"];
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:WTBrownColor forState:UIControlStateDisabled];
        [button sizeToFit];
        button.x = i*(button.width+margin);
        button.centerY = titleView.height*0.5;
        button.tag = i;
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:button];

        if (i == 0) {
            button.enabled = NO;
            self.mapBtn = button;
            self.currentBtn = button;
            self.indicatorView.width = button.width;
            self.indicatorView.centerX = button.centerX;
            self.indicatorView.y = titleView.height-self.indicatorView.height;
        } else {
            self.listBtn = button;
            titleView.width = CGRectGetMaxX(button.frame);
        }
    }
    
    UIButton *userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.userBtn = userBtn;
    [userBtn setImage:HYXImage(@"myCase_head_icon") forState:UIControlStateNormal];
    [userBtn sizeToFit];
    userBtn.adjustsImageWhenHighlighted = NO;
    [userBtn addTarget:self action:@selector(userClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.userBtn];
    
    [self checkRedMsgView];
}

- (void)setupContentView {
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, HYXScreenW, HYXScreenH-IPhoneX_Nav_Height-IPhoneX_TabBar_Height)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.delegate = self;
    contentView.contentSize = CGSizeMake(HYXScreenW*2, 0);
    contentView.pagingEnabled = YES;
    self.contentView = contentView;
    [self.view addSubview:contentView];
    adjustsScrollViewInsets(contentView);
    
    [contentView addSubview:self.mapView];
}

- (void)setupDateView {
    WTWeakSelf;
    WTCaseDateView *dateView = [[WTCaseDateView alloc] initWithFrame:HYXScreenBounds];
    dateView.dateBlock = ^(NSString *dateStr) {
        weakSelf.chosenDateStr = dateStr;
        weakSelf.listView.chosenDateStr = dateStr;
        [weakSelf loadData];
    };
    [HYXRootViewController.view addSubview:dateView];
}

- (void)configNotification {
    HYXNote_ADD(kMyCaseTransferNote, receiveMyCaseTransferNote:);
    HYXNote_ADD(kMyCaseAddSignNote, receiveMyCaseAddSignNote:);
    HYXNote_ADD(kMyCaseListGuideRouteNote, receiveMyCaseListGuideRouteNote:);
    HYXNote_ADD(kGetReadMessageNote, receiveReadMessageNote);
    HYXNote_ADD(kGetUnreadMessageNote, receiveUnreadMessageNote);
    HYXNote_ADD(kClearDiskNote, receiveClearDiskNote);
    HYXNote_ADD(kMyCaseDeliverCallNote, receiveCallNote:);
    HYXNote_ADD(kMyCaseGeoUpdate, receiveGeoUpdate:);
}
- (void)dealloc {
    HYXNote_REMOVE();
}

- (void)loadData {
    WTWeakSelf;
    [SVProgressHUD show];
    geoCount = 0;
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"userId"] = [WTAccountManager sharedManager].userId;
    if (self.chosenDateStr.length) {
        paras[@"dateString"] = self.chosenDateStr;
    }
    
    WTMyCaseViewModel * caseModel = [WTMyCaseViewModel new];
    caseModel.isNeedPostNoti = YES;
    [caseModel dataByParameters:paras success:^(WTTotalModel *totalModel) {
        if (totalModel.code == 2) {
            [SVProgressHUD showErrorWithStatus:totalModel.message];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self logout];
            });
            
            return ;
        }
        weakSelf.totalModel = totalModel;
        weakSelf.listView.totalModel = totalModel;
//        weakSelf.mapView.totalModel = totalModel;
        [SVProgressHUD dismiss];
    } failure:^(NSError *error, NSString *message) {
        [SVProgressHUD dismiss];
        weakSelf.listView.totalModel = nil;
        weakSelf.mapView.totalModel = nil;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription?error.localizedDescription:@"请求失败"];
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
    // 退出列表中搜索框的第一响应者
    [self.view endEditing:YES];
    
    self.currentBtn.enabled = YES;
    button.enabled = NO;
    self.currentBtn = button;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.centerX = button.centerX;
    }];
    
    CGPoint offset = self.contentView.contentOffset;
    offset.x = self.contentView.width*button.tag;
    [self.contentView setContentOffset:offset animated:YES];
}

- (void)userClick {
    self.userView.userTableView.right = 0;
    self.userView.backgroundView.alpha = 0.0;
    [HYXRootViewController.view addSubview:self.userView];
    [UIView animateWithDuration:0.25 animations:^{
        self.userView.userTableView.x = 0;
        self.userView.backgroundView.alpha = 0.3;
    }];
}

- (void)receiveMyCaseTransferNote:(NSNotification *)note {
    WTMyCaseModel *caseModel = note.object;
    WTCaseTransferCodeController *transferVc = [[WTCaseTransferCodeController alloc] init];
    transferVc.caseModel = caseModel;
    [self.navigationController pushViewController:transferVc animated:YES];
}
- (void)receiveMyCaseAddSignNote:(NSNotification *)note {
    WTWeakSelf;
    WTMyCaseModel *caseModel = note.object;
    WTMyCaseSignController *signVc = [[WTMyCaseSignController alloc] init];
    signVc.caseModel = caseModel;
    signVc.groupID = caseModel.groupId;
    signVc.addSignBlock = ^{
        for (NSInteger i = 0; i < weakSelf.totalModel.data.count; i++) {
            WTMyCaseModel *model = weakSelf.totalModel.data[i];
            if ([model.groupId isEqualToString:caseModel.groupId]) {
                [weakSelf.totalModel.data removeObject:model];
                i--;
            }
        }
        weakSelf.listView.totalModel = weakSelf.totalModel;
        weakSelf.mapView.totalModel = weakSelf.totalModel;
    };
    [self.navigationController pushViewController:signVc animated:YES];
}


- (void)receiveMyCaseListGuideRouteNote:(NSNotification *)note {
    _caseModel = note.object;
    self.naviObj.tableView.userInteractionEnabled = YES;
    _pop = [KLCPopup popupWithContentView:self.naviObj.tableView];
    _pop.showType = KLCPopupShowTypeSlideInFromBottom;
    _pop.dismissType = KLCPopupDismissTypeSlideOutToBottom;
    [_pop showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
}

#pragma mark - WTNavigationChooseObjDelegate
-(void)yc_navigationChooseAreaCard:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _naviObj.tableView.userInteractionEnabled = NO;
    [_pop dismiss:YES];
    
    BOOL canOpen = [WTNavigationModel turnToThirdPartRouteWithDestLat:_caseModel.lat destLng:_caseModel.lng address:_caseModel.detailAddr mapType:indexPath.row];
    
    if (!canOpen) {
        if ([WTAccountManager sharedManager].traffic == WTTrafficTypeBus) {
            [SVProgressHUD showWithStatus:@"路线规划中..."];
            
            AMapTransitRouteSearchRequest *navi = [[AMapTransitRouteSearchRequest alloc] init];
            navi.requireExtension = YES;
#warning hyx_cityName
            navi.city             = [WTLocationManager shareInstance].currentCity;
            //        navi.city             = @"昆明";
            /* 出发点. */
            navi.origin           = [AMapGeoPoint locationWithLatitude:[WTLocationManager shareInstance].latitude longitude:[WTLocationManager shareInstance].longitude];
            /* 目的地. */
            navi.destination      = [AMapGeoPoint locationWithLatitude:_caseModel.lat longitude:_caseModel.lng];
            [self.search AMapTransitRouteSearch:navi];
        } else {
            
            WTMyCaseNaviController *naviCtrl = [[WTMyCaseNaviController alloc] init];
            naviCtrl.caseModel = _caseModel;
            [self.navigationController pushViewController:naviCtrl animated:YES];
        }
    }
}

- (void)receiveUnreadMessageNote {
    self.msgRedView.right = self.userBtn.width;
    [self.userBtn addSubview:self.msgRedView];
    
    if (_userView) {
        [self.userView.userTableView reloadData];
    }
}
- (void)receiveReadMessageNote {
    [self checkRedMsgView];
    
    if (_userView) {
        [self.userView.userTableView reloadData];
    }
}
- (void)receiveClearDiskNote {
    if (_userView) {
        [self.userView.userTableView reloadData];
    }
}
- (void)receiveCallNote:(NSNotification *)note {
    NSString *phoneNum = (NSString *)note.object;
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phoneNum];
    /// 10及其以上系统
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        /// 10以下系统
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}


- (void)receiveGeoUpdate:(NSNotification *)noti{
    WTMyCaseModel * model = noti.object;
    if (model.isNeedPostNoti == NO) {
        return;
    }
    geoCount++;
    if (geoCount >= model.count||_mapView.totalModel) {
        [self.mapView clearMap];
        self.mapView.totalModel = self.totalModel;
    }
    NSLog(@"%d",geoCount);
}

/**
 检查是否有未读消息
 */
- (void)checkRedMsgView {
    NSArray *msgArr = [[WTMessageManager shareManager] getMessageWithIndex:0 count:100];
    NSInteger unreadCount = 0;
    for (WTMessageModel *msgModel in msgArr) {
        if (msgModel.isUnread) {
            unreadCount++;
        }
    }
    if (unreadCount) {
        self.msgRedView.right = self.userBtn.width;
        [self.userBtn addSubview:self.msgRedView];
    } else {
        if (_msgRedView) {
            [self.msgRedView removeFromSuperview];
        }
    }
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 当前索引
    NSInteger index = self.contentView.contentOffset.x / scrollView.width;
    
    switch (index) {
        case 0:
        {
            self.totalModel = self.listView.totalModel;
            self.mapView.totalModel = self.totalModel;
            self.mapView.x = self.contentView.contentOffset.x;
            [self.contentView addSubview:self.mapView];
        }
            break;
        case 1:
        {
            self.listView.x = self.contentView.contentOffset.x;
            [self.contentView addSubview:self.listView];
        }
            break;
        default:
            break;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:self.contentView];
    
    // 点击按钮
    NSInteger index = self.contentView.contentOffset.x / scrollView.width;
    
    if (index == 0) {
        [self titleClick:self.mapBtn];
    } else {
        [self titleClick:self.listBtn];
    }
}

#pragma mark - <WTMyCaseUserViewDelegate>
- (void)userViewWillBeHidden:(WTMyCaseUserView *)userView {
    [UIView animateWithDuration:0.25 animations:^{
        self.userView.userTableView.right = 0;
        self.userView.backgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.userView removeFromSuperview];
    }];
}

/*
- (void)pushModifyPasswordController:(WTMyCaseUserView *)userView {
//    NSDictionary *paras = @{@"mobile" : [WTAccountManager sharedManager].phoneNum, @"type" : kVerifyTypeModify};
//    [[[WTLoginViewModel alloc] init] getVerifyCodeWithParas:paras success:^(id obj) {
//
//    } failure:^(NSError *error, NSString *message) {
//HYXLog(@"error  %@",error);
//    }];
    WTModifyPwdController *modifyVc = [[WTModifyPwdController alloc] init];
    [self.navigationController pushViewController:modifyVc animated:YES];
}
 */
- (void)pushUserMessageController:(WTMyCaseUserView *)userView {
    WTMyCaseMessageController *messageVc = [[WTMyCaseMessageController alloc] init];
    [self.navigationController pushViewController:messageVc animated:YES];
}
- (void)pushCaseArrivedController:(WTMyCaseUserView *)userView {
    WTMyCaseArrivedController *arrivedVc = [[WTMyCaseArrivedController alloc] init];
    [self.navigationController pushViewController:arrivedVc animated:YES];
}
- (void)pushTrafficChooseController:(WTMyCaseUserView *)userView {
    WTUserTrafficController *trafficVc = [[WTUserTrafficController alloc] init];
    [self.navigationController pushViewController:trafficVc animated:YES];
}

#pragma mark - <WTMyCaseListViewDelegate>
- (void)transferCaseToMateInListView:(WTMyCaseListView *)liseView currentModel:(WTMyCaseModel *)caseModel {
    WTCaseTransferCodeController *transferVc = [[WTCaseTransferCodeController alloc] init];
    transferVc.caseModel = caseModel;
    [self.navigationController pushViewController:transferVc animated:YES];
}

- (void)signCaseInListView:(WTMyCaseListView *)listView currentModel:(WTMyCaseModel *)caseModel {
    WTWeakSelf;
    WTMyCaseSignController *signVc = [[WTMyCaseSignController alloc] init];
    signVc.caseModel = caseModel;
    signVc.groupID = caseModel.groupId;
    signVc.addSignBlock = ^{
        for (NSInteger i = 0; i < weakSelf.totalModel.data.count; i++) {
            WTMyCaseModel *model = weakSelf.totalModel.data[i];
            if ([model.groupId isEqualToString:caseModel.groupId]) {
                [weakSelf.totalModel.data removeObject:model];
                i--;
            }
        }
        weakSelf.listView.totalModel = weakSelf.totalModel;
        weakSelf.mapView.totalModel = weakSelf.totalModel;
    };
    [self.navigationController pushViewController:signVc animated:YES];
}

#pragma mark - <WTMyCaseMapViewDelegate>
- (void)pushTakeBusController:(WTMyCaseMapView *)mapView bouteModel:(WTBusRouteModel *)routeModel {
    WTMyCaseByBusController *busVc = [[WTMyCaseByBusController alloc] init];
    busVc.busRouteModel = routeModel;
    [self.navigationController pushViewController:busVc animated:YES];
}

#pragma mark - <AMapSearchDelegate>
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    WTBusRouteModel *routeModel = [[WTBusRouteModel alloc] init];
    if ([request isKindOfClass:[AMapTransitRouteSearchRequest class]]) { //公交
        if (response.route.transits.count) {
            
            AMapTransit *transit = response.route.transits.firstObject;
            routeModel.walkingDistance = transit.walkingDistance;
            routeModel.duration = transit.duration/60.0;
            routeModel.lines = [NSMutableArray array];
            
            for (AMapSegment *segment in transit.segments) {
                WTBusLineModel *lineModel = [[WTBusLineModel alloc] init];
                lineModel.buses = [NSMutableArray array];
                
                NSArray *buslines = segment.buslines;
                for (AMapBusLine *busLine in buslines) {
                    WTBusStopModel *stopModel = [[WTBusStopModel alloc] init];
                    stopModel.lineName = [busLine.name componentsSeparatedByString:@"("].firstObject;
                    stopModel.departureStop = busLine.departureStop.name;
                    stopModel.arrivalStop = busLine.arrivalStop.name;
                    [lineModel.buses addObject:stopModel];
                }
                if (lineModel.buses.count) {
                    [routeModel.lines addObject:lineModel];
                }
            }
        }
    }
    
    [SVProgressHUD dismiss];
    
    if (routeModel.lines.count) {
        WTMyCaseByBusController *busVc = [[WTMyCaseByBusController alloc] init];
        busVc.busRouteModel = routeModel;
        [self.navigationController pushViewController:busVc animated:YES];
    } else {
        [SVProgressHUD showInfoWithStatus:@"距离太近，建议步行前往"];
    }
}
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    HYXLog(@"AMapSearchRequest__Error: %@", error);
    [SVProgressHUD dismiss];
}


@end
