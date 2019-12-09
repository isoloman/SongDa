//
//  WTRegionPickHeader.h
//  SongDa
//
//  Created by 灰太狼 on 2018/10/11.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTRegionModel;

@interface WTRegionPickHeader : UITableViewHeaderFooterView
@property (nonatomic,assign) BOOL selected;

@property (nonatomic,copy) void(^ tapAction)(void);

- (void)setModel:(WTRegionModel *)model;
@end
