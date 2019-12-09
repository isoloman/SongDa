//
//  WTAddressModel.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/25.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTAddressModel.h"

@implementation WTAddressModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.userId = [dict stringValueForKey:@"id" default:@""];
        self.userName = [dict stringValueForKey:@"name" default:@""];
        self.userPhone = [dict stringValueForKey:@"mobile" default:@""];
        self.userAddress = [dict stringValueForKey:@"address" default:@""];
        self.lat = [dict doubleValueForKey:@"lat" default:0];
        self.lng = [dict doubleValueForKey:@"lng" default:0];
    }
    return self;
}

@end
