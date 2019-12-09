//
//  WTCatchCrash.h
//  SongDa
//
//  Created by admin on 2019/6/27.
//  Copyright © 2019 维途. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WTCatchCrash : NSObject
void uncaughtExceptionHandler(NSException *exception);
@end

NS_ASSUME_NONNULL_END
