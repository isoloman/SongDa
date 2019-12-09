//
//  HYXDefine.h
//  BiaoQing
//
//  Created by Fancy on 2017/7/6.
//  Copyright © 2017年 Fancy. All rights reserved.
//

#ifdef __OBJC__

#define HYXKeyWindow                [[UIApplication sharedApplication] keyWindow]
#define HYXRootViewController       HYXKeyWindow.rootViewController
#define HYXScreenBounds             [UIScreen mainScreen].bounds
#define HYXScreenW                  HYXScreenBounds.size.width
#define HYXScreenH                  HYXScreenBounds.size.height
#define isIPad                      [[UIDevice currentDevice] isPad]

//-----------适配iPhone X-----------
//是否是手机
#define isIPhone    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//是否是iPhoneX
#define isIPhoneX   (HYXScreenW >= 375.0f && HYXScreenH >= 812.0f && isIPhone)
//iPhoneX宽高
#define IPhoneX_ScreenW                 375
#define IPhoneX_ScreenH                 812
//底部安全高度
#define IPhoneX_Bottom_Safe_Height      (isIPhoneX ? 34 : 0)
//系统手势高度
#define IPhoneX_System_Gesture_Height   (isIPhoneX ? 13 : 0)
//tabbar高度
#define IPhoneX_TabBar_Height           (49 + IPhoneX_Bottom_Safe_Height)
//状态栏高度
#define IPhoneX_Status_Height           (isIPhoneX ? 44 : 20)
//状态栏高度
#define IPhoneX_Status_Height_NoStatus  (isIPhoneX ? 44 : 0)
//导航栏高度
#define IPhoneX_Nav_Height              (isIPhoneX ? 88 : 64)
//---------------------------------

//颜色
#define HYXColor(r, g, b)               [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define HYXRGBAColor(r, g, b, a)        [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define HYXRandomColor                  [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

//字体
#define HYXFontL(s)                     [UIFont systemFontOfSize:s weight:UIFontWeightLight]
#define HYXFontR(s)                     [UIFont systemFontOfSize:s weight:UIFontWeightRegular]
#define HYXFontB(s)                     [UIFont systemFontOfSize:s weight:UIFontWeightBold]
#define HYXFontT(s)                     [UIFont systemFontOfSize:s weight:UIFontWeightThin]
#define HYXFont(s)                      HYXFontR(s)

//通知
#define HYXNoteCenter                   [NSNotificationCenter defaultCenter]
#define HYXNote_ADD(n, f)               [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(f) name:n object:nil]
#define HYXNote_POST(n, o)              [[NSNotificationCenter defaultCenter] postNotificationName:n object:o]
#define HYXNote_REMOVE()                [[NSNotificationCenter defaultCenter] removeObserver:self]

#define HYXImage(imageName)             [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

//强弱引用
#define HYXWeakSelf(type)               __weak typeof(type) weak##type = type // weak
#define HYXStrongSelf(type)             __strong typeof(type) type = weak##type // strong

//获取temp
#define HYXPathTemp                     NSTemporaryDirectory()
//获取沙盒 Document
#define HYXPathDocument                 [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define HYXPathCache                    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#ifdef DEBUG
#define HYXLog(...) NSLog(__VA_ARGS__)
#else
#define HYXLog(...)
#endif

#define HYXLogFunc NSLog(@"%s", __func__)

#endif
