//
//  WTAccountManager.m
//  SongDa
//
//  Created by Fancy on 2018/3/28.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTAccountManager.h"
#import <JPUSHService.h>

static NSString * const kUserIdKey = @"kUserId";
static NSString * const kUserNameKey = @"kUserName";
static NSString * const kAvatarKey = @"kAvatar";
static NSString * const kPhoneNumKey = @"kPhoneNum";
static NSString * const kCourtCityKey = @"kCourtCity";
static NSString * const kIsLoginKey = @"kIsLogin";
static NSString * const kTrafficKey = @"kTraffic";

// ------------------------WTAccountInfo------------------------
@implementation WTAccountInfo

- (instancetype)init {
    if (self = [super init]) {
        _userId = [self objectInUserDefaults:kUserIdKey];
        _userName = [self objectInUserDefaults:kUserNameKey];
        _avatar = [self objectInUserDefaults:kAvatarKey];
        _phoneNum = [self objectInUserDefaults:kPhoneNumKey];
        _courtCity = [self objectInUserDefaults:kCourtCityKey];
        _isLogined = [[self objectInUserDefaults:kIsLoginKey] boolValue];
        
        NSNumber *trafficNum = [self objectInUserDefaults:kTrafficKey];
        if (trafficNum == nil) {
            _traffic = WTTrafficTypeCar;
        } else {
            switch ([trafficNum integerValue]) {
                case 0:
                    _traffic = WTTrafficTypeCar;
                    break;
                case 1:
                    _traffic = WTTrafficTypeBus;
                    break;
                case 2:
                    _traffic = WTTrafficTypeBike;
                    break;
                case 3:
                    _traffic = WTTrafficTypeWalk;
                    break;
                default:
                    break;
            }
        }
    }
    return self;
}

- (id)objectInUserDefaults:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}
- (void)setObjectInUserDefaults:(id)object withKey:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:object forKey:key];
    [userDefaults synchronize];
}

- (NSString *)userId {
    return _userId ? _userId : @"";
}
- (NSString *)userName {
    return _userName ? _userName : @"";
}
- (NSString *)avatar {
    return _avatar ? _avatar : @"";
}
- (NSString *)phoneNum {
    return _phoneNum ? _phoneNum : @"";
}
- (NSString *)courtCity {
    return _courtCity ? _courtCity : @"";
}
- (BOOL)isLogined {
    return _isLogined ? _isLogined : NO;
}
- (WTTrafficType)traffic {
    return _traffic;
}

- (void)resetUserId:(NSString *)newUserId {
    _userId = newUserId;
    
    [self setObjectInUserDefaults:_userId withKey:kUserIdKey];
}
- (void)resetUserName:(NSString *)newUserName {
    _userName = newUserName;
    
    [self setObjectInUserDefaults:_userName withKey:kUserNameKey];
}
- (void)resetAvatar:(NSString *)newAvatar {
    _avatar = newAvatar;
    
    [self setObjectInUserDefaults:_avatar withKey:kPhoneNumKey];
}
- (void)resetPhoneNum:(NSString *)newPhoneNum {
    _phoneNum = newPhoneNum;
    
    [self setObjectInUserDefaults:newPhoneNum withKey:kPhoneNumKey];
}
- (void)resetCourtCity:(NSString *)newCourtCity {
    _courtCity = newCourtCity;
    
    [self setObjectInUserDefaults:newCourtCity withKey:kCourtCityKey];
}
- (void)resetIsLogined:(BOOL)isLogined{
    _isLogined = isLogined;
    
    [self setObjectInUserDefaults:@(_isLogined) withKey:kIsLoginKey];
}
- (void)resetTraffic:(WTTrafficType)traffic{
    _traffic = traffic;
    
    [self setObjectInUserDefaults:@(_traffic) withKey:kTrafficKey];
}

@end

// ------------------------WTAccountManager------------------------
@interface WTAccountManager ()
@property (strong, nonatomic) WTAccountInfo *accountInfo;
@end

@implementation WTAccountManager

+ (instancetype)sharedManager {
    static WTAccountManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _accountInfo = [[WTAccountInfo alloc] init];
    }
    return self;
}

- (void)loginWithDictionary:(NSDictionary *)dict {
    NSString *userName = [dict stringValueForKey:@"name" default:@""];
    if (userName.length) {
        [[WTAccountManager sharedManager] resetUserId:[dict stringValueForKey:@"id" default:@""]];
        [[WTAccountManager sharedManager] resetUserName:[dict stringValueForKey:@"name" default:@""]];
        [[WTAccountManager sharedManager] resetAvatar:[dict stringValueForKey:@"" default:@""]];
        [[WTAccountManager sharedManager] resetPhoneNum:[dict stringValueForKey:@"mobile" default:@""]];
        [[WTAccountManager sharedManager] resetCourtCity:[dict stringValueForKey:@"courtCity" default:@""]];
        [[WTAccountManager sharedManager] resetIsLogined:YES];
        
        // 保存当前登录时间到本地缓存
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        NSDate *currentDate = [NSDate date];
        NSString *timeString = [formatter stringFromDate:currentDate];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:timeString forKey:kLastLoginTimeKey];
        [userDefaults synchronize];
    } else {
        [[WTAccountManager sharedManager] resetUserId:@""];
        [[WTAccountManager sharedManager] resetUserName:@""];
        [[WTAccountManager sharedManager] resetAvatar:@""];
        [[WTAccountManager sharedManager] resetPhoneNum:@""];
        [[WTAccountManager sharedManager] resetCourtCity:@""];
        [[WTAccountManager sharedManager] resetIsLogined:NO];
    }
}

- (NSString *)userId {
    return _accountInfo.userId;
}
- (NSString *)userName {
    return _accountInfo.userName;
}
- (NSString *)avatar {
    return _accountInfo.avatar;
}
- (NSString *)phoneNum {
    return _accountInfo.phoneNum;
}
- (NSString *)courtCity {
    return _accountInfo.courtCity;
}
- (BOOL)isLogined {
    return _accountInfo.isLogined;
}
- (WTTrafficType)traffic {
    return _accountInfo.traffic;
}

- (void)resetUserId:(NSString *)userId {
    [_accountInfo resetUserId:userId];
}
- (void)resetUserName:(NSString *)userName {
    [_accountInfo resetUserName:userName];
}
- (void)resetAvatar:(NSString *)avatar {
    [_accountInfo resetAvatar:avatar];
}
- (void)resetPhoneNum:(NSString *)phoneNum {
    // 设置推送别名
    if (![phoneNum isEmpty]) {
        [JPUSHService setAlias:phoneNum completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            if (iResCode == 0) {
                HYXLog(@"推送别名设置成功！");
            } else {
                HYXLog(@"推送别名设置失败！");
            }
        } seq:1000];
    }
    [_accountInfo resetPhoneNum:phoneNum];
}
- (void)resetCourtCity:(NSString *)courtCity {
    [_accountInfo resetCourtCity:courtCity];
}
- (void)resetIsLogined:(BOOL)isLogined {
    [_accountInfo resetIsLogined:isLogined];
}
- (void)resetTraffic:(WTTrafficType)traffic {
    [_accountInfo resetTraffic:traffic];
}

@end


