//
//  WTMyCaseSignController.h
//  SongDa
//
//  Created by 灰太狼 on 2018/4/10.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^AddSignBlock) (void);
@class WTMyCaseModel;

@interface WTMyCaseSignController : UIViewController
@property (strong, nonatomic) WTMyCaseModel *caseModel;
/** 成功添加追记 */
@property (copy, nonatomic) AddSignBlock addSignBlock;
/** 上门追记 送达id */
@property (copy, nonatomic) NSString *visitRecordId;
/** 案件组id */
@property (copy, nonatomic) NSString *groupID;
@end
