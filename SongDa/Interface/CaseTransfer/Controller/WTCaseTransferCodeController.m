//
//  WTCaseTransferCodeController.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/8.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseTransferCodeController.h"
#import "WTMyCaseModel.h"
#import "WTCaseTransferOperateController.h"
#import "WTCaseRelatedViewModel.h"

@interface WTCaseTransferCodeController ()
/** 关联案件model */
@property (strong, nonatomic) WTTotalModel *totalModel;
@end

@implementation WTCaseTransferCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"移交同事";
    self.view.backgroundColor = WTGlobalBG;
    
    [self loadCaseRelatedData];
}

- (void)loadCaseRelatedData {
    WTWeakSelf;
    NSDictionary *para = @{@"groupId" : self.caseModel.groupId};
    [[[WTCaseRelatedViewModel alloc] init] dataByParameters:para success:^(WTTotalModel *totalModel) {
        weakSelf.totalModel = totalModel;
        [weakSelf setupUI];
    } failure:^(NSError *error, NSString *message) {
        [weakSelf setupUI];
    }];
}

- (void)setupUI {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.size = CGSizeMake(HYXSizeFit(222), HYXSizeFit(222));
    imageView.centerX = self.view.width*0.5;
    imageView.y = 54;
    [self.view addSubview:imageView];
    
    // 创建二维码滤镜实例
    CIFilter *filer = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜默认设置
    [filer setDefaults];
    // 添加数据
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    if (self.totalModel.data.count > 1) {
        NSMutableArray *caseIDs = [NSMutableArray array];
        for (WTMyCaseModel *model in self.totalModel.data) {
            [caseIDs addObject:model.caseId];
        }
        dataDict[@"id"] = [caseIDs componentsJoinedByString:@","];
    } else {
        dataDict[@"id"] = self.caseModel.caseId;
    }
    dataDict[@"opName"] = [WTAccountManager sharedManager].userName;
    dataDict[@"action"] = @"addr_tranfer";
    dataDict[@"oriBelongUid"] = [WTAccountManager sharedManager].userId;
    dataDict[@"opUid"] = [WTAccountManager sharedManager].userId;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil];
    [filer setValue:data forKey:@"inputMessage"];
    
    // 生成二维码
    CIImage *image = [filer outputImage];
    // 显示二维码
    imageView.image = [self createNonInterpolatedUIImageFormCIImage:image withSize:400];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.size = CGSizeMake(HYXScreenW, HYXSizeFit(400));
    [self.view insertSubview:backView belowSubview:imageView];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"请让接收的同事打开APP\n扫描上方的二维码确认接收送达"];
    attrString.lineSpacing = 7;
    UILabel *mentionLabel = [[UILabel alloc] init];
    mentionLabel.attributedText = attrString;
    mentionLabel.textColor = [UIColor colorWithHexString:@"333333"];
    mentionLabel.font = [UIFont systemFontOfSize:16];
    mentionLabel.numberOfLines = 0;
    mentionLabel.lineBreakMode = NSLineBreakByCharWrapping;
    mentionLabel.textAlignment = NSTextAlignmentCenter;
    [mentionLabel sizeToFit];
    mentionLabel.centerX = self.view.width*0.5;
    mentionLabel.y = CGRectGetMaxY(imageView.frame)+30;
    [self.view addSubview:mentionLabel];
    
    UIImageView *bottomImgView = [[UIImageView alloc] initWithImage:HYXImage(@"caseCenter_caseDetail_wave")];
    bottomImgView.width = self.view.width;
    bottomImgView.height = HYXSizeFit(185);
    bottomImgView.bottom = backView.bottom+10;
    [self.view insertSubview:bottomImgView belowSubview:backView];
    
    UILabel *transferLabel = [[UILabel alloc] init];
    transferLabel.text = @"同事不在身边？可手动移交哦~";
    transferLabel.textColor = [UIColor colorWithHexString:@"105fb0"];
    transferLabel.font = [UIFont systemFontOfSize:12];
    [transferLabel sizeToFit];
    transferLabel.y = CGRectGetMaxY(bottomImgView.frame)+20;
    transferLabel.centerX = bottomImgView.centerX;
    [self.view addSubview:transferLabel];
    
    UIButton *transferBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    transferBtn.backgroundColor = [UIColor whiteColor];
    [transferBtn setTitle:@"手动移交" forState:UIControlStateNormal];
    [transferBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    transferBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    transferBtn.size = CGSizeMake(150, 44);
    transferBtn.centerX = transferLabel.centerX;
    transferBtn.y = CGRectGetMaxY(transferLabel.frame)+10;
    transferBtn.layer.cornerRadius = 4;
    transferBtn.layer.masksToBounds = YES;
    transferBtn.layer.borderWidth = 0.5;
    transferBtn.layer.borderColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
    [transferBtn addTarget:self action:@selector(transferCase) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:transferBtn];
}

- (void)transferCase {
    WTWeakSelf;
    WTCaseTransferOperateController *transferVc = [[WTCaseTransferOperateController alloc] init];
    transferVc.caseId = self.caseModel.caseId;
    transferVc.caseModels = self.totalModel;
    transferVc.courtId = self.caseModel.courtId;
    transferVc.TransferSuccessBlcok = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:transferVc animated:YES];
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
