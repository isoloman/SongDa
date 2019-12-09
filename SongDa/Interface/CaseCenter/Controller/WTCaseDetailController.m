//
//  WTCaseDetailController.m
//  SongDa
//
//  Created by Fancy on 2018/4/2.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseDetailController.h"
#import "WTCaseDetailViewModel.h"
#import "WTCaseDetailModel.h"
#import "WTCaseTransferConfirmViewModel.h"
#import "WTMyCaseSignController.h"
#import "WTCaseConfirmFromCodeViewModel.h"

#import "WTMessageManager.h"
#import "WTMessageModel.h"

@interface WTCaseDetailController ()
@property (strong, nonatomic) WTCaseDetailModel *detailModel;

@property (strong, nonatomic) IBOutlet UIView *sectionOneView;
/** 案号 */
@property (weak, nonatomic) IBOutlet UILabel *caseCodeLabel;
/** 部门标题 */
@property (strong, nonatomic) IBOutlet UILabel *apartmentTitleLabel;
/** 部门详情 */
@property (strong, nonatomic) IBOutlet UILabel *apartmentLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *apartTop;
/** 法官助理/审判员 标题 */
@property (strong, nonatomic) IBOutlet UILabel *judgeAssistantTitleLabel;
/** 法官助理/审判员 详情 */
@property (weak, nonatomic) IBOutlet UILabel *judgeAssistantLabel;
/** 书记员 标题 */
@property (strong, nonatomic) IBOutlet UILabel *chiefTitleLabel;
/** 书记员 详情 */
@property (strong, nonatomic) IBOutlet UILabel *chiefLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chiefTop;
/** 案由 */
@property (weak, nonatomic) IBOutlet UILabel *caseReasonLabel;
/** （预）立案时间 标题 */
@property (strong, nonatomic) IBOutlet UILabel *caseTimeTitleLabel;
/** （预）立案时间 详情 */
@property (weak, nonatomic) IBOutlet UILabel *caseMakeTimeLabel;
/** 审核截止日期 标题 */
@property (strong, nonatomic) IBOutlet UILabel *deadLineTitleLabel;
/** 审核截止日期 详情 */
@property (strong, nonatomic) IBOutlet UILabel *deadLineLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *deadLineTop;
/** 预排庭时间 标题 */
@property (strong, nonatomic) IBOutlet UILabel *tribunalTitleLabel;
/** 预排庭时间 详情 */
@property (strong, nonatomic) IBOutlet UILabel *tribunalLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tribunalTop;

@property (strong, nonatomic) IBOutlet UIView *sectionTwoView;
/** 送达当事人 */
@property (weak, nonatomic) IBOutlet UILabel *caseDeliverNameLabel;
/** 诉讼地位 */
@property (strong, nonatomic) IBOutlet UILabel *caseStatusLabel;
/** 联系电话 */
@property (weak, nonatomic) IBOutlet UILabel *caseDeliverPhoneLabel;

@property (strong, nonatomic) IBOutlet UIView *sectionThreeView;
/** 地址 */
@property (weak, nonatomic) IBOutlet UILabel *litigantAddr1Label;
/** 详细地址 */
@property (weak, nonatomic) IBOutlet UILabel *litigantAddr2Label;

@property (strong, nonatomic) UIView *mentionView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) IBOutlet UITableViewCell *firstCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *secondCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *thirdCell;
@end

@implementation WTCaseDetailController

- (UIView *)mentionView
{
    if (_mentionView == nil) {
        _mentionView = [[UIView alloc] init];
        _mentionView.backgroundColor = WTGlobalBG;
        _mentionView.size = CGSizeMake(HYXScreenW, 30);
        
        UILabel *mentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, HYXScreenW-2*10, 20)];
        mentionLabel.text = [NSString stringWithFormat:@"您的同事%@已经成功接收您移交给Ta的地址",self.transferToName];
        mentionLabel.textColor = [UIColor colorWithHexString:@"E4393C"];
        mentionLabel.font = [UIFont systemFontOfSize:14];
        mentionLabel.numberOfLines = 0;
        mentionLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [mentionLabel sizeToFit];
        [_mentionView addSubview:mentionLabel];
    }
    return _mentionView;
}

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = WTGlobalBG;
        _headerView.size = CGSizeMake(HYXScreenW, 44);
        
        UILabel *mentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, HYXScreenW-2*10, 34)];
        mentionLabel.text = [NSString stringWithFormat:@"您的同事%@将以下地址移交给您，请核对后点击下方确认接收按钮",self.beTransferName];
        mentionLabel.textColor = [UIColor colorWithHexString:@"E4393C"];
        mentionLabel.font = [UIFont systemFontOfSize:14];
        mentionLabel.numberOfLines = 0;
        mentionLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_headerView addSubview:mentionLabel];
    }
    return _headerView;
}

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = WTGlobalBG;
        _footerView.width = HYXScreenW;
        _footerView.height = 90;
        
        UIView *containView = [[UIView alloc] init];
        containView.backgroundColor = [UIColor whiteColor];
        [_footerView addSubview:containView];
        [containView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(HYXScreenW);
            make.height.mas_equalTo(58);
            make.left.bottom.equalTo(_footerView);
        }];
        [containView layoutIfNeeded];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.backgroundColor = WTBlueColor;
        [sureBtn setTitle:@"确认接收" forState:UIControlStateNormal];
        [sureBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        sureBtn.size = CGSizeMake(containView.width-2*10, 39);
        sureBtn.centerX = containView.width*0.5;
        sureBtn.centerY = containView.height*0.5;
        [sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
        [containView addSubview:sureBtn];
    }
    return _footerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
    [self setupNav];
    
    [self loadCaseDetailData];
}

- (void)initConfig {
    self.view.backgroundColor = WTGlobalBG;
    self.tableView.backgroundColor = WTGlobalBG;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    adjustsScrollViewInsets(self.tableView);
    
    self.sectionOneView.layer.cornerRadius = self.sectionTwoView.layer.cornerRadius = self.sectionThreeView.layer.cornerRadius = 4;
    self.sectionOneView.layer.masksToBounds = self.sectionTwoView.layer.masksToBounds = self.sectionThreeView.layer.masksToBounds = YES;
}

- (void)setupNav {
    self.navigationItem.title = @"案件详情";
    
    if (self.isPushFromCodeVc || self.isPresented) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:HYXImage(@"nav_back") forState:UIControlStateNormal];
        backBtn.adjustsImageWhenHighlighted = NO;
        backBtn.size = CGSizeMake(30, 44);
        [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [backBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    }
    
    if (self.isFromArrived) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:@"查看送达记录" forState:UIControlStateNormal];
        [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [rightBtn sizeToFit];
        [rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    }
}

- (void)backClick {
    WTWeakSelf;
    if (self.isPushFromCodeVc) {
        if (weakSelf.popClickBlock) {
            weakSelf.popClickBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (self.isPresented) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)rightClick {
    WTMyCaseSignController *signVc = [[WTMyCaseSignController alloc] init];
    signVc.visitRecordId = self.detailModel.visitRecordId;
    [self.navigationController pushViewController:signVc animated:YES];
}

- (void)sureClick:(UIButton *)button {
    WTWeakSelf;
    button.userInteractionEnabled = NO;
    if (weakSelf.popClickBlock) {
        NSMutableDictionary *paras = [NSMutableDictionary dictionary];
        paras[@"visitRecordIds"] = self.visitRecordIds.length ? self.visitRecordIds : self.caseId;
        paras[@"sysUserId"] = [WTAccountManager sharedManager].userId; //接收人
        paras[@"assignUserId"] = self.beTransferId; //移交人
        [[[WTCaseConfirmFromCodeViewModel alloc] init] dataByParameters:paras success:^(id obj) {
            [SVProgressHUD showSuccessWithStatus:@"接收成功！"];
            button.userInteractionEnabled = YES;
            if (weakSelf.isPresented) {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            } else {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            if (weakSelf.popClickBlock) {
                weakSelf.popClickBlock();
            }
            if (weakSelf.messageModel) {
                weakSelf.messageModel.isReceived = YES;
                [[WTMessageManager shareManager] addMessage:weakSelf.messageModel];
            }
        } failure:^(NSError *error, NSString *message) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            button.userInteractionEnabled = YES;
        }];
    } else {
        NSMutableDictionary *paras = [NSMutableDictionary dictionary];
        if (self.visitRecordIds.length) {
            paras[@"visitRecordIds"] = self.visitRecordIds;
        } else {
            paras[@"visitRecordIds"] = self.detailModel.visitRecordId;
        }
        paras[@"userId"] = [WTAccountManager sharedManager].userId;
        [[[WTCaseTransferConfirmViewModel alloc] init] dataByParameters:paras success:^(id obj) {
            [SVProgressHUD showSuccessWithStatus:@"接收成功！"];
            button.userInteractionEnabled = YES;
            if (weakSelf.isPresented) {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            } else {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            if (weakSelf.popClickBlock) {
                weakSelf.popClickBlock();
            }
            if (weakSelf.messageModel) {
                weakSelf.messageModel.isReceived = YES;
                [[WTMessageManager shareManager] addMessage:weakSelf.messageModel];
            }
        } failure:^(NSError *error, NSString *message) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            button.userInteractionEnabled = YES;
        }];
    }
}

- (void)loadCaseDetailData {
    WTWeakSelf;
    if (self.caseId.length || self.visitRecordIds.length) {
        [SVProgressHUD show];
        NSMutableDictionary * param = [NSMutableDictionary new];
        [param setValue:self.visitRecordIds.length ? self.visitRecordIds : self.caseId forKey:@"visitRecordIds"];
        if (_isPushFromCodeVc) {
            [param setValue:@"1" forKey:@"transfer"];//随便传个值
        }
        
        [[[WTCaseDetailViewModel alloc] init] dataByParameters:param success:^(WTCaseDetailModel *detailModel) {
            weakSelf.detailModel = detailModel;
            [weakSelf setData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        } failure:^(NSError *error, NSString *message) {
            HYXLog(@"error  %@",error);
            [weakSelf setData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }];
    }
}

- (void)setData {
    self.firstCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *caseCode = self.detailModel.caseCode;
    if (caseCode.length) {
        self.firstCell.height = 280;
        
        //案号
        self.caseCodeLabel.text = caseCode;
        //部门
        self.apartmentTitleLabel.hidden = NO;
        self.apartmentLabel.hidden = NO;
        self.apartTop.constant = 10;
        self.apartmentTitleLabel.text = @"部        门:";
        self.apartmentLabel.text = self.detailModel.deptName;
        //审判员
        self.judgeAssistantTitleLabel.text = @"审  判  员:";
        self.judgeAssistantLabel.text = self.detailModel.judge;
        //书记员
        self.chiefTitleLabel.hidden = NO;
        self.chiefLabel.hidden = NO;
        self.chiefTop.constant = 10;
        self.chiefTitleLabel.text = @"书  记  员:";
        self.chiefLabel.text = self.detailModel.courtClerk;
        //立案时间
        self.caseTimeTitleLabel.text = @"立案时间:";
        [self.caseTimeTitleLabel sizeToFit];
        self.caseMakeTimeLabel.text = self.detailModel.registerDate;
        //审限截止时间
        self.deadLineTitleLabel.hidden = NO;
        self.deadLineLabel.hidden = NO;
        self.deadLineTop.constant = 10;
        self.deadLineTitleLabel.text = @"审限截止日期:";
        self.deadLineLabel.text = self.detailModel.trialEndDate;
        //预排庭时间
        self.tribunalTitleLabel.hidden = NO;
        self.tribunalLabel.hidden = NO;
        self.tribunalTop.constant = 10;
        self.tribunalTitleLabel.text = @"预排庭时间:";
        self.tribunalLabel.text = self.detailModel.prePlatoonTime;
    } else {
        self.firstCell.height = 170;
        
        //案号
        self.caseCodeLabel.text = self.detailModel.preCaseCode;
        //法官助理
        self.judgeAssistantTitleLabel.text = @"法官助理:";
        self.judgeAssistantLabel.text = self.detailModel.judgeAssistant;
        //预立案时间
        self.caseTimeTitleLabel.text = @"预立案时间:";
        [self.caseTimeTitleLabel sizeToFit];
        self.caseMakeTimeLabel.text = self.detailModel.preTrialDate;
        
        //部门
        self.apartmentTitleLabel.hidden = YES;
        self.apartmentLabel.hidden = YES;
        self.apartTop.constant = 0;
        self.apartmentTitleLabel.text = @"";
        self.apartmentLabel.text = @"";
        //书记员
        self.chiefTitleLabel.hidden = YES;
        self.chiefLabel.hidden = YES;
        self.chiefTitleLabel.text = @"";
        self.chiefLabel.text = @"";
        self.chiefTop.constant = 0;
        //审限截止时间
        self.deadLineTitleLabel.hidden = YES;
        self.deadLineLabel.hidden = YES;
        self.deadLineTop.constant = 0;
        self.deadLineTitleLabel.text = @"";
        self.deadLineLabel.text = @"";
        //预排庭时间
        self.tribunalTitleLabel.hidden = YES;
        self.tribunalLabel.hidden = YES;
        self.tribunalTop.constant = 0;
        self.tribunalTitleLabel.text = @"";
        self.tribunalLabel.text = @"";
    }
    self.caseReasonLabel.text = self.detailModel.caseCauseName;
    
    self.caseDeliverNameLabel.text = self.detailModel.litigantName;
    self.caseStatusLabel.text = self.detailModel.litigationStatus;
    self.caseDeliverPhoneLabel.text = self.detailModel.tels;
    self.litigantAddr1Label.text = self.detailModel.region;
    self.litigantAddr2Label.text = self.detailModel.detailAddr;
    
    self.firstCell.y = 0;
    [self.firstCell layoutIfNeeded];
    self.secondCell.y = CGRectGetMaxY(self.firstCell.frame);
    self.thirdCell.y = CGRectGetMaxY(self.secondCell.frame);
    [self.tableView layoutIfNeeded];
    
    if (self.beTransferName.length) {
        if (self.messageModel.isReceived) {
            self.tableView.tableFooterView = [UIView new];
            self.tableView.tableHeaderView = [UIView new];
        } else {
            self.tableView.tableHeaderView = self.headerView;
            self.tableView.tableFooterView = self.footerView;
        }
    } else if (self.transferToName.length) {
        self.tableView.tableHeaderView = self.mentionView;
        self.tableView.tableFooterView = [UIView new];
    } else {
        self.tableView.tableFooterView = [UIView new];
    }
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (self.detailModel.caseCode.length) {
            return 280;
        } else {
            return 170;
        }
    } else if (indexPath.row == 1) {
        return 150;
    } else if (indexPath.row == 2) {
        return 131;
    } else {
        return 200;
    }
}

@end
