//
//  WTCaseRelatedButton.h
//  SongDa
//
//  Created by 灰太狼 on 2018/6/27.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTMyCaseModel;

@interface WTCaseRelatedButton : UIButton
@property (strong, nonatomic) UIButton *seletedBtn;
@property (strong, nonatomic) WTMyCaseModel *caseModel;
@end
