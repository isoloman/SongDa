//
//  UISearchBar+HYXAdd.m
//  BiaoQing
//
//  Created by Fancy on 2016/10/12.
//  Copyright © 2016年 hyx.com. All rights reserved.
//

#import "UISearchBar+HYXAdd.h"

#define IS_IOS9 [UIDevice currentDevice].systemVersion.floatValue >= 9.0f

@implementation UISearchBar (HYXAdd)

- (void)hyx_setTextFont:(UIFont *)font
{
    if (@available(iOS 9.0, *)) {
        [UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].font = font;
    }else {
        [UITextField appearanceWhenContainedIn:[UISearchBar class], nil].font = font;
    }
}

- (void)hyx_setTextColor:(UIColor *)textColor
{
    if (@available(iOS 9.0, *)) {
        [UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].textColor = textColor;
    }else {
        [UITextField appearanceWhenContainedIn:[UISearchBar class], nil].textColor = textColor;
    }
}

//- (void)hyx_setPlaceholderTextColor:(UIColor *)textColor
//{
//    if (IS_IOS9) {
//        [UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].textColor = textColor;
//    }
//    else {
//        [UITextField appearanceWhenContainedIn:[UISearchBar class], nil].textColor = textColor;
//    }
//}

- (void)hyx_setCancelButtonFont:(UIFont *)font
{
    NSDictionary *attr = @{NSFontAttributeName : font};
    if (@available(iOS 9.0, *)) {
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitleTextAttributes:attr forState:UIControlStateNormal];
    }
    else {
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:attr forState:UIControlStateNormal];
    }
}

- (void)hyx_setCancelButtonTitleColor:(UIColor *)color 
{
    NSDictionary *attr = @{NSForegroundColorAttributeName : color};
    if (@available(iOS 9.0, *)) {
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitleTextAttributes:attr forState:UIControlStateNormal];
    } else {
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:attr forState:UIControlStateNormal];
    }
}

- (void)hyx_setCancelButtonTitle:(NSString *)title
{
    if (@available(iOS 9.0, *)) {
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:title];
    }
    else {
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:title];
    }
}

@end
