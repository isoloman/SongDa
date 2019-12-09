//
//  WTCaseSignCollectionCell.h
//  SongDa
//
//  Created by 灰太狼 on 2018/4/10.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTCaseSignCollectionCell;

typedef void (^DeleteCellBlock) (WTCaseSignCollectionCell *currentCell);

@interface WTCaseSignCollectionCell : UICollectionViewCell
/** 图片/图片url */
@property (strong, nonatomic) id image;
/** 图片view */
@property (strong, nonatomic) UIImageView *showImgView;
/** 是否隐藏删除view */
@property (assign, nonatomic) BOOL isHideDeleteBtn;

@property (copy, nonatomic) DeleteCellBlock deleteBlock;
@end
