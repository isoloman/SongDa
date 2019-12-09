//
//  WTAddressModel.h
//  SongDa
//
//  Created by 灰太狼 on 2018/4/25.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTBaseModel.h"

@interface WTAddressModel : WTBaseModel
/** 用户id */
@property (copy, nonatomic) NSString *userId;
/** 用户名 */
@property (copy, nonatomic) NSString *userName;
/** 用户号码 */
@property (copy, nonatomic) NSString *userPhone;
/** 用户当前地址 */
@property (copy, nonatomic) NSString *userAddress;
/** 用户当前所处纬度 */
@property (assign, nonatomic) double lat;
/** 用户当前所处经度 */
@property (assign, nonatomic) double lng;
@end
