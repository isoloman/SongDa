//
//  WTMyCaseModel.h
//  SongDa
//
//  Created by Fancy on 2018/4/3.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTBaseModel.h"

@interface WTMyCaseModel : WTBaseModel 
/** 案件id */
@property (copy, nonatomic) NSString *caseId;
/** 法院id */
@property (copy, nonatomic) NSString *courtId;
/** 案件组id */
@property (copy, nonatomic) NSString *groupId;
/** 当事人 */
@property (copy, nonatomic) NSString *litigantName;
/** 当事人id */
@property (copy, nonatomic) NSString *litigantId;
/** 所属区 */
@property (copy, nonatomic) NSString *region;
/** 简洁地址 */
@property (copy, nonatomic) NSString *detailAddr;
/** 详细地址 */
@property (copy, nonatomic) NSString *fullAddress;
/** 案号 */
@property (copy, nonatomic) NSString *caseCode;
@property (copy, nonatomic) NSString *preCaseCode;
/** 接收时间 */
@property (copy, nonatomic) NSString *receiveTime;
/** 上门记录id */
@property (copy, nonatomic) NSString *visitRecordId;
/** 是否送达 */
@property (assign, nonatomic) long isDelivery;
/** 经度 */
@property (assign, nonatomic) double lng;
/** 纬度 */
@property (assign, nonatomic) double lat;
/** 电话号码 */
@property (strong, nonatomic) NSMutableArray *phoneNums;

//---------------辅助属性---------------
/** 距离 */
@property (assign, nonatomic) double distance;

@end
