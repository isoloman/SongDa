//
//  HYXPlaceholderTextView.m
//  
//
//  Created by hyx on 16/8/22.
//  Copyright © 2016年 hyx. All rights reserved.
//

#import "HYXPlaceholderTextView.h"

@interface HYXPlaceholderTextView ()
/**
 *  UITextView作为placeholderView，使placeholderView等于UITextView的大小，字体重叠显示，方便快捷，解决占位符问题.
 */
@property (nonatomic, strong) UITextView *placeholderView;

/** 文字高度 */
@property (nonatomic, assign) NSInteger textH;

/** 文字最大高度 */
@property (nonatomic, assign) NSInteger maxTextH;
@end

@implementation HYXPlaceholderTextView

- (UITextView *)placeholderView
{
    if (!_placeholderView ) {
        _placeholderView = [[UITextView alloc] initWithFrame:self.bounds];
        //防止textView输入时跳动问题
        _placeholderView.scrollEnabled = NO;
        _placeholderView.showsHorizontalScrollIndicator = NO;
        _placeholderView.showsVerticalScrollIndicator = NO;
        _placeholderView.userInteractionEnabled = NO;
        _placeholderView.font = self.font;
        _placeholderView.textColor = [UIColor lightGrayColor];
        _placeholderView.backgroundColor = [UIColor clearColor];
        [self addSubview:_placeholderView];
    }
    return _placeholderView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.scrollEnabled = NO;
    self.scrollsToTop = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.enablesReturnKeyAutomatically = YES;
    self.layer.borderWidth = 0;
    self.layer.borderColor = [UIColor lightTextColor].CGColor;
    //实时监听textView值得改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    [HYXNoteCenter addObserver:self selector:@selector(textDidChange) name:@"HYXPlaceholderTextViewTextDidChange" object:nil];
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    self.contentInset = UIEdgeInsetsMake(16, 24, 16, 24);
//}

- (void)setPlaceholderRect:(CGRect)placeholderRect
{
    _placeholderRect = placeholderRect;
    
    self.placeholderView.x = placeholderRect.origin.x;
    self.placeholderView.y = placeholderRect.origin.y;
    self.placeholderView.size = CGSizeMake(self.width-placeholderRect.origin.x, self.height-placeholderRect.origin.y);
}

- (void)setIsHiddenPlaceholder:(BOOL)isHiddenPlaceholder
{
    _isHiddenPlaceholder = isHiddenPlaceholder;
    
    self.placeholderView.hidden = isHiddenPlaceholder;
}

- (void)textDidChange
{
    // 根据文字内容决定placeholderView是否隐藏
    self.placeholderView.hidden = self.text.length > 0;
    
    NSInteger height = ceilf([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
    if (_textH != height) { // 高度不一样，就改变了高度
        
        // 当高度大于最大高度时，需要滚动
        self.scrollEnabled = height > _maxTextH && _maxTextH > 0;
        
        _textH = height;
        //当不可以滚动（即 <= 最大高度）时，传值改变textView高度
        if (_textChangedBlock && self.scrollEnabled == NO) {
            _textChangedBlock(self.text,height);
            
            [self.superview layoutIfNeeded];
//            self.placeholderView.frame = self.bounds;
        }
        //当一次性复制大量文字，高度则相应大于最大高度，此时改变textView高度为最大高度，且滚动
        else if (_textChangedBlock && self.scrollEnabled == YES) {
            _textChangedBlock(self.text,_maxTextH);
            [self.superview layoutIfNeeded];
        }
    }
}

- (void)setMaxNumberOfLines:(NSUInteger)maxNumberOfLines
{
    _maxNumberOfLines = maxNumberOfLines;
    
    /**
     *  根据最大的行数计算textView的最大高度
     *  计算最大高度 = (每行高度 * 总行数 + 文字上下间距)
     */
    _maxTextH = ceil(self.font.lineHeight * maxNumberOfLines + self.textContainerInset.top + self.textContainerInset.bottom+self.placeholderRect.origin.y);
}
- (void)setMaxHeight:(CGFloat)maxHeight
{
    _maxHeight = maxHeight;
    
    _maxTextH = maxHeight;
}

- (void)setCornerRadius:(NSUInteger)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 重写setter方法
/**
 *  通过设置placeholder设置私有属性placeholderView中的textColor
 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderView.textColor = placeholderColor;
}
/**
 *  通过设置placeholder设置私有属性placeholderView中的textColor
 */
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    self.placeholderView.text = placeholder;
}
/**
 *  通过设置_placeholderFont设置私有属性placeholderView中的Font
 */
- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    
    _placeholderFont = placeholderFont;
    
    self.placeholderView.font = placeholderFont;
}

@end
