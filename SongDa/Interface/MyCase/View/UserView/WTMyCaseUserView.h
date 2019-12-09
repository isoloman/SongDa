//
//  WTMyCaseUserView.h
//  SongDa
//
//  Created by Fancy on 2018/3/27.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTMyCaseUserView;

@protocol WTMyCaseUserViewDelegate <NSObject>
- (void)userViewWillBeHidden:(WTMyCaseUserView *)userView;
//- (void)pushModifyPasswordController:(WTMyCaseUserView *)userView;
- (void)pushUserMessageController:(WTMyCaseUserView *)userView;
- (void)pushCaseArrivedController:(WTMyCaseUserView *)userView;
- (void)pushTrafficChooseController:(WTMyCaseUserView *)userView;
@end

@interface WTMyCaseUserView : UIView
@property (strong, nonatomic) UITableView *userTableView;
@property (strong, nonatomic) UIView *backgroundView;
@property (weak, nonatomic) id<WTMyCaseUserViewDelegate> delegate;
@end
