//
//  verificationTool.m
//  jZB_iOS2.0
//
//  Created by jzb_iOS on 15/4/27.
//  Copyright (c) 2015年 jzb_iOS. All rights reserved.
//

#import "verificationTool.h"

@implementation verificationTool
+(BOOL)isPhoneNumberWith:(NSString *)phone{
    return phone.length == 11?YES:NO;
}
+(BOOL)isPasswordVerfication:(NSString *)password{
    return password.length >=6&& password.length <=18 ? YES:NO;
}
+(BOOL)isEmailAddress:(NSString *)email{
    // 编写正则表达式：只能是 汉字 英文 - •
    NSString *regex = @"\\w\[-\\w\\.+]*@\([A-Za-z0-9][-A-Za-z0-9]+\\.)+\[A-Za-z]{2,14}";
    // 创建谓词对象并设定条件的表达式
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    // 判断的字符串
    // 对字符串进行判断
    if ([predicate evaluateWithObject:email]) {
        return YES;
    }
    else
        return NO;
}
+(BOOL)isUserNameWith:(NSString *)userName{
    if (userName.length > 20) {
        return NO;
    }
    return YES;
}
+(BOOL)isQQWith:(NSString *)qq{
    if (qq.length > 50) {
        return NO;
    }
    return YES;
}
+(BOOL)isNameWith:(NSString *)name{
    if (name.length > 8) {
        return NO;
    }
    return YES;
}
+(BOOL)isCodeWith:(NSString *)code{
    if (code.length > 10) {
        return NO;
    }
    return YES;
}

+(BOOL)isContantWith:(NSString *)contant{
    if (contant.length > 140) {
        return NO;
    }
    return YES;

}
+(BOOL)isLeaglRealName:(NSString *)realName{
    // 编写正则表达式：只能是 汉字 英文 - •
    NSString *regex = @"[\u4e00-\u9fa5A-Za-z•]+";
    // 创建谓词对象并设定条件的表达式
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    // 判断的字符串
    // 对字符串进行判断
    if ([predicate evaluateWithObject:realName]) {
        return YES;
    }
    else{
        return NO;
    }
}
@end























