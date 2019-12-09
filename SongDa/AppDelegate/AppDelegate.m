//
//  AppDelegate.m
//  SongDa
//
//  Created by Fancy on 2018/3/27.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "AppDelegate.h"
#import "WTTabBarController.h"
#import "WTNavigationController.h"
#import "WTLoginController.h"
#import "WTMessageManager.h"
#import "WTMessageModel.h"
#import "WTCaseDetailController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <Bugly/Bugly.h>

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#if SongDa
#define JPushAppKey     @"a6b8302b4441c31c8c7d5212"
#define AMapKey         @"13cad5ad1ae7f2cb3f603ebca13959aa"
#define TestMapKey      @"991c121432ebdec99f605c914198c516"
#define BUGLY_APP_ID    @"93b3dce5fa"

#elif YuBo

#define JPushAppKey     @"a6b8302b4441c31c8c7d5212"
#define AMapKey         @"5204a4013f63d82273bebf732e20e3c3"
#define TestMapKey      @"991c121432ebdec99f605c914198c516"
#define BUGLY_APP_ID    @"93b3dce5fa"
#elif MianYang

#define JPushAppKey     @"a6b8302b4441c31c8c7d5212"
#define AMapKey         @"115f22c77212de58909e606c701b7e68"
#define TestMapKey      @"991c121432ebdec99f605c914198c516"
#define BUGLY_APP_ID    @"93b3dce5fa"
#endif

@interface AppDelegate () <JPUSHRegisterDelegate,BuglyDelegate>
@property (strong, nonatomic) NSDateFormatter *formatter;
@end

@implementation AppDelegate

- (NSDateFormatter *)formatter
{
    if (_formatter == nil) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"yyyy-MM-dd";
    }
    return _formatter;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    /*************** 设置主窗口 ***************/
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    BOOL isLogined = [WTAccountManager sharedManager].isLogined;
    if (isLogined) {
        WTTabBarController *tabBarVc = [[WTTabBarController alloc] init];
        self.window.rootViewController = tabBarVc;
    } else {
        WTLoginController *loginVc = [[WTLoginController alloc] init];
        WTNavigationController *navVc = [[WTNavigationController alloc] initWithRootViewController:loginVc];
        self.window.rootViewController = navVc;
    }
    [self.window makeKeyAndVisible];
    
    /*************** 设置HUD ***************/
    [self setupSVProgressHUD];
    
    /*************** 设置搜索框字体 ***************/
    if (@available(iOS 9.0, *)) {
        [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setDefaultTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kSearchTextFont]}];
    } else {
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kSearchTextFont]}];
    }
    
    /*************** 设置高德地图key ***************/
    [AMapServices sharedServices].apiKey = AMapKey;
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    [[WTLocationManager shareInstance] start];
    
    /*************** 极光推送配置 ***************/
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions
                           appKey:JPushAppKey
                          channel:@"App Store"
                 apsForProduction:true
            advertisingIdentifier:nil];
    
    // ------接收远程推送时，程序还没有运行情况下收到通知，点击跳转
    NSDictionary *pushInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    if ([pushInfo isKindOfClass:[NSDictionary class]]) {
        WTMessageModel *messageModel = [[WTMessageModel alloc] initWithDict:pushInfo];
        NSDate *currentDate = [NSDate date];
        messageModel.timeString = [self.formatter stringFromDate:currentDate];
        messageModel.isUnread = NO;
        if (![messageModel.caseIDs isEmpty]) {
            [[WTMessageManager shareManager] addMessage:messageModel];
            [self pushCaseDetailControllerWithMessageModel:messageModel];
        }
    }
    
    //配置CocoaLumberjack
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    

    return YES;
}

- (void)setupBugly {
    // Get the default config
    BuglyConfig * config = [[BuglyConfig alloc] init];
    
    config.debugMode = YES;
 
    config.blockMonitorEnable = YES;
    
    config.blockMonitorTimeout = 1.5;
    
    config.channel = @"Bugly";
    
    config.delegate = self;
    
    config.consolelogEnable = NO;
    config.viewControllerTrackingEnable = NO;
    
    // NOTE:Required
    // Start the Bugly sdk with APP_ID and your config
    [Bugly startWithAppId:BUGLY_APP_ID
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    
    // Set the customizd tag thats config in your APP registerd on the  bugly.qq.com
    // [Bugly setTag:1799];
    
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
    
}

#pragma mark - BuglyDelegate
- (NSString *)attachmentForException:(NSException *)exception {
    NSString * exceptionStr = [NSString stringWithFormat:@"(%@:%d) %s %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__,exception];
    NSLog(@"%@",exceptionStr);
    
    return exceptionStr;
}

#pragma mark - <HUD>
- (void)setupSVProgressHUD{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setCornerRadius:4.0];
    [SVProgressHUD setRingNoTextRadius:21.5];
    [SVProgressHUD setRingThickness:3.5];
    [SVProgressHUD setRingRadius:16.5];
    [SVProgressHUD setSuccessImage:[UIImage imageNamed:@"HUD_gou"]];
    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"HUD_cha"]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@"HUD_xinxi"]];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:12.0]];
    [SVProgressHUD setBackgroundLayerColor:[UIColor clearColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    [SVProgressHUD dismiss];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    // 清除应用图标通知数小圆点
    application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 跳转到消息
 */
- (void)pushCaseDetailControllerWithMessageModel:(WTMessageModel *)messageModel {
    if ([WTAccountManager sharedManager].isLogined) {
        WTCaseDetailController *caseDetailVc = [[UIStoryboard storyboardWithName:@"WTCaseDetailController" bundle:nil] instantiateViewControllerWithIdentifier:@"caseDetailId"];
        messageModel.caseIDArrM = [messageModel.caseIDs componentsSeparatedByString:@","];
        caseDetailVc.caseId = messageModel.caseIDArrM.firstObject;
        caseDetailVc.visitRecordIds = messageModel.caseIDs;
        caseDetailVc.isPresented = YES;
        if (messageModel.type == WTMessageTypeTransferTo) {
            caseDetailVc.transferToName = messageModel.transferName;
        } else if (messageModel.type == WTMessageTypeBeTranfer) {
            caseDetailVc.beTransferName = messageModel.transferName;
        }
        caseDetailVc.messageModel = messageModel;
        WTNavigationController *navVc = [[WTNavigationController alloc] initWithRootViewController:caseDetailVc];
        [HYXRootViewController presentViewController:navVc animated:YES completion:nil];
    }
}

/*********************** 极光推送相关配置 ***********************/
//注册用户通知设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}
//注册APNs成功,并上报DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    // 注册deviceToken
    if (deviceToken.length) {
        [JPUSHService registerDeviceToken:deviceToken];
        HYXLog(@"极光推送---------注册成功！");
    }
}
//注册APNs失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    HYXLog(@"极光推送注册失败: %@",error);
}

#pragma mark - <JPUSHRegisterDelegate>
//前台收到通知 （iOS 10 及以上）
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary *userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
            WTMessageModel *messageModel = [[WTMessageModel alloc] initWithDict:userInfo];
            NSDate *currentDate = [NSDate date];
            messageModel.timeString = [self.formatter stringFromDate:currentDate];
            if (![messageModel.caseIDs isEmpty]) {
                messageModel.isUnread = YES;
                [[WTMessageManager shareManager] addMessage:messageModel];
                HYXNote_POST(kGetUnreadMessageNote, nil);
            }
        } else {
            // 本地通知
        }
    }
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    } // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}
// 后台收到通知 （iOS 10 及以上）
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    WTMessageModel *messageModel = [[WTMessageModel alloc] initWithDict:userInfo];
    NSDate *currentDate = [NSDate date];
    messageModel.timeString = [self.formatter stringFromDate:currentDate];
    if (![messageModel.caseIDs isEmpty]) {
        [[WTMessageManager shareManager] addMessage:messageModel];
        [self pushCaseDetailControllerWithMessageModel:messageModel];
//        HYXNote_POST(kGetUnreadMessageNote, nil);
    }
    
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        } else {
            // 本地通知
        }
    }
    completionHandler();  // 系统要求执行这个方法
}

// iOS 7-9 ----程序在后台或者被杀死状态下，收到通知，进入前台时，调用此方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    // 取得 APNs 标准信息内容
    WTMessageModel *messageModel = [[WTMessageModel alloc] initWithDict:userInfo];
    NSDate *currentDate = [NSDate date];
    messageModel.timeString = [self.formatter stringFromDate:currentDate];
    if (![messageModel.caseIDs isEmpty]) {
        [[WTMessageManager shareManager] addMessage:messageModel];
        [self pushCaseDetailControllerWithMessageModel:messageModel];
    }
}

// iOS 6 及以下 ----程序在前台运行时，收到通知会调用此方法；若方法application:didReceiveRemoteNotification:fetchCompletionHandler:也存在，则只会走application:didReceiveRemoteNotification:fetchCompletionHandler:方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // 取得 APNs 标准信息内容
    WTMessageModel *messageModel = [[WTMessageModel alloc] initWithDict:userInfo];
    NSDate *currentDate = [NSDate date];
    messageModel.timeString = [self.formatter stringFromDate:currentDate];
    if (![messageModel.caseIDs isEmpty]) {
        [[WTMessageManager shareManager] addMessage:messageModel];
        [self pushCaseDetailControllerWithMessageModel:messageModel];
    }
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

@end
