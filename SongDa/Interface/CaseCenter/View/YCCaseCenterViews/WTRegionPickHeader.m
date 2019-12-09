//
//  WTRegionPickHeader.m
//  SongDa
//
//  Created by 灰太狼 on 2018/10/11.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTRegionPickHeader.h"
#import "WTRegionModel.h"
#import "UIView+SeperatorLine.h"

@interface WTRegionPickHeader ()
@property (nonatomic, strong) UILabel * region;
@property (nonatomic, strong) UIImageView * imageView;
@end

@implementation WTRegionPickHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self imageView];
        [self.contentView addSepetarorLineWithInsetBoth:0 withColor:UIColorHex(0xE5E5E5)];
        [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            if (_tapAction) {
                _tapAction();
            }
        }]];
    }
    
    return self;
}

- (void)setModel:(WTRegionModel *)model{
    self.region.text = model.local_name;
}

- (void)setSelected:(BOOL)selected{
    _selected = selected;
    if (_selected) {
        self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI);
    }
    else{
        self.imageView.transform = CGAffineTransformMakeRotation(0);
    }
}

- (UILabel *)region{
    if (!_region) {
        _region = [UILabel new];
        _region.font = [UIFont systemFontOfSize:14];
        _region.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        [self.contentView addSubview:_region];
        
        [_region mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.mas_offset(15);
        }];
    }
    return _region;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithImage:HYXImage(@"caseCenter_zone_next")];
        [self.contentView addSubview:_imageView];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-15);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(12, 7));
        }];
    }
    
    return _imageView;
}

@end
