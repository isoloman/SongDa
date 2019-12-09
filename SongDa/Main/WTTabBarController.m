//
//  WTTabBarController.m
//  SongDa
//
//  Created by Fancy on 2018/3/27.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTTabBarController.h"
#import "WTNavigationController.h"
#import "WTTabBar.h"
#import "WTMyCaseController.h"
#import "WTCaseCenterController.h"

#define kTabBarImagesN  @[@"tabBar_myCase_n",@"tabBar_caseCenter_n"]
#define kTabBarImagesS  @[@"tabBar_myCase_s",@"tabBar_caseCenter_s"]
#define kTabBarTitles   @[@"我的任务",@"案件中心"]

@interface WTTabBarController ()

@end

@implementation WTTabBarController

+ (void)initialize {
    // 正常状态
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor grayColor];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:9];
    
    // 选中状态
    NSMutableDictionary *selAttr = [NSMutableDictionary dictionary];
    selAttr[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    selAttr[NSFontAttributeName] = attr[NSFontAttributeName];
    
    // 通过appearance设置所有item的属性
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attr forState:UIControlStateNormal];
    [item setTitleTextAttributes:selAttr forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WTTabBar *tabBar = [[WTTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self setupChildVcs];
}

- (void)setupChildVcs {
    [self setupChildVc:[[WTMyCaseController alloc] init] image:kTabBarImagesN[0] selImage:kTabBarImagesS[0] title:kTabBarTitles[0]];
    [self setupChildVc:[[WTCaseCenterController alloc] init] image:kTabBarImagesN[1] selImage:kTabBarImagesS[1] title:kTabBarTitles[1]];
}

/**
 *  初始化子控制器
 *
 *  @param vc       控制器
 *  @param image    图片
 *  @param selImage 选中图片
 */
- (void)setupChildVc:(UIViewController *)vc image:(NSString *)image selImage:(NSString *)selImage title:(NSString *)title
{
    vc.tabBarItem.image = [UIImage imageWithOriRenderingImage:image];
    vc.tabBarItem.selectedImage = [UIImage imageWithOriRenderingImage:selImage];
    [vc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3.5)];
    vc.tabBarItem.title = title;
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : HYXColor(169, 169, 169), NSFontAttributeName : [UIFont systemFontOfSize:9]} forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : WTBlueColor, NSFontAttributeName : [UIFont systemFontOfSize:9]} forState:UIControlStateSelected];
    
    // 包装一个导航控制器，添加导航控制器为tabBarControll的子控制器
    WTNavigationController *nav = [[WTNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

- (void)viewSafeAreaInsetsDidChange {
    // 补充：顶部的危险区域就是距离刘海10points，（状态栏不隐藏）
    // 也可以不写，系统默认是UIEdgeInsetsMake(10, 0, 34, 0);
    [super viewSafeAreaInsetsDidChange];
    self.additionalSafeAreaInsets = UIEdgeInsetsMake(10, 0, 34, 0);
}

@end
