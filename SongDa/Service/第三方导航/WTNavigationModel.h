//
//  WTNavigationModel.h
//  SongDa
//
//  Created by 灰太狼 on 2018/11/5.
//  Copyright © 2018 维途. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger , YCMapType) {
    YCMapTypeBaidu = 0,
    YCMapTypeGaode
};

@interface WTNavigationModel : NSObject
+ (BOOL)turnToThirdPartRouteWithDestLat:(CGFloat)destLat destLng:(CGFloat)destLng address:(NSString *)adress mapType:(YCMapType)type;
@end

NS_ASSUME_NONNULL_END
