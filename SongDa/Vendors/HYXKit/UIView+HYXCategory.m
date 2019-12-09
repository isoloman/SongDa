//
//  UIView+HYXCategory.m
//  BiaoQing
//
//  Created by Fancy on 2017/4/7.
//  Copyright © 2017年 Fancy. All rights reserved.
//

#import "UIView+HYXCategory.h"

#define kBorderWidth 0.2f

@implementation UIView (HYXCategory)
// x
- (void)setX:(CGFloat)x
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}
- (CGFloat)x
{
    return self.frame.origin.x;
}


// y
- (void)setY:(CGFloat)y
{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}
- (CGFloat)y
{
    return self.frame.origin.y;
}

@end
