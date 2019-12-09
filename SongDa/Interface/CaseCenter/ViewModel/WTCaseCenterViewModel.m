//
//  WTCaseCenterViewModel.m
//  SongDa
//
//  Created by Fancy on 2018/4/2.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseCenterViewModel.h"
#import "WTCaseCenterModel.h"

@implementation WTCaseCenterViewModel

- (void)dataByParameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *, NSString *))failure {
    [[WTHTTPSessionManager sharedManager] HTTPRequestWithRelativePOSTPath:kCaseCenterPath parameters:parameters responeBlock:^(id jsonObject, NSError *error) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            long code = [jsonObject longValueForKey:@"code" default:-1000];
            if (code == 0) {
                WTTotalModel *model = [[WTTotalModel alloc] initWithDict:jsonObject dataClass:[WTCaseCenterModel class]];
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
