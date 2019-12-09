//
//  WTAccountManager.h
//  SongDa
//
//  Created by Fancy on 2018/3/28.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <Foundation/Foundation.h>

// 交通工具类型
typedef NS_ENUM(NSUInteger, WTTrafficType) {
    WTTrafficTypeCar,
    WTTrafficTypeBus,
    WTTrafficTypeBike,
    WTTrafficTypeWalk,
};

@interface WTAccountManager : NSObject
+ (instancetype)sharedManager;
/** 更新登录信息，如果dict为空，则退出登录 */
- (void)loginWithDictionary:(NSDictionary *)dict;
- (BOOL)isLogined;

/** 用户id */
- (NSString *)userId;
/** 用户昵称 */
- (NSString *)userName;
/** 用户头像 */
- (NSString *)avatar;
/** 用户号码 */
- (NSString *)phoneNum;
/** 法院城市代号 */
- (NSString *)courtCity;
/** 交通工具类型 */
- (WTTrafficType)traffic;

- (void)resetUserId:(NSString *)userId;
- (void)resetUserName:(NSString *)userName;
- (void)resetAvatar:(NSString *)avatar;
- (void)resetPhoneNum:(NSString *)phoneNum;
- (void)resetCourtCity:(NSString *)courtCity;
- (void)resetIsLogined:(BOOL)isLogined;
- (void)resetTraffic:(WTTrafficType)traffic;

@end

@interface WTAccountInfo : NSObject
/** 是否处于登录状态 */
@property (assign, nonatomic) BOOL isLogined;
/** 用户id */
@property (copy, nonatomic) NSString *userId;
/** 用户昵称 */
@property (copy, nonatomic) NSString *userName;
/** 用户头像 */
@property (copy, nonatomic) NSString *avatar;
/** 用户号码 */
@property (copy, nonatomic) NSString *phoneNum;
/** 法院城市代号 */
@property (copy, nonatomic) NSString *courtCity;
/** 交通工具类型 */
@property (assign, nonatomic) WTTrafficType traffic;
@end
