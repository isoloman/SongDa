//
//  WTNavigationController.m
//  SongDa
//
//  Created by Fancy on 2018/3/27.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTNavigationController.h"

@interface WTNavigationController ()

@end

@implementation WTNavigationController

+ (void)initialize {
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    [bar setBackgroundImage:[UIImage imageWithColor:WTBlueColor] forBarMetrics:UIBarMetricsDefault];
    [bar setTintColor:[UIColor whiteColor]];
    [bar setShadowImage:[UIImage new]];
    
    // 设置导航条标题属性
    NSMutableDictionary *tittleAtt = [NSMutableDictionary dictionary];
    tittleAtt[NSForegroundColorAttributeName] = [UIColor whiteColor];
    tittleAtt[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    [bar setTitleTextAttributes:tittleAtt];
    
    // 状态栏白色
    bar.barStyle = UIBarStyleBlack;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:HYXImage(@"nav_back") forState:UIControlStateNormal];
        backBtn.adjustsImageWhenHighlighted = NO;
        backBtn.size = CGSizeMake(30, 44);
        [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [backBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)backClick {
    [self popViewControllerAnimated:YES];
}

- (void)viewSafeAreaInsetsDidChange {
    // 补充：顶部的危险区域就是距离刘海10points，（状态栏不隐藏）
    // 也可以不写，系统默认是UIEdgeInsetsMake(10, 0, 34, 0);
    [super viewSafeAreaInsetsDidChange];
    self.additionalSafeAreaInsets = UIEdgeInsetsMake(10, 0, 34, 0);
}

@end
