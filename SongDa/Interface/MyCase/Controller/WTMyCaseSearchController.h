//
//  WTMyCaseSearchController.h
//  SongDa
//
//  Created by Fancy on 2018/4/16.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTMyCaseSearchModel;

typedef void (^SearchBlock) (WTMyCaseSearchModel *searchModel);

@interface WTMyCaseSearchController : UIViewController
/** 点击周边列表回调 */
@property (copy, nonatomic) SearchBlock searchBlock;
@end
