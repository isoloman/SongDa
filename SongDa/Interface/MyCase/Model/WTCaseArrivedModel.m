//
//  WTCaseArrivedModel.m
//  SongDa
//
//  Created by Fancy on 2018/4/13.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseArrivedModel.h"

@implementation WTCaseArrivedModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.caseId = [dict stringValueForKey:@"id" default:@""];
        self.litigantName = [dict stringValueForKey:@"litigantName" default:@""];
        self.visitDetail = [dict stringValueForKey:@"visitDetail" default:@""];
        self.visitTime = [dict stringValueForKey:@"visitTime" default:@""];
        self.region = [dict stringValueForKey:@"region" default:@""];
        self.fullAddress = [dict stringValueForKey:@"fullAddress" default:@""];
        self.caseCode = [dict stringValueForKey:@"caseCode" default:@""];
        if ([self.caseCode isEmpty]) {
            self.caseCode = [dict stringValueForKey:@"preCaseCode" default:@""];
        }
        self.receiveTime = [dict stringValueForKey:@"receiveTime" default:@""];
        self.isArrived = [dict longValueForKey:@"isArrived" default:-1000];
    }
    return self;
}

@end
