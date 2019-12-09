//
//  WTMyCaseUserCell.m
//  SongDa
//
//  Created by Fancy on 2018/3/27.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTMyCaseUserCell.h"

#define kLeftViewW  30
#define kLeftViewH  44

@interface WTMyCaseUserCell ()

@end

@implementation WTMyCaseUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.userImgView = [[UIImageView alloc] init];
    self.userImgView.size = CGSizeMake(kLeftViewW, kLeftViewH);
    self.userImgView.contentMode = UIViewContentModeCenter;
    [self addSubview:self.userImgView];
    
    self.userTitleLabel = [[UILabel alloc] init];
    self.userTitleLabel.text = @"交通工具选择";
    self.userTitleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.userTitleLabel.font = [UIFont systemFontOfSize:15];
    self.userTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.userTitleLabel sizeToFit];
    self.userTitleLabel.width += 10;
    self.userTitleLabel.x = CGRectGetMaxX(self.userImgView.frame);
    self.userTitleLabel.centerY = self.userImgView.centerY;
    [self addSubview:self.userTitleLabel];
    
    UIView *separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    separateLine.size = CGSizeMake(HYXScreenW, 0.5);
    separateLine.y = kLeftViewH-separateLine.height;
    [self addSubview:separateLine];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
