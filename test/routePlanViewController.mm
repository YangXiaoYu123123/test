//
//  routePlanViewController.m
//  jZB_iOS2.0
//
//  Created by 马彦飞 on 2017/2/20.
//  Copyright © 2017年 jzb_iOS. All rights reserved.
//

#import "routePlanViewController.h"
#import "UIImage+Rotate.h"
#import "RouteAnnotation.h"
#import "UIView+shadow.h"
#import "UIButton+block.h"
#import "NSString+URL.h"

#define BaiduMAPKey @"4TTbGEPYYGbGANLG0P1QqCWTcQ0ln4CW"//百度地图SDK

#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;

#define kScreen_Height   [[UIScreen mainScreen] bounds].size.height
#define kScreen_Width    [[UIScreen mainScreen] bounds].size.width

#define KMainColor [UIColor colorWithRed:59.0/255.0 green:194.0/255.0 blue:168.0/255.0 alpha:1]
#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)

@interface routePlanViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,BMKPoiSearchDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *startImageView;
@property (weak, nonatomic) IBOutlet UITextField *startTextField;
@property (weak, nonatomic) IBOutlet UILabel *endAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIView *mapViewBgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (strong,nonatomic)NSArray * dataArray;
@property (strong,nonatomic)NSArray * searchArray;
@property (strong,nonatomic)NSString* startStr;//用来记录搜索前的地址
@property (strong,nonatomic)NSIndexPath * lastIndex;
@property (weak, nonatomic) IBOutlet UIView *moreLineButtonBgView;
@property (weak, nonatomic) IBOutlet UIButton *moreLineButton;//显示更多路线
@property (strong,nonatomic)BMKRouteSearch * routesearch;//路径规划
@property (strong,nonatomic)BMKPoiSearch   * poiSearch;//范围搜索
@property (strong,nonatomic)NSURLSessionDataTask * task;//请求的task.
/**mapView*/
@property (strong,nonatomic)BMKMapView * mapView;
@end

@implementation routePlanViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _routesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _poiSearch.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _routesearch.delegate = nil; // 不用时，置nil
    _poiSearch.delegate = nil;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_task cancel];
    [_mapView removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self starUserLoaction];
    // Do any additional setup after loading the view.
}
- (void)initSubViews{
    @WeakObj(self);
    self.title = @"地图详情";
    _locationButton.layer.cornerRadius = 3;
    _locationButton.layer.borderColor  = KMainColor.CGColor;
    _locationButton.layer.borderWidth  = SINGLE_LINE_WIDTH;
    [_locationButton setTitle:@"取消" forState:UIControlStateSelected];
    _endAddressLabel.text = _endAddress;
    _routesearch = [[BMKRouteSearch alloc]init];
    _poiSearch = [[BMKPoiSearch alloc]init];
    _searchTableView.hidden = YES;
    
    [_startTextField addTarget:self action:@selector(StartTextFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    _startTextField.text = @"当前位置";
    _startTextField.layer.borderColor  = [UIColor colorWithHexString:@"#eeeeee"].CGColor;
    _startTextField.layer.borderWidth  = 1;
    _startTextField.layer.cornerRadius = 4;
    ////////////mapView//////////
    _mapView = ({
        BMKMapView * map = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 148 - 44)];
        [_mapViewBgView addSubview:map];
        map;
    });
    
    _tableView.scrollEnabled = NO;
    _tableView.rowHeight = 52;
    [_tableView addShadowWihtColor:nil Offset:CGSizeMake(0, -3) Opacity:0 Radius:3];
    [_moreLineButtonBgView addShadowWihtColor:nil Offset:CGSizeMake(0, -3) Opacity:0 Radius:3];
    [_moreLineButton addCornerWithRectCorners:UIRectCornerTopRight|UIRectCornerTopLeft Size:CGSizeMake(3, 3)];
    [_moreLineButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        selfWeak.moreLineButton.selected = !selfWeak.moreLineButton.selected;
        [UIView animateWithDuration:0.3 animations:^{
            if (selfWeak.moreLineButton.selected && _dataArray !=0) {
                _tableViewHeight.constant = _dataArray.count >6?52*6:_dataArray.count * 52;
            }
            else{
                _tableViewHeight.constant = 52;
            }
            [self.view layoutIfNeeded];
        }];
    }];
}
- (IBAction)locationButtonClick:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = NO;
        _startTextField.text = _startStr;
        [_startTextField resignFirstResponder];
        _searchTableView.hidden = YES;
        _searchArray = nil;
        [_searchTableView reloadData];
    }
    else{
        _startTextField.text = @"当前位置";
        [self starUserLoaction];
    }
}
#pragma mark ---------------- 定位
/**
 开始定位
 */
- (void)starUserLoaction{
    @WeakObj(self);
    [self startGetLocationOnCompleted:^(BMKUserLocation *loction) {
        //反编译当前的地址
        [selfWeak geoAddressWith:loction.location.coordinate Complete:^(BMKReverseGeoCodeResult * result) {
            selfWeak.startTextField.text = result.address;
            NSLog(@"商圈名称%@",result.businessCircle);
        } error:^(BMKSearchErrorCode eroor) {
            NSLog(@"反编译失败%u",eroor);
        }];
        //添加线路
        [selfWeak getTransitDataWith:loction.location.coordinate];
    } error:^(NSError *error) {
        [selfWeak showAlertWithInfo:@"定位失败，请重新上传位置"];
    }];
}
/**
 根据api获取到路线数据
 */
- (void)getTransitDataWith:(CLLocationCoordinate2D)coordinate{
    @WeakObj(self);
    [self.HUD showAnimated:YES];
    NSMutableDictionary * parameter = ({
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        NSString * mcode = [[NSBundle mainBundle] bundleIdentifier];
        NSString * origin = [NSString stringWithFormat:@"%.6f,%.6f",coordinate.latitude,coordinate.longitude];
        NSString * destination = [NSString stringWithFormat:@"%.6f,%.6f",_coordinate.latitude,_coordinate.longitude];
        [dic setObject:BaiduMAPKey forKey:@"ak"];
        [dic setObject:mcode forKey:@"mcode"];
        [dic setObject:origin forKey:@"origin"];
        [dic setObject:destination forKey:@"destination"];
        dic;
    });
    NSMutableString * parmtar = [[NSMutableString alloc]init];
    for (NSString * key  in parameter.allKeys) {
        NSString * keyValue = [NSString stringWithFormat:@"&%@=%@",key,[parameter objectForKey:key]];
        [parmtar appendString:keyValue];
    }
    NSString *urlStr = [NSString stringWithFormat:@"https://api.map.baidu.com/direction/v2/transit?%@",parmtar];
    NSString *newStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:newStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration];
    // 基本网络请求
    _task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dic[@"status"]integerValue] != 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [selfWeak.HUD hideAnimated:YES];
                        [selfWeak showAlertWithInfo:dic[@"message"]];
                    });
                }
                else{
                    [selfWeak analysisRouteLineDataWith:dic];
                }
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [selfWeak.HUD hideAnimated:YES];
                [selfWeak showAlertWithInfo:@"服务器错误"];
            });
        }
    }];
    [_task resume];
}
/**
 解析路线规划数据
 */
- (void)analysisRouteLineDataWith:(NSDictionary *)dic{
    NSDictionary * result = dic[@"result"];
    NSArray * routes = result[@"routes"];
    NSMutableArray * routeObjs = [NSMutableArray array];
    for (NSDictionary* info in routes) {
        BMKMassTransitRouteLine * routeLine = [[BMKMassTransitRouteLine alloc]init];
        routeLine.distance = [info[@"distance"]intValue];
        BMKTime * time  = ({
            BMKTime * t  = [[BMKTime alloc]init];
            int secondes = [info[@"duration"]intValue];
            t.seconds = secondes%60;
            t.minutes = (secondes/60)%60;
            t.hours   = (secondes/60/60)%24;
            t.dates   = secondes/60/60/24;
            t;
        });
        routeLine.duration = time;
        routeLine.price = [info[@"price"]floatValue];
        //steps
        NSMutableArray * routeSteps = [NSMutableArray array];
        NSArray * steps = info[@"steps"];
        for (NSArray * transitSteps in steps) {
            NSMutableArray * subStpArray = [NSMutableArray array];
            for (NSDictionary * subInfo in transitSteps) {
                BMKMassTransitSubStep * subStep = [[BMKMassTransitSubStep alloc]init];
                subStep.distance = [subInfo[@"distance"]intValue];
                subStep.duration = [subInfo[@"duration"]intValue];
                subStep.instructions = subInfo[@"instructions"];
                //坐标点
                NSString * path = subInfo[@"path"];
                NSArray * pathArray = [path componentsSeparatedByString:@";"];
                int pathCount = (int)pathArray.count;
                BMKMapPoint * temppoints = new BMKMapPoint[pathCount];
                for (int i = 0 ;i < pathCount ; i++ ){
                    NSString * aPath = pathArray[i];
                    NSArray * aPointArray = [aPath componentsSeparatedByString:@","];
                   temppoints[i] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([aPointArray[1]doubleValue], [aPointArray[0]doubleValue]));
                }
                subStep.points = temppoints;
                subStep.pointsCount = pathCount;
                
                NSDictionary * start_location = subInfo[@"start_location"];
                subStep.entraceCoor = CLLocationCoordinate2DMake([start_location[@"lat"]doubleValue],[start_location[@"lng"]doubleValue]);
                
                NSDictionary * end_location = subInfo[@"end_location"];
                subStep.exitCoor = CLLocationCoordinate2DMake([end_location[@"lat"]doubleValue],[end_location[@"lng"]doubleValue]);
                [subStpArray addObject:subStep];
            }
            BMKMassTransitStep * transitStep = [[BMKMassTransitStep alloc]init];
            transitStep.steps = subStpArray;
            [routeSteps addObject:transitStep];
        }
        routeLine.steps = routeSteps;
        [routeObjs addObject:routeLine];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
        array = [NSArray arrayWithArray:_mapView.overlays];
        [_mapView removeOverlays:array];
    });

    dispatch_async(dispatch_get_main_queue(), ^{
        _dataArray = [NSArray arrayWithArray:routeObjs];
        [_tableView reloadData];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        //刷新完成
        if (routeObjs.count) {
            BMKMassTransitRouteLine* routeLine = (BMKMassTransitRouteLine*)[routeObjs objectAtIndex:0];
            [self mapViewAddOVerlayWith:routeLine];
        }
        else{
            [self.HUD hideAnimated:YES];
            [self showAlertWithInfo:@"距离目标地点太近"];
        }
    });
}
/**
 开始规划线路
 */
- (void)busRoutePlanWith:(CLLocationCoordinate2D)coordinate{
    //[self showAlertWithInfo:@"正在规划线路"];
    [self.HUD showAnimated:YES];
    
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = coordinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = _coordinate;

    BMKMassTransitRoutePlanOption *option = [[BMKMassTransitRoutePlanOption alloc]init];
    option.from = start;
    option.to = end;
    BOOL flag = [_routesearch massTransitSearch:option];
    
    if(flag) {
        NSLog(@"公交交通检索（支持垮城）发送成功");
    } else {
        NSLog(@"公交交通检索（支持垮城）发送失败");
    }
}
#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [(RouteAnnotation*)annotation getRouteAnnotationView:view];
    }
    return nil;
}
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor   = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth   = 3.0;
        return polylineView;
    }
    return nil;
}

#pragma mark - BMKRouteSearchDelegate
/**
 *返回公共交通路线检索结果（new）
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKMassTransitRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetMassTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKMassTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error{
    NSLog(@"onGetMassTransitRouteResult error:%d", (int)error);
    [self.HUD hideAnimated:YES];
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        _dataArray = result.routes;
        [_tableView reloadData];
        BMKMassTransitRouteLine* routeLine = (BMKMassTransitRouteLine*)[result.routes objectAtIndex:0];
        [self mapViewAddOVerlayWith:routeLine];
    }
    else{
        NSString * note;
        switch (error) {
            case BMK_SEARCH_NOT_SUPPORT_BUS:{
                note = @"该城市不支持公交搜索";
            }
                break;
            case BMK_SEARCH_NOT_SUPPORT_BUS_2CITY:{
                note = @"不支持跨城市公交";
            }
                break;
            case BMK_SEARCH_RESULT_NOT_FOUND:{
                note = @"没有找到检索结果";
            }
                break;
            case BMK_SEARCH_ST_EN_TOO_NEAR:{
                note = @"起终点太近";
            }
                break;
            case BMK_SEARCH_NETWOKR_ERROR:{
                note = @"网络连接错误";
            }
                break;
            case BMK_SEARCH_NETWOKR_TIMEOUT:{
                note = @"网络连接超时";
            }
                break;
            case BMK_SEARCH_PERMISSION_UNFINISHED:{
                note = @"地图未成功初始化，请重新打开应用";
            }
                break;
            default:
                note = @"由于网络原因加载失败，请重试";
                break;
        }
        [self showAlertWithInfo:note];
    }
}
/**
 根据划线在地图上花线
 */
- (void)mapViewAddOVerlayWith:(BMKMassTransitRouteLine*)routeLine{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    BOOL startCoorIsNull = YES;
    CLLocationCoordinate2D startCoor;//起点经纬度
    CLLocationCoordinate2D endCoor;//终点经纬度
    
    NSInteger size = [routeLine.steps count];
    NSInteger planPointCounts = 0;
    for (NSInteger i = 0; i < size; i++) {
        BMKMassTransitStep* transitStep = [routeLine.steps objectAtIndex:i];
        for (BMKMassTransitSubStep *subStep in transitStep.steps) {
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = subStep.entraceCoor;
            item.title      = subStep.instructions;
            item.type       = 2;
            [_mapView addAnnotation:item];
            if (startCoorIsNull) {
                startCoor = subStep.entraceCoor;
                startCoorIsNull = NO;
            }
            endCoor = subStep.exitCoor;
            //轨迹点总数累计
            planPointCounts += subStep.pointsCount;
            //steps中是方案还是子路段，YES:steps是BMKMassTransitStep的子路段（A到B需要经过多个steps）;NO:steps是多个方案（A到B有多个方案选择）
            if (transitStep.isSubStep == NO) {//是子方案，只取第一条方案
                break;
            }
            else {
                //是子路段，需要完整遍历transitStep.steps
            }
        }
    }
    //添加起点标注
    RouteAnnotation* startAnnotation = [[RouteAnnotation alloc]init];
    startAnnotation.coordinate = startCoor;
    startAnnotation.title = @"起点";
    startAnnotation.type = 0;
    
     [_mapView addAnnotation:startAnnotation];//添加起点标注
    //添加终点标注
    RouteAnnotation* endAnnotation = [[RouteAnnotation alloc]init];
    endAnnotation.coordinate = endCoor;
    endAnnotation.title = @"终点";
    endAnnotation.type = 1;
    [_mapView addAnnotation:endAnnotation]; //添加终点标注
    //轨迹点
    BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
    NSInteger index = 0;
    for (BMKMassTransitStep* transitStep in routeLine.steps) {
        for (BMKMassTransitSubStep *subStep in transitStep.steps) {
            for (NSInteger i = 0; i < subStep.pointsCount; i++) {
                temppoints[index].x = subStep.points[i].x;
                temppoints[index].y = subStep.points[i].y;
                index++;
            }
            //steps中是方案还是子路段，YES:steps是BMKMassTransitStep的子路段（A到B需要经过多个steps）;NO:steps是多个方案（A到B有多个方案选择）
            if (transitStep.isSubStep == NO) {//是子方案，只取第一条方案
                break;
            }
            else {
                //是子路段，需要完整遍历transitStep.steps
            }
        }
    }
    //通过points构建BMKPolyline
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
    [_mapView addOverlay:polyLine]; // 添加路线overlay
    delete []temppoints;
    [self mapViewFitPolyLine:polyLine];
    [self.HUD hideAnimated:YES];
}
//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}
#pragma mark ---------- BMKPoiSearchViewDelegate
- (void)poiSearchWithKeyword:(NSString *)keyword{
    BMKNearbySearchOption * searchOption = [[BMKNearbySearchOption alloc]init];
    searchOption.pageIndex = 0;
    searchOption.pageCapacity = 20;
    //searchOption.radius = 100000000;
    searchOption.keyword = keyword;
    searchOption.location = _mapView.centerCoordinate;
    searchOption.sortType = BMK_POI_SORT_BY_COMPOSITE;
    [_poiSearch poiSearchNearBy:searchOption];
}
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    if (poiResult.poiInfoList.count) {
        _searchArray = [poiResult.poiInfoList mutableCopy];
        [_searchTableView reloadData];
    }
}

#pragma mark ---------------- UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _startStr = textField.text;
    textField.text = @"";
    _searchTableView.hidden = NO;
    _locationButton.selected = YES;
}
- (void)StartTextFieldTextChange:(UITextField *)textField{
    NSString *toBeString = textField.text;
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字
    if (!position){
        [self poiSearchWithKeyword:toBeString];
    }
}
#pragma mark ---------------- UITableViewDataSourse
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _searchTableView) {
        return _searchArray.count;
    }
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _searchTableView) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
        BMKPoiInfo * info = _searchArray[indexPath.row];
        cell.textLabel.attributedText       = [info.name changString:_startTextField.text Color:KMainColor];
        cell.detailTextLabel.attributedText = [info.address changString:_startTextField.text Color:KMainColor];
        return cell;
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"subCell" forIndexPath:indexPath];
    BMKMassTransitRouteLine * routeLine = _dataArray[indexPath.row];
    NSString * distacne = routeLine.distance > 1000
    ?[NSString stringWithFormat:@"%.2fkm",routeLine.distance/1000.0]
    :[NSString stringWithFormat:@"%dm",routeLine.distance];
    cell.textLabel.text = [NSString stringWithFormat:@"线路%ld 全长%@",indexPath.row+1,distacne];
    NSMutableArray * time = [NSMutableArray array];
    if (routeLine.duration.dates) {
        [time addObject:[NSString stringWithFormat:@"%d天",routeLine.duration.dates]];
    }
    if (routeLine.duration.hours) {
        [time addObject:[NSString stringWithFormat:@"%d小时",routeLine.duration.hours]];
    }
    if (routeLine.duration.minutes) {
        [time addObject:[NSString stringWithFormat:@"%d分钟",routeLine.duration.minutes]];
    }
    NSString * timeStr = [time componentsJoinedByString:@""];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"花费%.1f元 耗时%@",routeLine.price,timeStr];
    [cell setTintColor:KMainColor];
    //添加一个默认值
    if (indexPath.row == 0 && !_lastIndex) {
        _lastIndex = indexPath;
    }
    if (indexPath == _lastIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _searchTableView) {
        _locationButton.selected = NO;
        _searchTableView.hidden  = YES;
        BMKPoiInfo * info = _searchArray[indexPath.row];
        _startTextField.text = info.name;
        [_startTextField resignFirstResponder];
        [self busRoutePlanWith:info.pt];
        return;
    }
    [_moreLineButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    NSIndexPath * lastPath = _lastIndex;
    _lastIndex = indexPath;
    [tableView reloadRowsAtIndexPaths:@[lastPath,indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    BMKMassTransitRouteLine* routeLine = (BMKMassTransitRouteLine*)[_dataArray objectAtIndex:indexPath.row];
    [self mapViewAddOVerlayWith:routeLine];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
