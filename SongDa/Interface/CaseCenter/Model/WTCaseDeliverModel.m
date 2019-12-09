//
//  WTCaseDeliverModel.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/11.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseDeliverModel.h"

@implementation WTCaseDeliverModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.deliverId = [dict stringValueForKey:@"id" default:@""];
        self.deliverName = [dict stringValueForKey:@"name" default:@""];
        self.deliverPhoneNum = [dict stringValueForKey:@"mobile" default:@""];
    }
    return self;
}

@end
