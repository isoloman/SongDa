//
//  NSString+HYXCategory.m
//  BiaoQing
//
//  Created by Fancy on 2017/3/16.
//  Copyright © 2017年 Fancy. All rights reserved.
//

#import "NSString+HYXCategory.h"

@implementation NSString (HYXCategory)

/**
 是否是纯数字
 */
- (BOOL)isPureNumber
{
    NSString *pattern = @"^[0-9]+$";
    NSError *error = nil;
    NSRegularExpression *regularExp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray<NSTextCheckingResult *> *result = [regularExp matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return result.count == 0 ? NO : YES;
}


/**
 数字格式化: m <-----> km
 
 @param num 原始数量
 @return 格式化后数量:
 */
+ (NSString *)stringKiloMeterFormatByNum:(double)num {
    NSString *countStr = @"";
    if (num >= 1000.0) {
        countStr = [NSString stringWithFormat:@"%.1fkm", num / 1000.0];
    } else {
        countStr = [NSString stringWithFormat:@"%.0fm",num];
    }
    return countStr;
}

/**
 是否为空（全部空格，或者nil）
 */
- (BOOL)isEmpty
{
    if (!self) {
        return YES;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedStr = [self stringByTrimmingCharactersInSet:set];
        if (trimedStr.length == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

@end
