//
//  WTCaseCenterModel.h
//  SongDa
//
//  Created by 灰太狼 on 2018/4/9.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTBaseModel.h"
@class WTCaseDeliverModel;

@interface WTCaseCenterModel : WTBaseModel
/** 案件id */
@property (copy, nonatomic) NSString *caseId;
/** 当事人 */
@property (copy, nonatomic) NSString *litigantName;
/** 送达状态 */
@property (assign, nonatomic) long isArrived;
/** 所属区域 */
@property (copy, nonatomic) NSString *region;
/** 详细地址 */
@property (copy, nonatomic) NSString *detailAddr;
/** 送达员 */
@property (copy, nonatomic) NSString *visitDeliverName;
/** 送达员id */
@property (copy, nonatomic) NSString *visitDeliverId;
/** 案号 */
@property (copy, nonatomic) NSString *caseCode;
@property (copy, nonatomic) NSString *preCaseCode;
/** 接收时间 */
@property (copy, nonatomic) NSString *receiveDate;
/** 送达时间 */
@property (copy, nonatomic) NSString *visitTime;
/** 送达详情描述 */
@property (copy, nonatomic) NSString *visitDetail;
/** 送达员数组 */
@property (strong, nonatomic) NSMutableArray <WTCaseDeliverModel *> *delivers;
@end
