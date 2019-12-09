//
//  WTMyCaseModel.m
//  SongDa
//
//  Created by Fancy on 2018/4/3.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTMyCaseModel.h"
#import "JZLocationConverter.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "YCCommonTool.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface WTMyCaseModel ()<AMapSearchDelegate>

@end

@implementation WTMyCaseModel{
    AMapSearchAPI * _search;
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.caseId = [dict stringValueForKey:@"id" default:@""];
        self.courtId = [dict stringValueForKey:@"courtId" default:@""];
        self.groupId = [dict stringValueForKey:@"groupId" default:@""];
        self.litigantName = [dict stringValueForKey:@"litigantName" default:@""];
        self.litigantId = [dict stringValueForKey:@"sdLitigantId" default:@""];
        self.region = [dict stringValueForKey:@"region" default:@""];
        self.detailAddr = [dict stringValueForKey:@"detailAddr" default:@""];
        self.fullAddress = [dict stringValueForKey:@"fullAddress" default:@""];
        if (!self.region.length) {
            NSString *region0 = [self.fullAddress componentsSeparatedByString:@"区"].firstObject;
            NSString *region = [region0 componentsSeparatedByString:@"市"].lastObject;
            self.region = [region stringByAppendingString:@"区"];
        }
        self.caseCode = [dict stringValueForKey:@"caseCode" default:@""];
        self.preCaseCode = [dict stringValueForKey:@"preCaseCode" default:@""];
        self.receiveTime = [dict stringValueForKey:@"receiveTime" default:@""];
        self.visitRecordId = [dict stringValueForKey:@"visitRecordId" default:@""];
        self.isDelivery = [dict longValueForKey:@"isDel" default:0];
        
        self.lng = [dict doubleValueForKey:@"lng" default:0];
        self.lat = [dict doubleValueForKey:@"lat" default:0];
        self.distance = [self distanceBetweenPointByLat1:[WTLocationManager shareInstance].latitude lng1:[WTLocationManager shareInstance].longitude lat2:self.lat lng2:self.lng];
        // 如果不存在经纬度，则将地址进行转换
        
        if (self.lng == 0) {
            _search = [[AMapSearchAPI alloc] init];
            _search.delegate = self;
            [self startGeo:self.fullAddress];
//            WTWeakSelf;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
//                [myGeocoder geocodeAddressString:self.fullAddress completionHandler:^(NSArray *placemarks, NSError *error) {
//
//                    if ([self.fullAddress isEqualToString:@"成都市人民南路4段63号"]) {
//                        NSLog(@"%@",[dict valueForKey:@"litigantName"]);
//                    }
//                    if ([placemarks count] > 0 && error == nil) {
//
//                        CLPlacemark *firstPlacemark = placemarks.firstObject;
//                        if (@available(iOS 10.0, *)) {
//                            weakSelf.lng = firstPlacemark.location.coordinate.longitude;
//                            weakSelf.lat = firstPlacemark.location.coordinate.latitude;
//                        }
//                        else{//iOS10 之前 WGS1984
//                            CLLocationCoordinate2D coordinate = [JZLocationConverter wgs84ToGcj02:firstPlacemark.location.coordinate];
//                            weakSelf.lng = coordinate.longitude;
//                            weakSelf.lat = coordinate.latitude;
//                        }
//                        weakSelf.distance = [weakSelf distanceBetweenPointByLat1:[WTLocationManager shareInstance].latitude lng1:[WTLocationManager shareInstance].longitude lat2:weakSelf.lat lng2:weakSelf.lng];
//                        HYXLog(@"lng=%f,lat=%f,distance=%f",weakSelf.lng,weakSelf.lat,weakSelf.distance);
//                    } else if ([placemarks count] == 0 && error == nil) {
//                        HYXLog(@"MYCaseModel:Found no placemarks");
//                    } else if (error != nil) {
//                        HYXLog(@"MYCaseModel:error occurred = %@", error);
//                    } else {
//
//                    }
//                }];
//            });
        }
        
        NSArray *tels = dict[@"tels"];
        self.phoneNums = [NSMutableArray array];
        if ([tels isKindOfClass:[NSArray class]] && tels.count) {
            for (NSDictionary *dictionary in tels) {
                NSString *tel = [dictionary stringValueForKey:@"tel" default:@""];
                [self.phoneNums addObject:tel];
            }
        }
    }
    return self;
}

- (double)distanceBetweenPointByLat1:(double)lat1 lng1:(double)lng1 lat2:(double)lat2 lng2:(double)lng2 {
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    return  [curLocation distanceFromLocation:otherLocation];
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
   
    if (response.geocodes.count == 0)
    {
//        NSLog(@"%@",self.fullAddress);
        WTLocationManager * manage = [WTLocationManager shareInstance];
        if (![self.fullAddress containsString:manage.cityName]||![self.fullAddress containsString:manage.provinceName]) {//编码失败尝试添加当地城市再试一次
            NSString * address = [manage.cityName stringByAppendingString:self.fullAddress];
            [self startGeo:address];
            
            if (self.isNeedPostNoti) {
                NSString * msg = [NSString stringWithFormat:@"部分地址不准确我们自动补充为:%@",address];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showErrorWithStatus:msg];
                });
            }
            
        }
        else{
            [self showAlert];
            HYXNote_POST(kMyCaseGeoUpdate, self);
        }
        
        return;
    }
    AMapGeocode * geo = response.geocodes.firstObject;
    AMapGeoPoint *location = geo.location;
    self.lng = location.longitude;
    self.lat = location.latitude;
    self.distance = [self distanceBetweenPointByLat1:[WTLocationManager shareInstance].latitude lng1:[WTLocationManager shareInstance].longitude lat2:self.lat lng2:self.lng];
    HYXLog(@"lng=%f,lat=%f,distance=%f",self.lng,self.lat,self.distance);
    HYXNote_POST(kMyCaseGeoUpdate, self);
    NSLog(@"%@",self.fullAddress);
}

- (void)showAlert{
    NSString * msg = [NSString stringWithFormat:@"地址：'%@'编码失败，请手动输入地址",self.fullAddress];
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:@"编码失败" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        //配置文本框的代码块
        textField.placeholder = @"请输入其他地址";
        textField.textColor = [UIColor blackColor];
    }];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString * address = controller.textFields.firstObject.text;
        [self startGeo:address];
        self.fullAddress = address;
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:ok];
    [controller addAction:cancel];
    [[YCCommonTool getCurrentVC] presentViewController:controller animated:YES completion:nil];
    
    
}

- (void)startGeo:(NSString *)address{
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = address;
    [_search AMapGeocodeSearch:geo];
}
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super init]) {
//        self.caseId = [aDecoder decodeObjectForKey:@"id"];
//        self.litigantName = [aDecoder decodeObjectForKey:@"litigantName"];
//        self.litigantId = [aDecoder decodeObjectForKey:@"sdLitigantId"];
//        self.detailAddr = [aDecoder decodeObjectForKey:@"detailAddr"];
//        self.fullAddress = [aDecoder decodeObjectForKey:@"fullAddress"];
//        self.caseCode = [aDecoder decodeObjectForKey:@"caseCode"];
//        self.receiveTime = [aDecoder decodeObjectForKey:@"receiveTime"];
//        self.visitRecordId = [aDecoder decodeObjectForKey:@"visitRecordId"];
//
//        self.isDelivery = [[aDecoder decodeObjectForKey:@"isDel"] longValue];
//        self.lng = [[aDecoder decodeObjectForKey:@"lng"] doubleValue];
//        self.lat = [[aDecoder decodeObjectForKey:@"lat"] doubleValue];
//        self.distance = [[aDecoder decodeObjectForKey:@"distance"] doubleValue];
//
//        self.phoneNums = [aDecoder decodeObjectForKey:@"phoneNums"];
//    }
//    return self;
//}
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeObject:self.caseId forKey:@"id"];
//    [aCoder encodeObject:self.litigantName forKey:@"litigantName"];
//    [aCoder encodeObject:self.litigantName forKey:@"sdLitigantId"];
//    [aCoder encodeObject:self.detailAddr forKey:@"detailAddr"];
//    [aCoder encodeObject:self.fullAddress forKey:@"fullAddress"];
//    [aCoder encodeObject:self.fullAddress forKey:@"caseCode"];
//    [aCoder encodeObject:self.receiveTime forKey:@"receiveTime"];
//    [aCoder encodeObject:self.visitRecordId forKey:@"visitRecordId"];
//
//    [aCoder encodeObject:[NSNumber numberWithLong:self.isDelivery] forKey:@"isDel"];
//    [aCoder encodeObject:[NSNumber numberWithDouble:self.lng] forKey:@"lng"];
//    [aCoder encodeObject:[NSNumber numberWithDouble:self.lat] forKey:@"lat"];
//
//    [aCoder encodeObject:self.phoneNums forKey:@"phoneNums"];
//}

@end
