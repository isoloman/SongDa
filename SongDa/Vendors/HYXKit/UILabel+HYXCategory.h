//
//  UILabel+HYXCategory.h
//  SongDa
//
//  Created by Fancy on 2018/4/2.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (HYXCategory)

/**
 两端对齐
 */
- (void)textAlignmentLeftAndRight;

/**
 指定label宽度两端对齐
 */
- (void)textAlignmentLeftAndRightWithLabelWidth:(CGFloat)labelWidth;

@end
