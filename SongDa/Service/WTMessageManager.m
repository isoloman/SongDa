//
//  WTMessageManager.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/23.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTMessageManager.h"
#import "WTMessageModel.h"
#import <FMDatabase.h>

@interface WTMessageManager ()
@property (strong, nonatomic) FMDatabase *database;
@end

@implementation WTMessageManager

+ (instancetype)shareManager {
    static WTMessageManager *_instace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
        if (![_instace openDataBase]) {
            [_instace openDataBase];
        }
    });
    return _instace;
}

- (BOOL)openDataBase {
    NSString *cachePath = HYXPathCache;
    NSString *fillPath = [cachePath stringByAppendingPathComponent:@"WTSongDaMessage.sqlite"];
    self.database = [FMDatabase databaseWithPath:fillPath];
    [self.database open];
    BOOL result = [self.database executeUpdate:@"CREATE TABLE WTSongDaMessage (id integer PRIMARY KEY AUTOINCREMENT, userId text NOT NULL, message text NOT NULL, caseIDs text NOT NULL, transferName text NOT NULL, transferUserId text NOT NULL, type text NOT NULL, timeString text NOT NULL, cellHeight text NOT NULL, diskIndex text NOT NULL, isUnread text NOT NULL, isReceived text NOT NULL);"];
    [self.database close];
    return result;
}

/**
 消息总数
 */
- (NSUInteger)messageCount {
    if (self.database == nil) return 0;
    
    [self.database open];
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM WTSongDaMessage WHERE userId = '%@'",[WTAccountManager sharedManager].userId];
    FMResultSet *result = [self.database executeQuery:sqlStr];
    NSInteger i = 0;
    while ([result next]) {
        i++;
    }
    [self.database close];
    return i;
}

/**
 获取消息
 
 @param index 游标
 @param count 数量
 */
- (NSArray *)getMessageWithIndex:(NSUInteger)index count:(NSUInteger)count {
    if (self.database == nil) return nil;
    
    [self.database open];
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM WTSongDaMessage WHERE userId = '%@' order by id desc LIMIT %zd, %zd",[WTAccountManager sharedManager].userId,index,count];
    FMResultSet *result = [self.database executeQuery:sqlStr];
    NSMutableArray *arrM = [NSMutableArray array];
    while ([result next]) {
        WTMessageModel *model = [[WTMessageModel alloc] init];
        model.message = [result stringForColumn:@"message"];
        model.caseIDs = [result stringForColumn:@"caseIDs"];
        model.transferName = [result stringForColumn:@"transferName"];
        model.transferUserId = [result stringForColumn:@"transferUserId"];
        int type = [result intForColumn:@"type"];
        if (type == 12) {
            model.type = WTMessageTypeBeTranfer;
        } else if (type == 13) {
            model.type = WTMessageTypeTransferTo;
        }
        model.timeString = [result stringForColumn:@"timeString"];
        model.cellHeight = [result longForColumn:@"cellHeight"];
        model.isUnread = [result boolForColumn:@"isUnread"];
        model.isReceived = [result boolForColumn:@"isReceived"];
        model.diskIndex = [result intForColumn:@"diskIndex"];
        [arrM addObject:model];
    }
    [result close];
    [self.database close];
    return arrM;
}

/**
 添加消息
 */
- (BOOL)addMessage:(WTMessageModel *)messageModel {
    if (self.database == nil) return NO;
    
    [self.database open];
    // 遍历，若重复，则删除；否则，添加
    NSString *sqlStr = [NSString stringWithFormat:@"delete from WTSongDaMessage where caseIDs = '%@'",messageModel.caseIDs];
    [self.database executeUpdate:sqlStr];
    
    // userId, message, caseIDs, transferName, transferUserId, type
    NSNumber *type = [NSNumber numberWithInt:12];
    if (messageModel.type == WTMessageTypeBeTranfer) {
        type = [NSNumber numberWithInt:12];
    } else if (messageModel.type == WTMessageTypeTransferTo) {
        type = [NSNumber numberWithInt:13];
    }
    NSNumber *cellHeight = [NSNumber numberWithLong:messageModel.cellHeight];
    NSNumber *isUnread = [NSNumber numberWithBool:messageModel.isUnread];
    NSNumber *isReceived = [NSNumber numberWithBool:messageModel.isReceived];
    NSNumber *diskIndex = [NSNumber numberWithInt:messageModel.diskIndex];
    BOOL isAdd = [self.database executeUpdate:@"INSERT INTO WTSongDaMessage (userId, message, caseIDs, transferName, transferUserId, type, timeString, cellHeight, diskIndex, isUnread, isReceived) VALUES (?,?,?,?,?,?,?,?,?,?,?)",[WTAccountManager sharedManager].userId,messageModel.message,messageModel.caseIDs,messageModel.transferName,messageModel.transferUserId,type,messageModel.timeString,cellHeight,diskIndex,isUnread,isReceived];
    [self.database close];
    return isAdd;
}

/**
 删除消息
 */
- (BOOL)deleteMessage:(WTMessageModel *)messageModel {
    if (self.database == nil) return NO;
    
    [self.database open];
    NSString *sqlStr = [NSString stringWithFormat:@"delete from WTSongDaMessage where caseIDs = '%@'",messageModel.caseIDs];
    BOOL isDelete = [self.database executeUpdate:sqlStr];
    [self.database close];
    return isDelete;
}

/**
 更新
 */
/*
- (BOOL)updateModel:(WTMessageModel *)messageModel {
    if (!messageModel) {
        return NO;
    }
    if (!self.database) return NO;
    [self.database open];
    
    [NSString stringWithFormat:@"update WTSongDaMessage set userId = '%@', message = '%@', caseIDs = '%@', caseIDArrM = '%@' transferName = '%@', transferUserId = '%@', type = '%@', timeString, cellHeight, diskIndex, isUnread, isReceived where id = '%ld'",[WTAccountManager sharedManager].userId,draftsModel.imageKEY,draftsModel.describe,draftsModel.date,emoInfoStr,(long)draftsModel.modelID];
    
    
    NSString *updateStr = [NSString stringWithFormat:@"update WTSongDaMessage set userId = '%@',message = '%@',caseIDs = '%@',transferName = '%ld',transferUserId = '%@',type = '', where id = '%ld'",[WTAccountManager sharedManager].userId,draftsModel.imageKEY,draftsModel.describe,draftsModel.date,emoInfoStr,(long)draftsModel.modelID];
    BOOL isSuccess = [self.database executeUpdate:updateStr];
    
    if (!isSuccess) {
        HYXLog(@"update Failure");
    }
    
    [self.database close];
    return isSuccess;
}
 */

/**
 清空消息记录
 */
- (BOOL)clearMessage {
    if (self.database == nil) return NO;
    
    [self.database open];
    NSString *sqlStr = [NSString stringWithFormat:@"delete from WTSongDaMessage"];
    BOOL isClear = [self.database executeUpdate:sqlStr];
    [self.database close];
    return isClear;
}

@end
