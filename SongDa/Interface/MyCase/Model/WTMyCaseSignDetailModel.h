//
//  WTMyCaseSignDetailModel.h
//  SongDa
//
//  Created by 灰太狼 on 2018/4/26.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTBaseModel.h"

@interface WTMyCaseSignDetailModel : WTBaseModel
/** 上门情况 */
@property (copy, nonatomic) NSString *visitDetail;
/** 定位地址 */
@property (copy, nonatomic) NSString *fullAddress;
/** 送达情况 */
@property (copy, nonatomic) NSString *serviceRemark;
/** 送达结果 */
@property (assign, nonatomic) long isArrived;
/** 送达标记图片 */
@property (strong, nonatomic) NSMutableArray *signImages;

/** 送达情况id */
@property (assign, nonatomic) long visitDetailId;
@end
