//
//  WTSearchAnnotation.h
//  SongDa
//
//  Created by Fancy on 2018/4/17.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
@class WTMyCaseSearchModel;

@interface WTSearchAnnotation : MAPointAnnotation
/** 周边搜索model */
@property (strong, nonatomic) WTMyCaseSearchModel *searchModel;
@end
