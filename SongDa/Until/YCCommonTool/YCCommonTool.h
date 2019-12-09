//
//  YCCommonTool.h
//  test
//
//  Created by ibook on 15/7/5.
//  Copyright (c) 2015年 kay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "pinyin.h"
#import "sys/utsname.h"
#import <CoreLocation/CoreLocation.h>
#import <CommonCrypto/CommonDigest.h>
#import <MapKit/MapKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
//播放通知声音
#import <AudioToolbox/AudioToolbox.h>

typedef void (^MapSnapshotCompletionBlock)(void);
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

@interface YCCommonTool : NSObject

@property (nonatomic, strong) UIImage * MapSnapshot;

/*!
 @brief  检验字符串是否为空
 @param  string 要检验的电话号码
 @return 返回结果，符合为YES
 */
+(BOOL)isBlankString:(NSString *)string;

/*!
 @brief  检验密码是否包含大小写字母和数组
 @param  password 要检验的密码
 @return 返回结果，符合为YES
 */
+ (BOOL)isComplexPassword:(NSString *)password;

/*!
 @brief  检验电话号码是否合格
 @param  mobile 要检验的电话号码
 @return 返回结果，符合为YES
 */
//+ (BOOL) validateMobile:(NSString *)mobile defaultRegion:(NSString *)defaultRegion;

/*!
 @brief  检验网址是否合格
 @param  httpUrl 要检验的网址
 @return 返回结果，符合为YES
 */
+ (BOOL) validateHttpUrl:(NSString *)httpUrl;

/*!
 @brief  检验邮箱是否合格
 @param  email 要检验的邮箱号码
 @return 返回结果，符合为YES
 */
+ (BOOL) validateEmail:(NSString *)email;

/*!
 @brief  检验字符串是否为纯数字(不包含小数点)
 @param  string 要检验的字符串
 @return 返回结果，符合为YES
 */
+ (BOOL)isPureInt:(NSString*)string;

/*!
 @brief  检验字符串是否为纯数字(包含小数点)
 @param  string 要检验的字符串
 @return 返回结果，符合为YES
 */
+ (BOOL)isPureNumber:(NSString *)string;

/*!
 @brief  检验字符串是否为浮点型
 @param  string 要检验的字符串
 @return 返回结果，符合为YES
 */
+ (BOOL)isPureFloat:(NSString*)string;

/*!
 @brief  检验车牌号是否有效
 @param  carNo 要检验的字符串
 @return 返回结果，符合为YES
 */
+ (BOOL) validateCarNo:(NSString *)carNo;

/*!
 @brief 判断是否为空数组
 */
+ (BOOL)isNullArray:(NSArray *)array;

/*!
 @brief 获取当前屏幕显示的相应的视图控制器
 
 */
+ (UIViewController *)getCurrentVC;

/*!
 @brief 通过按钮的点击事件来获取按钮所在View（仅限tableview和collectionView）的indexPath
 @param view 要获取的View（仅限tableview和collectionView）
 
 */
+ (NSIndexPath *)indexPathForSender:(id)sender event:(UIEvent *)event withTableview:(UIView *)view;

/*!
 @brief 获取汉字首字母
 @param originArr 传入的原数组
 @ref 返回首字母数组
 */
+ (NSMutableArray *)getFirstChar:(NSArray *)originArr;


/*!
 @brief 将汉字数组转化成拼音
 @param string 传入的原汉子字符串
 @ref 返回拼音字符串
 */
+ (NSString *)transformToPinyin:(NSString *)string;

/*!
 @brief 将字符串复制到黏贴板
 @param string 将要复制的字符串

 */
+ (void)copyToPasteboard:(NSString *)string;

/*!
 @brief 刷新tableview特定某些行数
 @param tableView 将要刷新的tableview
 @param row 将要刷新的特定行,与section数组一一对应
 @param section 将要刷新的分组,与row数组一一对应
 */
+ (void)updateTableView:(UITableView *)tableView
        indexPathForRow:(NSArray *)row
              inSection:(NSArray *)section;

/*!
 @brief 刷新tableview特定行
 @param tableView 将要刷新的tableview
 @param row 将要刷新的特定行,与section数组一一对应
 @param section 将要刷新的分组,与row数组一一对应
 */
+ (void)updateTableViewRow:(UITableView *)tableView
           indexPathForRow:(NSInteger)row
                 inSection:(NSInteger)section;
/*!
 @brief 通过当前定位位置获取地图截图
 @param location 当前位置
 */
- (void)createMapViewSnapshotForLocation:(CLLocation *)location
                     withCompletionHandler:(MapSnapshotCompletionBlock)completion;

/*!
 @brief 遍历出字符串中的网址，并将非图片链接替换掉
 @param originalStr 原始字符串
 @param replaceStr 用来替换的字符串
 @ref 返回替换完成后的字符串
 */
+(NSString *)replaceVedioUrlString:(NSString *)originalStr withUrlString:(NSString *)replaceStr;

/*!
 @brief 播放通知声音
 @param pathResource 文件名
 @param type 文件类型
 */
+(void)playSystemSoundWithPath:(NSString *)pathResource andType:(NSString *)type;


/*!
 @brief 把NSDate转成dispatch_time_t
 */
+ (dispatch_time_t)getDispatchTimeByDate:(NSDate *)date;


//+ (NSString *)scanIframeFromHtmlString:(NSString *)htmlString;


/*!
 @brief 删除空格
 @param string 输入字符串
 */
+ (NSString *)deleteBlankSpace:(NSString *)string;

+ (NSString *)insertPhoneNumBlankSpace:(NSString *)string;

/**
 计算文件大小

 @param size 文件size
 @return 返回计算结果
 */
+ (NSString *)getFileSize:(CGFloat)size;

/**
 数组转化为JSon字符串
 */
+ (NSString *)arrayToJsonString:(NSArray *)array;

/**
 Json字符串转换为字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 判断文件是否存在
 */
+ (BOOL)isFileExist:(NSString *)filePath;

+ (BOOL) runningInBackground;

+ (BOOL) runningInForeground;


+ (NSString *)hiddenPhoneNum:(NSString *)num defaultRegion:(NSString*)defaultRegion;

+ (NSString *)hiddenPhoneString:(NSString *)string inRange:(NSRange)range;


@end
