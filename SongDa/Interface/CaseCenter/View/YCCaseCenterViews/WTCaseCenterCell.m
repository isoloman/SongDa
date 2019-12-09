//
//  WTCaseCenterCell.m
//  SongDa
//
//  Created by Fancy on 2018/3/29.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseCenterCell.h"
#import "WTCaseCenterModel.h"
#import "WTCaseDeliverModel.h"
#import "UIView+Toast.h"

#define kDeliverStatusSuccess       [UIColor colorWithHexString:@"12A09C"]
#define kDeliverStatusFail          [UIColor colorWithHexString:@"E4393C"]
#define kDeliverStatusUnreachable   [UIColor colorWithHexString:@"FF842A"]

@interface WTCaseCenterCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roughZoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailZoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliverTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliverLabel;
@property (weak, nonatomic) IBOutlet UILabel *caseCodeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *caseCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *caseTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *deliverCallBtn;
@property (weak, nonatomic) IBOutlet UIButton *deliverZoneBtn;
@end

@implementation WTCaseCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.deliverTitleLabel textAlignmentLeftAndRightWithLabelWidth:58];
    [self.caseCodeTitleLabel textAlignmentLeftAndRightWithLabelWidth:58];
    [self.timeTitleLabel textAlignmentLeftAndRightWithLabelWidth:58];
    
    self.deliverCallBtn.layer.cornerRadius = self.deliverZoneBtn.layer.cornerRadius = 4;
    self.deliverCallBtn.layer.masksToBounds = self.deliverZoneBtn.layer.masksToBounds = YES;
    self.deliverCallBtn.layer.borderColor = kDeliverStatusSuccess.CGColor;
    self.deliverCallBtn.layer.borderWidth = 1;
    self.deliverZoneBtn.layer.borderColor = kDeliverStatusUnreachable.CGColor;
    self.deliverZoneBtn.layer.borderWidth = 1;
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 10;
    frame.size.width -= 2*10;
    frame.origin.x = 10;
    [super setFrame:frame];
}

- (void)setCenterModel:(WTCaseCenterModel *)centerModel {
    _centerModel = centerModel;
    
    self.nameLabel.text = centerModel.litigantName;
    self.roughZoneLabel.text = centerModel.region;
    self.detailZoneLabel.text = centerModel.detailAddr;
    if (centerModel.visitDeliverName.length) {
        self.deliverLabel.text = [@":   " stringByAppendingString:centerModel.visitDeliverName];
    } else {
        self.deliverLabel.text = @":";
    }
    if (centerModel.caseCode.length) {
        self.caseCodeLabel.text = [@":   " stringByAppendingString:centerModel.caseCode];
    } else if (centerModel.preCaseCode.length) {
        self.caseCodeLabel.text = [@":   " stringByAppendingString:centerModel.preCaseCode];
    } else {
        self.caseCodeLabel.text = @":";
    }
    if (centerModel.receiveDate.length) {
        self.caseTimeLabel.text = [@":   " stringByAppendingString:centerModel.receiveDate];
    } else {
        self.caseTimeLabel.text = @":";
    }
}
// 呼叫送达员
- (IBAction)callDeliverer:(UIButton *)sender {
    if (self.centerModel.delivers.count > 1) {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        for (WTCaseDeliverModel *deliverModel in self.centerModel.delivers) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@ (%@)",deliverModel.deliverPhoneNum,deliverModel.deliverName] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", deliverModel.deliverPhoneNum];
                
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:callPhone]]){
                    /// 10及其以上系统
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
                    } else {
                        /// 10以下系统
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
                    }
                }
                else{
                    [self.contentView makeToast:@"暂无改送达员联系方式"];
                }
            }];
            [alertCtrl addAction:action];
        }
        UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertCtrl addAction:cancelAct];
        if (isIPad) {
            UIPopoverPresentationController *popPresenter = [alertCtrl popoverPresentationController];
            popPresenter.sourceView = sender;
            popPresenter.sourceRect = sender.bounds;
        }
        [HYXRootViewController presentViewController:alertCtrl animated:YES completion:nil];
    } else if (self.centerModel.delivers.count == 1) {
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", self.centerModel.delivers.firstObject.deliverPhoneNum];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:callPhone]]) {
            /// 10及其以上系统
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
            } else {
                /// 10以下系统
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
            }
        }
        else{
            [self.contentView makeToast:@"暂无改送达员联系方式"];
        }
    }
    else{
        [self.contentView makeToast:@"暂无改送达员联系方式"];
    }
}
// 定位送达员当前位置
- (IBAction)locateDeliverer:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didClickDelivererCurrentLocation:)]) {
        [_delegate didClickDelivererCurrentLocation:self];
    }
}

@end
