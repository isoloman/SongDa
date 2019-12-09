//
//  UIImage+Image.m
//  BiaoQing
//
//  Created by hyx on 16/5/8.
//  Copyright © 2016年 hyx. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)

/**
 *  创建原生图片
 */
+ (instancetype)imageWithOriRenderingImage:(NSString *)imageName
{
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

/**
 颜色转图片
 
 @param color 需要被转的颜色
 @return image
 */
+ (UIImage *)imageWithColor:(UIColor *)color
{
    if (!color) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
