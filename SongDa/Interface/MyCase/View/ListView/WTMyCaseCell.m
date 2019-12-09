//
//  WTMyCaseCell.m
//  SongDa
//
//  Created by Fancy on 2018/4/2.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTMyCaseCell.h"
#import "WTMyCaseModel.h"

@interface WTMyCaseCell ()
@property (weak, nonatomic) IBOutlet UILabel *litigantLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *simpleAddrLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullAddrLabel;
@property (weak, nonatomic) IBOutlet UILabel *caseCodeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *caseCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *caseTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivedLabel;
@property (strong, nonatomic) IBOutlet UIButton *deliverBtn;
@property (strong, nonatomic) IBOutlet UIButton *litigantBtn;
@property (strong, nonatomic) IBOutlet UIButton *arriveBtn;
@end

@implementation WTMyCaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    
    self.deliverBtn.layer.cornerRadius = self.litigantBtn.layer.cornerRadius = self.arriveBtn.layer.cornerRadius = 4;
    self.deliverBtn.layer.masksToBounds = self.litigantBtn.layer.masksToBounds = self.arriveBtn.layer.masksToBounds = YES;
    self.deliverBtn.layer.borderWidth = self.litigantBtn.layer.borderWidth = self.arriveBtn.layer.borderWidth = 1;
    self.deliverBtn.layer.borderColor = [UIColor colorWithHexString:@"0E65BD"].CGColor;
    self.litigantBtn.layer.borderColor = [UIColor colorWithHexString:@"21A09B"].CGColor;
    self.arriveBtn.layer.borderColor = [UIColor colorWithHexString:@"FF842A"].CGColor;
    
    [self.caseCodeTitleLabel textAlignmentLeftAndRightWithLabelWidth:58];
    
    self.arrivedLabel.layer.cornerRadius = self.arrivedLabel.height*0.5;
    self.arrivedLabel.layer.masksToBounds = YES;
    self.arrivedLabel.userInteractionEnabled = YES;
    [self.arrivedLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrivedLabelClick)]];
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x = 10;
    frame.size.width -= 2*10;
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (void)setCaseModel:(WTMyCaseModel *)caseModel {
    _caseModel = caseModel;
    
    self.litigantLabel.text = caseModel.litigantName;
    self.statusLabel.text = self.isSortByDistance ? [NSString stringWithFormat:@"%.2fkm",caseModel.distance/1000.0] : @"待送达";
    self.simpleAddrLabel.text = caseModel.region;
    self.fullAddrLabel.text = caseModel.fullAddress;
    if (caseModel.caseCode.length) {
        self.caseCodeLabel.text = [@":   " stringByAppendingString:caseModel.caseCode];
    } else if (self.caseModel.preCaseCode.length) {
        self.caseCodeLabel.text = [@":   " stringByAppendingString:caseModel.preCaseCode];
    } else {
        self.caseCodeLabel.text = @":";
    }
    
    if (caseModel.receiveTime.length) {
        self.caseTimeLabel.text = [@":   " stringByAppendingString:caseModel.receiveTime];
    } else {
        self.caseTimeLabel.text = @":";
    }
}

// 添加追记
- (void)arrivedLabelClick {
    if (_delegate && [_delegate respondsToSelector:@selector(signCaseInCell:)]) {
        [_delegate signCaseInCell:self];
    }
}
// 移交同事
- (IBAction)deliverToMate:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(transferCaseToMateInCell:)]) {
        [_delegate transferCaseToMateInCell:self];
    }
}
// 呼叫当事人
- (IBAction)callLitigant:(UIButton *)sender {
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *phoneNum in self.caseModel.phoneNums) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:phoneNum style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phoneNum];
            /// 10及其以上系统
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
            } else {
                /// 10以下系统
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
            }
        }];
        [alertCtrl addAction:action];
    }
    UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];;
    [alertCtrl addAction:cancelAct];
    
    if (isIPad) {
        UIPopoverPresentationController *popPresenter = [alertCtrl popoverPresentationController];
        popPresenter.sourceView = sender;
        popPresenter.sourceRect = sender.bounds;
    }
    [HYXRootViewController presentViewController:alertCtrl animated:YES completion:nil];
}

// 到指定位置
- (IBAction)arriveLitigantZone:(id)sender {
    HYXNote_POST(kMyCaseListGuideRouteNote, self.caseModel);
}

@end
