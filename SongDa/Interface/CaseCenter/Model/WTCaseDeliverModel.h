//
//  WTCaseDeliverModel.h
//  SongDa
//
//  Created by 灰太狼 on 2018/4/11.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTBaseModel.h"

@interface WTCaseDeliverModel : WTBaseModel
/** 送达员id */
@property (copy, nonatomic) NSString *deliverId;
/** 送达员昵称 */
@property (copy, nonatomic) NSString *deliverName;
/** 送达员号码 */
@property (copy, nonatomic) NSString *deliverPhoneNum;

/** 送达员位置传递数值*/
@property (copy, nonatomic) NSString *address;

@end
