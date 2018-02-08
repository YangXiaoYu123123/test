//
//  routePlanViewController.h
//  jZB_iOS2.0
//
//  Created by 马彦飞 on 2017/2/20.
//  Copyright © 2017年 jzb_iOS. All rights reserved.
//
/**
 路线规划
 */
#import "BaseViewController.h"
@interface routePlanViewController : BaseViewController <BMKMapViewDelegate, BMKRouteSearchDelegate>
@property (assign,nonatomic)CLLocationCoordinate2D coordinate;
@property (strong,nonatomic)NSString * endAddress;
@end
