//
//  UILabel+HYXCategory.m
//  SongDa
//
//  Created by Fancy on 2018/4/2.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "UILabel+HYXCategory.h"

@implementation UILabel (HYXCategory)

/**
 两端对齐
 */
- (void)textAlignmentLeftAndRight {
    [self textAlignmentLeftAndRightWithLabelWidth:CGRectGetWidth(self.frame)];
}

/**
 指定label宽度两端对齐
 */
- (void)textAlignmentLeftAndRightWithLabelWidth:(CGFloat)labelWidth {
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT)
                                          options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                       attributes:@{NSFontAttributeName : self.font}
                                          context:nil].size;
    
    CGFloat margin = (labelWidth - size.width)/(self.text.length-1);
    NSNumber *number = [NSNumber numberWithFloat:margin];
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString  alloc]  initWithString:self.text];
    [attribute addAttribute:NSKernAttributeName
                      value:number
                      range:NSMakeRange(0, self.text.length-1)];
    
    self.attributedText = attribute;
}

@end
