//
//  WTMyCaseMapView.m
//  SongDa
//
//  Created by Fancy on 2018/3/27.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTMyCaseMapView.h"
#import "WTMyCaseModel.h"
#import "WTMyCaseSearchModel.h"
#import "WTAnnotationView.h"
#import "WTAnnotation.h"
#import "WTSearchAnnotation.h"
#import "WTMyCaseSearchController.h"
#import "WTMyCaseSearchModel.h"
#import "WTBusRouteModel.h"
#import "WTCaseTransferDelivererViewModel.h"
#import "WTCaseTransferDelivererModel.h"

#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "WTNavigationChooseObj.h"
#import "WTNavigationModel.h"
#import "KLCPopup.h"

@interface WTMyCaseMapView () <MAMapViewDelegate,AMapSearchDelegate,AMapNaviDriveViewDelegate,AMapNaviDriveManagerDelegate,AMapNaviRideManagerDelegate,AMapNaviRideViewDelegate,AMapNaviWalkManagerDelegate,AMapNaviWalkViewDelegate,WTNavigationChooseObjDelegate>
@property (strong, nonatomic) KLCPopup              *pop;
/** 案件简介view */
@property (strong, nonatomic) UIView                *caseDescripView;
@property (strong, nonatomic) NSMutableArray        *annotationsArrM;
@property (strong, nonatomic) NSMutableArray        *annotationsDeliverArrM;
@property (strong, nonatomic) UIButton              *routBtn;
@property (strong, nonatomic) WTNavigationChooseObj * naviObj;
/** 排序后的模型数组 */
@property (strong, nonatomic) NSMutableArray        *sortedArrM;
/** 定时器 */
@property (strong, nonatomic) YYTimer               *timer;
/** 公交搭乘模型 */
@property (strong, nonatomic) WTBusRouteModel       *busRouteModel;
/** 案件折线 */
@property (strong, nonatomic) MAPolyline            *polyline;
@property (assign, nonatomic) NSInteger             routeChangeTime;

//---------导航---------
/** 导航起点 */
@property (nonatomic, strong) AMapNaviPoint         *startPoint;
/** 导航终点 */
@property (nonatomic, strong) AMapNaviPoint         *endPoint;
/** 驾车导航界面 */
@property (nonatomic, strong) AMapNaviDriveView     *driveView;
/** 骑行导航管理类 */
@property (strong, nonatomic) AMapNaviRideManager   *rideManager;
/** 骑行导航界面 */
@property (strong, nonatomic) AMapNaviRideView      *rideView;
/** 步行导航管理类 */
@property (strong, nonatomic) AMapNaviWalkManager   *walkManager;
/** 步行导航界面 */
@property (strong, nonatomic) AMapNaviWalkView      *walkView;

/** 地图搜索类 */
@property (strong, nonatomic) AMapSearchAPI         *search;

/** 周边搜索annotatian */
@property (strong, nonatomic) WTSearchAnnotation    *searchAnnotation;
@end

@implementation WTMyCaseMapView

{
    MAMapView *_mapView;
    WTMyCaseModel * _caseModel;
    WTMyCaseSearchModel * _searchModel;
    
    NSTimer * _updateDeliverTimer;
}
static NSString * const reusableUserId = @"WTDeliverUserLocation";
static NSString * const reusableId = @"WTCaseLocation";
static NSString * const aroundId = @"WTAroundId";
static NSString * const deliverId = @"WTDeliverId";

- (NSMutableArray *)annotationsArrM
{
    if (_annotationsArrM == nil) {
        _annotationsArrM = [NSMutableArray array];
    }
    return _annotationsArrM;
}

- (NSMutableArray *)annotationsDeliverArrM{
    if (!_annotationsDeliverArrM) {
        _annotationsDeliverArrM = [NSMutableArray array];
    }
    return _annotationsDeliverArrM;
}

- (WTSearchAnnotation *)searchAnnotation
{
    if (_searchAnnotation == nil) {
        _searchAnnotation = [[WTSearchAnnotation alloc] init];
        _searchAnnotation.title = @"周边";
    }
    return _searchAnnotation;
}

- (WTNavigationChooseObj *)naviObj{
    if (!_naviObj) {
        _naviObj = [WTNavigationChooseObj new];
        _naviObj.delegate = self;
        _naviObj.tableView.frame = CGRectMake(0, 0, HYXScreenW, 44 * 2 + IPhoneX_Bottom_Safe_Height);
    }
    return _naviObj;
}

- (UIButton *)routBtn
{
    if (_routBtn == nil) {
        _routBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_routBtn setBackgroundImage:HYXImage(@"tabBar_caseCode") forState:UIControlStateNormal];
        [_routBtn setTitle:@"更换\n线路" forState:UIControlStateNormal];
        _routBtn.titleLabel.numberOfLines = 2;
        _routBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_routBtn sizeToFit];
        [_routBtn addTarget:self action:@selector(changeRout) forControlEvents:UIControlEventTouchUpInside];
    }
    return _routBtn;
}

- (AMapSearchAPI *)search
{
    if (_search == nil) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}
- (AMapNaviDriveView *)driveView
{
    if (_driveView == nil) {
        _driveView = [[AMapNaviDriveView alloc] initWithFrame:self.bounds];
        _driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _driveView.showMoreButton = NO;
        _driveView.delegate = self;
    }
    return _driveView;
}
- (AMapNaviRideManager *)rideManager
{
    if (_rideManager == nil) {
        _rideManager = [[AMapNaviRideManager alloc] init];
        _rideManager.delegate = self;
    }
    return _rideManager;
}
- (AMapNaviRideView *)rideView {
    if (_rideView == nil) {
        _rideView = [[AMapNaviRideView alloc] initWithFrame:self.bounds];
        _rideView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _rideView.showMoreButton = NO;
        _rideView.delegate = self;
    }
    return _rideView;
}
- (AMapNaviWalkManager *)walkManager
{
    if (_walkManager == nil) {
        _walkManager = [[AMapNaviWalkManager alloc] init];
        _walkManager.delegate = self;
    }
    return _walkManager;
}
- (AMapNaviWalkView *)walkView {
    if (_walkView == nil) {
        _walkView = [[AMapNaviWalkView alloc] initWithFrame:self.bounds];
        _walkView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _walkView.showMoreButton = NO;
        _walkView.delegate = self;
    }
    return _walkView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        
        [self configNotification];
    }
    return self;
}

- (void)setupUI {
    _mapView = [[MAMapView alloc] initWithFrame:self.bounds];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.distanceFilter = 100;
    _mapView.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    [self addSubview:_mapView];
    
//    MACoordinateSpan span = MACoordinateSpanMake(0.1, 0.1);
//    CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake([WTLocationManager shareInstance].latitude, [WTLocationManager shareInstance].longitude);
//    MACoordinateRegion region = MACoordinateRegionMake(coordinate2D, span);
//    [_mapView setRegion:region];
    
    // 周边
    UIView *aroundView = [[UIView alloc] init];
    aroundView.backgroundColor = [UIColor whiteColor];
    aroundView.size = CGSizeMake(HYXScreenW, 44);
    aroundView.bottom = self.height;
    [self addSubview:aroundView];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:HYXImage(@"caseCenter_search") forState:UIControlStateNormal];
    [searchBtn setTitle:@"搜索周边" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    searchBtn.size = CGSizeMake(HYXScreenW*0.5, aroundView.height);
    searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [aroundView addSubview:searchBtn];
    
    UIButton *dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dateBtn setTitle:@"最迟上门时间" forState:UIControlStateNormal];
    [dateBtn setTitleColor:searchBtn.currentTitleColor forState:UIControlStateNormal];
    dateBtn.titleLabel.font = searchBtn.titleLabel.font;
    [dateBtn addTarget:self action:@selector(dateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    dateBtn.size = searchBtn.size;
    dateBtn.right = aroundView.width;
    [aroundView addSubview:dateBtn];
    
    UIView *separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    separateLine.size = CGSizeMake(0.5, 20);
    separateLine.x = dateBtn.x;
    separateLine.centerY = aroundView.height*0.5;
    [aroundView addSubview:separateLine];
    
    // 更换线路
    self.routBtn.right = self.width-10;
    self.routBtn.bottom = aroundView.y-50;
    [self addSubview:self.routBtn];
    
    
    _updateDeliverTimer = [NSTimer scheduledTimerWithTimeInterval:3 * 60 + 5 target:self selector:@selector(addDeliverSign) userInfo:nil repeats:YES];
    [_updateDeliverTimer fire];
}

- (void)configNotification {
    HYXNote_ADD(kMyCaseMapGuideRouteNote, receiveMyCaseGuideRouteNote:);
    HYXNote_ADD(kMyCaseAroundGuideRouteNote, receiveMyCaseAroundRouteNote:);
}

//TODO: 添加送达员位置标记
- (void)addDeliverSign {
    NSMutableDictionary * param = [NSMutableDictionary new];
    param[@"userId"] = [WTAccountManager sharedManager].userId;
    [[[WTCaseTransferDelivererViewModel alloc] init] dataByParameters:param success:^(WTTotalModel *totalModel) {
         [_mapView removeAnnotations:self.annotationsDeliverArrM];
        [self.annotationsDeliverArrM removeAllObjects];
        
        for (WTCaseTransferDelivererModel *model in totalModel.data) {
            if (![model.delivereId isEqualToString:[WTAccountManager sharedManager].userId]) {
                if (model.lng != 0 && model.lat != 0) {
                    WTAnnotation *pointAnnotation = [[WTAnnotation alloc] init];
                    pointAnnotation.title = @"送达员";
                    pointAnnotation.coordinate = CLLocationCoordinate2DMake(model.lat, model.lng);
                    pointAnnotation.mapDeliverModel = model;
                    [_mapView addAnnotation:pointAnnotation];
                    [self.annotationsDeliverArrM addObject:pointAnnotation];
                   
                }
            }
        }
    } failure:^(NSError *error, NSString *message) {
        HYXLog(@"error  %@",error);
    }];
}

- (void)clearMap{
    [_mapView removeAnnotations:self.annotationsArrM];
    [self.annotationsArrM removeAllObjects];
    self.annotationsArrM = nil;
    [_mapView removeOverlay:self.polyline];
}

- (void)setTotalModel:(WTTotalModel *)totalModel {
    _totalModel = totalModel;

    if (totalModel.data.count) {//添加大头针
        [self drawCaseLine];
//        [self.timer invalidate];
//        if ([self isGeocoded]) {
//            [self drawCaseLine];
//        } else {
//            self.timer = [YYTimer timerWithTimeInterval:1.0 target:self selector:@selector(judgeIsGeocoded) repeats:YES];
//            [self.timer fire];
//        }
    } else {//移除已添加的大头针
        [_mapView removeAnnotations:self.annotationsArrM];
        [self.annotationsArrM removeAllObjects];
        self.annotationsArrM = nil;
        [_mapView removeOverlay:self.polyline];
    }
}

/**
 是否地理编码完成
 */
- (BOOL)isGeocoded {
    NSInteger index1 = arc4random_uniform((int)self.totalModel.data.count);
    WTMyCaseModel *model1 = self.totalModel.data[index1];
    
    NSInteger index2 = arc4random_uniform((int)self.totalModel.data.count);
    WTMyCaseModel *model2 = self.totalModel.data[index2];
    
    return model1.lat != 0 && model1.lng != 0 && model2.lat != 0 && model2.lng != 0;
}
- (void)judgeIsGeocoded {
    if ([self isGeocoded]) {
        [self drawCaseLine];
    }
}
/**
 绘制案件连线
 */
- (void)drawCaseLine {
    if (self.annotationsArrM.count) {// 移除之前添加的大头针
        [_mapView removeAnnotations:self.annotationsArrM];
        [self.annotationsArrM removeAllObjects];
        self.annotationsArrM = nil;
        [_mapView removeOverlay:self.polyline];
    }
    
    NSInteger count = self.totalModel.data.count+1;
    CLLocationCoordinate2D coordinates[count];
    coordinates[0] = _mapView.userLocation.coordinate;
    NSMutableArray *sortArrM = [self.totalModel.data mutableCopy];
    [sortArrM sortUsingComparator:^NSComparisonResult(WTMyCaseModel *caseModel1, WTMyCaseModel *caseModel2) {
        return [@(caseModel1.distance) compare:@(caseModel2.distance)];
    }];

    self.sortedArrM = [NSMutableArray arrayWithArray:sortArrM];
    for (NSInteger i = 0; i < sortArrM.count; i++) {
        WTMyCaseModel *caseModel = sortArrM[i];
        WTAnnotation *pointAnnotation = [[WTAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(caseModel.lat, caseModel.lng);
        pointAnnotation.caseModel = caseModel;
        [_mapView addAnnotation:pointAnnotation];
        [self.annotationsArrM addObject:pointAnnotation];

        coordinates[i+1] = pointAnnotation.coordinate;
    }

    // 绘制折现
    self.polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
    [_mapView addOverlay:self.polyline];
    
    [self.timer invalidate];
}

/* 更换路线 */
- (void)changeRout {
    NSInteger count = self.totalModel.data.count+1;
    if (count > 2) {
        CLLocationCoordinate2D coordinates[count];
        coordinates[0] = _mapView.userLocation.coordinate;
//        coordinates[0] = CLLocationCoordinate2DMake([WTLocationManager shareInstance].latitude, [WTLocationManager shareInstance].longitude);
        NSMutableArray *pointsArrM = [NSMutableArray array];
        [self.annotationsArrM removeAllObjects];
        self.annotationsArrM = nil;
        self.routeChangeTime++;
        NSInteger plus = self.totalModel.data.count>2?3:2;
        switch (self.routeChangeTime%plus) {
            case 0:
                [pointsArrM addObjectsFromArray:self.sortedArrM];
                break;
            case 1:
            {
                [pointsArrM addObjectsFromArray:self.sortedArrM];
                if (pointsArrM.count == 2) {
                    [pointsArrM exchangeObjectAtIndex:0 withObjectAtIndex:1];
                } else {
                    [pointsArrM exchangeObjectAtIndex:0 withObjectAtIndex:pointsArrM.count-1];
                }
            }
                break;
            case 2:
                if (self.totalModel.isSorted) {
                    [pointsArrM addObjectsFromArray:self.sortedArrM];
                    [pointsArrM exchangeObjectAtIndex:0 withObjectAtIndex:pointsArrM.count-2];
                } else {
                    [pointsArrM addObjectsFromArray:self.totalModel.data];
                }
                break;
                
            default:
                break;
        }
        
        for (NSInteger i = 0; i < pointsArrM.count; i++) {
            WTMyCaseModel *caseModel = pointsArrM[i];
            WTAnnotation *pointAnnotation = [[WTAnnotation alloc] init];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(caseModel.lat, caseModel.lng);
            pointAnnotation.caseModel = caseModel;
            [_mapView addAnnotation:pointAnnotation];
            [self.annotationsArrM addObject:pointAnnotation];
            
            coordinates[i+1] = pointAnnotation.coordinate;
        }
        
        // 重绘折现
        [self.polyline setPolylineWithCoordinates:coordinates count:count];
    }
}
/* 搜索周边 */
- (void)searchClick {
    // 移除callout
    WTAnnotationView *searchAnnotationView = (WTAnnotationView *)[_mapView viewForAnnotation:self.searchAnnotation];
    searchAnnotationView.selected = NO;
    for (WTAnnotation *annotation in self.annotationsArrM) {
        MAAnnotationView *annotationView = [_mapView viewForAnnotation:annotation];
        annotationView.selected = NO;
    }
    
    WTWeakSelf;
    WTMyCaseSearchController *searchVc = [[WTMyCaseSearchController alloc] init];
    searchVc.searchBlock = ^(WTMyCaseSearchModel *searchModel) {
        // 移除之前锚点
        [_mapView removeAnnotation:weakSelf.searchAnnotation];
        
        // 搜索锚点模型重新赋值
        weakSelf.searchAnnotation.searchModel = searchModel;
        weakSelf.searchAnnotation.coordinate = CLLocationCoordinate2DMake(searchModel.lat, searchModel.lng);
        [_mapView addAnnotation:weakSelf.searchAnnotation];
        
        // 设置搜索中心
        MACoordinateSpan span = MACoordinateSpanMake(0.01, 0.01);
        MACoordinateRegion region = MACoordinateRegionMake(CLLocationCoordinate2DMake(searchModel.lat, searchModel.lng), span);
        [_mapView setRegion:region animated:YES];
    };
    [HYXRootViewController presentViewController:searchVc animated:YES completion:nil];
}

- (void)dateBtnClick {
    if (self.dateChoseBlock) {
        self.dateChoseBlock();
    }
}

//TODO: 开始导航
- (void)receiveMyCaseGuideRouteNote:(NSNotification *)note {
    _caseModel = note.object;
    self.naviObj.type = 0;
    self.naviObj.tableView.userInteractionEnabled = YES;
    _pop = [KLCPopup popupWithContentView:self.naviObj.tableView];
    _pop.showType = KLCPopupShowTypeSlideInFromBottom;
    _pop.dismissType = KLCPopupDismissTypeSlideOutToBottom;
    [_pop showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
    
}

- (void)receiveMyCaseAroundRouteNote:(NSNotification *)note {
    _searchModel = note.object;
    self.naviObj.tableView.userInteractionEnabled = YES;
    self.naviObj.type = 1;
    _pop = [KLCPopup popupWithContentView:self.naviObj.tableView];
     _pop.showType = KLCPopupShowTypeSlideInFromBottom;
     _pop.dismissType = KLCPopupDismissTypeSlideOutToBottom;
     [_pop showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
}

#pragma mark - WTNavigationChooseObjDelegate
-(void)yc_navigationChooseAreaCard:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.naviObj.tableView.userInteractionEnabled = NO;
    [_pop dismiss:YES];
    if (self.naviObj.type == 0) {
        [self naviRouteWithDestLat:_caseModel.lat destLng:_caseModel.lng address:_caseModel.detailAddr type:indexPath.row];
    }
    else{
        [self naviRouteWithDestLat:_searchModel.lat destLng:_searchModel.lng address:_searchModel.address type:indexPath.row];
    }
    
}

//TODO:导航
- (void)naviRouteWithDestLat:(CGFloat)destLat destLng:(CGFloat)destLng address:(NSString *)adress type:(YCMapType)type{

    BOOL canOpen = [WTNavigationModel turnToThirdPartRouteWithDestLat:destLat destLng:destLng address:adress mapType:type];
    
    if (canOpen) {
        return;
    }
    
    self.startPoint = [AMapNaviPoint locationWithLatitude:[WTLocationManager shareInstance].latitude longitude:[WTLocationManager shareInstance].longitude];
    self.endPoint = [AMapNaviPoint locationWithLatitude:destLat longitude:destLng];
    
    switch ([WTAccountManager sharedManager].traffic) {
        case WTTrafficTypeCar:
        {
            if (self.driveView.superview) {
                return;
            }
            [AMapNaviDriveManager sharedInstance].delegate = self;
            [[AMapNaviDriveManager sharedInstance] addDataRepresentative:self.driveView];
            [self addSubview:self.driveView];
            [[AMapNaviDriveManager sharedInstance] calculateDriveRouteWithStartPoints:@[self.startPoint] endPoints:@[self.endPoint] wayPoints:nil drivingStrategy:AMapNaviDrivingStrategySingleDefault];
        }
            break;
        case WTTrafficTypeBus:
        {
            AMapTransitRouteSearchRequest *navi = [[AMapTransitRouteSearchRequest alloc] init];
            navi.requireExtension = YES;
#warning hyx_cityName
            navi.city             = [WTLocationManager shareInstance].currentCity;
//            navi.city             = @"昆明";
            /* 出发点. */
            navi.origin = [AMapGeoPoint locationWithLatitude:[WTLocationManager shareInstance].latitude longitude:[WTLocationManager shareInstance].longitude];
            /* 目的地. */
            navi.destination = [AMapGeoPoint locationWithLatitude:destLat longitude:destLng];
            [self.search AMapTransitRouteSearch:navi];
        }
            break;
        case WTTrafficTypeBike:
        {
            if (self.rideView.superview) {
                return;
            }
            [self.rideManager addDataRepresentative:self.rideView];
            [self addSubview:self.rideView];
            [self.rideManager calculateRideRouteWithStartPoint:self.startPoint endPoint:self.endPoint];
        }
            break;
        case WTTrafficTypeWalk:
        {
            if (self.walkView.superview) {
                return;
            }
            [self.walkManager addDataRepresentative:self.walkView];
            [self addSubview:self.walkView];
            [self.walkManager calculateWalkRouteWithStartPoints:@[self.startPoint] endPoints:@[self.endPoint]];
        }
            break;
            
        default:
            break;
    }
}

- (void)dealloc {
    HYXNote_REMOVE();
    
    if (_driveView) {
        [[AMapNaviDriveManager sharedInstance] stopNavi];
        [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:self.driveView];
        [[AMapNaviDriveManager sharedInstance] setDelegate:nil];
        [AMapNaviDriveManager destroyInstance];
    }
    if (_rideView) {
        [self.rideManager stopNavi];
        [self.rideManager removeDataRepresentative:self.rideView];
        [self.rideManager setDelegate:nil];
        self.rideManager = nil;
    }
    if (_walkView) {
        [self.walkManager stopNavi];
        [self.walkManager removeDataRepresentative:self.walkView];
        [self.walkManager setDelegate:nil];
        self.walkManager = nil;
    }
    
    [self.timer invalidate];
}

#pragma mark - <MAMapViewDelegate>
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
//        MAAnnotationView *userView = [mapView dequeueReusableAnnotationViewWithIdentifier:reusableUserId];
//        if (userView == nil) {
//            userView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reusableUserId];
//        }
//        userView.image = HYXImage(@"map_sign");
//        userView.canShowCallout = YES;
//        return userView;
        return nil;
    } else if ([annotation.title isEqualToString:@"周边"]) {
        WTAnnotationView *annotationView = (WTAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:aroundId];
        if (annotationView == nil) {
            annotationView = [[WTAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:aroundId];
        }
        annotationView.image = HYXImage(@"map_sign");
        annotationView.canShowCallout = NO;
        WTSearchAnnotation *customAnnotation = (WTSearchAnnotation *)annotation;
        annotationView.searchModel = customAnnotation.searchModel;
        return annotationView;
    } else if ([annotation.title isEqualToString:@"送达员"]) {
        WTAnnotationView *annotationView = (WTAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:deliverId];
        if (annotationView == nil) {
            annotationView = [[WTAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:deliverId];
        }
        annotationView.image = HYXImage(@"summoner");
        annotationView.canShowCallout = NO;
        WTAnnotation *customAnnotation = (WTAnnotation *)annotation;
        annotationView.mapDeliverModel = customAnnotation.mapDeliverModel;
        return annotationView;
    } else {
        WTAnnotationView *annotationView = (WTAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reusableId];
        if (annotationView == nil) {
            annotationView = [[WTAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reusableId];
        }
        annotationView.image = HYXImage(@"map_location");
        annotationView.canShowCallout = NO;
        WTAnnotation *customAnnotation = (WTAnnotation *)annotation;
        annotationView.caseModel = customAnnotation.caseModel;
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -12);
        return annotationView;
    }
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        polylineRenderer.lineWidth    = 5.f;
        polylineRenderer.strokeColor  = WTBlueColor;
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapArrow;
        return polylineRenderer;
    }
    return nil;
}

//- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
////    // 定位箭头随方向旋转
////    MAAnnotationView *annotationView = [mapView viewForAnnotation:userLocation];
////    if (!updatingLocation && annotationView != nil) {
////        double degree = userLocation.heading.trueHeading-mapView.rotationDegree;
////        [UIView animateWithDuration:0.25 animations:^{
////            annotationView.transform = CGAffineTransformMakeRotation(degree*M_PI/180.0);
////        }];
////    }
//
//    NSInteger count = self.totalModel.data.count+1;
//    CLLocationCoordinate2D coordinates[count];
//    coordinates[0] = userLocation.coordinate;
//
//    NSMutableArray *sortArrM = [self.sortedArrM mutableCopy];
//    for (NSInteger i = 0; i < sortArrM.count; i++) {
//        WTMyCaseModel *caseModel = sortArrM[i];
//        WTAnnotation *pointAnnotation = [[WTAnnotation alloc] init];
//        pointAnnotation.coordinate = CLLocationCoordinate2DMake(caseModel.lat, caseModel.lng);
//        pointAnnotation.caseModel = caseModel;
//        [_mapView addAnnotation:pointAnnotation];
//        [self.annotationsArrM addObject:pointAnnotation];
//
//        coordinates[i+1] = pointAnnotation.coordinate;
//    }
//
//    // 绘制折现
//    [self.polyline setPolylineWithCoordinates:coordinates count:count];
//}

#pragma mark - <AMapSearchDelegate>
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    WTBusRouteModel *routeModel = [[WTBusRouteModel alloc] init];
    self.busRouteModel = routeModel;
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

    if (self.busRouteModel.lines.count) {
        if (_delegate && [_delegate respondsToSelector:@selector(pushTakeBusController:bouteModel:)]) {
            [_delegate pushTakeBusController:self bouteModel:self.busRouteModel];
        }
    }
    HYXLog(@"%@",response);
}
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    HYXLog(@"AMapSearchRequest__Error: %@", error);
}

#pragma mark - <AMapNaviDriveViewDelegate>
- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView {
    [[AMapNaviDriveManager sharedInstance] stopNavi];
    [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:self.driveView];
    [[AMapNaviDriveManager sharedInstance] setDelegate:nil];
    
    [self.driveView removeFromSuperview];
    
    BOOL success = [AMapNaviDriveManager destroyInstance];
    HYXLog(@"导航单例是否销毁成功 : %d",success);
}
#pragma mark - <AMapNaviDriveManagerDelegate>
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager {
    [[AMapNaviDriveManager sharedInstance] startGPSNavi];
}

#pragma mark - <AMapNaviRideViewDelegate>
- (void)rideViewCloseButtonClicked:(AMapNaviRideView *)rideView {
    [self.rideManager stopNavi];
    [self.rideManager removeDataRepresentative:self.rideView];
    [self.rideManager setDelegate:nil];
    self.rideManager = nil;
    
    [self.rideView removeFromSuperview];
}
#pragma mark - <AMapNaviRideManagerDelegate>
- (void)rideManagerOnCalculateRouteSuccess:(AMapNaviRideManager *)rideManager {
    [self.rideManager startGPSNavi];
}
- (void)rideManager:(AMapNaviRideManager *)rideManager onCalculateRouteFailure:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:@"路线规划失败！\n请选择合适的交通工具~"];
}

#pragma mark - <AMapNaviWalkViewDelegate>
- (void)walkViewCloseButtonClicked:(AMapNaviWalkView *)walkView {
    [self.walkManager stopNavi];
    [self.walkManager removeDataRepresentative:self.walkView];
    [self.walkManager setDelegate:nil];
    self.walkManager = nil;
    
    [self.walkView removeFromSuperview];
}
#pragma mark - <AMapNaviWalkManagerDelegate>
- (void)walkManagerOnCalculateRouteSuccess:(AMapNaviWalkManager *)walkManager {
    [self.walkManager startGPSNavi];
}
- (void)walkManager:(AMapNaviWalkManager *)walkManager onCalculateRouteFailure:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:@"路线规划失败！\n请选择合适的交通工具~"];
}

@end
