//
//  UIView+SeperatorLine.m
//  DisplayExpression
//
//  Created by administrator on 2017/3/7.
//  Copyright © 2017年 star. All rights reserved.
//

#import "UIView+SeperatorLine.h"
static NSInteger defalutTag = 20170101;

@implementation UIView (SeperatorLine)
- (void)addSepetarorLineWithInsetBoth:(CGFloat)inset withColor:(UIColor *)color{
    if (![self viewWithTag:defalutTag]) {
        UIView * view = [UIView new];
        view.backgroundColor = color;
        view.tag = defalutTag;
        [self addSubview:view];
        
        view.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:inset]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:-inset]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0.5]];
    }
    
}

- (void)hiddenSeperator:(BOOL)hidden{
    UIView * view = [UIView new];
    view.tag = defalutTag;
    view.hidden = hidden;
}

@end
