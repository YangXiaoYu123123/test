//
//  randomcolor.m
//  测试工程
//
//  Created by lzj_TX on 14-9-2.
//  Copyright (c) 2014年 lzj_TX. All rights reserved.
//

#import "randomcolor.h"
@implementation UIColor(RandomColor)
+(UIColor*)randomColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
@end
