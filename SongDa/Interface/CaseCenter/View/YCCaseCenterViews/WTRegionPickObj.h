//
//  WTRegionPickObj.h
//  SongDa
//
//  Created by 灰太狼 on 2018/10/11.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WTRegionModel;

@protocol WTRegionPickObjDelegate <NSObject>

@optional;
- (void)yc_regionPickObj:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withModel:(WTRegionModel *)model;

@end

@interface WTRegionPickObj : NSObject<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray <WTRegionModel *> * dataSource;
@property (nonatomic, weak) id <WTRegionPickObjDelegate> delegate;
@end
