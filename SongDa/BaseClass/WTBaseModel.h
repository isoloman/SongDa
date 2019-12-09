//
//  WTBaseModel.h
//  SongDa
//
//  Created by Fancy on 2018/3/27.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTBaseModel : NSObject
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL isNeedPostNoti;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
