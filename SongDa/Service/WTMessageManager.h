//
//  WTMessageManager.h
//  SongDa
//
//  Created by 灰太狼 on 2018/4/23.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WTMessageModel;

@interface WTMessageManager : NSObject

+ (instancetype)shareManager;

/**
 消息总数
 */
- (NSUInteger)messageCount;

/**
 获取消息

 @param index 游标
 @param count 数量
 */
- (NSArray *)getMessageWithIndex:(NSUInteger)index count:(NSUInteger)count;

/**
 添加消息
 */
- (BOOL)addMessage:(WTMessageModel *)messageModel;

/**
 删除消息
 */
- (BOOL)deleteMessage:(WTMessageModel *)messageModel;

/**
 更新
 - (BOOL)updateModel:(WTMessageModel *)messageModel;
 */

/**
 清空消息记录
 */
- (BOOL)clearMessage;

@end
