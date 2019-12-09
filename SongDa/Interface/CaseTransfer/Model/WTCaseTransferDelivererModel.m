//
//  WTCaseTransferDelivererModel.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/8.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseTransferDelivererModel.h"

@implementation WTCaseTransferDelivererModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.name = [dict stringValueForKey:@"name" default:@""];
        self.phoneNum = [dict stringValueForKey:@"mobile" default:@""];
        self.detailAddr = [dict stringValueForKey:@"detailAddr" default:@""];
        if ([self.phoneNum isEmpty]) {
            self.phoneNum = [dict stringValueForKey:@"telephone" default:@""];
        }
        self.delivereId = [dict stringValueForKey:@"id" default:@""];
        self.lng = [dict doubleValueForKey:@"lng" default:0];
        self.lat = [dict doubleValueForKey:@"lat" default:0];
        
        if (self.lng != 0 && self.lat != 0) {
            self.distance = [self distanceBetweenPointByLat1:[WTLocationManager shareInstance].latitude lng1:[WTLocationManager shareInstance].longitude lat2:self.lat lng2:self.lng];
        }
    }
    return self;
}

- (double)distanceBetweenPointByLat1:(double)lat1 lng1:(double)lng1 lat2:(double)lat2 lng2:(double)lng2 {
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    return  [curLocation distanceFromLocation:otherLocation];
}

@end
