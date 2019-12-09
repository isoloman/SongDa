//
//  WTCaseSignCollectionCell.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/10.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseSignCollectionCell.h"

@interface WTCaseSignCollectionCell ()
@property (strong, nonatomic) UIButton *deleteBtn;
@end

@implementation WTCaseSignCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.showImgView = [[UIImageView alloc] initWithFrame:self.bounds];
//    self.showImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.showImgView];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteBtn setImage:HYXImage(@"caseSign_delete") forState:UIControlStateNormal];
    [self.deleteBtn sizeToFit];
    [self.deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteBtn];
}

- (void)setImage:(id)image {
    _image = image;
    
    if ([image isKindOfClass:[UIImage class]]) {
        self.showImgView.image = image;
    } else if ([image isKindOfClass:[NSString class]]) {
        [self.showImgView setImageWithURL:[NSURL URLWithString:image] options:YYWebImageOptionProgressive];
    }
}
- (void)setIsHideDeleteBtn:(BOOL)isHideDeleteBtn {
    _isHideDeleteBtn = isHideDeleteBtn;
    
    self.deleteBtn.hidden = isHideDeleteBtn;
}

- (void)deleteClick {
    WTWeakSelf;
    if (weakSelf.deleteBlock) {
        weakSelf.deleteBlock(weakSelf);
    }
}

@end
