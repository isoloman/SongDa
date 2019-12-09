//
//  WTRegionPickObj.m
//  SongDa
//
//  Created by 灰太狼 on 2018/10/11.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTRegionPickObj.h"
#import "WTRegionPickHeader.h"
#import "WTRegionPickCell.h"
#import "WTRegionManager.h"
#import "WTRegionModel.h"

@implementation WTRegionPickObj{
    NSInteger _selectedIndex;
    NSMutableDictionary * _areaForCity;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[WTRegionPickCell class] forCellReuseIdentifier:@"WTRegionPickCell"];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _areaForCity = [NSMutableDictionary new];
        _selectedIndex = -1;
    }
    
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    WTRegionModel * remodel = _dataSource[section];
    NSArray * data = [_areaForCity valueForKey:@(remodel.region_id).stringValue];
    
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WTRegionPickCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WTRegionPickCell"];
    WTRegionModel * remodel = _dataSource[indexPath.section];
    NSArray * data = [_areaForCity valueForKey:@(remodel.region_id).stringValue];
    [cell setModel:data[indexPath.row]];
    cell.region.hidden = !(indexPath.section == _selectedIndex);
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WTRegionPickHeader * header = [[WTRegionPickHeader alloc]initWithReuseIdentifier:@"WTRegionPickHeader"];
    [header setModel:_dataSource[section]];
    header.selected = _selectedIndex == section;
    WTRegionModel * remodel = _dataSource[section];
    HYXWeakSelf(self);
    HYXWeakSelf(header);
    header.tapAction = ^{
        HYXStrongSelf(self);
        
        if (self->_selectedIndex != section) {
            self->_selectedIndex = section;
            weakheader.selected = YES;
            NSArray * data = [_areaForCity valueForKey:@(remodel.region_id).stringValue];
            if (data.count==0) {
                data = [WTRegionManager getCityRegion:remodel.region_id];
                [_areaForCity setValue:data forKey:@(remodel.region_id).stringValue];
            }
            
            NSInteger last = self->_selectedIndex;
            if (last > 0) {
                [self.tableView reloadSection:last withRowAnimation:UITableViewRowAnimationFade];
            }
            [self.tableView reloadSection:section withRowAnimation:UITableViewRowAnimationFade];
            
//            [self.tableView scrollToRow:0 inSection:section atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        else{
            weakheader.selected = NO;
            self->_selectedIndex = -1;
            [self.tableView reloadSection:section withRowAnimation:UITableViewRowAnimationFade];
        }

    };
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectedIndex == indexPath.section) {
        return 44;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_delegate && [_delegate respondsToSelector:@selector(yc_regionPickObj:didSelectRowAtIndexPath:withModel:)]) {
        WTRegionModel * remodel = _dataSource[indexPath.section];
        NSArray * data = [_areaForCity valueForKey:@(remodel.region_id).stringValue];
        [_delegate yc_regionPickObj:tableView didSelectRowAtIndexPath:indexPath withModel:data[indexPath.row]];
    }
}

- (void)reloadData{
    [_tableView reloadData];
}
@end
