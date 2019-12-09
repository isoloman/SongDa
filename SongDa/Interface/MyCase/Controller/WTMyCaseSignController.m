//
//  WTMyCaseSignController.m
//  SongDa
//
//  Created by 灰太狼 on 2018/4/10.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTMyCaseSignController.h"
#import "WTMyCaseSignCell.h"
#import "HYXPlaceholderTextView.h"
#import "WTCaseSignCollectionCell.h"
#import "WTMyCaseSignResultController.h"
#import "WTCaseSignViewModel.h"
#import "WTMyCaseModel.h"
#import "WTCaseSignImageViewModel.h"
#import "WTMyCaseSignDetailViewModel.h"
#import "WTMyCaseSignDetailModel.h"
#import "WTPhotoManager.h"
#import "WTCaseRelatedViewModel.h"
#import "WTCaseRelatedButton.h"

#import <AMapLocationKit/AMapLocationKit.h>
#import <ZLPhotoBrowser/ZLPhotoBrowser.h>

#define kTitles         @[@"上门情况",@"送达结果"]
#define kSubTitles      @[@"未选择",@"请选择上门情况"]
#define kTextViewH      100
#define kCaseViewH      75

@interface WTMyCaseSignController () <UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UITextViewDelegate>
@property (strong, nonatomic) UITableView               *tableView;
@property (strong, nonatomic) HYXPlaceholderTextView    *textView;
@property (strong, nonatomic) UIView                    *headerView;
/** 案件关联view */
@property (strong, nonatomic) UIScrollView              *caseRelatedView;
/** 案件关联 全选按钮 */
@property (strong, nonatomic) UIButton                  *allSeletedBtn;
/** 案件关联model */
@property (strong, nonatomic) WTTotalModel              *totalModel;
/** 案件关联 选中数组 */
@property (strong, nonatomic) NSMutableArray            *seletedBtnsArrM;
/** 更新/上传按钮 */
@property (strong, nonatomic) UIButton                  *commitBtn;
/** 是否填写 上门情况 */
@property (assign, nonatomic) BOOL                      isWrittenDeliverSituation;
/** 是否填写 送达结果 */
@property (assign, nonatomic) BOOL                      isWrittenDeliverResult;
/** 图片数组 */
@property (strong, nonatomic) NSMutableArray            *imagesArrM;
/** 更新图片数组 */
//@property (strong, nonatomic) NSMutableArray            *updateImagesArrM;
@property (strong, nonatomic) UICollectionView          *collectionView;
/** 图片浏览view */
@property (strong, nonatomic) UIScrollView              *photoBrowser;
/** 当前展示图片view */
@property (strong, nonatomic) UIImageView               *imageView;
/** 定位label */
@property (strong, nonatomic) UILabel                   *locationLabel;

@property (strong, nonatomic) AMapLocationManager       *locationManager;

// -------请求参数------
@property (copy, nonatomic) NSString                    *visitDetail;
@property (assign, nonatomic) int                       visitDetailId;
@property (assign, nonatomic) int                       resultId;

/** 已送达追记模型 */
@property (strong, nonatomic) WTMyCaseSignDetailModel   *signDetailModel;
@property (strong, nonatomic) ZLPhotoActionSheet *photoSheet;
@property (nonatomic, strong, nullable) NSMutableArray<PHAsset *> *arrSelectedAssets;
@end

@implementation WTMyCaseSignController

static NSString * const ID = @"cell";
static NSString * const collectionID = @"collectionID";

- (ZLPhotoActionSheet *)photoSheet{
    if (!_photoSheet) {
        _photoSheet = [[ZLPhotoActionSheet alloc] init];
        _photoSheet.configuration.maxSelectCount = 9;
        _photoSheet.configuration.maxPreviewCount = 20;
        _photoSheet.sender = self;
        _photoSheet.configuration.allowMixSelect = NO;
        _photoSheet.configuration.allowSelectVideo = NO;
        WTWeakSelf;
        [_photoSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
            _arrSelectedAssets = [assets mutableCopy];
            [weakSelf.imagesArrM insertObjects:images atIndex:weakSelf.imagesArrM.count-1];
            [weakSelf.collectionView reloadData];
        }];
    }
    
    return _photoSheet;
}

- (UIButton *)commitBtn
{
    if (_commitBtn == nil) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _commitBtn.size = CGSizeMake(44, 44);
        _commitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_commitBtn addTarget:self action:@selector(commitClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

- (NSMutableArray *)imagesArrM
{
    if (_imagesArrM == nil) {
        if (self.visitRecordId.length) {
            _imagesArrM = [NSMutableArray array];
        } else {
            _imagesArrM = [NSMutableArray arrayWithObject:HYXImage(@"caseSign_addImage")];
        }
    }
    return _imagesArrM;
}
////更新
//- (NSMutableArray *)updateImagesArrM
//{
//    if (_updateImagesArrM == nil) {
//        _updateImagesArrM = [NSMutableArray array];
//    }
//    return _updateImagesArrM;
//}

- (NSMutableArray *)seletedBtnsArrM
{
    if (_seletedBtnsArrM == nil) {
        _seletedBtnsArrM = [NSMutableArray array];
    }
    return _seletedBtnsArrM;
}

- (UIScrollView *)photoBrowser
{
    if (_photoBrowser == nil) {
        _photoBrowser = [[UIScrollView alloc] initWithFrame:HYXScreenBounds];
//        _photoBrowser.backgroundColor = [UIColor clearColor];
        _photoBrowser.backgroundColor = [UIColor blackColor];
        _photoBrowser.maximumZoomScale = 2.0;
        _photoBrowser.minimumZoomScale = 1.0;
        _photoBrowser.showsVerticalScrollIndicator = NO;
        _photoBrowser.showsHorizontalScrollIndicator = NO;
        _photoBrowser.delegate = self;
        
        // 添加单点手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        [_photoBrowser addGestureRecognizer:singleTap];
        
        // 添加双击手势
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [_photoBrowser addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.size = CGSizeMake(HYXScreenW, HYXScreenW);
        self.imageView.centerX = _photoBrowser.width*0.5;
        self.imageView.centerY = _photoBrowser.height*0.5;
        [_photoBrowser addSubview:self.imageView];
    }
    return _photoBrowser;
}

- (AMapLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[AMapLocationManager alloc] init];
//        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.locationTimeout = 5;
        _locationManager.reGeocodeTimeout = 10;
    }
    return _locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav];
    [self setupTableView];
    _isWrittenDeliverResult = NO;
    _isWrittenDeliverSituation = NO;

    if (self.visitRecordId.length) {
        [self loadSignDetailData];
        //更新送达详情-----
        self.textView.editable = NO;
        self.textView.selectable = NO;
    } else {
        //更新送达详情-----
        self.textView.editable = YES;
        self.textView.selectable = YES;
    }
    
    if (self.groupID.length) {
        [self loadCaseRelatedData];
    }
}

- (void)setupNav {
    if (self.visitRecordId.length) {
        self.navigationItem.title = @"送达详情";
//        //更新送达详情-----
//        [self.commitBtn setTitle:@"更新" forState:UIControlStateNormal];
    } else {
        self.navigationItem.title = @"上门追记";
        [self.commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.commitBtn];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, HYXScreenW, HYXScreenH-IPhoneX_Nav_Height)];
    tableView.backgroundColor = WTGlobalBG;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [tableView registerClass:[WTMyCaseSignCell class] forCellReuseIdentifier:ID];
    
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    adjustsScrollViewInsets(tableView);
    
    [self setupHeaderView];
    [self setupFooterView];
}
- (void)setupHeaderView {
    // 头部
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = WTGlobalBG;
    headerView.size = CGSizeMake(HYXScreenW, kTextViewH);
    self.headerView = headerView;
    self.tableView.tableHeaderView = headerView;
    
    HYXPlaceholderTextView *textView = [[HYXPlaceholderTextView alloc] initWithFrame:CGRectMake(10, 5, headerView.width-2*10, kTextViewH-2*5)];
    textView.backgroundColor = [UIColor clearColor];
    textView.placeholder = @"请简单描述下送达情况(最多100字符)";
    textView.placeholderColor = [UIColor colorWithHexString:@"666666"];
    textView.placeholderFont = [UIFont systemFontOfSize:14];
    textView.font = [UIFont systemFontOfSize:13];
    textView.textColor = [UIColor colorWithHexString:@"333333"];
    textView.maxNumberOfLines = 4;
    textView.delegate = self;
    [headerView addSubview:textView];
    self.textView = textView;
}
- (void)setupFooterView {
    // 尾部
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = WTGlobalBG;
    footerView.width = HYXScreenW;
    self.tableView.tableFooterView = footerView;
    
    // 定位view
    UIView *locationView = [[UIView alloc] init];
    locationView.backgroundColor = [UIColor clearColor];
    locationView.size = CGSizeMake(HYXScreenW, 44);
    [footerView addSubview:locationView];
    footerView.height = locationView.height;
    
    UIImageView *locationImgView = [[UIImageView alloc] initWithImage:HYXImage(@"caseSign_location")];
    [locationImgView sizeToFit];
    locationImgView.x = 15;
    locationImgView.centerY = locationView.height*0.5;
    [locationView addSubview:locationImgView];
    
    CGFloat locationX = CGRectGetMaxX(locationImgView.frame)+10;
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(locationX, 0, locationView.width-10-locationX, locationView.height)];
    self.locationLabel = locationLabel;
    locationLabel.textColor = [UIColor colorWithHexString:@"666666"];
    locationLabel.font = [UIFont systemFontOfSize:13];
    [locationView addSubview:locationLabel];
    if (self.visitRecordId.length == 0) {
        locationLabel.text = @"定位中...";
        [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            if (regeocode) {
                locationLabel.text = [NSString stringWithFormat:@"%@%@%@%@",regeocode.city,regeocode.district,regeocode.street,regeocode.number];
            }
        }];
    }
    
    
    CGFloat margin = 10;
    CGFloat wh = (self.tableView.width-4*margin)/3.0;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(floorf(wh), floorf(wh));
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(locationView.frame), self.tableView.width, wh*3+4*margin) collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.contentInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    collectionView.scrollEnabled = NO;
    [collectionView registerClass:[WTCaseSignCollectionCell class] forCellWithReuseIdentifier:collectionID];
    [footerView addSubview:collectionView];
    footerView.height += collectionView.height;
}

- (void)setupCaseRelatedView {
    UIScrollView *caseRelatedView = [[UIScrollView alloc] init];
    caseRelatedView.backgroundColor = [UIColor whiteColor];
    caseRelatedView.width = HYXScreenW;
    self.caseRelatedView = caseRelatedView;
    
    // 标题视图
    UIView *titleView = [self setupCaseRelatedTitleView];
    [caseRelatedView addSubview:titleView];
    
    // 其他关联案件
    for (NSInteger i = 0; i < self.totalModel.data.count; i++) {
        WTMyCaseModel *caseModel = self.totalModel.data[i];
        WTCaseRelatedButton *button = [[WTCaseRelatedButton alloc] initWithFrame:CGRectMake(0, 0, HYXScreenW, kCaseViewH)];
        button.tag = i;
        button.caseModel = caseModel;
        button.y = CGRectGetMaxY(titleView.frame)+i*button.height;
        [button addTarget:self action:@selector(caseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [caseRelatedView addSubview:button];
        [self.seletedBtnsArrM addObject:button];
    }
    
    if (self.totalModel.data.count > 3) {
        caseRelatedView.height = CGRectGetMaxY(titleView.frame)+kCaseViewH*3;
        caseRelatedView.contentSize = CGSizeMake(HYXScreenW, CGRectGetMaxY(titleView.frame)+kCaseViewH*self.totalModel.data.count);
    } else {
        caseRelatedView.height = CGRectGetMaxY(titleView.frame)+kCaseViewH*self.totalModel.data.count;
    }
    
    [self allSeletedClick:self.allSeletedBtn];
    
    self.headerView.height = kTextViewH+caseRelatedView.height;
    [self.headerView addSubview:caseRelatedView];
    self.textView.y = CGRectGetMaxY(caseRelatedView.frame)+5;
}

- (void)allSeletedClick:(UIButton *)button {
    WTWeakSelf;
    button.selected = !button.selected;
    [self.seletedBtnsArrM removeAllObjects];
    if (button.selected) {
        [self.caseRelatedView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[WTCaseRelatedButton class]]) {
                WTCaseRelatedButton *relatedBtn = (WTCaseRelatedButton *)obj;
                relatedBtn.selected = YES;
                relatedBtn.seletedBtn.selected = YES;
                [weakSelf.seletedBtnsArrM addObject:relatedBtn];
            }
        }];
    } else {
        [self.caseRelatedView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[WTCaseRelatedButton class]]) {
                WTCaseRelatedButton *relatedBtn = (WTCaseRelatedButton *)obj;
                relatedBtn.selected = NO;
                relatedBtn.seletedBtn.selected = NO;
            }
        }];
    }
}

- (UIView *)setupCaseRelatedTitleView {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HYXScreenW, 44)];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"关联关系";
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [titleLabel sizeToFit];
    titleLabel.x = 15;
    titleLabel.centerY = titleView.height*0.5;
    [titleView addSubview:titleLabel];
    
    UIButton *allSeletedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [allSeletedBtn setTitle:@"全选  " forState:UIControlStateNormal];
    [allSeletedBtn setTitleColor:titleLabel.textColor forState:UIControlStateNormal];
    [allSeletedBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [allSeletedBtn setImage:HYXImage(@"caseRelated_unseleted") forState:UIControlStateNormal];
    [allSeletedBtn setImage:HYXImage(@"caseRelated_seleted") forState:UIControlStateSelected];
    allSeletedBtn.size = CGSizeMake(70, titleView.height);
    allSeletedBtn.right = titleView.width-11;
    [allSeletedBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -(allSeletedBtn.imageView.width+2), 0, allSeletedBtn.imageView.width+2)];
    [allSeletedBtn setImageEdgeInsets:UIEdgeInsetsMake(0, allSeletedBtn.titleLabel.width+2, 0, -(allSeletedBtn.titleLabel.width+2))];
    [allSeletedBtn addTarget:self action:@selector(allSeletedClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:allSeletedBtn];
    self.allSeletedBtn = allSeletedBtn;
    
    UIView *separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    separateLine.size = CGSizeMake(HYXScreenW, 1);
    separateLine.y = titleView.height-separateLine.height;
    [titleView addSubview:separateLine];
    
    return titleView;
}
- (void)caseBtnClick:(WTCaseRelatedButton *)button {
    button.selected = !button.selected;
    button.seletedBtn.selected = button.selected;
    if (button.selected) {
        [self.seletedBtnsArrM addObject:button];
    } else {
        [self.seletedBtnsArrM removeObject:button];
    }
}

- (void)loadCaseRelatedData {
    WTWeakSelf;
    NSDictionary *para = @{@"groupId" : self.groupID};
    [[[WTCaseRelatedViewModel alloc] init] dataByParameters:para success:^(WTTotalModel *totalModel) {
        for (NSInteger i = 0; i < totalModel.data.count; i++) {
            WTMyCaseModel *caseModel = totalModel.data[i];
            if ([caseModel.caseId isEqualToString:weakSelf.caseModel.caseId]) {
                [totalModel.data removeObject:caseModel];
                i--;
            }
        }
        weakSelf.totalModel = totalModel;
        if (totalModel.data.count) {
            [weakSelf setupCaseRelatedView];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error, NSString *message) {
        HYXLog(@"%@",error.localizedDescription);
    }];
}
- (void)loadSignDetailData {
    WTWeakSelf;
    [SVProgressHUD show];
    NSDictionary *paras = @{@"visitRecordId" : self.visitRecordId};
    [[[WTMyCaseSignDetailViewModel alloc] init] dataByParameters:paras success:^(WTMyCaseSignDetailModel *signModel) {
        weakSelf.signDetailModel = signModel;
        weakSelf.textView.placeholder = nil;
        weakSelf.textView.text = signModel.serviceRemark;
        weakSelf.locationLabel.text = signModel.fullAddress;
        if (signModel.signImages.count) {
            [weakSelf.imagesArrM addObjectsFromArray:signModel.signImages];
            [weakSelf.collectionView reloadData];
        }
//        //更新送达详情-----
//        [weakSelf.imagesArrM addObject:HYXImage(@"caseSign_addImage")];
        [weakSelf.tableView reloadData];
        
//        //更新送达详情-----
//        weakSelf.isWrittenDeliverResult = YES;
//        weakSelf.isWrittenDeliverSituation = YES;
//        weakSelf.visitDetailId = (int)signModel.visitDetailId;
//        weakSelf.visitDetail = signModel.visitDetail;
//        weakSelf.resultId = (int)signModel.isArrived;
//        if (weakSelf.caseModel == nil) {
//            weakSelf.caseModel = [[WTMyCaseModel alloc] init];
//            weakSelf.caseModel.caseId = weakSelf.visitRecordId;
//        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error, NSString *message) {
        HYXLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"加载上门追记数据出错！！！"];
        [self.view removeAllSubviews];
    }];
}

- (void)commitClick:(UIButton *)commitBtn {
    WTWeakSelf;
    if ([self.textView.text isEmpty]) {
        [SVProgressHUD showErrorWithStatus:@"请填写送达情况~"];
        return;
    }
    if (!self.isWrittenDeliverSituation) {
        [SVProgressHUD showErrorWithStatus:@"请填写上门情况~"];
        return;
    }
    if (!self.isWrittenDeliverResult) {
        [SVProgressHUD showErrorWithStatus:@"请填写送达结果~"];
        return;
    }
    [SVProgressHUD show];
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"visitDetailId"] = @(self.visitDetailId);
    paras[@"visitDetail"] = self.visitDetail;
    paras[@"serviceRemark"] = self.textView.text;
    paras[@"isArrived"] = @(self.resultId);
    if (![self.locationLabel.text containsString:@"定位中"]) { // 不包含"定位中"，则表示已经实现定位
        paras[@"lng"] = @([WTLocationManager shareInstance].longitude);
        paras[@"lat"] = @([WTLocationManager shareInstance].latitude);
    }
    
    if (self.seletedBtnsArrM.count) {
        NSMutableArray *ids = [NSMutableArray array];
        [ids addObject:self.caseModel.caseId];
        for (WTCaseRelatedButton *button in self.seletedBtnsArrM) {
            WTMyCaseModel *model = button.caseModel;
            [ids addObject:model.caseId];
        }
        paras[@"visitRecordIds"] = [ids componentsJoinedByString:@","];
    } else {
        paras[@"visitRecordIds"] = self.caseModel.caseId;
    }

    commitBtn.userInteractionEnabled = NO;
    
    NSMutableArray *images = [self.imagesArrM mutableCopy];
    [images removeLastObject];
    [[[WTCaseSignViewModel alloc] init] dataByParameters:paras success:^(id obj) {
        
        if (images.count) {
            [self postImages:images];
            return ;
        }
        
        [SVProgressHUD showSuccessWithStatus:@"成功添加追记！"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weakSelf.addSignBlock) {
                weakSelf.addSignBlock();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
        commitBtn.userInteractionEnabled = YES;
        
    } failure:^(NSError *error, NSString *message) {
        [SVProgressHUD showErrorWithStatus:@"添加失败！"];
        commitBtn.userInteractionEnabled = YES;
    }];
    
    
    
}

- (void)postImages:(NSArray *)images{
    NSMutableDictionary *imageParas = [NSMutableDictionary dictionary];
    if (self.seletedBtnsArrM.count) {
        NSMutableArray *ids = [NSMutableArray array];
        [ids addObject:self.caseModel.caseId];
        for (WTCaseRelatedButton *button in self.seletedBtnsArrM) {
            WTMyCaseModel *model = button.caseModel;
            [ids addObject:model.caseId];
        }
        imageParas[@"visitRecordIds"] = [ids componentsJoinedByString:@","];
    } else {
        imageParas[@"visitRecordIds"] = self.caseModel.caseId;
    }
    //        //更新送达详情-----
    //        if (self.visitRecordId.length) {
    //            images = [NSMutableArray arrayWithArray:self.updateImagesArrM];
    //        }
    WTWeakSelf;
    [[[WTCaseSignImageViewModel alloc] init] dataByParameters:imageParas images:images success:^(id obj) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weakSelf.addSignBlock) {
                weakSelf.addSignBlock();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
        [SVProgressHUD showSuccessWithStatus:@"成功添加追记！"];
        HYXLog(@"上传追记图片成功！");
    } failure:^(NSError *error, NSString *message) {
        [SVProgressHUD showErrorWithStatus:@"添加失败！"];
        _commitBtn.userInteractionEnabled = YES;
        HYXLog(@"上传追记图片失败！");
    }];
}

#pragma mark - <图片点击处理>
- (void)photoSingleTap:(UITapGestureRecognizer *)tapGes {
    [UIView animateWithDuration:0.4 animations:^{
        self.photoBrowser.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.photoBrowser.zoomScale = 1.0;
        [self.photoBrowser removeFromSuperview];
    }];
}
- (void)photoDoubleTap:(UITapGestureRecognizer *)tapGes {
    if (self.photoBrowser.zoomScale == 1.0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.photoBrowser.zoomScale = 2.0;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.photoBrowser.zoomScale = 1.0;
        }];
    }
}

#pragma mark - <TableView>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kTitles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTMyCaseSignCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.titleLabel.text = kTitles[indexPath.row];
    if (self.signDetailModel) {
        if (indexPath.row == 0) {
            cell.subTitleLabel.text = self.signDetailModel.visitDetail;
        } else {
            cell.subTitleLabel.text = self.signDetailModel.isArrived == 0 ? @"送达不成功" : @"送达成功";
        }
    } else {
        cell.subTitleLabel.text = kSubTitles[indexPath.row];
    }
    cell.isHideSeparateLine = indexPath.row == kTitles.count-1;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.visitRecordId.length == 0) {
        WTWeakSelf;
        WTMyCaseSignResultController *resultVc = [[WTMyCaseSignResultController alloc] init];
        resultVc.deliverResult = ^(NSString *visitDetail, int visitDetailId) {
            if (![visitDetail isEmpty]) {
                WTMyCaseSignCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.subTitleLabel.text = visitDetail;
                if (indexPath.row) {
                    weakSelf.isWrittenDeliverResult = YES;
                } else {
                    weakSelf.isWrittenDeliverSituation = YES;
                }
                
                if (indexPath.row == 0) { //上门情况
                    weakSelf.visitDetail = visitDetail;
                    weakSelf.visitDetailId = visitDetailId;
                } else { //送达结果
                    weakSelf.resultId = visitDetailId;
                }
            }
        };
        resultVc.isDeliverResult = indexPath.row;
        [self.navigationController pushViewController:resultVc animated:YES];
    }
}

#pragma mark - <CollectionView>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.imagesArrM.count > 9) {
        return 9;
    }
    return self.imagesArrM.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WTWeakSelf;
    WTCaseSignCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionID forIndexPath:indexPath];
    if (self.visitRecordId.length) {
        cell.image = self.imagesArrM[indexPath.row];
        
        cell.isHideDeleteBtn = YES;
//更新送达详情-----------------begin
//        if (indexPath.item == self.imagesArrM.count-1) {
//            cell.isHideDeleteBtn = YES;
//        } else {
//            if (self.updateImagesArrM.count) {
//                if (indexPath.item < self.updateImagesArrM.count) {
//                    cell.isHideDeleteBtn = NO;
//                } else {
//                    cell.isHideDeleteBtn = YES;
//                }
//            } else {
//                cell.isHideDeleteBtn = YES;
//            }
//        }
//        cell.deleteBlock = ^(WTCaseSignCollectionCell *currentCell) {
//            NSIndexPath *currentIndex = [collectionView indexPathForCell:currentCell];
//            [weakSelf.imagesArrM removeObjectAtIndex:currentIndex.item];
//            [weakSelf.collectionView deleteItemsAtIndexPaths:@[currentIndex]];
//
//            [weakSelf.updateImagesArrM removeObjectAtIndex:currentIndex.item];
//        };
//更新送达详情------------------end
    } else {
        cell.image = self.imagesArrM[indexPath.item];
        cell.isHideDeleteBtn = indexPath.item == self.imagesArrM.count-1;
        cell.deleteBlock = ^(WTCaseSignCollectionCell *currentCell) {
            NSIndexPath *currentIndex = [collectionView indexPathForCell:currentCell];
            [weakSelf.imagesArrM removeObjectAtIndex:currentIndex.item];
            [weakSelf.arrSelectedAssets removeObjectAtIndex:currentIndex.item];
            if (weakSelf.imagesArrM.count >= 9) {
                [weakSelf.collectionView reloadData];
            }
            else
             [weakSelf.collectionView deleteItemsAtIndexPaths:@[currentIndex]];
        };
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WTCaseSignCollectionCell *cell = (WTCaseSignCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.visitRecordId.length == 0) { // 添加追记
        if (indexPath.item == self.imagesArrM.count-1) { // 添加按钮
            [self.view endEditing:YES];
            self.photoSheet.arrSelectedAssets = _arrSelectedAssets;
            [self.photoSheet showPreviewAnimated:YES];
            
        } else { // 图片item
            self.photoBrowser.alpha = 0.0;
            self.imageView.image = cell.showImgView.image;
            [self.navigationController.view addSubview:self.photoBrowser];
            [UIView animateWithDuration:0.4 animations:^{
                self.photoBrowser.alpha = 1.0;
            }];
        }
    } else { // 查看追记详情
        self.photoBrowser.alpha = 0.0;
        self.imageView.image = cell.showImgView.image;
        [self.navigationController.view addSubview:self.photoBrowser];
        [UIView animateWithDuration:0.4 animations:^{
            self.photoBrowser.alpha = 1.0;
        }];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.textView resignFirstResponder];
}


#pragma mark - <UIScrollViewDelegate>
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark - <UITextViewDelegate>
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger kMaxLength = 100;
    NSString *toBeString = textView.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        UITextRange *selectedRange = [textView markedTextRange];
        
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > kMaxLength) {
                textView.text = [toBeString substringToIndex:kMaxLength];
                [SVProgressHUD showInfoWithStatus:@"最多100字符哦~"];
            }
        } else {//有高亮选择的字符串，则暂不对文字进行统计和限制
            
        }
    } else {//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLength) {
            textView.text = [toBeString substringToIndex:kMaxLength];
            [SVProgressHUD showInfoWithStatus:@"最多100字符哦~"];
        }
    }
}

@end
