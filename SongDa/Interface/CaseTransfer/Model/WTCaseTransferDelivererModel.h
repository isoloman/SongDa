//
//  WTCaseTransferDelivererModel.h
//  SongDa
//
//  Created by 灰太狼 on 2018/4/8.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTBaseModel.h"

@interface WTCaseTransferDelivererModel : WTBaseModel
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *delivereId;
@property (copy, nonatomic) NSString *phoneNum;
@property (copy, nonatomic) NSString *detailAddr;
/** 经度 */
@property (assign, nonatomic) double lng;
/** 纬度 */
@property (assign, nonatomic) double lat;
//---------------辅助属性---------------
/** 距离 */
@property (assign, nonatomic) double distance;
@end
