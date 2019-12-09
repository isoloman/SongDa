//
//  UILabel+extension.h
//  test
//
//  Created by ibook on 15/7/5.
//  Copyright (c) 2015年 kay. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

@interface UILabel (extension)

/*!
 @brief 改变label字符串某段range的颜色
 @param start 起始位置
 @param end 结束位置
 @param string 要改变的字符串
 @ref   返回结果使用 lable.attributedText
 */
-(NSMutableAttributedString *)setAttributedTextWithRange:(NSInteger)start
                                                     end:(NSInteger)end
                                                  String:(NSString*)string
                                                   color:(UIColor *)color;
/*!
 @brief 通过给定的text计算label的frame并返回
 */
- (CGRect) boundingRectWithText:(NSString *)text;

/*!
 @brief 设置label的首行缩进
 @param indent 缩进距离
 */
-(void)setAttributedString:(NSString *)content
            withHeadIndent:(NSInteger)indent;

/*!
 @brief 设置label的text为空时，默认显示内容
 */
-(void)setLabelPlacehold:(NSString *)content;

-(CGRect) boundingRectWidthWithText:(NSString *)text;


-(CGSize)boundingSizeWithText:(NSString *)text;

/*!
 *@brief 设置label删除线
 */
-(void)setStrikethroughWith:(NSString *)text;


/*!
 * 设置Label的行距
 */
- (void)setLineSpacing:(NSInteger)lineSpacing withText:(NSString *)text;

-(CGSize) boundingRectWithText:(NSString *)text NumberOfline:(NSInteger)lines lineSpace:(NSInteger)space;

- (void)setColorOfNumInString:(NSString *)content withColor:(UIColor *)color withLineSpacing:(NSInteger)lineSpace;

-(NSInteger) boundingNumberOfLineWithText:(NSString *)text lineSpace:(NSInteger)space;

- (CGFloat)getTextHeight;

-(CGFloat) boundingHeightWithText:(NSString *)text width:(CGFloat)width;

-(CGRect) boundingBoundsWidthWithText:(NSString *)text;

@end
