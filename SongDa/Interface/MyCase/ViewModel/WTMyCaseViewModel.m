//
//  WTMyCaseViewModel.m
//  SongDa
//
//  Created by Fancy on 2018/3/29.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTMyCaseViewModel.h"
#import "WTMyCaseModel.h"

@implementation WTMyCaseViewModel

- (void)dataByParameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *, NSString *))failure {

    [[WTHTTPSessionManager sharedManager] HTTPRequestWithRelativePOSTPath:kMyCasePath parameters:parameters responeBlock:^(id jsonObject, NSError *error) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"WTMyCaseViewModel = %@",jsonObject);
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]initWithDictionary:jsonObject];
            if (_isNeedPostNoti) {
                [dict setValue:@(_isNeedPostNoti) forKey:@"isNeedPostNoti"];
            }
            WTTotalModel *model = [[WTTotalModel alloc] initWithDict:dict dataClass:[WTMyCaseModel class]];
            success(model);
        } else {
            failure(error,nil);
        }
    }];
}



@end
