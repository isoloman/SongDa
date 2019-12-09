//
//  WTCaseCenterCell.h
//  SongDa
//
//  Created by Fancy on 2018/3/29.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTCaseCenterModel;
@class WTCaseCenterCell;

@protocol WTCaseCenterCellDelegate <NSObject>
@optional
- (void)didClickDelivererCurrentLocation:(WTCaseCenterCell *)cell;
@end

@interface WTCaseCenterCell : UITableViewCell
@property (strong, nonatomic) WTCaseCenterModel *centerModel;
@property (weak, nonatomic) id<WTCaseCenterCellDelegate> delegate;
@end
