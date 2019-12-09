//
//  WTCaseCodeController.m
//  SongDa
//
//  Created by Fancy on 2018/3/27.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTCaseCodeController.h"
#import "WTCaseDetailController.h"
#import "WTPhotoManager.h"
#import <CoreImage/CoreImage.h>
#import <AVFoundation/AVFoundation.h>

@interface WTCaseCodeController () <AVCaptureMetadataOutputObjectsDelegate>
/**  */
@property (strong, nonatomic) AVCaptureSession *session;
/**  */
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
/** 黑色遮罩 */
@property (strong, nonatomic) UIView *maskView;
/** 扫描区域 */
@property (strong, nonatomic) UIImageView *scanImgView;
/** 扫描线 */
@property (strong, nonatomic) UIView *scanLine;
@end

@implementation WTCaseCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title =  @"读取二维码";
    
    [self setupUI];
}

- (void)setupUI {
    CGFloat wh = HYXScreenW*0.7;
    self.scanImgView = [[UIImageView alloc] initWithImage:HYXImage(@"case_scan")];
    self.scanImgView.size = CGSizeMake(wh, wh);
    self.scanImgView.y = 60;
    self.scanImgView.centerX = self.view.width*0.5;
    [self.view addSubview:self.scanImgView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    cancelBtn.size = CGSizeMake(HYXScreenW*0.75, 44);
    cancelBtn.centerX = self.view.width*0.5;
    cancelBtn.y = CGRectGetMaxY(self.scanImgView.frame)+60;
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.borderColor = [[UIColor whiteColor]CGColor];
    cancelBtn.layer.cornerRadius = 4;
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:cancelBtn];
    
    // 初始化session
    [self readQRCode];
    
    // 添加遮罩
    self.maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.maskView.alpha = 0.5f;
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.userInteractionEnabled = NO;
    self.maskView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:self.maskView belowSubview:self.scanImgView];
    [self maskClipping];
    
    // 添加扫描线
    UIView *scanLine = [[UIView alloc] init];
    scanLine.backgroundColor = WTBlueColor;
    scanLine.size = CGSizeMake(self.scanImgView.width, 1);
    scanLine.x = self.scanImgView.x;
    scanLine.y = self.scanImgView.y;
    [self.view addSubview:scanLine];
    self.scanLine = scanLine;
    [self scanQRCode];
}

- (void)readQRCode {
    if ([WTPhotoManager isAuthorizedForCamera]) {
        // 1.实例化拍摄装备
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        // 2.设置输入设备
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        // 3.设置元数据输出
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        // 4.添加拍摄会话
        self.session = [[AVCaptureSession alloc] init];
        if ([self.session canAddInput:input]) {
            [self.session addInput:input];
        }
        if ([self.session canAddOutput:output]) {
            [self.session addOutput:output];
        }
        [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        
        // 5.视频预览图层
        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.previewLayer.frame = self.view.bounds;
        [self.view.layer insertSublayer:self.previewLayer atIndex:0];
        
        // 6.启动会话
        [self.session startRunning];
    } else {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"无法启动相机" message:@"请打开权限:手机设置->隐私->相机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertCtrl addAction:sureAct];
        [self presentViewController:alertCtrl animated:YES completion:nil];
    }
}

- (void)maskClipping
{
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    // Left side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0, 0,
                                        self.scanImgView.frame.origin.x,
                                        self.maskView.frame.size.height));
    // Right side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(
                                        self.scanImgView.frame.origin.x + self.scanImgView.frame.size.width,
                                        0,
                                        self.maskView.frame.size.width - self.scanImgView.frame.origin.x - self.scanImgView.frame.size.width,
                                        self.maskView.frame.size.height));
    // Top side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0, 0,
                                        self.maskView.frame.size.width,
                                        self.scanImgView.frame.origin.y));
    // Bottom side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0,
                                        self.scanImgView.frame.origin.y + self.scanImgView.frame.size.height,
                                        self.maskView.frame.size.width,
                                        self.maskView.frame.size.height - self.scanImgView.frame.origin.y + self.scanImgView.frame.size.height));
    maskLayer.path = path;
    self.maskView.layer.mask = maskLayer;
    CGPathRelease(path);
}

- (void)scanQRCode {
    WTWeakSelf;
    self.scanLine.y = self.scanImgView.y;
    [UIView animateWithDuration:3.0 animations:^{
        weakSelf.scanLine.y = CGRectGetMaxY(weakSelf.scanImgView.frame);
    } completion:^(BOOL finished) {
        [weakSelf scanQRCode];
    }];
}

- (void)cancelClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <AVCaptureMetadataOutputObjectsDelegate>
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if ([metadataObjects isKindOfClass:[NSArray class]] && metadataObjects.count) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
        if ([metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            NSString *result = [metadataObject stringValue];
            [self performSelectorOnMainThread:@selector(pushCaseDetailVc:) withObject:result waitUntilDone:NO];
        } else {
            [SVProgressHUD showErrorWithStatus:@"当前二维码不正确"];
        }
    }
}

- (void)pushCaseDetailVc:(NSString *)result {
    WTWeakSelf;
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *caseId = dataDict[@"id"];
    NSArray *caseIDs = [caseId componentsSeparatedByString:@","];
    if (caseId.length) {
        WTCaseDetailController *caseDetailVc = [[UIStoryboard storyboardWithName:@"WTCaseDetailController" bundle:nil] instantiateViewControllerWithIdentifier:@"caseDetailId"];
        if (caseIDs.count > 1) {
            caseDetailVc.caseId = caseIDs.firstObject;
        }
        caseDetailVc.visitRecordIds = caseId;
        caseDetailVc.isPushFromCodeVc = YES;
        caseDetailVc.beTransferName = dataDict[@"opName"];
        caseDetailVc.beTransferId = dataDict[@"opUid"];
        caseDetailVc.popClickBlock = ^{
            [weakSelf cancelClick];
        };
        [self.navigationController pushViewController:caseDetailVc animated:YES];
    }
}

@end
