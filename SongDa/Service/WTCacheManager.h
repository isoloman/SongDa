//
//  WTCacheManager.h
//  SongDa
//
//  Created by Fancy on 2018/3/29.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTCacheManager : NSObject
+ (instancetype _Nonnull )sharedManager;

/**
 立即缓存

 @param cache 缓存对象
 @param key 缓存key
 */
- (void)setCache:(id _Nonnull )cache keyValue:(NSString *_Nonnull)key;

/**
 判断是否含有指定缓存

 @param key 指定缓存key
 */
- (BOOL)containObjectForKey:(NSString *_Nonnull)key;

/**
 获取指定缓存

 @param key 指定缓存key
 */
- (_Nonnull id<NSCoding>)getCacheForKey:(NSString *_Nonnull)key;

/**
 移除指定缓存

 @param key 指定缓存key
 */
- (void)removeObjectForKey:(NSString *_Nonnull)key;

@end
