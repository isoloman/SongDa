//
//  WTHTTPSessionManager.m
//  SongDa
//
//  Created by Fancy on 2018/3/28.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTHTTPSessionManager.h"
#import <AFNetworking.h>
#import <AFNetworkActivityIndicatorManager.h>
#import <CoreTelephony/CTCellularData.h>

@interface WTHTTPSessionManager ()
@property (copy, nonatomic) NSString *userAgent;
@end

@implementation WTHTTPSessionManager

static AFHTTPSessionManager *_sessionManager = nil;
static BOOL _canNetwork;

+ (void)initialize {
    _sessionManager = [AFHTTPSessionManager manager];
    _sessionManager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST", @"GET", @"HEAD"]];
    _sessionManager.requestSerializer.timeoutInterval = 30;
    _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", @"image/*", @"text/xml", nil];
    [_sessionManager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    // 打开loading菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    if (@available(iOS 10, *)) {
        CTCellularData *cellularData = [[CTCellularData alloc] init];
        cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState status) {
            if (status == kCTCellularDataRestricted) {
                 [SVProgressHUD showErrorWithStatus:@"请到设置界面开启应用访问网络权限！"];
            }
        };
    }
}

+ (instancetype)sharedManager {
    static WTHTTPSessionManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[WTHTTPSessionManager alloc] init];
        _instance.userAgent = [NSString stringWithString:[[UIWebView new] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"]];
        [_sessionManager.requestSerializer setValue:_instance.userAgent forHTTPHeaderField:@"User-Agent"];
        [WTHTTPSessionManager networkStatusWithBlock:^(WTNetworkStatus networkStatus) {
            _instance.networkStatus = networkStatus;
        }];
    });
    return _instance;
}

/**
 *  实时获取网络状态,通过Block回调实时获取(此方法block会多次调用)
 */
+ (void)networkStatusWithBlock:(void (^)(WTNetworkStatus networkStatus))statusBlock {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (status)
                {
                    case AFNetworkReachabilityStatusUnknown: //未知网络
                        statusBlock ? statusBlock(WTNetworkStatusUnknown) : nil;
                        _canNetwork = NO;
                        break;
                    case AFNetworkReachabilityStatusNotReachable: //无网络
                        statusBlock ? statusBlock(WTNetworkStatusNotReachable) : nil;
                        _canNetwork = NO;
                        break;
                    case AFNetworkReachabilityStatusReachableViaWiFi: //WIFI
                        statusBlock ? statusBlock(WTNetworkStatusReachableViaWiFi) : nil;
                        _canNetwork = YES;
                        break;
                    case AFNetworkReachabilityStatusReachableViaWWAN:  //手机网络
                        statusBlock ? statusBlock(WTNetworkStatusReachableViaWWAN) : nil;
                        _canNetwork = YES;
                        break;
                }
            });
        }];
        [manager startMonitoring];
    });
}

+ (BOOL)canConnectNetwork {
    return _canNetwork;
}


/**
 get请求
 
 @param relativeGETPath 请求路径
 @param parameters 请求参数
 @param block 响应回调block
 @return 请求任务
 */
- (NSURLSessionTask *)HTTPRequestWithRelativeGETPath:(NSString *)relativeGETPath
                                          parameters:(NSDictionary *)parameters
                                        responeBlock:(void (^)(id jsonObject, NSError *error))block {
    NSString *path = [self getRequestPathWithRelativePath:relativeGETPath];
    NSDictionary *paras = [[self getRequestParametersWithParameters:parameters] copy];
    NSURLSessionTask *sessionTask = [_sessionManager GET:path parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            block(responseObject,nil);
        } else {
            NSDictionary *info = @{NSLocalizedDescriptionKey : @"数据格式有误"};
            block(nil,[NSError errorWithDomain:@"WTReponse" code:kRequestErrorCodeFormat userInfo:info]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = [response statusCode];
        if (!_canNetwork || statusCode == 0) {
            NSDictionary *info = @{NSLocalizedDescriptionKey : kRequestErrorTypeNoNet};
            NSError *server = [NSError errorWithDomain:@"WTReponse" code:kRequestErrorCodeNoNet userInfo:info];
            block ? block(nil,server) : nil;
            return;
        }
        
        NSString *tipsStr = [[NSString alloc]initWithFormat:@"服务器错误，code = %zd",statusCode];
        NSDictionary *info = @{NSLocalizedDescriptionKey : tipsStr};
        NSError *server = [NSError errorWithDomain:@"WTReponse" code:kRequestErrorCodeServer userInfo:info];
        block ? block(nil,server) : nil;
    }];
    return sessionTask;
}


/**
 post请求
 
 @param relativePOSTPath 请求路径
 @param parameters 请求参数
 @param block 响应回调block
 @return 请求任务
 */
- (NSURLSessionTask *)HTTPRequestWithRelativePOSTPath:(NSString *)relativePOSTPath
                                           parameters:(NSDictionary *)parameters
                                         responeBlock:(void (^)(id jsonObject, NSError *error))block {
    NSString *path = [self getRequestPathWithRelativePath:relativePOSTPath];
    NSDictionary *paras = [self getRequestParametersWithParameters:parameters];
    NSURLSessionTask *sessionTask = [_sessionManager POST:path parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            block(responseObject,nil);
        } else {
            NSDictionary *info = @{NSLocalizedDescriptionKey : @"数据格式有误"};
            block(nil,[NSError errorWithDomain:@"WTReponse" code:kRequestErrorCodeFormat userInfo:info]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = [response statusCode];
        if (!_canNetwork || statusCode == 0) {
            NSDictionary *info = @{NSLocalizedDescriptionKey : kRequestErrorTypeNoNet};
            NSError *server = [NSError errorWithDomain:@"WTReponse" code:kRequestErrorCodeNoNet userInfo:info];
            block ? block(nil,server) : nil;
            return;
        }
        
        NSString *tipsStr = [[NSString alloc]initWithFormat:@"服务器错误，code = %zd",statusCode];
        NSDictionary *info = @{NSLocalizedDescriptionKey : tipsStr};
        NSError *server = [NSError errorWithDomain:@"WTReponse" code:kRequestErrorCodeServer userInfo:info];
        block ? block(nil,server) : nil;
    }];
    return sessionTask;
}


/**
 图片上传
 
 @param relativePOSTPath 上传路径
 @param parameters 请求参数
 @param images 上传的图片数组
 @param block 响应回调
 @return 请求任务
 */
- (NSURLSessionTask *)HTTPRequestWithRelativePOSTPath:(NSString *)relativePOSTPath
                                           parameters:(NSDictionary *)parameters
                                               images:(NSArray *)images
                                         responeBlock:(void (^)(id jsonObject, NSError *error))block {
    NSString *path = [self getRequestPathWithRelativePath:relativePOSTPath];
    NSDictionary *paras = [self getRequestParametersWithParameters:parameters];
    NSURLSessionTask *sessionTask = [_sessionManager POST:path parameters:paras constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSInteger i = 0; i < images.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation(images[i], 1);
            NSString *imageName = [NSString stringWithFormat:@"MyCaseSignImage%zd.jpg",i];
            [formData appendPartWithFileData:imageData name:@"receipt" fileName:imageName mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            block(responseObject,nil);
        } else {
            NSDictionary *info = @{NSLocalizedDescriptionKey : @"数据格式有误"};
            block(nil,[NSError errorWithDomain:@"WTReponse" code:kRequestErrorCodeFormat userInfo:info]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = [response statusCode];
        if (!_canNetwork || statusCode == 0) {
            NSDictionary *info = @{NSLocalizedDescriptionKey : kRequestErrorTypeNoNet};
            NSError *server = [NSError errorWithDomain:@"WTReponse" code:kRequestErrorCodeNoNet userInfo:info];
            block ? block(nil,server) : nil;
            return;
        }
        
        NSString *tipsStr = [[NSString alloc]initWithFormat:@"服务器错误，code = %zd",statusCode];
        NSDictionary *info = @{NSLocalizedDescriptionKey : tipsStr};
        NSError *server = [NSError errorWithDomain:@"WTReponse" code:kRequestErrorCodeServer userInfo:info];
        block ? block(nil,server) : nil;
    }];
    return sessionTask;
}


/**
 获取完整请求路径
 */
- (NSString *)getRequestPathWithRelativePath:(NSString *)path {
    return [kBaseURLString stringByAppendingString:path];
}

/**
 格式化请求参数
 */
- (NSDictionary *)getRequestParametersWithParameters:(NSDictionary *)paras {
    NSMutableDictionary *parameters;
    if ([paras isKindOfClass:[NSDictionary class]] && paras.count) {
        parameters = [NSMutableDictionary dictionaryWithDictionary:paras];
    } else {
        parameters = [NSMutableDictionary dictionary];
    }
    return parameters;
}

@end
