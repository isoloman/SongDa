//
//  WTRegionManager.h
//  SongDa
//
//  Created by 灰太狼 on 2018/10/10.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WTRegionModel;
@interface WTRegionManager : NSObject
+ (NSMutableArray <WTRegionModel *> *)getRegion:(NSString *)area isProvince:(BOOL)isProvince;
+ (NSMutableArray <WTRegionModel *>*)getCityRegion:(NSInteger)region_id;
+ (WTRegionModel *)getRegionByLocalName:(NSString *)area;
+ (WTRegionModel *)getRegionByRegionID:(NSString *)regionID;
@end
