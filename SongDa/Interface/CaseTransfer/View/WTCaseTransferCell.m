//
//  WTCaseTransferCell.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/8.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseTransferCell.h"
#import "WTCaseTransferDelivererModel.h"

@interface WTCaseTransferCell ()
@property (strong, nonatomic) UIImageView *iconImgView;
@property (strong, nonatomic) UIImageView *phoneImgView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *phoneLabel;
@property (strong, nonatomic) UIImageView *transferImgView;
@end

@implementation WTCaseTransferCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.iconImgView = [[UIImageView alloc] initWithImage:HYXImage(@"placeholder_user")];
    self.iconImgView.size = CGSizeMake(40, 40);
    self.iconImgView.x = 10;
    self.iconImgView.centerY = 64*0.5;
    self.iconImgView.layer.cornerRadius = self.iconImgView.height*0.5;
    self.iconImgView.layer.masksToBounds = YES;
    [self addSubview:self.iconImgView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"周星星";
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    [self.nameLabel sizeToFit];
    self.nameLabel.x = CGRectGetMaxX(self.iconImgView.frame)+10;
    self.nameLabel.y = self.iconImgView.y;
    [self addSubview:self.nameLabel];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callTheNum)];
    
    self.phoneLabel = [[UILabel alloc] init];
    self.phoneLabel.text = @"0592-68886688";
    self.phoneLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.phoneLabel.font = [UIFont systemFontOfSize:12];
    [self.phoneLabel sizeToFit];
    self.phoneLabel.x = self.nameLabel.x;
    self.phoneLabel.bottom = self.iconImgView.bottom;
    self.phoneLabel.userInteractionEnabled = YES;
    [self.phoneLabel addGestureRecognizer:tapGesture];
    [self addSubview:self.phoneLabel];
    
    self.phoneImgView = [[UIImageView alloc] initWithImage:HYXImage(@"caseTransfer_phone")];
    self.phoneImgView.contentMode = UIViewContentModeCenter;
    self.phoneImgView.size = CGSizeMake(36, 36);
    self.phoneImgView.x = CGRectGetMaxX(self.nameLabel.frame);
    self.phoneImgView.centerY = self.nameLabel.centerY;
    self.phoneImgView.userInteractionEnabled = YES;
    [self.phoneImgView addGestureRecognizer:tapGesture];
    [self addSubview:self.phoneImgView];
    
    self.transferImgView = [[UIImageView alloc] initWithImage:HYXImage(@"caseTransfer_transfer")];
    self.transferImgView.size = CGSizeMake(36, 36);
    self.transferImgView.right = HYXScreenW-10;
    self.transferImgView.centerY = 64*0.5;
    [self addSubview:self.transferImgView];
}

- (void)setDelivererModel:(WTCaseTransferDelivererModel *)delivererModel {
    _delivererModel = delivererModel;
    
    self.nameLabel.text = delivererModel.name;
    [self.nameLabel sizeToFit];
    self.phoneImgView.x = CGRectGetMaxX(self.nameLabel.frame);
    self.phoneLabel.text = delivererModel.phoneNum;
}

- (void)callTheNum {
    if (![self.delivererModel.phoneNum isEmpty]) {
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", self.delivererModel.phoneNum];
        /// 10及其以上系统
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        } else {
            /// 10以下系统
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
    }
}

@end
