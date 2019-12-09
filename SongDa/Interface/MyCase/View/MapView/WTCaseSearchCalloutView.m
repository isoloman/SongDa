//
//  WTCaseSearchCalloutView.m
//  SongDa
//
//  Created by Fancy on 2018/4/17.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseSearchCalloutView.h"
#import "WTMyCaseSearchModel.h"
#import "WTCaseDeliverModel.h"
#import "WTCaseTransferDelivererModel.h"
#import "UILabel+extension.h"

#define kArrowHeight        10
#define kDefaultHeight      72

@interface WTCaseSearchCalloutView ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) UIButton *navBtn;
@end

@implementation WTCaseSearchCalloutView{
    CGFloat _otherHeight;
}

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

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 导航按钮
    self.navBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navBtn setImage:HYXImage(@"myCase_goto") forState:UIControlStateNormal];
    [self.navBtn sizeToFit];
    self.navBtn.right = self.width-10;
    self.navBtn.centerY = self.height*0.5;
    [self.navBtn addTarget:self action:@selector(navClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.navBtn];
    
    // 分割线
    UIView *separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    separateLine.size = CGSizeMake(1, 44);
    separateLine.right = self.navBtn.x-10;
    separateLine.centerY = self.navBtn.centerY;
    [self addSubview:separateLine];
    
    // 标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, separateLine.x-2*10, 20)];
    self.titleLabel.text = @"周边标题";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.titleLabel];
    
    // 副标题
    self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame)+5, self.titleLabel.width, 17)];
    self.subTitleLabel.text = @"周边地点";
    self.subTitleLabel.numberOfLines = 0;
    self.subTitleLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.subTitleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.subTitleLabel];
}

- (void)setSearchModel:(WTMyCaseSearchModel *)searchModel {
    _searchModel = searchModel;
    
    self.mj_h = kDefaultHeight;
    
    [self.navBtn setImage:HYXImage(@"myCase_goto") forState:UIControlStateNormal];
    self.titleLabel.text = searchModel.name;
    NSString *distance = [NSString stringKiloMeterFormatByNum:searchModel.distance];
    self.subTitleLabel.text = [NSString stringWithFormat:@"%@ | %@",distance,searchModel.address];
    
    [self adjustSubTitleFrame];
    
}

- (void)setDeliverModel:(WTCaseDeliverModel *)deliverModel {
    _deliverModel = deliverModel;
    
    self.mj_h = kDefaultHeight;
    
    [self.navBtn setImage:HYXImage(@"myCase_call") forState:UIControlStateNormal];
    self.titleLabel.text = deliverModel.deliverName;
    self.subTitleLabel.text = deliverModel.address?deliverModel.address:deliverModel.deliverPhoneNum;
    
    [self adjustSubTitleFrame];
}

- (void)setMapDeliverModel:(WTCaseTransferDelivererModel *)mapDeliverModel {
    _mapDeliverModel = mapDeliverModel;
    
    self.mj_h = kDefaultHeight;
    
    [self.navBtn setImage:HYXImage(@"myCase_call") forState:UIControlStateNormal];
    self.titleLabel.text = mapDeliverModel.name;
    self.subTitleLabel.text = mapDeliverModel.detailAddr;
    [self adjustSubTitleFrame];
}

- (void)adjustSubTitleFrame{
    CGRect rect = [self.subTitleLabel boundingRectWithText:self.subTitleLabel.text];
    if (rect.size.height > 17) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + (rect.size.height-17));
        [self setNeedsDisplay];
    }
}

- (void)navClick {
    if (self.searchModel) {
        HYXNote_POST(kMyCaseAroundGuideRouteNote, self.searchModel);
    } else if (self.deliverModel) {
        HYXNote_POST(kCaseCenterDeliverCallNote, self.deliverModel);
    } else if (self.mapDeliverModel) {
        if (self.mapDeliverModel.phoneNum.length) {
            HYXNote_POST(kMyCaseDeliverCallNote, self.mapDeliverModel.phoneNum);
        }
    }
}

@end
