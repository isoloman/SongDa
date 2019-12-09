//
//  WTTotalModel.h
//  SongDa
//
//  Created by Fancy on 2018/4/3.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTBaseModel.h"

@interface WTTotalModel : NSObject
/** 状态码，判断是否成功请求到数据 */
@property (assign, nonatomic) long code;
/** message */
@property (copy, nonatomic) NSString *message;
/** error */
@property (copy, nonatomic) NSString *error;
/** 数据数组 */
@property (strong, nonatomic) NSMutableArray *data;

/** 是否已经按距离排序好 */
@property (assign, nonatomic) BOOL isSorted;

- (instancetype)initWithDict:(NSDictionary *)dict dataClass:(Class)class;

@end
