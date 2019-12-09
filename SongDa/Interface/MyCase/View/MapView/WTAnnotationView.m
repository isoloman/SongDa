//
//  WTAnnotationView.m
//  SongDa
//
//  Created by Fancy on 2018/4/12.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTAnnotationView.h"
#import "WTMyCaseCalloutView.h"
#import "WTMyCaseModel.h"
#import "WTCaseSearchCalloutView.h"
#import "WTMyCaseSearchModel.h"

@interface WTAnnotationView ()
// 气泡框
@property (strong, nonatomic) WTMyCaseCalloutView *calloutView;
@property (strong, nonatomic) WTCaseSearchCalloutView *searchView;
@end

@implementation WTAnnotationView

- (WTMyCaseCalloutView *)calloutView
{
    if (_calloutView == nil) {
        CGFloat height = self.caseModel.phoneNums.count > 1 ? 215 : 180;
        _calloutView = [[WTMyCaseCalloutView alloc] initWithFrame:CGRectMake(0, 0, 250, height)];
        _calloutView.centerX = self.width*0.5+self.calloutOffset.x;
        _calloutView.bottom = self.calloutOffset.y;
    }
    return _calloutView;
}

- (WTCaseSearchCalloutView *)searchView
{
    if (_searchView == nil) {
        _searchView = [[WTCaseSearchCalloutView alloc] initWithFrame:CGRectMake(0, 0, 250, 72)];
        _searchView.centerX = self.width*0.5+self.calloutOffset.x;
        _searchView.bottom = self.calloutOffset.y;
    }
    return _searchView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.selected == selected) {
        return;
    }
    if (selected) {
        if (self.caseModel) {
            self.calloutView.myCaseModel = self.caseModel;
            [self addSubview:self.calloutView];
        } else if (self.searchModel) {
            self.searchView.searchModel = self.searchModel;
            [self addSubview:self.searchView];
        } else if (self.deliverModel) {
            self.searchView.deliverModel = self.deliverModel;
            [self addSubview:self.searchView];
        } else if (self.mapDeliverModel) {
            self.searchView.mapDeliverModel = self.mapDeliverModel;
            [self addSubview:self.searchView];
        }
    } else {
        if (_calloutView) {
            [self.calloutView removeFromSuperview];
            self.calloutView = nil;
        }
        if (_searchView) {
            [self.searchView removeFromSuperview];
            self.searchView = nil;
        }
    }
    
    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    //获取点击的位置
    BOOL inside = [super pointInside:point withEvent:event];
    if (!inside) {
        //判断点击的位置是不是在self.calloutView上面，如果是返回YES,不是返回NO
        if (self.caseModel) {
            inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
        } else if (self.searchModel || self.deliverModel || self.mapDeliverModel) {
            if (CGRectContainsPoint(self.bounds, point)) {
                inside = [self.searchView pointInside:[self convertPoint:point toView:self.searchView] withEvent:event];
                if (!inside) {
                    return YES;
                }
            }
            else{
                inside = [self.searchView pointInside:[self convertPoint:point toView:self.searchView] withEvent:event];
            }
            
        }
    }
    
    return inside;
}

@end
