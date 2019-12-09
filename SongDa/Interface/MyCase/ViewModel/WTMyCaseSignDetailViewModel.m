//
//  WTMyCaseSignDetailViewModel.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/26.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTMyCaseSignDetailViewModel.h"
#import "WTMyCaseSignDetailModel.h"

@implementation WTMyCaseSignDetailViewModel

- (void)dataByParameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *, NSString *))failure {
    [[WTHTTPSessionManager sharedManager] HTTPRequestWithRelativePOSTPath:kCaseSignDetailPath parameters:parameters responeBlock:^(id jsonObject, NSError *error) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            long code = [jsonObject longValueForKey:@"code" default:-1000];
            if (code == 0) {
                NSDictionary *data = jsonObject[@"data"];
                if ([data isKindOfClass:[NSDictionary class]]) {
                    WTMyCaseSignDetailModel *model = [[WTMyCaseSignDetailModel alloc] initWithDict:data];
                    success(model);
                } else {
                    NSError *codeError = WTError(code, @"Data not exist");
                    failure(codeError,nil);
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
