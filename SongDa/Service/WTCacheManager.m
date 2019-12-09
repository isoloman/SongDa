//
//  WTCacheManager.m
//  SongDa
//
//  Created by Fancy on 2018/3/29.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCacheManager.h"
#import <YYCache.h>

@interface WTCacheManager ()
@property (strong, nonatomic) YYCache *dataCache;
@end

@implementation WTCacheManager

+ (instancetype)sharedManager {
    static WTCacheManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _dataCache = [[YYCache alloc] initWithName:@"WeiTuCenter"];
    }
    return self;
}

- (void)setCache:(id)cache keyValue:(NSString *)key {
    [self.dataCache setObject:cache forKey:key];
}

- (BOOL)containObjectForKey:(NSString *)key {
    return [self.dataCache containsObjectForKey:key];
}

- (_Nonnull id<NSCoding>)getCacheForKey:(NSString *)key {
    return [self.dataCache objectForKey:key];
}

- (void)removeObjectForKey:(NSString *)key {
    [self.dataCache removeObjectForKey:key];
}

@end
