//
//  WTNavigationModel.m
//  SongDa
//
//  Created by 灰太狼 on 2018/11/5.
//  Copyright © 2018 维途. All rights reserved.
//

#import "WTNavigationModel.h"
#import "JZLocationConverter.h"

@implementation WTNavigationModel

+ (BOOL)turnToThirdPartRouteWithDestLat:(CGFloat)destLat destLng:(CGFloat)destLng address:(NSString *)adress mapType:(YCMapType)type{
    
    int gaodeT = 0;
    NSString * baiduMode = @"";
    
    switch ([WTAccountManager sharedManager].traffic) {
        case WTTrafficTypeCar:
        {
            gaodeT = 0;
            baiduMode = @"driving";
        }
            break;
        case WTTrafficTypeBus:
        {
            gaodeT = 1;
            baiduMode = @"transit";
        }
            break;
        case WTTrafficTypeBike:
        {
            gaodeT = 3;
            baiduMode = @"riding";
        }
            break;
        case WTTrafficTypeWalk:
        {
            gaodeT = 2;
            baiduMode = @"walking";
        }
            break;
            
        default:
            break;
    }
    
    NSURL *scheme = nil;
    if (type == YCMapTypeBaidu) {
        //http://lbsyun.baidu.com/index.php?title=uri/api/ios详细说明
        scheme = [NSURL URLWithString:@"baidumap://"];
    }
    else{
        //https://lbs.amap.com/api/amap-mobile/guide/ios/route详细说明
        scheme =[NSURL URLWithString:@"iosamap://"];
    }
    
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:scheme];
    
    NSString * url;
    if (type == YCMapTypeGaode) {
        url = [NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&slat=%lf&slon=%lf&sname=%@&did=BGVIS2&dlat=%lf&dlon=%lf&dname=%@&dev=0&t=%d",@"chengduSongda",
              [WTLocationManager shareInstance].latitude,
              [WTLocationManager shareInstance].longitude,
              [[WTLocationManager shareInstance].currentAdress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
              destLat,
              destLng,
              [adress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
              gaodeT];
    }
    else if (type == YCMapTypeBaidu){
        CLLocationCoordinate2D origin = CLLocationCoordinate2DMake([WTLocationManager shareInstance].latitude, [WTLocationManager shareInstance].longitude);
        CLLocationCoordinate2D bdOrigin = [JZLocationConverter gcj02ToBd09:origin];
        
        CLLocationCoordinate2D destination = CLLocationCoordinate2DMake(destLat, destLng);
        CLLocationCoordinate2D bdDestination = [JZLocationConverter gcj02ToBd09:destination];
        
        NSString * originStr = [NSString stringWithFormat:@"%lf,%lf",bdOrigin.latitude,bdOrigin.longitude];
        NSString * destinationStr = [NSString stringWithFormat:@"%lf,%lf",bdDestination.latitude,bdDestination.longitude];
        
        url = [NSString stringWithFormat:@"baidumap://map/direction?origin=%@&origin_region=%@&destination=%@&destination_region=%@&mode=%@&src=%@",
               originStr,
               [[WTLocationManager shareInstance].currentAdress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
               destinationStr,
               [adress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
               baiduMode,
               @"com.weitu.chengduSongdaTest"];
    }
    
    NSURL *myLocationScheme = [NSURL URLWithString:url];
    
    if (!canOpen) {
        [SVProgressHUD showInfoWithStatus:@"暂未安装该应用，将在APP内进行导航"];
        return NO;
    }
    
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:myLocationScheme options:@{} completionHandler:^(BOOL success) {
            NSLog(@"scheme调用结束");
        }];
    } else {
        //iOS10以前,使用旧API
        [[UIApplication sharedApplication] openURL:myLocationScheme];
    }
    
    return YES;
}


@end
