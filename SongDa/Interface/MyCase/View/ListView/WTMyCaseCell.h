//
//  WTMyCaseCell.h
//  SongDa
//
//  Created by Fancy on 2018/4/2.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTMyCaseCell;
@class WTMyCaseModel;

@protocol WTMyCaseCellDelegate <NSObject>
@optional
- (void)transferCaseToMateInCell:(WTMyCaseCell *)cell;
- (void)signCaseInCell:(WTMyCaseCell *)cell;
@end

@interface WTMyCaseCell : UITableViewCell
/** 是否是按距离排序 */
@property (assign, nonatomic) BOOL isSortByDistance;
@property (strong, nonatomic) WTMyCaseModel *caseModel;
@property (weak, nonatomic) id<WTMyCaseCellDelegate> delegate;
@end
