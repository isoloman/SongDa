//
//  WTCaseDateView.m
//  SongDa
//
//  Created by 灰太狼 on 2018/6/26.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseDateView.h"

@interface WTCaseDateView ()
@property (strong, nonatomic) UIView *containView;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIView *blackView;
@end

@implementation WTCaseDateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self startAnimation];
    }
    return self;
}

- (void)setupUI {
    //黑色背景
    self.blackView = [[UIView alloc] initWithFrame:self.bounds];
    self.blackView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.blackView];
    
    //标题按钮等整体控件
    self.containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HYXScreenW, 200+50)];
    self.containView.backgroundColor = [UIColor whiteColor];
    self.containView.bottom = HYXScreenH-IPhoneX_Bottom_Safe_Height;
    [self addSubview:self.containView];
    
    //标题控件
    UIView *titleView = [[UIView alloc] init];
    titleView.size = CGSizeMake(HYXScreenW, 50);
    [self.containView addSubview:titleView];
    
    NSArray *titles = @[@"取消",@"时间不限",@"确定"];
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        button.size = CGSizeMake(63, titleView.height);
        if (i == 2) {
            [button setTitleColor:WTBrownColor forState:UIControlStateNormal];
            button.right = titleView.width;
        } else {
            if (i == 1) {
                button.centerX = titleView.width*0.5;
            }
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        button.tag = i;
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:button];
        
        UIView *separateLine = [[UIView alloc] init];
        separateLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        separateLine.size = CGSizeMake(HYXScreenW, 0.5);
        separateLine.y = titleView.height-separateLine.height;
        [titleView addSubview:separateLine];
    }
    
    //日期控件
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), HYXScreenW, 200)];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    self.datePicker.locale = locale;
    [self.containView addSubview:self.datePicker];
}

- (void)startAnimation {
    self.blackView.alpha = 0.001f;
    self.containView.transform = CGAffineTransformMakeTranslation(0, HYXScreenH);
    [UIView animateWithDuration:0.2 animations:^{
        self.blackView.alpha = 0.5;
    }];
    [UIView animateWithDuration:0.25 animations:^{
        self.containView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        HYXLog(@"======================");
    }];
}

- (void)titleClick:(UIButton *)button {
    if (button.tag == 0) {
        [self cancelClick];
    } else if (button.tag == 1) {
        [self cancelPickDate];
    } else {
        [self sureClick];
    }
}
- (void)cancelClick {
    [UIView animateWithDuration:0.3 animations:^{
        self.blackView.alpha = 0.01;
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.containView.transform = CGAffineTransformMakeTranslation(0, HYXScreenH);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)cancelPickDate {
    if (self.dateBlock) {
        self.dateBlock(@"");
    }
    
    [self cancelClick];
}
- (void)sureClick {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [fmt stringFromDate:self.datePicker.date];
    if (self.dateBlock) {
        self.dateBlock(dateString);
    }
    
    [self cancelClick];
}

@end
