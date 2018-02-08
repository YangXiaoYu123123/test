//
//  userObject.m
//  dy-Autolayout
//
//  Created by jzb_iOS on 15/6/12.
//  Copyright (c) 2015年 jzb_iOS. All rights reserved.
//

#import "userObject.h"

@interface userObject ()
@property (nonatomic,strong)NSMutableDictionary * userInfoDictionary;
@property (nonatomic,strong)dispatch_queue_t concurrentUserQueue;

@end

@implementation userObject

+(instancetype)shareInstance{
    static userObject * shareUser = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        shareUser = [[userObject alloc]init];
        //_shareUser.userInfoDictionary = [[NSMutableDictionary alloc]init];
        shareUser->_userInfoDictionary  = [NSMutableDictionary dictionary];
        shareUser->_concurrentUserQueue = dispatch_queue_create("com.jianzhibao", DISPATCH_QUEUE_CONCURRENT);
    });
    return shareUser;
}


-(void)setObject:(id<NSCopying>)object forKey:(id<NSCopying>)aKey{
    if (object) {
        dispatch_barrier_async(self.concurrentUserQueue, ^{
            [_userInfoDictionary  setObject:object forKey:aKey];
        });
    }
}

-(void)setUserInfoDictionaryWithDictionary:(NSDictionary *)dictionary{
    if (dictionary) {
        dispatch_barrier_async(self.concurrentUserQueue, ^{
            for (id key in  [dictionary allKeys]) {
                [self setObject:[dictionary objectForKey:key] forKey:key];
            }
        });
    }
}

-(id)objectForKey:(id)aKey{
    __block id object;
    dispatch_sync(self.concurrentUserQueue, ^{
        object = [self.userInfoDictionary objectForKey:aKey];
    });
    return object;
}

-(NSDictionary*)userDictionary{
    if (_userInfoDictionary.allKeys.count == 0) {
        return nil;
    }
    __block NSDictionary * user;
    dispatch_sync(self.concurrentUserQueue, ^{
        user = _userInfoDictionary;
    });
    return user;
}

-(void)removeAllObjects{
    [_userInfoDictionary removeAllObjects];
    
}
@end











