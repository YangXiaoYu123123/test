//
//  UIView+shadow.h
//  jZB_iOS2.0
//
//  Created by 马彦飞 on 2017/3/16.
//  Copyright © 2017年 jzb_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface UIView (shadow)
@property (strong,nonatomic)NSIndexPath  *indexPath;//扩展一个属性
/**
 给view添加阴影,有默认值
 color   阴影颜色
 offset  偏移量，x向右，y向下
 opacity 透明度
 radius  半径
 */
- (void)addShadowWihtColor:(UIColor *)color Offset:(CGSize)size Opacity:(CGFloat)opacity Radius:(CGFloat)radius;

/**
 给指定位置添加圆角
 * UIRectCornerTopLeft
 * UIRectCornerTopRight
 * UIRectCornerBottomLeft
 * UIRectCornerBottomRight
 * UIRectCornerAllCorners
 */
- (void)addCornerWithRectCorners:(UIRectCorner)corners Size:(CGSize)size;
/**
 给view指定位置添加边框
 */
- (void)setBorderTop:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;


/**父ViewContorller*/
- (BaseViewController *)parentController;

@end
