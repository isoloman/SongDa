//
//  WTCaseRegionModel.h
//  SongDa
//
//  Created by 灰太狼 on 2018/4/9.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTBaseModel.h"

@interface WTCaseRegionModel : WTBaseModel
/** 县市区名称 */
@property (copy, nonatomic) NSString *localName;
/** 县市区id */
@property (copy, nonatomic) NSString *regionId;
/** 县市区所在地级市id */
@property (copy, nonatomic) NSString *parentId;
@end
