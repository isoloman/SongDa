//
//  WTMyCaseUserView.m
//  SongDa
//
//  Created by Fancy on 2018/3/27.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTMyCaseUserView.h"
#import "WTMyCaseUserCell.h"
#import "WTLoginViewModel.h"
#import "WTLoginController.h"
#import "WTNavigationController.h"
#import "WTMessageManager.h"
#import "WTMessageModel.h"

#define kTableImages    @[@"myCase_user_delivered",@"myCase_user_cache",@"myCase_user_msg",@"myCase_user_traffic",@"myCase_user_login"]
#define kTableTitles    @[@"已完成",@"清除缓存",@"消息中心",@"交通工具选择",@"退出系统"]
#define kRowHeight      44

@interface WTMyCaseUserView () <UITableViewDelegate,UITableViewDataSource>
/** 缓存label */
@property (strong, nonatomic) UILabel *cacheLabel;
/** 未读数 */
@property (strong, nonatomic) UIButton *unreadMsgBtn;
@end

@implementation WTMyCaseUserView

static NSString * const ID = @"userCell";

- (UIView *)backgroundView
{
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor blackColor];
        [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEmptyZone)]];
    }
    return _backgroundView;
}

- (UILabel *)cacheLabel
{
    if (_cacheLabel == nil) {
        _cacheLabel = [[UILabel alloc] init];
        _cacheLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _cacheLabel.font = [UIFont systemFontOfSize:13];
    }
    return _cacheLabel;
}

- (UIButton *)unreadMsgBtn
{
    if (_unreadMsgBtn == nil) {
        _unreadMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _unreadMsgBtn.backgroundColor = [UIColor redColor];
        _unreadMsgBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _unreadMsgBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backgroundView];
        [self setupUserTableView];
    }
    return self;
}

- (void)setupUserTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds];
    tableView.width = HYXScreenW*0.5;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    self.userTableView = tableView;
    
    [tableView registerClass:[WTMyCaseUserCell class] forCellReuseIdentifier:ID];
    
    adjustsScrollViewInsets(tableView);
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    
    // 头部
    UIView *headerView = [[UIView alloc] init];
    headerView.width = tableView.width;
    tableView.tableHeaderView = headerView;
    
    UIImageView *headImgView = [[UIImageView alloc] initWithImage:HYXImage(@"myCase_user_header")];
    headImgView.size = CGSizeMake(HYXSizeFit(188.0), HYXSizeFit(64));
    [headerView addSubview:headImgView];
    
    UIImageView *iconImgView = [[UIImageView alloc] initWithImage:HYXImage(@"myCase_user_head_icon")];
    iconImgView.size = CGSizeMake(HYXSizeFit(55), HYXSizeFit(55));
    iconImgView.x = 15;
    iconImgView.centerY = headImgView.height;
    [headerView addSubview:iconImgView];
    
    UIView *circleView = [[UIView alloc] init];
    circleView.backgroundColor = [UIColor colorWithHexString:@"e8f3ff"];
    circleView.size = CGSizeMake(iconImgView.width+2*2, iconImgView.height+2*2);
    circleView.center = iconImgView.center;
    circleView.layer.cornerRadius = circleView.height*0.5;
    circleView.layer.masksToBounds = YES;
    [headerView insertSubview:circleView belowSubview:iconImgView];
    headerView.height = CGRectGetMaxY(circleView.frame)+15;
    
    CGFloat nameX = CGRectGetMaxX(iconImgView.frame)+15;
    CGFloat nameW = headerView.width-nameX-15;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameX, 0, nameW, 22)];
    nameLabel.text = [WTAccountManager sharedManager].userName;
    nameLabel.textColor = [UIColor colorWithHexString:@"115fb1"];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.centerY = iconImgView.centerY;
    [headerView addSubview:nameLabel];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *lastLoginTime = [userDefaults objectForKey:kLastLoginTimeKey];
    if (![lastLoginTime isEmpty]) {
        UILabel *lastLoginLabel = [[UILabel alloc] init];
        if (HYXScreenW <= 320) {
            lastLoginTime = [lastLoginTime substringFromIndex:5];
        }
        lastLoginLabel.text = [NSString stringWithFormat:@"上次登录：%@",lastLoginTime];
        lastLoginLabel.textColor = [UIColor colorWithHexString:@"999999"];
        lastLoginLabel.font = [UIFont systemFontOfSize:11.5];
        [lastLoginLabel sizeToFit];
        lastLoginLabel.width = HYXScreenW*0.5-2*10;
        lastLoginLabel.x = 10;
        lastLoginLabel.y = CGRectGetMaxY(circleView.frame)+15;
        lastLoginLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:lastLoginLabel];
        headerView.height = CGRectGetMaxY(lastLoginLabel.frame)+10;
    }
    
    // 分割线
    UIView *separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    separateLine.size = CGSizeMake(HYXScreenW, 0.5);
    separateLine.y = headerView.height-separateLine.height;
    [headerView addSubview:separateLine];
    
    // 尾部
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    footerView.size = CGSizeMake(self.userTableView.width, self.userTableView.height-headerView.height-[self tableView:self.userTableView numberOfRowsInSection:0]*kRowHeight);
    tableView.tableFooterView = footerView;
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = [NSString stringWithFormat:@"当前版本号：%@",appVersion];
    versionLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    versionLabel.font = [UIFont systemFontOfSize:13];
    [versionLabel sizeToFit];
    versionLabel.centerX = footerView.width*0.5;
    versionLabel.bottom = footerView.height-70;
    [footerView addSubview:versionLabel];
}

- (void)clickEmptyZone {
    if (_delegate && [_delegate respondsToSelector:@selector(userViewWillBeHidden:)]) {
        [_delegate userViewWillBeHidden:self];
    }
}

- (NSString *)getCacheSize {
    float cacheSize = 0.0;
    
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:HYXPathCache];
    for (NSString *file in files) {
        NSString *path = [HYXPathCache stringByAppendingPathComponent:file];
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        double fileSize = [[dict objectForKey:NSFileSize] doubleValue];
        cacheSize += fileSize;
    }
    
    NSString *sizeStr;
    if(cacheSize >= 1048576) {
        sizeStr = [NSString stringWithFormat:@"%.2fM",cacheSize/1048576];
        return sizeStr;
    } else if (cacheSize > 1024 && cacheSize < 1048576) {
        sizeStr = [NSString stringWithFormat:@"%.0fKB",cacheSize/1024];
        return sizeStr;
    } else {
        sizeStr = [NSString stringWithFormat:@"%.0fB",cacheSize];
        return sizeStr;
    }
}
- (void)clearDisk {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您确定要清除缓存吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:HYXPathCache];
            for (NSString *p in files) {
                NSError *error;
                NSString *path = [HYXPathCache stringByAppendingPathComponent:p];
                if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    if (![p containsString:@"WeiTuCenter"]) {
                        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                    }
                }
            }
        });
        if (_unreadMsgBtn) {
            [self.unreadMsgBtn removeFromSuperview];
        }
        HYXNote_POST(kClearDiskNote, nil);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"清除成功！"];
            self.cacheLabel.text = @"0B";
            [self.cacheLabel sizeToFit];
            self.cacheLabel.right = HYXScreenW*0.5-10;
        });
    }]];
    
    [HYXRootViewController presentViewController:alertController animated:YES completion:nil];
}
- (void)logout {
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"确定退出？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD show];
        [[[WTLoginViewModel alloc] init] logoutWithParas:nil success:^(id obj) {
            [SVProgressHUD showSuccessWithStatus:@"退出成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                WTLoginController *loginVc = [[WTLoginController alloc] init];
                WTNavigationController *navVc = [[WTNavigationController alloc] initWithRootViewController:loginVc];
                [UIApplication sharedApplication].keyWindow.rootViewController = navVc;
                [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
            });
        } failure:^(NSError *error, NSString *message) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }];
    [alertCtrl addAction:sureAct];
    UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertCtrl addAction:cancelAct];
    [HYXRootViewController presentViewController:alertCtrl animated:YES completion:nil];
}

#pragma mark - <数据源 代理>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kTableImages.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTMyCaseUserCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.userImgView.image = HYXImage(kTableImages[indexPath.row]);
    cell.userTitleLabel.text = kTableTitles[indexPath.row];
    if (indexPath.row == 1) {
        self.cacheLabel.text = [self getCacheSize];
        [self.cacheLabel sizeToFit];
        self.cacheLabel.right = HYXScreenW*0.5-10;
        self.cacheLabel.centerY = cell.userTitleLabel.centerY;
        [cell.contentView addSubview:self.cacheLabel];
    } else if (indexPath.row == 2) {
        NSArray *msgArr = [[[WTMessageManager shareManager] getMessageWithIndex:0 count:100] copy];
        NSInteger unreadCount = 0;
        for (WTMessageModel *msgModel in msgArr) {
            if (msgModel.isUnread) {
                unreadCount++;
            }
        }
        if (unreadCount) {
            [self.unreadMsgBtn setTitle:[NSString stringWithFormat:@"%zd",unreadCount] forState:UIControlStateNormal];
            self.unreadMsgBtn.size = CGSizeMake(18, 18);
            if (unreadCount < 10) {
                self.unreadMsgBtn.height = self.unreadMsgBtn.width;
            } else if (unreadCount >= 10 && unreadCount < 100) {
                self.unreadMsgBtn.width += 8;
            } else if (unreadCount >= 100) {
                self.unreadMsgBtn.width += 15;
                [self.unreadMsgBtn setTitle:@"99+" forState:UIControlStateNormal];
            }
            self.unreadMsgBtn.layer.cornerRadius = self.unreadMsgBtn.height*0.5;
            self.unreadMsgBtn.layer.masksToBounds = YES;
            self.unreadMsgBtn.right = HYXScreenW*0.5-10;
            self.unreadMsgBtn.centerY = cell.userTitleLabel.centerY;
            [cell.contentView addSubview:self.unreadMsgBtn];
        } else {
            if (_unreadMsgBtn) {
                [self.unreadMsgBtn removeFromSuperview];
            }
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) { // 已送达
        [self clickEmptyZone];
        if (_delegate && [_delegate respondsToSelector:@selector(pushCaseArrivedController:)]) {
            [_delegate pushCaseArrivedController:self];
        }
    } else if (indexPath.row == 1) { // 清除缓存
        [self clearDisk];
    } else if (indexPath.row == 2) { // 消息中心
        [self clickEmptyZone];
        if (_delegate && [_delegate respondsToSelector:@selector(pushUserMessageController:)]) {
            [_delegate pushUserMessageController:self];
        }
    } else if (indexPath.row == 3) { // 交通选择
        [self clickEmptyZone];
        if (_delegate && [_delegate respondsToSelector:@selector(pushTrafficChooseController:)]) {
            [_delegate pushTrafficChooseController:self];
        }
    } else if (indexPath.row == 4) { // 退出登录
        [self logout];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRowHeight;
}

@end
