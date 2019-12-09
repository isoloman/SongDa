//
//  WTMyCaseSearchModel.m
//  SongDa
//
//  Created by Fancy on 2018/4/16.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTMyCaseSearchModel.h"

@implementation WTMyCaseSearchModel

- (double)distance {
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:[WTLocationManager shareInstance].latitude longitude:[WTLocationManager shareInstance].longitude];
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:self.lat longitude:self.lng];
    return  [curLocation distanceFromLocation:otherLocation];
}

@end
