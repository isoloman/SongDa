//
//  WTCaseDateView.h
//  SongDa
//
//  Created by 灰太狼 on 2018/6/26.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DateBlock) (NSString *dateStr);

@interface WTCaseDateView : UIView
/** 选中日期回调 */
@property (copy, nonatomic) DateBlock dateBlock;
@end
