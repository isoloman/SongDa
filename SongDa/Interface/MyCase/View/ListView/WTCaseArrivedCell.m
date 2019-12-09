//
//  WTCaseArrivedCell.m
//  SongDa
//
//  Created by Fancy on 2018/4/13.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseArrivedCell.h"
#import "WTCaseArrivedModel.h"

@interface WTCaseArrivedCell ()
@property (weak, nonatomic) IBOutlet UILabel *litigantLabel;
//@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivedDescripLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *zoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *caseCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveTimeLabel;
@end

@implementation WTCaseArrivedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x = 10;
    frame.size.width -= 2*10;
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (void)setArrivedModel:(WTCaseArrivedModel *)arrivedModel {
    _arrivedModel = arrivedModel;
    
    self.litigantLabel.text = arrivedModel.litigantName;
//    if (arrivedModel.isArrived == 1) {
//        self.statusLabel.text = @"已送达";
//        self.statusLabel.textColor = WTGreenColor;
//    } else {
//        self.statusLabel.text = @"送达不成功";
//        self.statusLabel.textColor = WTRedColor;
//    }
    
    self.arrivedDescripLabel.text = arrivedModel.visitDetail;
    self.arrivedTimeLabel.text = arrivedModel.visitTime;
    self.zoneLabel.text = arrivedModel.region;
    self.addressLabel.text = arrivedModel.fullAddress;
    self.caseCodeLabel.text = arrivedModel.caseCode;
    self.receiveTimeLabel.text = arrivedModel.receiveTime;
}

@end
