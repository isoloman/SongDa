//
//  WTPhotoManager.h
//  SongDa
//
//  Created by 灰太狼 on 2018/5/30.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTPhotoManager : NSObject

//+ (instancetype)sharedManager;
+ (BOOL)isAuthorizedForPhoto;
+ (BOOL)isAuthorizedForCamera;

@end
