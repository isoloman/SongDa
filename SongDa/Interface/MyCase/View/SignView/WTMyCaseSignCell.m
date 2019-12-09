//
//  WTMyCaseSignCell.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/10.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTMyCaseSignCell.h"

#define kItemHeight     44

@interface WTMyCaseSignCell ()
@property (strong, nonatomic) UIView *separateLine;
@end

@implementation WTMyCaseSignCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initConfig];
    }
    return self;
}

- (void)initConfig {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"上门情况";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.titleLabel sizeToFit];
    self.titleLabel.x = 15;
    self.titleLabel.centerY = kItemHeight*0.5;
    [self addSubview:self.titleLabel];
    
    UIImageView *nextImgView = [[UIImageView alloc] initWithImage:HYXImage(@"common_next")];
    [nextImgView sizeToFit];
    nextImgView.right = HYXScreenW-15;
    nextImgView.centerY = self.titleLabel.centerY;
    [self addSubview:nextImgView];
    
    CGFloat width = nextImgView.x-15-(CGRectGetMaxX(self.titleLabel.frame)+15);
    self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+15, 5, width, 34)];
    self.subTitleLabel.text = @"请先选择上门情况";
    self.subTitleLabel.textColor = [UIColor colorWithHexString:@"606171"];
    self.subTitleLabel.textAlignment = NSTextAlignmentRight;
    self.subTitleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.subTitleLabel];
    
    UIView *separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    separateLine.size = CGSizeMake(HYXScreenW-2*10, 0.5);
    separateLine.centerX = HYXScreenW*0.5;
    separateLine.y = kItemHeight-separateLine.height;
    separateLine.hidden = YES;
    [self addSubview:separateLine];
    self.separateLine = separateLine;
}

- (void)setIsHideSeparateLine:(BOOL)isHideSeparateLine {
    _isHideSeparateLine = isHideSeparateLine;
    
    self.separateLine.hidden = isHideSeparateLine;
}

@end
