//
//  WTTotalModel.m
//  SongDa
//
//  Created by Fancy on 2018/4/3.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTTotalModel.h"

@implementation WTTotalModel

- (instancetype)initWithDict:(NSDictionary *)dict dataClass:(__unsafe_unretained Class)class {
    if (self = [super init]) {
        self.code = [dict longValueForKey:@"code" default:-1000];
        self.error = [dict stringValueForKey:@"error" default:@""];
        self.message = [dict stringValueForKey:@"message" default:@""];
        
        NSArray *data = dict[@"data"];
        self.data = [NSMutableArray array];
        if ([data isKindOfClass:[NSArray class]] && data.count) {
            for (NSDictionary *dic in data) {
                WTBaseModel *model = [[class alloc] initWithDict:dic];
                model.isNeedPostNoti = [[dict valueForKey:@"isNeedPostNoti"] boolValue];
                model.count = data.count;
                [self.data addObject:model];
            }
        }
    }
    return self;
}

@end
