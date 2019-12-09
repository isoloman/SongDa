//
//  WTCaseDetailController.h
//  SongDa
//
//  Created by Fancy on 2018/4/2.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTMessageModel;

typedef void (^PopBlock) (void);

@interface WTCaseDetailController : UITableViewController
/** 案件详情id */
@property (copy, nonatomic) NSString *caseId;
/** 是否是接收到推送消息present出来的 */
@property (assign, nonatomic) BOOL isPresented;
/** 确认接收案件的案件visitRecordIds */
@property (copy, nonatomic) NSString *visitRecordIds;
/** 是否从二维码界面进入 */
@property (assign, nonatomic) BOOL isPushFromCodeVc;
/** 返回点击（从二维码扫描进入到“案件详情”，二维码界面一并退出） */
@property (copy, nonatomic) PopBlock popClickBlock;
/** 我移交案件给A，A的姓名 */
@property (copy, nonatomic) NSString *transferToName;
/** A移交案件给我，A姓名 */
@property (copy, nonatomic) NSString *beTransferName;
/** A移交案件给我，A的id */
@property (copy, nonatomic) NSString *beTransferId;
/** 是否从“已送达”进入 */
@property (assign, nonatomic) BOOL isFromArrived;
/** 推送消息模型 */
@property (strong, nonatomic) WTMessageModel *messageModel;
@end
