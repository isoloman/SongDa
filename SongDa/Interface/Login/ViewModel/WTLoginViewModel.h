//
//  WTLoginViewModel.h
//  SongDa
//
//  Created by Fancy on 2018/3/29.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTLoginViewModel : NSObject

- (void)loginWithPhoneNumParas:(id)parameters
                       success:(void (^)(id))success
                       failure:(void (^)(NSError *error, NSString *message))failure;

- (void)logoutWithParas:(id)parameters
                success:(void (^)(id))success
                failure:(void (^)(NSError *error, NSString *message))failure;

- (void)getVerifyCodeWithParas:(id)parameters
                       success:(void (^)(id))success
                       failure:(void (^)(NSError *error, NSString *message))failure;

@end
