//
//  WTAddressReportViewModel.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/25.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTAddressReportViewModel.h"

@implementation WTAddressReportViewModel

- (void)dataByParameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *, NSString *))failure {
    [[WTHTTPSessionManager sharedManager] HTTPRequestWithRelativePOSTPath:kUserAddrReportPath parameters:parameters responeBlock:^(id jsonObject, NSError *error) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            long code = [jsonObject longValueForKey:@"code" default:-1000];
            if (code == 0) {
                success(nil);
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
