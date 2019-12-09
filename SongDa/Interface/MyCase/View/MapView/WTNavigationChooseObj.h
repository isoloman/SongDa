//
//  WTNavigationChooseObj.h
//  SongDa
//
//  Created by 灰太狼 on 2018/11/5.
//  Copyright © 2018 维途. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WTNavigationChooseObjDelegate <NSObject>
- (void)yc_navigationChooseAreaCard:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface WTNavigationChooseObj : NSObject<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) NSInteger type;//0 案件导航 1搜索导航
@property (nonatomic, weak) id <WTNavigationChooseObjDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
