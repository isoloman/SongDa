//
//  WTCaseTransferDelivererViewModel.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/8.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseTransferDelivererViewModel.h"
#import "WTCaseTransferDelivererModel.h"

@implementation WTCaseTransferDelivererViewModel

- (void)dataByParameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *, NSString *))failure {
    [[WTHTTPSessionManager sharedManager] HTTPRequestWithRelativePOSTPath:kCaseDelivererPath parameters:parameters responeBlock:^(id jsonObject, NSError *error) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"kCaseDelivererPath = %@",jsonObject);
            WTTotalModel *model = [[WTTotalModel alloc] initWithDict:jsonObject dataClass:[WTCaseTransferDelivererModel class]];
            success(model);
        } else {
            failure(error,nil);
        }
    }];
}

+ (void)getDataByParameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *, NSString *))failure {
    [[WTHTTPSessionManager sharedManager] HTTPRequestWithRelativeGETPath:kGetAllPosition parameters:parameters responeBlock:^(id jsonObject, NSError *error) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"kLocationGetAll = %@",jsonObject);
            
            success(@"");
        } else {
            failure(error,nil);
        }
    }];
}

@end
