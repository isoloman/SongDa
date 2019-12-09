//
//  HYXCoreFit.m
//  SongDa
//
//  Created by Fancy on 2018/3/29.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "HYXCoreFit.h"

@implementation HYXCoreFit

// 以手机屏幕宽度375作为标准进行适配

+ (float)fontWithScale:(float)value {
    float iPhone6Width = 375;
    float scale = [UIScreen mainScreen].bounds.size.width/iPhone6Width;
    return (scale*value);
}

+ (float)sizeWithScale:(float)value {
    float iPhone6Width = 375;
    float scale = [UIScreen mainScreen].bounds.size.width/iPhone6Width;
    return (scale*value);
}

@end
