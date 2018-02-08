//
//  verificationTool.h
//  jZB_iOS2.0
//
//  Created by jzb_iOS on 15/4/27.
//  Copyright (c) 2015年 jzb_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface verificationTool : NSObject
+(BOOL)isPhoneNumberWith:(NSString *)phone;
+(BOOL)isPasswordVerfication:(NSString*)password;
+(BOOL)isEmailAddress:(NSString *)email;
+(BOOL)isUserNameWith:(NSString *)userName;
+(BOOL)isQQWith:(NSString *)qq;
+(BOOL)isNameWith:(NSString *)name;
+(BOOL)isCodeWith:(NSString *)code;
+(BOOL)isContantWith:(NSString *)contant;
+(BOOL)isLeaglRealName:(NSString * )realName;
@end
