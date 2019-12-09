//
//  WTMyCaseSearchModel.h
//  SongDa
//
//  Created by Fancy on 2018/4/16.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTMyCaseSearchModel : NSObject
/** 地点名称 */
@property (copy, nonatomic) NSString *name;
/** 地点地址 */
@property (copy, nonatomic) NSString *address;
/** 地点纬度 */
@property (assign, nonatomic) double lat;
/** 地点经度 */
@property (assign, nonatomic) double lng;
/** 距离 */
@property (assign, nonatomic, readonly) double distance;
@end
