//
//  WTMyCaseByBusController.m
//  SongDa
//
//  Created by Fancy on 2018/4/18.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTMyCaseByBusController.h"
#import "WTBusRouteModel.h"

@interface WTMyCaseByBusController ()

@end

@implementation WTMyCaseByBusController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"公交搭乘方案";
    self.view.backgroundColor = WTGlobalBG;
    [self setupUI];
}

- (void)setupUI {
    UIView *containView = [[UIView alloc] init];
    containView.backgroundColor = [UIColor whiteColor];
    containView.size = CGSizeMake(HYXScreenW, 80);
    containView.y = 10;
    [self.view addSubview:containView];
    
    NSString *timeStr = [NSString stringWithFormat:@"%ld分钟",self.busRouteModel.duration];
    if (self.busRouteModel.duration > 60) {
        long hour = self.busRouteModel.duration / 60;
        long minute = self.busRouteModel.duration % 60;
        timeStr = [NSString stringWithFormat:@"%ld小时%ld分钟",hour,minute];
    }
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 20)];
    timeLabel.text = timeStr;
    timeLabel.textColor = [UIColor colorWithHexString:@"333333"];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.font = [UIFont systemFontOfSize:15];
    [containView addSubview:timeLabel];
    
    NSString *distance = @"步行800米";
    if (self.busRouteModel.walkingDistance >= 1000) {
        distance = [NSString stringWithFormat:@"步行%.1f公里",self.busRouteModel.walkingDistance/1000.0];
    } else {
        distance = [NSString stringWithFormat:@"步行%ld米",self.busRouteModel.walkingDistance];
    }
    UILabel *walkLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(timeLabel.frame)+10, 100, 20)];
    walkLabel.text = distance;
    walkLabel.textColor = [UIColor colorWithHexString:@"333333"];
    walkLabel.textAlignment = NSTextAlignmentRight;
    walkLabel.font = [UIFont systemFontOfSize:15];
    [containView addSubview:walkLabel];
    
    UIView *separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    separateLine.size = CGSizeMake(0.5, 50);
    separateLine.x = CGRectGetMaxX(walkLabel.frame)+10;
    separateLine.centerY = containView.height*0.5;
    [containView addSubview:separateLine];
    
    NSString *routeStr = @"";
    for (WTBusLineModel *lineModel in self.busRouteModel.lines) {
        NSString *lineStr = @"";
        for (WTBusStopModel *stopModel in lineModel.buses) {
            lineStr = lineStr.length ? [lineStr stringByAppendingString:[NSString stringWithFormat:@"/%@",stopModel.lineName]] : [lineStr stringByAppendingString:stopModel.lineName];
        }
        routeStr = routeStr.length ? [routeStr stringByAppendingString:[NSString stringWithFormat:@" -> %@",lineStr]] : [routeStr stringByAppendingString:lineStr];
    }
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(separateLine.frame)+10, timeLabel.y, containView.width-2*10-CGRectGetMaxX(separateLine.frame), 25)];
    lineLabel.text = routeStr;
    lineLabel.textColor = [UIColor colorWithHexString:@"333333"];
    lineLabel.font = [UIFont systemFontOfSize:18];
    [containView addSubview:lineLabel];
    
    WTBusLineModel *lineModel = self.busRouteModel.lines.firstObject;
    WTBusStopModel *stopModel = lineModel.buses.firstObject;
    UILabel *departureLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineLabel.x, walkLabel.y, lineLabel.width, 20)];
    departureLabel.text = [NSString stringWithFormat:@"%@站上车",stopModel.departureStop];
    departureLabel.textColor = [UIColor colorWithHexString:@"333333"];
    departureLabel.font = [UIFont systemFontOfSize:15];
    [containView addSubview:departureLabel];
}

@end
