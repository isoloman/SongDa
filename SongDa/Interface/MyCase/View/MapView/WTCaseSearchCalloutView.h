//
//  WTCaseSearchCalloutView.h
//  SongDa
//
//  Created by Fancy on 2018/4/17.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTMyCaseSearchModel;
@class WTCaseDeliverModel;
@class WTCaseTransferDelivererModel;

@interface WTCaseSearchCalloutView : UIView
/** 周边搜索模型 */
@property (strong, nonatomic) WTMyCaseSearchModel *searchModel;
/** 送达员模型(案件中心) */
@property (strong, nonatomic) WTCaseDeliverModel *deliverModel;
/** 送达员模型(地图模式) */
@property (strong, nonatomic) WTCaseTransferDelivererModel *mapDeliverModel;
@end
