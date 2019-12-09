//
//  YCCommonTool.m
//  test
//
//  Created by ibook on 15/7/5.
//  Copyright (c) 2015年 kay. All rights reserved.
//

#import "YCCommonTool.h"
#import <ImageIO/ImageIO.h>     // 图像的输入输出文件
#import <MobileCoreServices/MobileCoreServices.h>
#import <YYKit/YYKit.h>
#import <UIKit/UIKit.h>

#define Main_Screen_Width [UIScreen mainScreen].bounds.size.width

@implementation YCCommonTool


//手机号码验证
//+ (BOOL) validateMobile:(NSString *)mobile defaultRegion:(NSString *)defaultRegion
//{
//    mobile = [self deleteBlankSpace:mobile];
//    defaultRegion = [defaultRegion hasPrefix:@"+"]?[defaultRegion substringFromIndex:1]:defaultRegion;
//    NBPhoneNumberUtil *phoneUtil = [[NBPhoneNumberUtil alloc] init];
//    NSError *anError = nil;
//    NBPhoneNumber *myNumber = [phoneUtil parse:mobile
//                                 defaultRegion:defaultRegion error:&anError];
//    
//    if (anError||![phoneUtil isValidNumber:myNumber]) {
//        return NO;
//    }
//    
//    return YES;
//    
//}

//网址
+(BOOL) validateHttpUrl:(NSString *)httpUrl{
    NSString *httpUrlRegex = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *httpUrlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", httpUrlRegex];
    return [httpUrlTest evaluateWithObject:httpUrl];
}

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//+ (BOOL) isPureNumberMaxTwoFloat:(NSString *)number{
//    NSString *Regex = @"^\\d+(\\.\\d{2})?$";
//    NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
//    return [numberPredicate evaluateWithObject:number];
//}

//纯数字
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
+(BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

+(BOOL)isPureNumber:(NSString *)string{
    if (![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    return [[self class]isPureInt:string]||[[self class]isPureFloat:string];
}

+(BOOL)isBlankString:(NSString *)string{
//    NSLog(@"%@",string);
    if (string == nil || string == NULL) {
        return YES;
    }
    
    if ([[string class] isSubclassOfClass:[NSNull class]]) {
        return YES;
    }
    
    
    if ([[string class] isSubclassOfClass:[NSString class]])
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            if ([string containsString:@"null"]||[string containsString:@"nil"]) {
                return YES;
            }
        }
        else
        {
            if ([string rangeOfString:@"null"].location != NSNotFound || [string rangeOfString:@"nil"].location != NSNotFound)
            {
                
                return YES;
            }
        }
        
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
            return YES;
        }

    }
    
    return NO;
}

//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}

//身份证号码
+ (BOOL)validateIDCardNumber:(NSString *)value {
    NSMutableArray *IDArray = [NSMutableArray array];
    
    // 遍历身份证字符串,存入数组中
    
    for (int i = 0; i < 18; i++) {
        
        NSRange range = NSMakeRange(i, 1);
        
        NSString *subString = [value substringWithRange:range];
        
        [IDArray addObject:subString];
        
    }
    
    // 系数数组
    
    NSArray *coefficientArray = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3",@"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
    
    // 余数数组
    
    NSArray *remainderArray = [NSArray arrayWithObjects:@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3",@"2", nil];
    
    // 每一位身份证号码和对应系数相乘之后相加所得的和
    
    int sum = 0;
    
    for (int i = 0; i < 17; i++) {
        
        int coefficient = [coefficientArray[i] intValue];
        
        int ID = [IDArray[i] intValue];
        
        sum += coefficient * ID;
        
    }
    
    // 这个和除以11的余数对应的数
    
    NSString *str = remainderArray[(sum % 11)];
    
    // 身份证号码最后一位
    
    NSString *string = [value substringFromIndex:17];
    
    // 如果这个数字和身份证最后一位相同,则符合国家标准,返回YES
    
    if ([str isEqualToString:string]) {
        
        return YES;
        
    } else {
        
        return NO;
        
    }
}

+(BOOL)isNullArray:(NSArray *)array{
    BOOL isNull;
    if (array != nil && ![array isKindOfClass:[NSNull class]] && array.count != 0){
        isNull = NO;
    }else{
        isNull = YES;
    }
    return isNull;
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIViewController * nextResponder = window.rootViewController;
    
    result = [self getCurrentViewController:nextResponder];
    
    if ([result isEqual: window.rootViewController]) {
        if (result.presentedViewController) {
            result = result.presentedViewController;
        }
        else{
            if (result.childViewControllers) {
                nextResponder = result.childViewControllers[0];
                result = [self getCurrentViewController:nextResponder];
            }
        }
    }
    
    if (![result isMemberOfClass:[UIViewController class]]) {
        result = [self getCurrentViewController:result];
    }
    
    return result;
}

+(UIViewController *)getCurrentViewController:(id)nextResponder{
    
     UIViewController *result = nil;
    
    if ([nextResponder isKindOfClass:[UITabBarController class]])
    {
        UITabBarController * nextVc = (UITabBarController *)nextResponder;
        nextResponder = nextVc.viewControllers[nextVc.selectedIndex];
        
        result =  [self getCurrentViewController:nextResponder];
        
    }
    else if([nextResponder isKindOfClass:[UINavigationController class]])
    {
        UINavigationController * Navi = (UINavigationController *)nextResponder;
        result = Navi.topViewController;
        if (result) result = [self getCurrentViewController:result];

    }
    else if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }
    
    return result == nil?nextResponder:result;

}

//通过下载按钮获取按钮所在indexPath
+ (NSIndexPath *)indexPathForSender:(id)sender event:(UIEvent *)event withTableview:(UIView *)view{
    
    UIButton *button = (UIButton*)sender;
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if (![button pointInside:[touch locationInView:button] withEvent:event])
    {
        return nil;
    }
    
    CGPoint touchPosition = [touch locationInView:view];
    
    if ([view isKindOfClass:[UITableView class]]) {
         return [(UITableView *)view indexPathForRowAtPoint:touchPosition];
    }else if([view isKindOfClass:[UICollectionView class]]){
        return [(UICollectionView *)view indexPathForItemAtPoint:touchPosition];
    }
    else
        return nil;

}

+ (NSMutableArray *)getFirstChar:(NSArray *)originArr{
    
    NSMutableArray * sectionTitle = [[NSMutableArray alloc]init];
    for (int i = 0; i< originArr.count; i++) {
        NSString *firstPlace = [originArr objectAtIndex:i];
        
        NSString *firstChar = [NSString stringWithFormat:@"%c",pinyinFirstLetter([firstPlace characterAtIndex:0])-32];
        
        if (![sectionTitle containsObject:firstChar]) {
            [sectionTitle addObject:firstChar];
        }
        
    }
    
    return sectionTitle;
}

//汉子转拼音
+ (NSString *)transformToPinyin:(NSString *)string {
    NSMutableString *mutableString = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return mutableString;
}

+ (void)copyToPasteboard:(NSString *)string{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = string;
}

+ (void)updateTableView:(UITableView *)tableView
        indexPathForRow:(NSArray *)row
              inSection:(NSArray *)section{
    
    NSMutableArray * indexPathArr = [NSMutableArray new];
    
    for (int i = 0; i < row.count; i++) {
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[row[i] integerValue] inSection:[section[i] integerValue]];
        [indexPathArr addObject:indexPath];
    }
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
}

+ (void)updateTableViewRow:(UITableView *)tableView
           indexPathForRow:(NSInteger)row
                 inSection:(NSInteger)section{
    
    [tableView beginUpdates];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
}

- (void)createMapViewSnapshotForLocation:(CLLocation *)location
                     withCompletionHandler:(MapSnapshotCompletionBlock)completion
                   
{
    NSParameterAssert(location != nil);
    
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    
    options.region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500.0, 500.0);
    
    options.size = CGSizeMake(Main_Screen_Width-40, 120);
    options.scale = [UIScreen mainScreen].scale;
    
    __block MKMapSnapshotter *snapShotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    
    [snapShotter startWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
              completionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
                  if (error) {
                      NSLog(@"%s Error creating map snapshot: %@", __PRETTY_FUNCTION__, error);
                      return;
                  }
                  
                  MKAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:nil];
                  CGPoint coordinatePoint = [snapshot pointForCoordinate:location.coordinate];
                  UIImage *image = snapshot.image;
                  
                  UIGraphicsBeginImageContextWithOptions(image.size, YES, image.scale);
                  {
                      [image drawAtPoint:CGPointZero];
                      [pin.image drawAtPoint:coordinatePoint];
                       self.MapSnapshot = UIGraphicsGetImageFromCurrentImageContext();
                  }
                  UIGraphicsEndImageContext();
                  
                  if (completion) {
                      dispatch_async(dispatch_get_main_queue(), completion);
            
                  }
                  
              }];
    
    
}

+(NSString *)replaceVedioUrlString:(NSString *)originalStr withUrlString:(NSString *)replaceStr{
    
    NSMutableAttributedString * originalString = [[NSMutableAttributedString alloc]initWithString:originalStr];
    
    NSError *error;
    NSString *regulaStr = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                    options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:originalStr options:0 range:NSMakeRange(0, [originalStr length])];
    
    NSArray * arr = [NSArray arrayWithObjects:@"BMP",@"JPG",@"JPEG",@"PNG",@"GIF",@"bmp",@"jpg",@"jepg",@"png",@"gif", nil];
    
    __block BOOL needContinue = NO;
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSString* substringForMatch = [originalStr substringWithRange:match.range];
        
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([substringForMatch hasSuffix:obj]) {
                needContinue = YES;
                *stop = YES;
            }
        }];
        
        if (needContinue == YES) {
            needContinue = NO;
            continue;
        }
        
        [originalString deleteCharactersInRange:match.range];
        [originalString insertAttributedString:[[NSMutableAttributedString alloc]initWithString:replaceStr] atIndex:match.range.location];
//     　 NSLog(@"substringForMatch=%@",originalString);
        
    }
    return [originalString string];
}

-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<iframe" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@"</iframe>" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

+(void)playSystemSoundWithPath:(NSString *)pathResource andType:(NSString *)type{
    NSString *path = [[NSBundle mainBundle] pathForResource:pathResource ofType:type];
    //组装并播放音效
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
    //声音停止
//    AudioServicesDisposeSystemSoundID(soundID);

}

+(dispatch_time_t)getDispatchTimeByDate:(NSDate *)date{
    NSInteger interval = date.timeIntervalSince1970;
    double second = 0.0;
    NSInteger subsecond = modf(interval, &second);
    struct timespec time = {second,subsecond * (double)(NSEC_PER_SEC)};
    return dispatch_walltime(&time, 0);
}


+ (NSString *)deleteBlankSpace:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
   
    //过滤中间空格
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string;
}

+ (NSString *)insertPhoneNumBlankSpace:(NSString *)string{
    string = [self deleteBlankSpace:string];
    if (string.length > 3) {
        
        NSString * subStr1 = [string substringToIndex:3];
        NSString * subStr2 = [string substringFromIndex:3];
        
        subStr1 = [subStr1 stringByAppendingString:@" "];
        
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        NSString *newString = @"";
        while (subStr2.length > 0) {
            NSString *subString = [subStr2 substringToIndex:MIN(subStr2.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            subStr2 = [subStr2 substringFromIndex:MIN(subStr2.length, 4)];
        }
        
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        
        string = [subStr1 stringByAppendingString:newString];
        
        return string;
    }
    return string;
}

+ (NSString *)getFileSize:(CGFloat)size{
    
    NSString *sizeText = nil;
    if (size >= pow(10, 9)) { // size >= 1GB
        sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
    } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
        sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
    } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
        sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
    } else { // 1KB > size
        sizeText = [NSString stringWithFormat:@"%fB", size];
    }
    return sizeText;
    
}

//得到中英文混合字符串长度 方法2
+ (NSInteger)getToInt:(NSString*)strtemp
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [strtemp dataUsingEncoding:enc];
    return [da length];
}

+ (NSString *)arrayToJsonString:(NSArray *)array{
    NSString * arrayString = @"[";
    for (int i = 0;i < array.count;i++) {
        NSDictionary * dic = array[i];
        NSString * string = @"{";
        for (NSString * key in dic.allKeys) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"'%@':'%@',",key,dic[key]]];
        }
        string = [string substringToIndex:string.length-1];
        string = [string stringByAppendingString:@"}"];
        arrayString = [arrayString stringByAppendingString:string];
        if (i != array.count-1) {
            arrayString = [arrayString stringByAppendingString:@","];
        }
        
    }
    arrayString = [arrayString stringByAppendingString:@"]"];
    
    return arrayString;
}

+ (BOOL)isFileExist:(NSString *)filePath{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL blHave=[fileManager fileExistsAtPath:filePath];
    return blHave;
}

+(BOOL) runningInBackground
{
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    BOOL result = (state == UIApplicationStateBackground);
    
    return result;
}

+(BOOL) runningInForeground
{
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    BOOL result = (state == UIApplicationStateActive);
    
    return result;
}


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (BOOL)isComplexPassword:(NSString *)password{
    BOOL up = false , low = false , num = false;
    NSInteger alength = [password length];
    for (int i = 0; i<alength; i++) {
        char commitChar = [password characterAtIndex:i];
    
        if((commitChar>64)&&(commitChar<91)){
            up = YES;
            NSLog(@"字符串中含有大写英文字母");
        }else if((commitChar>96)&&(commitChar<123)){
            low = YES;
            NSLog(@"字符串中含有小写英文字母");
        }else if((commitChar>47)&&(commitChar<58)){
            num = YES;
            NSLog(@"字符串中含有数字");
        }
    }
    if (up&&low&&num) {
        return YES;
    }
    return NO;
}

//+ (NSString *)hiddenPhoneNum:(NSString *)num defaultRegion:(NSString*)defaultRegion{
//    if ([self validateMobile:num defaultRegion:defaultRegion]) {
//
//        return [num stringByReplacingCharactersInRange:NSMakeRange(3, num.length<=7?num.length-3:4) withString:@"****"];
//    }
//
//
//    return num;
//}

+ (NSString *)hiddenPhoneString:(NSString *)string inRange:(NSRange)range{
    if (range.location+range.length>string.length) {
        
        range = NSMakeRange(range.location, string.length-range.location);
    }
    return [string stringByReplacingCharactersInRange:range withString:@"****"];
    
}

@end
