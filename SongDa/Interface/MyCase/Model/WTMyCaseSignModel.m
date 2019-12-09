//
//  WTMyCaseSignModel.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/11.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTMyCaseSignModel.h"

@implementation WTMyCaseSignModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.result = [dict stringValueForKey:@"text" default:@""];
        self.resultId = [dict stringValueForKey:@"id" default:@""];
    }
    return self;
}

@end
