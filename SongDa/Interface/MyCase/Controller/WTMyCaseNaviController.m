//
//  WTMyCaseNaviController.m
//  SongDa
//
//  Created by Fancy on 2018/4/17.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTMyCaseNaviController.h"
#import "WTMyCaseModel.h"

#import <AMapNaviKit/AMapNaviKit.h>

@interface WTMyCaseNaviController () <AMapNaviDriveViewDelegate,AMapNaviDriveManagerDelegate,AMapNaviRideManagerDelegate,AMapNaviRideViewDelegate,AMapNaviWalkManagerDelegate,AMapNaviWalkViewDelegate>

//---------导航---------
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

/** 是否从公交导航界面pop回（若是，则pop） */
@property (assign, nonatomic) BOOL                  isPopFromBusGuideVc;
@end

@implementation WTMyCaseNaviController

- (AMapNaviDriveView *)driveView
{
    if (_driveView == nil) {
        _driveView = [[AMapNaviDriveView alloc] initWithFrame:CGRectMake(0, IPhoneX_Status_Height, HYXScreenW, HYXScreenH-IPhoneX_Status_Height-IPhoneX_Bottom_Safe_Height)];
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
        _rideView = [[AMapNaviRideView alloc] initWithFrame:CGRectMake(0, IPhoneX_Status_Height, HYXScreenW, HYXScreenH-IPhoneX_Status_Height-IPhoneX_Bottom_Safe_Height)];
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
        _walkView = [[AMapNaviWalkView alloc] initWithFrame:CGRectMake(0, IPhoneX_Status_Height, HYXScreenW, HYXScreenH-IPhoneX_Status_Height-IPhoneX_Bottom_Safe_Height)];
        _walkView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _walkView.showMoreButton = NO;
        _walkView.delegate = self;
    }
    return _walkView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isPopFromBusGuideVc) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _isPopFromBusGuideVc = NO;
    
    [self setupStatusView];
    [self setupNavi];
}

- (void)setupStatusView {
    UIView *statusView = [[UIView alloc] init];
    statusView.backgroundColor = WTBlueColor;
    statusView.size = CGSizeMake(HYXScreenW, IPhoneX_Status_Height);
    [self.view addSubview:statusView];
}

- (void)setupNavi {
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:[WTLocationManager shareInstance].latitude longitude:[WTLocationManager shareInstance].longitude];
    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:self.caseModel.lat longitude:self.caseModel.lng];
    switch ([WTAccountManager sharedManager].traffic) {
        case WTTrafficTypeCar:
        {
            [AMapNaviDriveManager sharedInstance].delegate = self;
            [[AMapNaviDriveManager sharedInstance] addDataRepresentative:self.driveView];
            [self.view addSubview:self.driveView];
            [[AMapNaviDriveManager sharedInstance] calculateDriveRouteWithStartPoints:@[startPoint] endPoints:@[endPoint] wayPoints:nil drivingStrategy:AMapNaviDrivingStrategySingleDefault];
        }
            break;
        case WTTrafficTypeBus:
            break;
        case WTTrafficTypeBike:
        {
            [self.rideManager addDataRepresentative:self.rideView];
            [self.view addSubview:self.rideView];
            [self.rideManager calculateRideRouteWithStartPoint:startPoint endPoint:endPoint];
        }
            break;
        case WTTrafficTypeWalk:
        {
            [self.walkManager addDataRepresentative:self.walkView];
            [self.view addSubview:self.walkView];
            [self.walkManager calculateWalkRouteWithStartPoints:@[startPoint] endPoints:@[endPoint]];
        }
            break;
            
        default:
            break;
    }
}

- (void)dealloc {
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
}

#pragma mark - <AMapNaviDriveViewDelegate>
- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView {
    //    [[AMapNaviDriveManager sharedInstance] stopNavi];
    //    [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:self.driveView];
    //    [[AMapNaviDriveManager sharedInstance] setDelegate:nil];
    //    [AMapNaviDriveManager destroyInstance];
    //    [self.driveView removeFromSuperview];
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - <AMapNaviDriveManagerDelegate>
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager {
    [driveManager startGPSNavi];
}

#pragma mark - <AMapNaviRideViewDelegate>
- (void)rideViewCloseButtonClicked:(AMapNaviRideView *)rideView {
//    [self.rideManager stopNavi];
//    [self.rideManager removeDataRepresentative:self.rideView];
//    [self.rideManager setDelegate:nil];
//    self.rideManager = nil;
//    [self.rideView removeFromSuperview];
    
    [self.navigationController popViewControllerAnimated:YES];
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
//    [self.walkManager stopNavi];
//    [self.walkManager removeDataRepresentative:self.walkView];
//    [self.walkManager setDelegate:nil];
//    self.walkManager = nil;
//    [self.walkView removeFromSuperview];
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - <AMapNaviWalkManagerDelegate>
- (void)walkManagerOnCalculateRouteSuccess:(AMapNaviWalkManager *)walkManager {
    [self.walkManager startGPSNavi];
}
- (void)walkManager:(AMapNaviWalkManager *)walkManager onCalculateRouteFailure:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:@"路线规划失败！\n请选择合适的交通工具~"];
}

@end
