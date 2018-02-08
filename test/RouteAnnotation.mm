//
//  RouteAnnotation.m
//  IphoneMapSdkDemo
//
//  Created by wzy on 16/8/31.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "RouteAnnotation.h"
#import "UIImage+Rotate.h"

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;

- (UIImage *)getImageWithImageName:(NSString *)imageName{
    // 加载自定义名称为Resources.bundle中对应images文件夹中的图片
    // 思路:从mainbundle中获取resources.bundle
    NSString *strResourcesBundle = [[NSBundle mainBundle] pathForResource:@"mapapi" ofType:@"bundle"];
    // 找到对应images夹下的图片
    NSString *strC = [[NSBundle bundleWithPath:strResourcesBundle] pathForResource:imageName ofType:@"png" inDirectory:@"images"];
    UIImage *imgC = [UIImage imageWithContentsOfFile:strC];
    return imgC;
}
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview
{
    BMKAnnotationView* view = nil;
    switch (_type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"start_node"];
                //view.image = [UIImage imageNamed:@"icon_nav_start.png"];
                view.image = [self getImageWithImageName:@"icon_nav_start"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                
                
            }
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"end_node"];
                //view.image = [UIImage imageNamed:@"icon_nav_end.png"];
                view.image = [self getImageWithImageName:@"icon_nav_end"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
            }
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"bus_node"];
                //view.image = [UIImage imageNamed:@"icon_nav_bus.png"];
                view.image = [self getImageWithImageName:@"icon_nav_bus"];
            }
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"rail_node"];
                //view.image = [UIImage imageNamed:@"icon_nav_rail.png"];
                view.image = [self getImageWithImageName:@"icon_nav_rail"];
            }
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"route_node"];
            } else {
                [view setNeedsDisplay];
            }
            
            //UIImage* image = [UIImage imageNamed:@"icon_direction.png"];
            UIImage* image = [self getImageWithImageName:@"icon_direction"];
            view.image = [image imageRotatedByDegrees:_degree];
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"waypoint_node"];
            } else {
                [view setNeedsDisplay];
            }
            
            //UIImage* image = [UIImage imageNamed:@"icon_nav_waypoint.png"];
            UIImage* image = [self getImageWithImageName:@"icon_nav_waypoint"];
            view.image = [image imageRotatedByDegrees:_degree];
        }
            break;
            
        case 6:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"stairs_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"stairs_node"];
            }
            //view.image = [UIImage imageNamed:@"icon_stairs.png"];
            view.image = [self getImageWithImageName:@"icon_stairs"];
        }
            break;
        default:
            break;
    }
    if (view) {
        view.annotation = self;
        view.canShowCallout = YES;
    }
    return view;
}

@end
