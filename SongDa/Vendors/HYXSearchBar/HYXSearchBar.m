//
//  HYXSearchBar.m
//  BiaoQing
//
//  Created by Fancy on 2017/11/6.
//  Copyright © 2017年 Fancy. All rights reserved.
//

#import "HYXSearchBar.h"

@interface HYXSearchBar ()
@property(nonatomic,assign) BOOL isChangeFrame;//是否要改变searchBar的frame
@end

@implementation HYXSearchBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView *subView in self.subviews.firstObject.subviews) {
        
        if ([subView isKindOfClass:[UIImageView class]]) {
            //移除UISearchBarBackground
            [subView removeFromSuperview];
        }
        
        if ([subView isKindOfClass:[UITextField class]]) {
            
            CGFloat height = self.bounds.size.height;
            CGFloat width = self.bounds.size.width;
            
            if (_isChangeFrame) {
                //说明contentInset已经被赋值
                // 根据contentInset改变UISearchBarTextField的布局
                subView.frame = CGRectMake(_contentInset.left, _contentInset.top, width - 2 * _contentInset.left, height - 2 * _contentInset.top);
            } else {
                
                // contentSet未被赋值
                // 设置UISearchBar中UISearchBarTextField的默认边距
                CGFloat top = (height - 28.0) / 2.0;
                CGFloat bottom = top;
                CGFloat left = 8.0;
                CGFloat right = left;
                _contentInset = UIEdgeInsetsMake(top, left, bottom, right);
            }
        }
    }
}

#pragma mark - set method
- (void)setContentInset:(UIEdgeInsets)contentInset {
    
    _contentInset.top = contentInset.top;
    _contentInset.bottom = contentInset.bottom;
    _contentInset.left = contentInset.left;
    _contentInset.right = contentInset.right;
    
    self.isChangeFrame = YES;
    [self layoutSubviews];
}

- (void)setIsChangeFrame:(BOOL)isChangeFrame {
    
    if (_isChangeFrame != isChangeFrame) {
        
        _isChangeFrame = isChangeFrame;
    }
}

@end
