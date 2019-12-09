//
//  WTCaseCenterMapController.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/25.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseCenterMapController.h"
#import "WTCaseCenterModel.h"
#import "WTAnnotation.h"
#import "WTAnnotationView.h"
#import "WTAddressGetViewModel.h"
#import "WTAddressModel.h"
#import "WTCaseDeliverModel.h"

//#import <AMapFoundationKit/AMapFoundationKit.h>
//#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>

@interface WTCaseCenterMapController () <MAMapViewDelegate>

@end

@implementation WTCaseCenterMapController

{
    MAMapView *_mapView;
}
static NSString * const ID = @"reuseable";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"送达员位置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupMapView];
    HYXNote_ADD(kCaseCenterDeliverCallNote, receiveCallNote:);
}

- (void)setupMapView {
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.showsUserLocation = NO;
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow  animated:YES];
    [self.view addSubview:_mapView];
    
    WTWeakSelf;
    NSDictionary *paras = @{@"ids" : self.caseModel.visitDeliverId};
    [[[WTAddressGetViewModel alloc] init] dataByParameters:paras success:^(WTTotalModel *totalModel) {
        for (NSInteger i = 0; i < totalModel.data.count; i++) {
            WTAddressModel *addressModel = totalModel.data[i];
            WTAnnotation *annotation = [[WTAnnotation alloc] init];
            annotation.coordinate = CLLocationCoordinate2DMake(addressModel.lat, addressModel.lng);
            if (weakSelf.caseModel.delivers.count) {
                annotation.deliverModel = weakSelf.caseModel.delivers[i];
                annotation.deliverModel.address = addressModel.userAddress;
                [_mapView addAnnotation:annotation];
            }
        }
    } failure:^(NSError *error, NSString *message) {
        
    }];
}

- (void)receiveCallNote:(NSNotification *)note {
    WTCaseDeliverModel *model = note.object;
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", model.deliverPhoneNum];
    /// 10及其以上系统
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        /// 10以下系统
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}

#pragma mark - <MAMapViewDelegate>
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if (![annotation isKindOfClass:[MAUserLocation class]]) {
        WTAnnotationView *annotationView = (WTAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
        if (annotationView == nil) {
            annotationView = [[WTAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        }
        annotationView.image = HYXImage(@"map_location");
        annotationView.canShowCallout = NO;
        WTAnnotation *customAnnotation = (WTAnnotation *)annotation;
        annotationView.deliverModel = customAnnotation.deliverModel;
        return annotationView;
    }
    return nil;
}

- (void)dealloc
{
    HYXNote_REMOVE();
}

@end
