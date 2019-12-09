//
//  HYXPlaceholderTextView.h
//  
//
//  Created by hyx on 16/8/22.
//  Copyright © 2016年 hyx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HYX_textHeightChangedBlock)(NSString *text,CGFloat textHeight);

@interface HYXPlaceholderTextView : UITextView
/** 是否隐藏占位文字 */
@property (assign, nonatomic) BOOL          isHiddenPlaceholder;
/** 占位文字 */
@property (copy, nonatomic) NSString        *placeholder;
/** 占位文字颜色 */
@property (copy, nonatomic) UIColor         *placeholderColor;
/** 占位符字体大小 */
@property (nonatomic,strong) UIFont         *placeholderFont;
/** 占位符间距 */
@property (nonatomic, assign) CGRect        placeholderRect;
/** textView最大行数(切记设置位置后于placeholderRect) */
@property (nonatomic, assign) NSUInteger    maxNumberOfLines;
/** textView最大高度*/
@property (nonatomic, assign) CGFloat       maxHeight;
/** 设置圆角 */
@property (nonatomic, assign) NSUInteger    cornerRadius;


/**
 *  文字高度改变block → 文字高度改变会自动调用
 *  block参数(text) → 文字内容
 *  block参数(textHeight) → 文字高度
 */
@property (nonatomic, copy) HYX_textHeightChangedBlock textChangedBlock;
@end
