//
//  WTMyCaseListView.h
//  SongDa
//
//  Created by Fancy on 2018/3/27.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTMyCaseListView;
@class WTMyCaseModel;

typedef void (^DataChosenBlock) (void);

@protocol WTMyCaseListViewDelegate <NSObject>
- (void)transferCaseToMateInListView:(WTMyCaseListView *)liseView currentModel:(WTMyCaseModel *)caseModel;
- (void)signCaseInListView:(WTMyCaseListView *)listView currentModel:(WTMyCaseModel *)caseModel;
@end

@interface WTMyCaseListView : UIView
@property (strong, nonatomic) WTTotalModel *totalModel;
@property (weak, nonatomic) id<WTMyCaseListViewDelegate> delegate;
/** 根据日期筛选案件 */
@property (copy, nonatomic) DataChosenBlock dataChosenBlock;
/** 筛选案件日期 */
@property (copy, nonatomic) NSString *chosenDateStr;
@end
