//
//  WTCaseSignViewModel.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/10.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseSignViewModel.h"
#import <Bugly/Bugly.h>

@implementation WTCaseSignViewModel

- (void)dataByParameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *, NSString *))failure {
    [[WTHTTPSessionManager sharedManager] HTTPRequestWithRelativePOSTPath:kCaseSignPath parameters:parameters responeBlock:^(id jsonObject, NSError *error) {
        if (jsonObject) {
            long code = [jsonObject longValueForKey:@"code" default:-1000];
            if (code == 0) {
                success(nil);
            } else {
                NSString *message = [jsonObject stringValueForKey:@"message" default:@"MessageError"];
                NSError *codeError = WTError(code, message);
                DLog(@"error:%@",jsonObject);
                failure(codeError,nil);
                [Bugly reportException:[NSException exceptionWithName:@"追记添加失败" reason:message userInfo:jsonObject]];
                [Bugly reportError:error];
            }
        } else {
            failure(error,nil);
            DLog(@"error:%@",error);
            [Bugly reportError:error];
        }
    }];
}

@end
