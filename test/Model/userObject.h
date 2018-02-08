//
//  userObject.h
//  dy-Autolayout
//
//  Created by jzb_iOS on 15/6/12.
//  Copyright (c) 2015年 jzb_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userObject : NSObject

+(instancetype)shareInstance;

/**
    用一个字典初始化userInfoDictionary
 */
-(void)setUserInfoDictionaryWithDictionary:(NSDictionary *)dictionary;


/**
    赋值或更改
 */
-(void)setObject:(id<NSCopying>)object forKey:(id<NSCopying>)aKey;

/**
    获取值
 */
-(id)objectForKey:(id)aKey;

/**
    获取userDic
 */
-(NSDictionary *)userDictionary;

/**
    删除所有
 */
-(void)removeAllObjects;

@end
