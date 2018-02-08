//
//  UIButton+block.m
//  jZB_iOS2.0
//
//  Created by jzb_iOS on 16/3/14.
//  Copyright © 2016年 jzb_iOS. All rights reserved.
//

#import "UIButton+block.h"

@implementation UIButton (block)
static char overviewKey;

@dynamic event;

- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)block {
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

- (void)callActionBlock:(id)sender {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block();
    }
}
@end
