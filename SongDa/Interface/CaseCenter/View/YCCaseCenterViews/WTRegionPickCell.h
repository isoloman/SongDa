//
//  WTRegionPickCell.h
//  SongDa
//
//  Created by 灰太狼 on 2018/10/11.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTRegionModel;

@interface WTRegionPickCell : UITableViewCell
@property (nonatomic, strong) UILabel * region;
- (void)setModel:(WTRegionModel *)model;
@end
