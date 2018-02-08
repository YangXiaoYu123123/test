//
//  UIView+shadow.m
//  jZB_iOS2.0
//
//  Created by 马彦飞 on 2017/3/16.
//  Copyright © 2017年 jzb_iOS. All rights reserved.
//

#import "UIView+shadow.h"
static char indexPathKey;
@implementation UIView (shadow)
@dynamic indexPath;
- (void)addShadowWihtColor:(UIColor *)color Offset:(CGSize)size Opacity:(CGFloat)opacity Radius:(CGFloat)radius{
    self.layer.masksToBounds = NO;
    self.layer.shadowColor  = color?color.CGColor:[UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
    self.layer.shadowOffset = size.width!=0 || size.height!=0?size:CGSizeMake(0,1);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowOpacity = opacity != 0.0?opacity:0.3;//阴影透明度
    self.layer.shadowRadius  = radius!=0?radius:1;//阴影半径
}

- (void)addCornerWithRectCorners:(UIRectCorner)corners Size:(CGSize)size{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
/**
 给view指定位置添加边框
 */
- (void)setBorderTop:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, self.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, self.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, self.frame.size.height - width, self.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(self.frame.size.width - width, 0, width, self.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
}
- (BaseViewController *)parentController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[BaseViewController class]]) {
            return (BaseViewController*)nextResponder;
        }
    }
    return nil;
}
#pragma mark ---------------- getter setter
- (NSIndexPath*)indexPath{
    return objc_getAssociatedObject(self, &indexPathKey);
}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    objc_setAssociatedObject(self, &indexPathKey,indexPath,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
