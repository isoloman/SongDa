//
//  WTMyCaseCalloutView.m
//  SongDa
//
//  Created by Fancy on 2018/4/12.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTMyCaseCalloutView.h"
#import "WTMyCaseModel.h"

#define kArrowHeight        10
#define kGoToWidth          55

@interface WTMyCaseCalloutView ()
/** 当事人 */
@property (strong, nonatomic) UILabel *nameLabel;
/** 当事人距离 */
@property (strong, nonatomic) UILabel *distanceLabel;
/** 当事人地址 */
@property (strong, nonatomic) UILabel *addrLabel;
/** 导航按钮 */
@property (strong, nonatomic) UIButton *navBtn;
/** 当事人电话1 */
@property (strong, nonatomic) UILabel *phoneLabel;
/** 当事人电话2 */
@property (strong, nonatomic) UILabel *phoneLabel2;
/** 呼叫当事人 */
@property (strong, nonatomic) UIButton *callBtn;
/** 呼叫当事人 */
@property (strong, nonatomic) UIButton *callBtn2;
/** 移交同事 */
@property (strong, nonatomic) UIButton *transferBtn;
/** 添加追记 */
@property (strong, nonatomic) UIButton *addSignBtn;
/** 案号 */
@property (strong, nonatomic) UILabel *codeLabel;
@end

@implementation WTMyCaseCalloutView

- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrowHeight;
    
    CGContextMoveToPoint(context, midx+kArrowHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrowHeight);
    CGContextAddLineToPoint(context,midx-kArrowHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (UILabel *)phoneLabel2
{
    if (_phoneLabel2 == nil) {
        _phoneLabel2 = [[UILabel alloc] init];
        _phoneLabel2.text = @"13800000000";
        _phoneLabel2.textColor = [UIColor colorWithHexString:@"333333"];
        _phoneLabel2.font = [UIFont systemFontOfSize:13];
        [_phoneLabel2 sizeToFit];
        _phoneLabel2.width += 5;
        _phoneLabel2.x = 10;
    }
    return _phoneLabel2;
}
- (UIButton *)callBtn2
{
    if (_callBtn2 == nil) {
        _callBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_callBtn2 setImage:HYXImage(@"myCase_call") forState:UIControlStateNormal];
        [_callBtn2 sizeToFit];
        _callBtn2.centerY = self.phoneLabel2.centerY;
        _callBtn2.x = CGRectGetMaxX(self.phoneLabel.frame)+15;
        [_callBtn2 addTarget:self action:@selector(callClick2) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callBtn2;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.width-kGoToWidth-2*10, 19)];
    self.nameLabel.text = @"张三";
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    [self.nameLabel sizeToFit];
    self.nameLabel.x = 10;
    self.nameLabel.y = 10;
    [self addSubview:self.nameLabel];
    
    UIView *separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    separateLine.size = CGSizeMake(1, 44);
    separateLine.y = 15;
    separateLine.right = self.width-kGoToWidth;
    [self addSubview:separateLine];
    
    self.navBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navBtn setImage:HYXImage(@"myCase_goto") forState:UIControlStateNormal];
    [self.navBtn sizeToFit];
    self.navBtn.y = separateLine.y;
    self.navBtn.centerX = separateLine.x+kGoToWidth*0.5;
    [self.navBtn addTarget:self action:@selector(navClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.navBtn];
    
    UILabel *navLabel = [[UILabel alloc] init];
    navLabel.text = @"去这里";
    navLabel.textColor = [UIColor colorWithHexString:@"666666"];
    navLabel.font = [UIFont systemFontOfSize:13];
    [navLabel sizeToFit];
    navLabel.centerX = self.navBtn.centerX;
    navLabel.y = CGRectGetMaxY(self.navBtn.frame)+5;
    [self addSubview:navLabel];
    
    self.addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.nameLabel.frame)+15, separateLine.x-2*10, 16)];
    self.addrLabel.text = @"福建省厦门市思明区望海路19号楼";
    self.addrLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.addrLabel.font = [UIFont systemFontOfSize:13];
    self.addrLabel.textAlignment = NSTextAlignmentLeft;
    self.addrLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    self.addrLabel.numberOfLines = 2;
    [self addSubview:self.addrLabel];
    
    self.phoneLabel = [[UILabel alloc] init];
    self.phoneLabel.text = @"13800000000";
    self.phoneLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.phoneLabel.font = [UIFont systemFontOfSize:13];
    [self.phoneLabel sizeToFit];
    self.phoneLabel.width += 5;
    self.phoneLabel.x = 10;
    self.phoneLabel.y = CGRectGetMaxY(self.addrLabel.frame)+15;
    [self addSubview:self.phoneLabel];
    
    self.callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.callBtn setImage:HYXImage(@"myCase_call") forState:UIControlStateNormal];
    [self.callBtn sizeToFit];
    self.callBtn.centerY = self.phoneLabel.centerY;
    self.callBtn.x = CGRectGetMaxX(self.phoneLabel.frame)+15;
    [self.callBtn addTarget:self action:@selector(callClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.callBtn];
    
    self.addSignBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addSignBtn.backgroundColor = [UIColor whiteColor];
    [self.addSignBtn setTitle:@"添加追记" forState:UIControlStateNormal];
    [self.addSignBtn setTitleColor:WTBrownColor forState:UIControlStateNormal];
    self.addSignBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.addSignBtn.size = CGSizeMake(69, 32);
    self.addSignBtn.right = self.width-10;
    self.addSignBtn.bottom = self.height-16;
    self.addSignBtn.layer.cornerRadius = 4;
    self.addSignBtn.layer.masksToBounds = YES;
    self.addSignBtn.layer.borderColor = WTBrownColor.CGColor;
    self.addSignBtn.layer.borderWidth = 1;
    [self.addSignBtn addTarget:self action:@selector(signClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addSignBtn];
    
    self.transferBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.transferBtn.backgroundColor = [UIColor whiteColor];
    [self.transferBtn setTitle:@"移交同事" forState:UIControlStateNormal];
    [self.transferBtn setTitleColor:WTBlueColor forState:UIControlStateNormal];
    self.transferBtn.titleLabel.font = self.addSignBtn.titleLabel.font;
    self.transferBtn.size = self.addSignBtn.size;
    self.transferBtn.centerX = self.addSignBtn.centerX;
    self.transferBtn.bottom = self.addSignBtn.y-10;
    self.transferBtn.layer.cornerRadius = 4;
    self.transferBtn.layer.masksToBounds = YES;
    self.transferBtn.layer.borderColor = WTBlueColor.CGColor;
    self.transferBtn.layer.borderWidth = 1;
    [self.transferBtn addTarget:self action:@selector(transferClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.transferBtn];
    
    self.codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.transferBtn.frame), self.transferBtn.x-2*10, 16)];
    self.codeLabel.text = @"案号:闽民初103第88号";
    self.codeLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.codeLabel.font = [UIFont systemFontOfSize:13];
    self.codeLabel.textAlignment = NSTextAlignmentLeft;
    self.codeLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    self.codeLabel.numberOfLines = 2;
    [self addSubview:self.codeLabel];
}

- (void)setMyCaseModel:(WTMyCaseModel *)myCaseModel {
    _myCaseModel = myCaseModel;
    
    self.nameLabel.text = myCaseModel.litigantName;
    [self.nameLabel sizeToFit];
    self.addrLabel.text = myCaseModel.fullAddress;
    [self.addrLabel sizeToFit];
    self.phoneLabel.y = CGRectGetMaxY(self.addrLabel.frame)+15;
    self.callBtn.centerY = self.phoneLabel.centerY;
    if (myCaseModel.phoneNums.count == 1) {
        self.phoneLabel.text = myCaseModel.phoneNums.firstObject;
        if (_phoneLabel2) {
            [self.phoneLabel2 removeFromSuperview];
            [self.callBtn2 removeFromSuperview];
        }
    } else if (myCaseModel.phoneNums.count > 1) {
        self.phoneLabel.text = myCaseModel.phoneNums[0];
        self.phoneLabel2.text = myCaseModel.phoneNums[1];
        self.phoneLabel2.y = CGRectGetMaxY(self.phoneLabel.frame)+18;
        [self addSubview:self.phoneLabel2];
        self.callBtn2.x = CGRectGetMaxX(self.phoneLabel2.frame)+15;
        [self addSubview:self.callBtn2];
    } else {
        
    }
    NSString *caseCode = myCaseModel.caseCode.length ? myCaseModel.caseCode : myCaseModel.preCaseCode;
    self.codeLabel.text = [NSString stringWithFormat:@"案号:%@",caseCode];
    [self.codeLabel sizeToFit];
}

- (void)navClick {
    HYXNote_POST(kMyCaseMapGuideRouteNote, self.myCaseModel);
}
- (void)callClick {
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", self.myCaseModel.phoneNums.firstObject];
    /// 10及其以上系统
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        /// 10以下系统
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}
- (void)callClick2 {
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", self.myCaseModel.phoneNums[1]];
    /// 10及其以上系统
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        /// 10以下系统
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}
- (void)transferClick {
    HYXNote_POST(kMyCaseTransferNote, self.myCaseModel);
}
- (void)signClick {
    HYXNote_POST(kMyCaseAddSignNote, self.myCaseModel);
}

@end
