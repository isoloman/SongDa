//
//  WTTabBar.m
//  SongDa
//
//  Created by Fancy on 2018/3/27.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTTabBar.h"
#import "WTCaseCodeController.h"
#import "WTNavigationController.h"

@interface WTTabBar ()
@property (strong, nonatomic) UIButton *codeBtn;
/** 扫描按钮背景 */
@property (strong, nonatomic) UIImageView *codeImgView;
@end

@implementation WTTabBar

- (UIImageView *)codeImgView
{
    if (_codeImgView == nil) {
        _codeImgView = [[UIImageView alloc] initWithImage:HYXImage(@"tabBar_caseCode")];
        [_codeImgView sizeToFit];
    }
    return _codeImgView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIButton *codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [codeBtn addSubview:self.codeImgView];
        [codeBtn setTitle:@"扫码" forState:UIControlStateNormal];
        codeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [codeBtn addTarget:self action:@selector(codeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        codeBtn.adjustsImageWhenHighlighted = NO;
        self.codeBtn = codeBtn;
        [self addSubview:self.codeBtn];
        
        //隐藏阴影线
        [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
        [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

#pragma mark - Override Methods
- (void)setFrame:(CGRect)frame
{
    if (self.superview && CGRectGetMaxY(self.superview.bounds) != CGRectGetMaxY(frame)) {
        frame.origin.y = CGRectGetHeight(self.superview.bounds) - CGRectGetHeight(frame);
    }
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat buttonX = 0;
    CGFloat buttonY = 0;
    CGFloat buttonW = self.width / 3.0;
    CGFloat buttonH = 49;
    NSInteger index = 0;
    CGFloat leftMargin = 0;
    
    self.codeBtn.size = CGSizeMake(buttonW, buttonH);
    self.codeBtn.centerX = self.width*0.5;
    self.codeBtn.centerY = buttonH*0.5;
    self.codeImgView.centerX = self.codeBtn.width*0.5;
    self.codeImgView.centerY = self.codeBtn.height*0.5;
    
    if ([[UIDevice currentDevice] isPad]) {
        leftMargin = 90;
        buttonW = (self.width-2*leftMargin)/3.0;
    }
    for (UIControl *button in self.subviews) {
        if (![button isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            continue;
        }
        buttonX = leftMargin + buttonW * (index > 0 ? (index + 1) : index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        index++;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return [super hitTest:point withEvent:event];
    }
    
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView) {
        CGPoint btnP = [self convertPoint:point toView:self.codeBtn];
        CGPoint ImgP = [self convertPoint:point toView:self.codeImgView];
        
        if ([self.codeBtn pointInside:btnP withEvent:event]) {
            return self.codeBtn;
        } else if ([self.codeImgView pointInside:ImgP withEvent:event]) {
            return self.codeBtn;
        } else {
            for (UIControl *button in self.subviews) {
                if ([button isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                    
                    if (CGRectContainsPoint(button.frame, point)){
                        return button;
                    }
                }
                
            }
            CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            anim.duration = 0.5;
            anim.values = @[@1.1,@1.2,@1.1,@1,@1.1,@1.2,@1.1,@1];
            anim.calculationMode = kCAAnimationCubic;
            [hitView.layer addAnimation:anim forKey:@"scale"];
            return hitView;
        }
    }
    
    return [super hitTest:point withEvent:event];
}

- (void)codeBtnClick {
    WTCaseCodeController *codeVc = [[WTCaseCodeController alloc] init];
    WTNavigationController *navVc = [[WTNavigationController alloc] initWithRootViewController:codeVc];
    [HYXRootViewController presentViewController:navVc animated:YES completion:nil];
}

@end
