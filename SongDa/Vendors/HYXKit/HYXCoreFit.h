//
//  HYXCoreFit.h
//  SongDa
//
//  Created by Fancy on 2018/3/29.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HYXSizeFit(s)   [HYXCoreFit sizeWithScale:(s)]
#define HYXFontFit(s)   [HYXCoreFit fontWithScale:(f)]

@interface HYXCoreFit : NSObject

/**
 字体字号适配
 
 @param value 屏宽375时的字号值
 */

+ (float)fontWithScale:(float)value;
/**
 按宽度适配
 
 @param value 屏宽375时的长度值
 */
+ (float)sizeWithScale:(float)value;

@end
