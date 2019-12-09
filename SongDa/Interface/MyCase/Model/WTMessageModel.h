//
//  WTMessageModel.h
//  SongDa
//
//  Created by 灰太狼 on 2018/4/23.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WTMessageType) {
    /* 移交给同事，同事确认后我收到推送通知 */
    WTMessageTypeTransferTo,
    /* 同事移交任务给我 */
    WTMessageTypeBeTranfer,
};

@interface WTMessageModel : WTBaseModel
/** 消息体 */
@property (copy, nonatomic) NSString *message;
/** 案件id */
@property (copy, nonatomic) NSString *caseIDs;
@property (strong, nonatomic) NSArray *caseIDArrM;
/** 移交人姓名 */
@property (copy, nonatomic) NSString *transferName;
/** 移交人id */
@property (copy, nonatomic) NSString *transferUserId;
/** 推送消息类型 */
@property (assign, nonatomic) WTMessageType type;
/** 消息接收时间 */
@property (copy, nonatomic) NSString *timeString;

// --------------辅助属性--------------
/** cell高度 */
@property (assign, nonatomic) long cellHeight;
/** 模型在缓存数据库中的索引 */
@property (assign, nonatomic) int diskIndex;
/** 是否未读 */
@property (assign, nonatomic) BOOL isUnread;
/** 是否已接收 */
@property (assign, nonatomic) BOOL isReceived;
@end
