//
//  WTMyCaseMapView.h
//  SongDa
//
//  Created by Fancy on 2018/3/27.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTMyCaseMapView;
@class WTBusRouteModel;

typedef void(^DateChosenBlock) (void);

@protocol WTMyCaseMapViewDelegate <NSObject>
@optional
- (void)pushTakeBusController:(WTMyCaseMapView *)mapView bouteModel:(WTBusRouteModel *)routeModel;
@end

@interface WTMyCaseMapView : UIView
@property (strong, nonatomic) WTTotalModel *totalModel;
@property (weak, nonatomic) id<WTMyCaseMapViewDelegate> delegate;
/** 案件日期筛选回调 */
@property (copy, nonatomic) DateChosenBlock dateChoseBlock;

- (void)clearMap;
@end
