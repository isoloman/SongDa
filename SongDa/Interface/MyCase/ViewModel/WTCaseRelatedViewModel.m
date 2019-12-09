//
//  WTCaseRelatedViewModel.m
//  SongDa
//
//  Created by 灰太狼 on 2018/6/27.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseRelatedViewModel.h"
#import "WTMyCaseModel.h"

@implementation WTCaseRelatedViewModel

- (void)dataByParameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *, NSString *))failure {
    [[WTHTTPSessionManager sharedManager] HTTPRequestWithRelativePOSTPath:kCaseRelatedPath parameters:parameters responeBlock:^(id jsonObject, NSError *error) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            WTTotalModel *model = [[WTTotalModel alloc] initWithDict:jsonObject dataClass:[WTMyCaseModel class]];
            success(model);
        } else {
            failure(error,nil);
        }
    }];
}

@end
