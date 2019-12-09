//
//  WTCaseDetailViewModel.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/8.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseDetailViewModel.h"
#import "WTCaseDetailModel.h"

@implementation WTCaseDetailViewModel

- (void)dataByParameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *, NSString *))failure {
    [[WTHTTPSessionManager sharedManager] HTTPRequestWithRelativePOSTPath:kCaseDetailPath parameters:parameters responeBlock:^(id jsonObject, NSError *error) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            long code = [jsonObject longValueForKey:@"code" default:-1000];
            if (code == 0) {
                NSArray *data = jsonObject[@"data"];
                if ([data isKindOfClass:[NSArray class]]) {
                    NSDictionary *modelDict = data.firstObject;
                    if ([modelDict isKindOfClass:[NSDictionary class]]) {
                        WTCaseDetailModel *model = [[WTCaseDetailModel alloc] initWithDict:modelDict];
                        success(model);
                    }
                }
            } else {
                NSString *message = [jsonObject stringValueForKey:@"message" default:@"MessageError"];
                NSError *codeError = WTError(code, message);
                failure(codeError,nil);
            }
        } else {
            failure(error,nil);
        }
    }];
}

@end
