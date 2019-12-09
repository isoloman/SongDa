//
//  WTMyCaseByBusController.h
//  SongDa
//
//  Created by Fancy on 2018/4/18.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTBusRouteModel;

@interface WTMyCaseByBusController : UIViewController
/** 公交搭乘数据模型 */
@property (strong, nonatomic) WTBusRouteModel *busRouteModel;
@end
