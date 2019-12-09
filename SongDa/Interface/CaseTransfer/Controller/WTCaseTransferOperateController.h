//
//  WTCaseTransferOperateController.h
//  SongDa
//
//  Created by 灰太狼 on 2018/4/8.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTCaseTransferOperateController : UIViewController
@property (copy, nonatomic) NSString *caseId;
@property (copy, nonatomic) NSString *courtId;
@property (strong, nonatomic) WTTotalModel *caseModels;
/** 移交请求成功回调 */
@property (copy, nonatomic) void(^TransferSuccessBlcok)(void);
@end
