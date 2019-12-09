//
//  UILabel+extension.m
//  test
//
//  Created by ibook on 15/7/5.
//  Copyright (c) 2015年 kay. All rights reserved.
//

#import "UILabel+extension.h"

@implementation UILabel (extension)

//设置行距
- (void)setLineSpacing:(NSInteger)lineSpacing withText:(NSString *)text{
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : self.font,}];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    [self setAttributedText:attributedString];
}


//label删除线
- (void)setStrikethroughWith:(NSString *)text{
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:text
                                  attributes:
  @{
    NSFontAttributeName:self.font,
    NSForegroundColorAttributeName:self.textColor,
    NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
    NSStrikethroughColorAttributeName:self.textColor
    }];
    
    self.attributedText = attrStr;
    
}


-(NSMutableAttributedString *)setAttributedTextWithRange:(NSInteger)start
                                                     end:(NSInteger)end
                                                  String:(NSString*)string
                                                   color:(UIColor *)color
{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    if (start + end > string.length) {
        [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(start,string.length-start)];
        self.attributedText = str;
        return str;
    }
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(start,end)];
    self.attributedText = str;
    return str;
}

-(CGFloat) boundingHeightWithText:(NSString *)text width:(CGFloat)width{
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:self.font} context:nil].size;
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    NSLog(@"size = %@",NSStringFromCGSize(size));
    return size.height;
    
}

-(CGRect) boundingRectWithText:(NSString *)text{
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:self.font} context:nil].size;
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
    
    return self.frame;
    
}

-(CGSize) boundingRectWithText:(NSString *)text NumberOfline:(NSInteger)lines lineSpace:(NSInteger)space{
    
    CGFloat labelHeight = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)].height;
    NSNumber * count = @((labelHeight) / (self.font.lineHeight + 6));
//    NSLog(@"%f",[count floatValue] + 0.5);
    
    NSInteger numberOfLine = ([count floatValue] + 0.5)>lines?lines:[count floatValue] + 0.5;
    if (lines == 0) {
        numberOfLine = [count floatValue] + 0.5;
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, numberOfLine * self.font.lineHeight + (numberOfLine - 1) * space);
    
    
    return self.frame.size;
    
}

-(NSInteger) boundingNumberOfLineWithText:(NSString *)text lineSpace:(NSInteger)space{
    
    CGFloat labelHeight = [self boundingRectWithText:text].size.height;
    NSNumber * count = @((labelHeight) / (self.font.lineHeight));
//    NSLog(@"%f",[count floatValue] + 0.5);
    
    NSInteger numberOfLine = [count floatValue];
    
    return numberOfLine;
}


-(CGRect) boundingRectWidthWithText:(NSString *)text{
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT,self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:self.font} context:nil].size;
    
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.numberOfLines = 0;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
    
    return self.frame;
}

-(CGRect) boundingBoundsWidthWithText:(NSString *)text{
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT,self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:self.font} context:nil].size;
    
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.numberOfLines = 0;
    self.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, size.width, size.height);
    
    return self.bounds;
    
}


-(void)setAttributedString:(NSString *)content withHeadIndent:(NSInteger)indent{
    
    NSMutableAttributedString *attributedString = [[ NSMutableAttributedString alloc ] initWithString : content ];
    
    NSMutableParagraphStyle *paragraphStyle = [[ NSMutableParagraphStyle alloc ] init ];
    
    [paragraphStyle setFirstLineHeadIndent : indent ];
    
    [attributedString addAttribute : NSParagraphStyleAttributeName value :paragraphStyle range : NSMakeRange ( 0 , [ content length ])];
    
    self.attributedText = attributedString;
}

-(void)setLabelPlacehold:(NSString *)content{
    
    if ([UILabel isBlankString:self.text]) {
        
        if ([UILabel isBlankString:content]) {
            self.text = @"暂无信息";
        }else{
            self.text = content;
        }
    }
}

- (void)setColorOfNumInString:(NSString *)content withColor:(UIColor *)color withLineSpacing:(NSInteger)lineSpace{
    // 1首选初始化对象，正则表达式选取0到9的数字范围
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^0-9]" options:0 error:nil];
    
    //2获取查询结果，得到的数组里面有一行文本中数字的范围

    NSArray *numArr = [regex matchesInString:content options:0 range:NSMakeRange(0, [content length])];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSForegroundColorAttributeName:color}];
    
    
    //3循环找到数字的范围用富文本来给这行文本赋值
    
    for (NSTextCheckingResult *attirbute in numArr) {
        
        [attributedString setAttributes:@{NSForegroundColorAttributeName:self.textColor} range:attirbute.range];
        
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];//行距
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    
    self.attributedText = attributedString;
}


+(BOOL)isBlankString:(NSString *)string{
    
    
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    
    
    if (IOS_VERSION >= 8.0) {
        if ([string containsString:@"null"]||[string containsString:@"nil"]) {
            return YES;
        }
    }else{
        if ([string rangeOfString:@"null"].location != NSNotFound || [string rangeOfString:@"nil"].location != NSNotFound) {
            
            return YES;
        }
    }
    return NO;
}

-(CGSize)boundingSizeWithText:(NSString *)text{
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:self.font} context:nil].size;
    
    
    return size;
    
}

- (CGFloat)getTextHeight{
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:self.font} context:nil].size;
    
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.numberOfLines = 0;

    return size.height;
}

@end
