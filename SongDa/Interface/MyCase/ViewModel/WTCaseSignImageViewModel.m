//
//  WTCaseSignImageViewModel.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/11.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseSignImageViewModel.h"
#import <Bugly/Bugly.h>

@implementation WTCaseSignImageViewModel

- (void)dataByParameters:(id)parameters images:(NSArray *)images success:(void (^)(id))success failure:(void (^)(NSError *, NSString *))failure {
    [[WTHTTPSessionManager sharedManager] HTTPRequestWithRelativePOSTPath:kCaseSignImagesPath parameters:parameters images:images responeBlock:^(id jsonObject, NSError *error) {
        
        if (jsonObject) {
            long code = [jsonObject longValueForKey:@"code" default:-1000];
            if (code == 0) {
                success(nil);
            } else {
                NSString *message = [jsonObject stringValueForKey:@"message" default:@"MessageError"];
                NSError *codeError = WTError(code, message);
                failure(codeError,nil);
                [Bugly reportException:[NSException exceptionWithName:@"上传图片失败" reason:@"错误上报" userInfo:jsonObject]];
                [Bugly reportError:error];
            }
        } else {
            failure(error,nil);
            [Bugly reportError:error];
        }
    }];
}

@end
