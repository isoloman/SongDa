//
//  WTAnnotationView.h
//  SongDa
//
//  Created by Fancy on 2018/4/12.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
@class WTMyCaseModel;
@class WTCaseDeliverModel;
@class WTMyCaseSearchModel;
@class WTCaseTransferDelivererModel;

@interface WTAnnotationView : MAPinAnnotationView
/** 待送达：案件模型 */
@property (strong, nonatomic) WTMyCaseModel *caseModel;
/** 案件中心：送达员模型 */
@property (strong, nonatomic) WTCaseDeliverModel *deliverModel;
/** 地图模式：周边搜索模型 */
@property (strong, nonatomic) WTMyCaseSearchModel *searchModel;
/** 地图模式：送达员模型 */
@property (strong, nonatomic) WTCaseTransferDelivererModel *mapDeliverModel;
@end
