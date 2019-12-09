//
//  WTCaseRelatedButton.m
//  SongDa
//
//  Created by 灰太狼 on 2018/6/27.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseRelatedButton.h"
#import "WTMyCaseModel.h"

@interface WTCaseRelatedButton ()
@property (strong, nonatomic) UILabel *codeLabel;
@property (strong, nonatomic) UILabel *litigantLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@end

@implementation WTCaseRelatedButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UILabel *codeLabel = [[UILabel alloc] init];
    codeLabel.text = @"案号：闽民初103第88号";
    codeLabel.textColor = [UIColor colorWithHexString:@"666666"];
    codeLabel.font = [UIFont systemFontOfSize:13];
    [codeLabel sizeToFit];
    codeLabel.x = 15;
    codeLabel.y = 12;
    [self addSubview:codeLabel];
    self.codeLabel = codeLabel;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:HYXImage(@"caseRelated_unseleted") forState:UIControlStateNormal];
    [button setImage:HYXImage(@"caseRelated_seleted") forState:UIControlStateSelected];
    [button sizeToFit];
    button.centerY = self.height*0.5;
    button.right = self.width-15;
    button.userInteractionEnabled = NO;
    [self addSubview:button];
    self.seletedBtn = button;
    
    UILabel *litigantLabel = [[UILabel alloc] init];
    litigantLabel.text = @"当事人：张三";
    litigantLabel.textColor = [UIColor colorWithHexString:@"666666"];
    litigantLabel.font = [UIFont systemFontOfSize:13];
    [litigantLabel sizeToFit];
    litigantLabel.y = codeLabel.y;
    if (litigantLabel.width > HYXScreenW*0.3) {
        litigantLabel.width = HYXScreenW*0.3;
    }
    litigantLabel.right = button.x-15;
    [self addSubview:litigantLabel];
    self.litigantLabel = litigantLabel;
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.text = @"地址：福建省厦门市软件园二期观日路88号";
    addressLabel.textColor = [UIColor colorWithHexString:@"333333"];
    addressLabel.font = [UIFont systemFontOfSize:13];
    [addressLabel sizeToFit];
    addressLabel.x = 15;
    addressLabel.y = CGRectGetMaxY(codeLabel.frame)+12;
    CGFloat addressMaxWidth = button.x-2*15;
    if (addressLabel.width > addressMaxWidth) {
        addressLabel.width = addressMaxWidth;
    }
    [self addSubview:addressLabel];
    self.addressLabel = addressLabel;
    
    UIView *separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    separateLine.size = CGSizeMake(HYXScreenW, 1);
    separateLine.y = self.height-separateLine.height;
    [self addSubview:separateLine];
}

- (void)setCaseModel:(WTMyCaseModel *)caseModel {
    _caseModel = caseModel;
    
    NSString *caseCode = caseModel.caseCode;
    if (!caseCode.length) {
        caseCode = caseModel.preCaseCode;
    }
    self.codeLabel.text = [NSString stringWithFormat:@"案号：%@",caseCode];
    [self.codeLabel sizeToFit];
    if (self.codeLabel.width > HYXScreenW*0.55) {
        self.codeLabel.width = HYXScreenW*0.55;
    }
    self.litigantLabel.text = [NSString stringWithFormat:@"当事人：%@",caseModel.litigantName];
    [self.litigantLabel sizeToFit];
    if (self.litigantLabel.width > HYXScreenW*0.3) {
        self.litigantLabel.width = HYXScreenW*0.3;
    }
    self.addressLabel.text = [NSString stringWithFormat:@"地址：%@",caseModel.fullAddress];
    [self.addressLabel sizeToFit];
    CGFloat addressMaxWidth = self.seletedBtn.x-2*15;
    if (self.addressLabel.width > addressMaxWidth) {
        self.addressLabel.width = addressMaxWidth;
    }
}

@end
