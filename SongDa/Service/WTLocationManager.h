//
//  WTLocationManager.h
//  SongDa
//
//  Created by 灰太狼 on 2018/4/10.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>

@interface WTLocationManager : NSObject
/** 经度 */
@property (nonatomic ,assign) CGFloat longitude;
/** 纬度 */
@property (nonatomic ,assign) CGFloat latitude;


@property (nonatomic ,copy) NSString * currentCity;
@property (nonatomic ,copy) NSString * currentProvince;
@property (nonatomic ,copy) NSString * cityName;//如北京，不包含市字
@property (nonatomic ,copy) NSString * provinceName;
@property (nonatomic ,copy) NSString * currentAdress;

@property (strong, nonatomic) AMapLocationManager *locationManager;


+ (instancetype)shareInstance;
- (void)start;


- (void)reportCurrentAddress;
+ (void)requestLocationCompletionBlock:(AMapLocatingCompletionBlock)completionBlock;


@end
