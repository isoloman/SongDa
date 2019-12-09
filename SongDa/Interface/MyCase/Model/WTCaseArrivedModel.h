//
//  WTCaseArrivedModel.h
//  SongDa
//
//  Created by Fancy on 2018/4/13.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTBaseModel.h"

@interface WTCaseArrivedModel : WTBaseModel
/** 案件id */
@property (copy, nonatomic) NSString *caseId;
/** 当事人 */
@property (copy, nonatomic) NSString *litigantName;
/** 签收说明 */
@property (copy, nonatomic) NSString *visitDetail;
/** 签收时间 */
@property (copy, nonatomic) NSString *visitTime;
/** 案件所属区域 */
@property (copy, nonatomic) NSString *region;
/** 详细地址 */
@property (copy, nonatomic) NSString *fullAddress;
/** 案号*/
@property (copy, nonatomic) NSString *caseCode;
/** 接收时间 */
@property (copy, nonatomic) NSString *receiveTime;
/** 是否送达 */
@property (assign, nonatomic) long isArrived;
@end
