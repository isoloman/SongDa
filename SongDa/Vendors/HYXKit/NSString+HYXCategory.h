//
//  NSString+HYXCategory.h
//  BiaoQing
//
//  Created by Fancy on 2017/3/16.
//  Copyright © 2017年 Fancy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HYXCategory)

/**
 是否是纯数字
 */
- (BOOL)isPureNumber;

/**
 数字格式化: m <-----> km
 
 @param num 原始数量
 @return 格式化后数量:
 */
+ (NSString *)stringKiloMeterFormatByNum:(double)num;

/**
 是否为空（全部空格，或者nil）
 */
- (BOOL)isEmpty;

@end
