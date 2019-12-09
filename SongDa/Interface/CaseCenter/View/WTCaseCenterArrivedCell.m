//
//  WTCaseCenterArrivedCell.m
//  SongDa
//
//  Created by 灰太狼 on 2018/5/16.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseCenterArrivedCell.h"
#import "WTCaseCenterModel.h"
#import "ModelDate.h"

@interface WTCaseCenterArrivedCell ()
@property (strong, nonatomic) IBOutlet UILabel *litigantLabel;
@property (strong, nonatomic) IBOutlet UILabel *visitDetailLabel;
@property (strong, nonatomic) IBOutlet UILabel *visitTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *transferLabel;
@property (strong, nonatomic) IBOutlet UILabel *zoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *caseCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *receiveTimeLabel;
@end

@implementation WTCaseCenterArrivedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 10;
    frame.size.width -= 2*10;
    frame.origin.x = 10;
    [super setFrame:frame];
}

- (void)setCenterModel:(WTCaseCenterModel *)centerModel {
    _centerModel = centerModel;
    
    self.litigantLabel.text = centerModel.litigantName;
    self.visitDetailLabel.text = centerModel.visitDetail;
    self.visitTimeLabel.text = centerModel.visitTime;
    self.transferLabel.text = centerModel.visitDeliverName;
    self.zoneLabel.text = centerModel.region;
    self.addressLabel.text = centerModel.detailAddr;
    self.caseCodeLabel.text = centerModel.caseCode.length ? centerModel.caseCode : centerModel.preCaseCode;
    self.receiveTimeLabel.text = [ModelDate getDateWithOriginalForamtter:@"yyyy-MM-dd HH:mm:ss" toForamtter:@"yyyy-MM-dd" withDateString:centerModel.receiveDate];
}

@end
