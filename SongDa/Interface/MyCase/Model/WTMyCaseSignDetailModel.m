//
//  WTMyCaseSignDetailModel.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/26.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTMyCaseSignDetailModel.h"

@implementation WTMyCaseSignDetailModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.visitDetail = [dict stringValueForKey:@"visitDetail" default:@""];
        self.fullAddress = [dict stringValueForKey:@"fullAddress" default:@""];
        self.serviceRemark = [dict stringValueForKey:@"serviceRemark" default:@""];
        self.isArrived = [dict longValueForKey:@"isArrived" default:0];
        self.visitDetailId = [dict longValueForKey:@"visitDetailId" default:0];
        
        NSString *fileUrls = [dict stringValueForKey:@"fileUrls" default:@""];
        if (![fileUrls isEmpty]) {
            NSString *encodeString = [fileUrls stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *images = [encodeString componentsSeparatedByString:@","];
            self.signImages = [NSMutableArray arrayWithArray:images];
        }
    }
    return self;
}

@end
