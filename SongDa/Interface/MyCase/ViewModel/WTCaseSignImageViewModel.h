//
//  WTCaseSignImageViewModel.h
//  SongDa
//
//  Created by 灰太狼 on 2018/4/11.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTBaseViewModel.h"

@interface WTCaseSignImageViewModel : WTBaseViewModel

- (void)dataByParameters:(id)parameters images:(NSArray *)images success:(void (^)(id))success failure:(void (^)(NSError *, NSString *))failure;

@end
