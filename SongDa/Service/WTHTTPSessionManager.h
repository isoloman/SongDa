//
//  WTHTTPSessionManager.h
//  SongDa
//
//  Created by Fancy on 2018/3/28.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,WTNetworkStatus) {
    /** 未知网络*/
    WTNetworkStatusUnknown,
    /** 无网络*/
    WTNetworkStatusNotReachable,
    /** Wifi网络*/
    WTNetworkStatusReachableViaWiFi,
    /** 手机网络*/
    WTNetworkStatusReachableViaWWAN,
};

typedef NS_ENUM(NSUInteger,WTRequestSerializer) {
    /** 设置响应数据为JSON格式*/
    WTRequestSerializerJSON,
    /** 设置响应数据为二进制格式*/
    WTRequestSerializerHTTP,
};

@interface WTHTTPSessionManager : NSObject
/** 当前网络状态 */
@property (assign, nonatomic) WTNetworkStatus networkStatus;

+ (instancetype)sharedManager;

+ (BOOL)canConnectNetwork;

/**
 get请求

 @param relativeGETPath 请求路径
 @param parameters 请求参数
 @param block 响应回调block
 @return 请求任务
 */
- (NSURLSessionTask *)HTTPRequestWithRelativeGETPath:(NSString *)relativeGETPath
                                          parameters:(NSDictionary *)parameters
                                        responeBlock:(void (^)(id jsonObject, NSError *error))block;


/**
 post请求
 
 @param relativePOSTPath 请求路径
 @param parameters 请求参数
 @param block 响应回调block
 @return 请求任务
 */
- (NSURLSessionTask *)HTTPRequestWithRelativePOSTPath:(NSString *)relativePOSTPath
                                          parameters:(NSDictionary *)parameters
                                        responeBlock:(void (^)(id jsonObject, NSError *error))block;



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
                                         responeBlock:(void (^)(id jsonObject, NSError *error))block;

@end
