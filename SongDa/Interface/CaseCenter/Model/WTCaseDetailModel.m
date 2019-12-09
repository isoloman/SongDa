//
//  WTCaseDetailModel.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/8.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseDetailModel.h"

@implementation WTCaseDetailModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.caseId = [dict stringValueForKey:@"caseId" default:@""];
        self.caseCode = [dict stringValueForKey:@"caseCode" default:@""];
        self.preCaseCode = [dict stringValueForKey:@"preCaseCode" default:@""];
        self.deptName = [dict stringValueForKey:@"deptName" default:@""];
        self.judge = [dict stringValueForKey:@"judge" default:@""];
        self.judgeAssistant = [dict stringValueForKey:@"judgeAssistant" default:@""];
        self.courtClerk = [dict stringValueForKey:@"courtClerk" default:@""];
        self.caseCauseName = [dict stringValueForKey:@"caseCauseName" default:@""];
        self.preTrialDate = [dict stringValueForKey:@"preTrialDate" default:@""];
        self.prePlatoonTime = [dict stringValueForKey:@"prePlatoonTime" default:@""];
        self.litigantName = [dict stringValueForKey:@"litigantName" default:@""];
        self.region = [dict stringValueForKey:@"region" default:@""];
        self.detailAddr = [dict stringValueForKey:@"detailAddr" default:@""];
        self.visitRecordId = [dict stringValueForKey:@"id" default:@""];
        self.trialEndDate = [dict stringValueForKey:@"trialEndDate" default:@""];
        self.registerDate = [dict stringValueForKey:@"registerDate" default:@""];
        
        long status = [dict longValueForKey:@"litigationStatus" default:0];
        if (status == 1) {
            self.litigationStatus = @"原告";
        } else if (status == 2) {
            self.litigationStatus = @"被告";
        } else {
            self.litigationStatus = @"第三人";
        }
        
        self.telsArrM = [NSMutableArray array];
        NSArray *tels = dict[@"tels"];
        NSString *telString = @"";
        if ([tels isKindOfClass:[NSArray class]] && tels.count) {
            for (NSDictionary *dic in tels) {
                NSString *tel = [dic stringValueForKey:@"tel" default:@""];
                [self.telsArrM addObject:tel];
                if (telString.length) {
                    telString = [telString stringByAppendingString:[NSString stringWithFormat:@",%@",tel]];
                } else {
                    telString = [telString stringByAppendingString:tel];
                }
            }
        }
        self.tels = telString;
    }
    return self;
}

@end
