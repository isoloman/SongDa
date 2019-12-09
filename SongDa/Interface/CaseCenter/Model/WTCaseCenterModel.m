//
//  WTCaseCenterModel.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/9.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseCenterModel.h"
#import "WTCaseDeliverModel.h"

@implementation WTCaseCenterModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.caseId = [dict stringValueForKey:@"visitRecordId" default:@""];
        self.litigantName = [dict stringValueForKey:@"litigantName" default:@""];
        self.region = [dict stringValueForKey:@"region" default:@""];
        self.detailAddr = [dict stringValueForKey:@"detailAddr" default:@""];
        self.visitDeliverName = [dict stringValueForKey:@"visitDeliverName" default:@""];
        self.visitDeliverId = [dict stringValueForKey:@"visitDeliverId" default:@""];
        self.caseCode = [dict stringValueForKey:@"caseCode" default:@""];
        self.preCaseCode = [dict stringValueForKey:@"preCaseCode" default:@""];
        self.receiveDate = [dict stringValueForKey:@"receiveDate" default:@""];
        self.isArrived = [dict longValueForKey:@"isArrived" default:-1000];
        self.visitTime = [dict stringValueForKey:@"visitTime" default:@""];
        self.visitDetail = [dict stringValueForKey:@"visitDetail" default:@""];
        
        NSArray *serviceUserList = dict[@"serviceUserList"];
        self.delivers = [NSMutableArray array];
        if ([serviceUserList isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in serviceUserList) {
                WTCaseDeliverModel *model = [[WTCaseDeliverModel alloc] initWithDict:dic];
                if (model.deliverPhoneNum.length) {
                    [self.delivers addObject:model];
                }
            }
        }
    }
    return self;
}

@end
