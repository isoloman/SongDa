//
//  WTCaseDetailModel.h
//  SongDa
//
//  Created by 灰太狼 on 2018/4/8.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTBaseModel.h"

@interface WTCaseDetailModel : WTBaseModel
@property (copy, nonatomic) NSString *caseId;
/** 诉前案号 */
@property (copy, nonatomic) NSString *preCaseCode;
/** 法官助理 */
@property (copy, nonatomic) NSString *judgeAssistant;
/** 案由 */
@property (copy, nonatomic) NSString *caseCauseName;
/** 预立案时间 */
@property (copy, nonatomic) NSString *preTrialDate;

/** 案号 */
@property (copy, nonatomic) NSString *caseCode;
/** 部门 */
@property (copy, nonatomic) NSString *deptName;
/** 审判员 */
@property (copy, nonatomic) NSString *judge;
/** 书记员 */
@property (copy, nonatomic) NSString *courtClerk;
/** 立案时间 */
@property (copy, nonatomic) NSString *registerDate;
/** 审限截止日期 */
@property (copy, nonatomic) NSString *trialEndDate;
/** 预排庭时间 */
@property (copy, nonatomic) NSString *prePlatoonTime;

/** 送达当事人 */
@property (copy, nonatomic) NSString *litigantName;
/** 送达当事人:诉讼地位 */
@property (copy, nonatomic) NSString *litigationStatus;
/** 联系电话 */
@property (strong, nonatomic) NSMutableArray *telsArrM;
/** 联系电话 */
@property (copy, nonatomic) NSString *tels;
/** 当事人地址区域 */
@property (copy, nonatomic) NSString *region;
/** 当事人详细地址 */
@property (copy, nonatomic) NSString *detailAddr;
/** 上门记录id */
@property (copy, nonatomic) NSString *visitRecordId;
@end
