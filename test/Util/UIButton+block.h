//
//  UIButton+block.h
//  jZB_iOS2.0
//
//  Created by jzb_iOS on 16/3/14.
//  Copyright © 2016年 jzb_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
typedef void (^ActionBlock)();
@interface UIButton (block)
@property (readonly) NSMutableDictionary *event;
- (void) handleControlEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)action;
@end
