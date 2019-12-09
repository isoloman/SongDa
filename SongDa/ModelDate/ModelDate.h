//
//  ModelDate.h
//  LovingHealth_doctor
//
//  Created by ibook on 15/4/28.
//  Copyright (c) 2015年 ForDeng. All rights reserved.
//

// 星期几对应的数字
//Weekday units are the numbers 1 through n, where n is the number of days in the week. For example, in the Gregorian calendar, n is 7 and Sunday is represented by 1.
// 2(星期一) 3(星期二) 4(星期三) 5(星期四) 6(星期五) 7(星期六) 1(星期天)

#import <Foundation/Foundation.h>

@interface ModelDate : NSObject

/*!
 @brief 传入字符串日期，与当前日期比较大小
 @param start 传入的原汉子字符串
 @ref 返回对比结果（NSComparisonResult）
 */
+ (NSComparisonResult)compareDateWith:(NSString *)start;


/*!
 @brief 获取当前周的第一天（即上一周星期日）
 @return 获取的日期
 */
+(NSDate *)getCurrentWeekFirstDay;

/*!
 @brief 获取起始日期date相差day天的日期
 @param date 输入的起始日期
 @param day 要获取的日期与起始日期相差天数
 @return 获取的日期
 */
+(NSDate *)addDays:(NSInteger)day withDate:(NSDate *)date;

/*!
 @brief 截取输入日期的组成部分（年，月，日，时，分，秒），并以数组形式返回
 @param formatterArr 将要截取的时间格式数组 ,如@[@"HH",@"dd"]
 @param date 将要截取的日期
 @return 返回截取的时间数组
 */
+(NSArray *)getDateComponenFormatterArray:(NSArray *)formatterArr date:(NSDate *)date ;

/*!
 @brief 将当前输入时间格式转化为MM-dd(确保日期包含有MM-dd)
 @param date 将要转换格式的时间
 */
+(NSString *)getCurrentDateWithFormatterMMDD:(NSDate *)date;

/*!
 @brief 将当前输入时间格式转化为yyyy-MM-dd(确保日期包含有yyyy-MM-dd)
 @param date 将要转换格式的时间
 */
+(NSString *)getCurrentDateWithFormatterYYYYMMDD:(NSDate *)date;

/*!
 @brief 将当前输入时间格式转化为yyyy-MM-dd(确保日期包含有yyyy-MM-dd)
 @param date 将要转换格式的时间
 */
+(NSString *)getCurrentDateWithFormatterYYYYMMDDHHMM:(NSDate *)date;

/*!
 @brief 将当前输入时间格式转化为yyyy-MM-dd(确保日期包含有yyyy-MM-dd)
 @param date 将要转换格式的时间
 */
+(NSString *)getCurrentDateWithFormatterYYYYMMDDChinese:(NSDate *)date;

/*!
 @brief 将输入的日期oneday 和anotherDay进行比较，如果oneday较早返回-1,相同返回0，较晚返回1(对比格式为dd-MM-yyyy)
 @param oneDay 被比较的日期
 @param anotherDay 要比较的日期
 */
+(NSInteger)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

/*!
 @brief 截取输入时间的小时（HH）并返回字符串
 @param date 将要截取的日期
 */
+(NSString *)getDateComponentHour:(NSDate *)date;

/*!
 @brief 输入时间字符串（dateForamtter格式）转换成目标格式（toForamtter）的时间字符串并输出                  示例：NSString *str = [ModelDate getDateWithOriginalForamtter:@"yyyy-MM-dd HH:mm:ss.0" toForamtter:@"yyyy-MM-dd" withDateString:@"2014-10-07 06:55:36.0"];
 @param dateString 将要转换的时间字符串
 @param dateForamtter 输入时间的格式
 @param toForamtter 将要转成的时间格式
 */
+(NSString *)getDateWithOriginalForamtter:(NSString *)dateForamtter toForamtter:(NSString *)toForamtter withDateString:(NSString *)dateString;

/*!
 @brief 输入时间字符串（dateForamtter格式）转换成目标格式（toForamtter）的时间字符串并输出                  示例：NSString *str = [ModelDate getDateWithOriginalForamtter:@"yyyy-MM-dd HH:mm:ss.0" toForamtter:@"yyyy-MM-dd" withDateString:@"2014-10-07 06:55:36.0"];
 @param dateString 将要转换的时间字符串
 @param dateForamtter 输入时间的格式
 @param toForamtter 将要转成的时间格式
 @param local 是否需要转化为本地时间的操作
 */
+(NSString *)getDateWithOriginalForamtter:(NSString *)dateForamtter toForamtter:(NSString *)toForamtter withDateString:(NSString *)dateString local:(BOOL)local;

/*!
 @brief 用于获取输入日期的NSDateComponents（包含有year,month,day,hour,minute,second,weekday,weekOfYear(该年第几周),weekOfMonth(该月第几周)
 @param date 输入的日期NSDateComponents
 @return 返回获取的
 */
+(NSDateComponents*)getDateComponentsOfDate:(NSDate *)date;

/*
 @brief 通过输入日期字符串和其对应的格式转化为date
 */
+(NSDate *)getDateWithFormatter:(NSString *)formatterStr andDateStr:(NSString *)dateStr;


/*
 *返回输入月份和年份第一天的date
 */
+(NSDate *)getFirstDayOfMonth:(NSInteger)month andYear:(NSInteger)year;

/*
 *获取指定日期对应上一个月的初始日期
 */
+(NSDate *)getPreviousMonthFirstDay:(NSDate *)date;

/*
 *获取指定日期对应下一个月的初始日期
 */
+(NSDate *)getNextMonthFirstDay:(NSDate *)date;

/**
 * 年 月 日 时 分 秒
 */
+(NSInteger)getYear:(NSDate *)date;
+(NSInteger)getMonth:(NSDate *)date;
+(NSInteger)getDay:(NSDate *)date;
+(NSInteger)getHour:(NSDate *)date;
+(NSInteger)getMinute:(NSDate *)date;
+(NSInteger)getSecond:(NSDate *)date;

/*!
 *@brief 对输入的时间进行给定格式的转换，并返回相应字符串
 *@param formatter 将要转换的格式
 *@param date 将要转换格式的时间
 */
+(NSString *)getCurrentDateWithFormatter:(NSString *)formatter andDate:(NSDate *)date;


+ (NSString *)getCurrentDate;

+ (NSInteger)getDifferenceByDate:(NSDate *)date;
@end
