//
//  WTCaseSignSituationViewModel.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/11.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseSignSituationViewModel.h"
#import "WTMyCaseSignModel.h"

@implementation WTCaseSignSituationViewModel

- (void)dataByParameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *, NSString *))failure {
    [[WTHTTPSessionManager sharedManager] HTTPRequestWithRelativePOSTPath:kCaseSignSituationPath parameters:parameters responeBlock:^(id jsonObject, NSError *error) {
        if (jsonObject) {
            WTTotalModel *model = [[WTTotalModel alloc] initWithDict:jsonObject dataClass:[WTMyCaseSignModel class]];
            success(model);
        } else {
            failure(error,nil);
        }
    }];
}

@end
