//
//  WTMyCaseMessageController.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/4.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTMyCaseMessageController.h"
#import "WTMessageManager.h"
#import "WTCaseDetailController.h"
#import "WTMessageManager.h"
#import "WTMessageModel.h"

@interface WTMyCaseMessageController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArrM;
@property (strong, nonatomic) WTPlaceholderView *placeholderView;
@end

@implementation WTMyCaseMessageController

static NSString * const ID = @"cell";

- (WTPlaceholderView *)placeholderView
{
    if (_placeholderView == nil) {
        _placeholderView = [[WTPlaceholderView alloc] initWithFrame:CGRectMake(0, 10, self.tableView.width, self.tableView.height)];
        _placeholderView.backgroundColor = [UIColor whiteColor];
    }
    return _placeholderView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"消息中心";
    
    [self setupTableView];
    [self loadData];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, HYXScreenW, HYXScreenH-IPhoneX_Nav_Height)];
    tableView.backgroundColor = [UIColor whiteColor];
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    tableView.tableFooterView = [UIView new];
    
    adjustsScrollViewInsets(tableView);
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
}

- (void)loadData {
    self.dataArrM = [[[WTMessageManager shareManager] getMessageWithIndex:0 count:100] mutableCopy];
    if (self.dataArrM.count) {
        if (_placeholderView) {
            [self.placeholderView removeFromSuperview];
        }
        [self.tableView reloadData];
    } else {
        [self.tableView addSubview:self.placeholderView];
    }
    if ([self.tableView.mj_header isRefreshing]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArrM.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    WTMessageModel *messageModel = self.dataArrM[indexPath.row];
    
    UILabel *messageLabel = [cell.contentView viewWithTag:9527];
    if (messageLabel == nil) {
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, HYXScreenW-2*15, 20)];
        messageLabel.tag = 9527;
        messageLabel.textColor = [UIColor colorWithHexString:@"333333"];
        messageLabel.font = [UIFont systemFontOfSize:15];
    }
    messageLabel.text = messageModel.message;
    messageLabel.numberOfLines = 0;
    messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [messageLabel sizeToFit];
    [cell.contentView addSubview:messageLabel];
    
    UILabel *timeLabel = [cell.contentView viewWithTag:95277];
    if (timeLabel == nil) {
        timeLabel = [[UILabel alloc] init];
        timeLabel.tag = 95277;
        timeLabel.textColor = [UIColor colorWithHexString:@"666666"];
        timeLabel.font = [UIFont systemFontOfSize:11];
        timeLabel.x = 15;
    }
    timeLabel.y = CGRectGetMaxY(messageLabel.frame)+10;
    timeLabel.text = messageModel.timeString;
    [timeLabel sizeToFit];
    [cell.contentView addSubview:timeLabel];
    
    
    UIView *msgRedView = [cell.contentView viewWithTag:9927];
    if (messageModel.isUnread) {
        if (msgRedView == nil) {
            msgRedView = [[UIView alloc] init];
            msgRedView.tag = 9927;
            msgRedView.backgroundColor = [UIColor redColor];
            msgRedView.size = CGSizeMake(4, 4);
            msgRedView.layer.cornerRadius = msgRedView.height*0.5;
            msgRedView.layer.masksToBounds = YES;
        }
        msgRedView.x = 5;
        msgRedView.centerY = cell.contentView.height*0.5;
        [cell.contentView addSubview:msgRedView];
    } else {
        [msgRedView removeFromSuperview];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    WTMessageModel *messageModel = self.dataArrM[indexPath.row];
    WTCaseDetailController *detailVc = [[UIStoryboard storyboardWithName:@"WTCaseDetailController" bundle:nil] instantiateViewControllerWithIdentifier:@"caseDetailId"];
    messageModel.caseIDArrM = [messageModel.caseIDs componentsSeparatedByString:@","];
    detailVc.caseId = messageModel.caseIDArrM.firstObject;
    detailVc.visitRecordIds = messageModel.caseIDs;
    if (messageModel.type == WTMessageTypeBeTranfer) {
        detailVc.beTransferName = messageModel.transferName;
    } else if (messageModel.type == WTMessageTypeTransferTo) {
        detailVc.transferToName = messageModel.transferName;
    }
    
    if (messageModel.isUnread) {
        messageModel.isUnread = NO;
        [[WTMessageManager shareManager] addMessage:messageModel];
        [self.tableView reloadData];
        HYXNote_POST(kGetReadMessageNote, nil);
    }
    detailVc.messageModel = messageModel;
    
    [self.navigationController pushViewController:detailVc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WTMessageModel *messageModel = self.dataArrM[indexPath.row];
    return messageModel.cellHeight;
}

@end
