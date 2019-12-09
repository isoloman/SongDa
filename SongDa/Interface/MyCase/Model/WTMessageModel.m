//
//  WTMessageModel.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/23.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTMessageModel.h"

@implementation WTMessageModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        NSDictionary *aps = [dict valueForKey:@"aps"];
        self.message = [aps stringValueForKey:@"alert" default:@""];
        
        NSString *code = [dict stringValueForKey:@"code" default:@""];
        if ([code isEqualToString:@"12"]) {
            self.type = WTMessageTypeBeTranfer;
        } else if ([code isEqualToString:@"13"]) {
            self.type = WTMessageTypeTransferTo;
        }
        
        NSString *content = [dict valueForKey:@"content"];
        if (content.length) {
            NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *contentDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            if ([contentDict isKindOfClass:[NSDictionary class]]) {
                self.caseIDs = [contentDict stringValueForKey:@"ids" default:@""];
                self.caseIDArrM = [self.caseIDs componentsSeparatedByString:@","];
                if (self.type == WTMessageTypeTransferTo) {
                    self.transferName = [contentDict stringValueForKey:@"acceptName" default:@""];
                    self.transferUserId = [contentDict stringValueForKey:@"acceptId" default:@""];
                } else if (self.type == WTMessageTypeBeTranfer) {
                    self.transferName = [contentDict stringValueForKey:@"opName" default:@""];
                    self.transferUserId = [contentDict stringValueForKey:@"opUid" default:@""];
                }
            } else {
                HYXLog(@"JSON格式有误");
            }
        }
        
        self.cellHeight = 15+10+12+15;
        self.cellHeight += [self.message boundingRectWithSize:CGSizeMake(HYXScreenW-2*10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
    }
    return self;
}

@end
