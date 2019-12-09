//
//  WTNavigationChooseObj.m
//  SongDa
//
//  Created by 灰太狼 on 2018/11/5.
//  Copyright © 2018 维途. All rights reserved.
//

#import "WTNavigationChooseObj.h"
#import "UIView+SeperatorLine.h"

@interface WTNavigationChooseCell : UITableViewCell
@property (nonatomic, strong) UILabel * content;
@end

@implementation WTNavigationChooseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _content = [UILabel new];
        _content.textColor= UIColorHex(0x333333);
        _content.font = [UIFont systemFontOfSize:15];
        _content.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_content];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [self.contentView addSepetarorLineWithInsetBoth:0 withColor:UIColorHex(0xE5E5E5)];
    }
    
    return self;
}

@end

@implementation WTNavigationChooseObj{
    NSArray * _dataSouce;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[WTNavigationChooseCell class] forCellReuseIdentifier:@"WTNavigationChooseCell"];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        
        _dataSouce = @[@"百度地图",@"高德地图"];
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    return _tableView;
}

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WTNavigationChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WTNavigationChooseCell class])];

    [cell.content setText:_dataSouce[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(yc_navigationChooseAreaCard:didSelectRowAtIndexPath:)]) {
        [_delegate yc_navigationChooseAreaCard:tableView didSelectRowAtIndexPath:indexPath];
    }
}


@end
