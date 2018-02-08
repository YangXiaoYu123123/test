//
//  NSString+URL.h
//  易华语
//
//  Created by lzj_TX on 14-11-6.
//  Copyright (c) 2014年 lzj_TX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (URL)
-(NSString*)URLEncodeString;

/**
    更改一个字符串中，某一段连续字符串的颜色
 */
-(NSMutableAttributedString *)changString:(NSString *)sting Color:(UIColor*)color;
/**
 更改一个字符串，某一段连续字符串的字体
 */
-(NSMutableAttributedString *)changString:(NSString *)sting Font:(UIFont* )font;
/**
    获取一个URL中的jobID
 */
-(NSString*)getJobIdWithString:(NSString *)string;

/**
    解析一个URL
 */
+(NSDictionary *)resolveURLWithURLString:(NSString*)string;

/**
    获取手机型号
 */
+ (NSString *)getCurrentDeviceModel:(UIViewController *)controller;
/**
    html
 */
+(NSAttributedString *)textWithHTMLString:(NSString *)htmlStr;

@end
