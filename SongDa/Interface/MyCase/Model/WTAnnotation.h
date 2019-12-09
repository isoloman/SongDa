//
//  WTAnnotation.h
//  SongDa
//
//  Created by Fancy on 2018/4/13.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
@class WTMyCaseModel;
@class WTCaseDeliverModel;
@class WTCaseTransferDelivererModel;

@interface WTAnnotation : MAPointAnnotation
@property (strong, nonatomic) WTMyCaseModel *caseModel;
@property (strong, nonatomic) WTCaseDeliverModel *deliverModel;
@property (strong, nonatomic) WTCaseTransferDelivererModel *mapDeliverModel;
@end
