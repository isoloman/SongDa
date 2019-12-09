//
//  ModelDate.m
//  LovingHealth_doctor
//
//  Created by ibook on 15/4/28.
//  Copyright (c) 2015年 ForDeng. All rights reserved.
//

#import "ModelDate.h"

@implementation ModelDate

+ (NSComparisonResult)compareDateWith:(NSString *)start{
    
    NSDate * now = [NSDate new];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * startDate = [formatter dateFromString:start];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * dateString = [formatter stringFromDate:startDate];
    NSString * nowString = [formatter stringFromDate:now];
    NSDate * date = [formatter dateFromString:dateString];
    NSDate * nowdate = [formatter dateFromString:nowString];
    
    NSComparisonResult result = [date compare:nowdate];
    
    return  result;
}


+(NSDate *)getCurrentWeekFirstDay{
    NSDate *now = [NSDate new];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitDay
                                              fromDate:now];
    
    // 得到星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    NSInteger weekday = [component weekday];
//    NSInteger day = [component day];
    
    if (weekday == 1) {
        return now;
    }else{
        NSInteger firstWeekday = weekday -1;//第一天距离现在天数
        
        NSDate *firstDay = [NSDate dateWithTimeInterval:-firstWeekday*3600*24 sinceDate:now];
        return firstDay;
    }
    
}
//
+(NSDate *)addDays:(NSInteger)day withDate:(NSDate *)date
{
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = day;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    return [theCalendar dateByAddingComponents:dayComponent toDate:date options:0];
}

// /获取时间组成成分如@[@"yyyy",@"dd",@"HH"]/
+(NSArray *)getDateComponenFormatterArray:(NSArray *)formatterArr date:(NSDate *)date {
    NSMutableArray *resultArr = [NSMutableArray new];
    NSDateFormatter *formatter = [NSDateFormatter new];
    
    for (int i = 0; i < formatterArr.count; i ++) {
        [formatter setDateFormat:formatterArr[i]];
        NSString *str = [formatter stringFromDate:date];
        [resultArr addObject:str];
    }
    return resultArr;
}

// /获取小时/
+(NSString *)getDateComponentHour:(NSDate *)date {
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"HH"];
    NSString *str = [formatter stringFromDate:date];
    return str;
}

+(NSString *)getCurrentDateWithFormatterMMDD:(NSDate *)date{
    NSDateFormatter *fotmatter = [NSDateFormatter new];
    [fotmatter setDateFormat:@"MM-dd"];
    NSString *dateStr = [fotmatter stringFromDate:date];
    return dateStr;

}

//获取格式为2014-08-23时间
+(NSString *)getCurrentDateWithFormatterYYYYMMDD:(NSDate *)date{
    NSDateFormatter *fotmatter = [NSDateFormatter new];
    [fotmatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [fotmatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)getCurrentDateWithFormatterYYYYMMDDHHMM:(NSDate *)date{
    NSDateFormatter *fotmatter = [NSDateFormatter new];
    [fotmatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [fotmatter stringFromDate:date];
    return dateStr;
}

//获取格式为2014年08月23时间
+(NSString *)getCurrentDateWithFormatterYYYYMMDDChinese:(NSDate *)date{
    NSDateFormatter *fotmatter = [NSDateFormatter new];
    [fotmatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateStr = [fotmatter stringFromDate:date];
    return dateStr;
}


//对比日期
+(NSInteger)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}

+(NSString *)getDateWithOriginalForamtter:(NSString *)dateForamtter toForamtter:(NSString *)toForamtter withDateString:(NSString *)dateString{
    return [self getDateWithOriginalForamtter:dateForamtter toForamtter:toForamtter withDateString:dateString local:NO];

}

+(NSString *)getDateWithOriginalForamtter:(NSString *)dateForamtter toForamtter:(NSString *)toForamtter withDateString:(NSString *)dateString local:(BOOL)local{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:dateForamtter];
    NSDate *date = [formatter dateFromString:dateString];
    
    NSString * todate;
    [formatter setDateFormat:toForamtter];
    if (local) {
         NSDate * newDate = [self getNowDateFromatAnDate:date];
        todate = [formatter stringFromDate:newDate];
    }
    else{
        todate = [formatter stringFromDate:date];
    }
    
    return [NSString stringWithFormat:@"%@",todate];
    
}

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate {
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}



+(NSDateComponents*)getDateComponentsOfDate:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //  通过已定义的日历对象，获取某个时间点的NSDateComponents表示，并设置需要表示哪些信息（NSYearCalendarUnit, NSCalendarUnitMonth, NSCalendarUnitDay等）
    NSDateComponents *dateComponents = [greCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear|NSCalendarUnitQuarter
                                                      fromDate:date];
//    NSLog(@"year(年份): %li", (long)dateComponents.year);
//    NSLog(@"quarter(季度):%ld", (long)dateComponents.quarter);
//    NSLog(@"month(月份):%ld", (long)dateComponents.month);
//    NSLog(@"day(日期):%li", (long)dateComponents.day);
//    NSLog(@"hour(小时):%li", (long)dateComponents.hour);
//    NSLog(@"minute(分钟):%li", (long)dateComponents.minute);
//    NSLog(@"second(秒):%li", (long)dateComponents.second);
//    //  Sunday:1, Monday:2, Tuesday:3, Wednesday:4, Friday:5, Saturday:6
//    NSLog(@"weekday(星期):%li", (long)dateComponents.weekday);
//    //  苹果官方不推荐使用week
//    NSLog(@"weekOfYear(该年第几周):%li", (long)dateComponents.weekOfYear);
//    NSLog(@"weekOfMonth(该月第几周):%li", (long)dateComponents.weekOfMonth);
    return dateComponents;
}


+(NSDate *)getDateWithFormatter:(NSString *)formatterStr andDateStr:(NSString *)dateStr{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formatterStr];
    NSDate * date = [formatter dateFromString:dateStr];
    
    return date;
}


+(NSDate *)getFirstDayOfMonth:(NSInteger)month andYear:(NSInteger)year{
    
    NSString * dateStr = [NSString stringWithFormat:@"%ld-%ld-01",(long)year,(long)month];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [formatter dateFromString:dateStr];
    
    return date;
}


+(NSDate *)getPreviousMonthFirstDay:(NSDate *)date{
    NSInteger year = [self getYear:date];
    NSInteger month = [self getMonth:date];
    if (month == 1) {
        month = 12;
        year -= 1;
    }else{
        month -= 1;
    }
    
    return [self getFirstDayOfMonth:month andYear:year];
}


+(NSDate *)getNextMonthFirstDay:(NSDate *)date{
    NSInteger year = [self getYear:date];
    NSInteger month = [self getMonth:date];
    if (month == 12) {
        month = 1;
        year += 1;
    }else{
        month += 1;
    }
    
    return [self getFirstDayOfMonth:month andYear:year];

}


+(NSInteger)getYear:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    return dateComponent.year;
}


+(NSInteger)getMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    return dateComponent.month;
}


+(NSInteger)getDay:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    return dateComponent.day;
}


+(NSInteger)getHour:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    return dateComponent.hour;
}


+(NSInteger)getMinute:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    return dateComponent.minute;
}


+(NSInteger)getSecond:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    return dateComponent.second;
}


+(NSString *)getCurrentDateWithFormatter:(NSString *)formatter andDate:(NSDate *)date{
    NSDateFormatter *fotmatter = [NSDateFormatter new];
    [fotmatter setDateFormat:formatter];
    NSString *dateStr = [fotmatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)getCurrentDate{
    
    NSDate * now = [NSDate new];
    NSDateFormatter * formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * nowTime = [formater stringFromDate:now];
    return nowTime;
}

+ (NSInteger)getDifferenceByDate:(NSDate *)date {
    
    //获得当前时间
    NSDate *now = [NSDate date];
    //实例化一个NSDateFormatter对象
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //设定时间格式
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *oldDate = date;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:oldDate  toDate:now  options:0];
    if ([comps day] != 0) {
        return [comps day];
    }
    else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式
        [dateFormatter setDateFormat:@"MM-dd"];
        NSString * oldStr = [dateFormatter stringFromDate:oldDate];
        NSString * nowStr = [dateFormatter stringFromDate:now];
        if ([oldStr isEqualToString:nowStr]) {
            return [comps day];
        }
        else{
            return 1;
        }
    }
    
}

@end
