//
//  WTCaseRegionModel.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/9.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseRegionModel.h"

@implementation WTCaseRegionModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.localName = [dict stringValueForKey:@"localName" default:@""];
        self.regionId = [dict stringValueForKey:@"id" default:@""];
        self.parentId = [dict stringValueForKey:@"parentId" default:@""];
    }
    return self;
}

@end
