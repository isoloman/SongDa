//
//  WTPlaceholderView.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/9.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTPlaceholderView.h"

@interface WTPlaceholderView ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *hintLabel;
@end

@implementation WTPlaceholderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:HYXImage(@"placeholder_noData")];
    [imageView sizeToFit];
    imageView.centerX = self.width*0.5;
    imageView.centerY = self.height*0.5-20;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    self.imageView = imageView;
    
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.text = kRequestErrorTypeNoData;
    hintLabel.textColor = [UIColor colorWithHexString:@"666666"];
    hintLabel.font = [UIFont systemFontOfSize:14];
    [hintLabel sizeToFit];
    hintLabel.centerX = imageView.centerX;
    hintLabel.y = CGRectGetMaxY(imageView.frame)+20;
    [self addSubview:hintLabel];
    self.hintLabel = hintLabel;
}

- (void)setHintText:(NSString *)hintText {
    _hintText = hintText;
    
    self.hintLabel.text = hintText;
    [self.hintLabel sizeToFit];
    self.hintLabel.centerX = self.width*0.5;
}

@end
