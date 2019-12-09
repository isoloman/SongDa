//
//  UIImage+Image.h
//  BiaoQing
//
//  Created by hyx on 16/5/8.
//  Copyright © 2016年 hyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)
/**
 * Return 快速返回最原始的图片
 */
+ (instancetype)imageWithOriRenderingImage:(NSString *)imageName;

/**
 颜色转图片

 @param color 需要被转的颜色
 @return image
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
