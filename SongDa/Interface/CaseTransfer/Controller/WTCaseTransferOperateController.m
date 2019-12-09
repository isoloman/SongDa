//
//  WTCaseTransferOperateController.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/8.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseTransferOperateController.h"
#import "WTCaseTransferCell.h"
#import "WTCaseTransferDelivererViewModel.h"
#import "WTCaseTransferViewModel.h"
#import "WTCaseTransferDelivererModel.h"
#import "WTMyCaseModel.h"

@interface WTCaseTransferOperateController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) WTTotalModel *totalModel;
@end

@implementation WTCaseTransferOperateController

static NSString * const ID = @"transferCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WTGlobalBG;
    self.navigationItem.title = @"手动移交";
    
    [self setupTableView];
    [self loadNewData];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, 0, HYXScreenW, HYXScreenH-IPhoneX_Nav_Height);
    tableView.backgroundColor = WTGlobalBG;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [tableView registerClass:[WTCaseTransferCell class] forCellReuseIdentifier:ID];
    tableView.tableFooterView = [UIView new];
    
    adjustsScrollViewInsets(tableView);
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
}

- (void)loadNewData {
    WTWeakSelf;
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:_courtId,@"courtId", nil];
    [[[WTCaseTransferDelivererViewModel alloc] init] dataByParameters:dict success:^(WTTotalModel *totalModel) {
        for (NSInteger i = 0; i < totalModel.data.count; i++) {
            WTCaseTransferDelivererModel *model = totalModel.data[i];
            if ([model.delivereId isEqualToString:[WTAccountManager sharedManager].userId]) {
                [totalModel.data removeObject:model];
                i--;
            }
        }
        weakSelf.totalModel = totalModel;
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error, NSString *message) {
        HYXLog(@"error  %@",error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.totalModel.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WTCaseTransferCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.delivererModel = self.totalModel.data[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    WTWeakSelf;
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"确定移交给Ta" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WTCaseTransferDelivererModel *model = weakSelf.totalModel.data[indexPath.row];
        NSMutableDictionary *paras = [NSMutableDictionary dictionary];
        if (weakSelf.caseModels.data.count > 1) {
            NSMutableArray *ids = [NSMutableArray array];
            for (WTMyCaseModel *caseModel in weakSelf.caseModels.data) {
                [ids addObject:caseModel.caseId];
            }
            paras[@"visitRecordIds"] = [ids componentsJoinedByString:@","];
        } else {
            paras[@"visitRecordIds"] = weakSelf.caseId;
        }
        paras[@"sysUserId"] = model.delivereId;
        paras[@"assignUserId"] = [WTAccountManager sharedManager].userId;
        [[[WTCaseTransferViewModel alloc] init] dataByParameters:paras success:^(id obj) {
            [SVProgressHUD showSuccessWithStatus:@"移交请求成功！"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
                if (weakSelf.TransferSuccessBlcok) {
                    weakSelf.TransferSuccessBlcok();
                }
            });
        } failure:^(NSError *error, NSString *message) {
            [SVProgressHUD showErrorWithStatus:@"移交请求失败！"];
            HYXLog(@"error  %@",error);
        }];
    }];
    [alertCtrl addAction:sureAct];
    UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertCtrl addAction:cancelAct];
    [self presentViewController:alertCtrl animated:YES completion:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

@end
