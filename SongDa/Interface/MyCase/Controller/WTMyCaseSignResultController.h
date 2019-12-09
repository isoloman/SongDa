//
//  WTMyCaseSignResultController.h
//  SongDa
//
//  Created by 灰太狼 on 2018/4/10.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BlockResult) (NSString *visitDetail, int visitDetailId);

@interface WTMyCaseSignResultController : UIViewController
/** 是否为“送达结果” */
@property (assign, nonatomic) BOOL isDeliverResult;
/** 点击送达选项回调 */
@property (copy, nonatomic) BlockResult deliverResult;
@end
