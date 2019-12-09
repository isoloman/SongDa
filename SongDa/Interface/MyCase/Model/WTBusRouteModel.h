//
//  WTBusRouteModel.h
//  SongDa
//
//  Created by Fancy on 2018/4/17.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <Foundation/Foundation.h>

// 车次模型
@interface WTBusStopModel : NSObject
/** 车次 */
@property (copy, nonatomic) NSString *lineName;
/** 上车站点 */
@property (copy, nonatomic) NSString *departureStop;
/** 下车站点 */
@property (copy, nonatomic) NSString *arrivalStop;
@end

// 路段模型
@interface WTBusLineModel : NSObject
/** 车次数组 */
@property (strong, nonatomic) NSMutableArray<WTBusStopModel *> *buses;
@end

// 总路线模型
@interface WTBusRouteModel : NSObject
/** 路段数组 */
@property (strong, nonatomic) NSMutableArray<WTBusLineModel *> *lines;
/** 步行总长 */
@property (assign, nonatomic) long walkingDistance;
/** 总时长 */
@property (assign, nonatomic) long duration;
@end
