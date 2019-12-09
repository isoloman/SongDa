//
//  WTLoginViewModel.m
//  SongDa
//
//  Created by Fancy on 2018/3/29.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTLoginViewModel.h"

@implementation WTLoginViewModel

- (void)loginWithPhoneNumParas:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *, NSString *))failure {
    [[WTHTTPSessionManager sharedManager] HTTPRequestWithRelativePOSTPath:kLoginPath parameters:parameters responeBlock:^(NSDictionary *jsonObject, NSError *error) {
        if (jsonObject) {
            long code = [jsonObject longValueForKey:@"code" default:-1000];
            if (code == 0) {
                NSLog(@"%@",jsonObject);
                NSDictionary *data = jsonObject[@"data"];
                if ([data isKindOfClass:[NSDictionary class]] && data.count) {
                    [[WTAccountManager sharedManager] loginWithDictionary:data];
                }
                success(jsonObject);
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

- (void)logoutWithParas:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *, NSString *))failure {
    [[WTHTTPSessionManager sharedManager] HTTPRequestWithRelativePOSTPath:kLogoutPath parameters:parameters responeBlock:^(id jsonObject, NSError *error) {
        if (jsonObject) {
            long code = [jsonObject longValueForKey:@"code" default:-1000];
            if (code == 0) {
                [[WTAccountManager sharedManager] loginWithDictionary:[NSDictionary dictionary]];
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

- (void)getVerifyCodeWithParas:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *, NSString *))failure {
    [[WTHTTPSessionManager sharedManager] HTTPRequestWithRelativePOSTPath:kSendVerifyCodePath parameters:parameters responeBlock:^(id jsonObject, NSError *error) {
        if (jsonObject) {
            long code = [jsonObject longValueForKey:@"code" default:-1000];
            if (code == 0) {
                success(jsonObject);
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
