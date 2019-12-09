//
//  WTCaseArrivedViewModel.m
//  SongDa
//
//  Created by Fancy on 2018/4/13.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseArrivedViewModel.h"
#import "WTCaseArrivedModel.h"

@implementation WTCaseArrivedViewModel

- (void)dataByParameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *, NSString *))failure {
    [[WTHTTPSessionManager sharedManager] HTTPRequestWithRelativePOSTPath:kCaseArrivedPath parameters:parameters responeBlock:^(id jsonObject, NSError *error) {
        if (jsonObject) {
            long code = [jsonObject longValueForKey:@"code" default:-1000];
            if (code == 0) {
                WTTotalModel *model = [[WTTotalModel alloc] initWithDict:jsonObject dataClass:[WTCaseArrivedModel class]];
                success(model);
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
