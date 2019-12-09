//
//  WTRegionPickCell.m
//  SongDa
//
//  Created by 灰太狼 on 2018/10/11.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTRegionPickCell.h"
#import "WTRegionModel.h"
#import "UIView+SeperatorLine.h"

@implementation WTRegionPickCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.masksToBounds = YES;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSepetarorLineWithInsetBoth:0 withColor:UIColorHex(0xE5E5E5)];
    }
    
    return self;
}

- (void)setModel:(WTRegionModel *)model{
    self.region.text = model.local_name;
}

- (UILabel *)region{
    if (!_region) {
        _region = [UILabel new];
        _region.font = [UIFont systemFontOfSize:14];
        _region.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        [self.contentView addSubview:_region];
        
        [_region mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.mas_offset(45);
        }];
    }
    return _region;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
