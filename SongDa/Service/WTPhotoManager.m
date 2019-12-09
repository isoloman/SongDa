//
//  WTPhotoManager.m
//  SongDa
//
//  Created by 灰太狼 on 2018/5/30.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTPhotoManager.h"
#import <Photos/Photos.h>

@implementation WTPhotoManager

//+ (instancetype)sharedManager {
//    static WTPhotoManager *_instance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _instance = [[super allocWithZone:nil] init];
//    });
//    return _instance;
//}
//
//+ (instancetype)allocWithZone:(struct _NSZone *)zone {
//    return [WTPhotoManager sharedManager];
//}
//
//- (id)copyWithZone:(NSZone *)zone {
//    return [WTPhotoManager sharedManager];
//}
//- (id)mutableCopyWithZone:(NSZone *)zone {
//    return [WTPhotoManager sharedManager];
//}

+ (BOOL)isAuthorizedForPhoto {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied ||
        status == PHAuthorizationStatusRestricted) {
        return NO;
    }
    return YES;
}

+ (BOOL)isAuthorizedForCamera {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusDenied ||
        status == AVAuthorizationStatusRestricted) {
        return NO;
    }
    return YES;
}

@end
