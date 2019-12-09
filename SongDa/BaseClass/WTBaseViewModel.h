//
//  WTBaseViewModel.h
//  SongDa
//
//  Created by Fancy on 2018/3/27.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTBaseViewModel : NSObject
- (void)dataByParameters:(id)parameters
                 success:(void (^)(id obj))success
                 failure:(void (^)(NSError *error, NSString *message))failure;
@end
