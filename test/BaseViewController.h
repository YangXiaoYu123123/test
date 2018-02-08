//
//  BaseViewController.h
//  jZB_iOS2.0
//
//  Created by jzb_iOS on 15/4/21.
//  Copyright (c) 2015年 jzb_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "UIColor+HEX.h"
#import "randomcolor.h" 
#import "verificationTool.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UILabel+StringFrame.h"
#import "Reachability.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
//项目里有两个版本，
#import "MBProgressHUD.h"

#import "userObject.h"

#import <CoreText/CoreText.h>
#import "TTTAttributedLabel.h"

#import "MYCodeView.h"
#import <MJExtension/MJExtension.h>
#import <AFNetworkReachabilityManager.h>

#import "NoInternetView.h"
#import "AFAppDotNetAPIClient.h"

//----------用来区分我的工作的类型---------
typedef enum {
    myJobVCType_cashList,
    myJobVCType_imcomeRank,
    myJobVCType_myJob,
    myJobVCType_myIncome,
    myJobVCType_myCredits,
    myJobVCType_none
}myJobVCType;
//分页操作
typedef enum {
    pageType_add,
    pageType_reload
}pageType;
@interface BaseViewController : UIViewController <BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>{
    
}
@property (strong,nonatomic)void(^CompletedGetLocation)(BMKUserLocation *userLocation);
@property (strong,nonatomic)void(^failedGetLocation)(NSError * error);
@property (strong,nonatomic)void(^CompletedGetGeo)(BMKReverseGeoCodeResult *result);
@property (strong,nonatomic)void(^failedGetGeo)(BMKSearchErrorCode  error);

@property (nonatomic,strong) MBProgressHUD        * HUD;
@property (nonatomic,strong) AFAppDotNetAPIClient * smanager;
@property (nonatomic,strong) BMKLocationService   * locService;
@property (strong,nonatomic) BMKGeoCodeSearch     * geoCodeSearch;
@property (nonatomic,strong) BMKLocationService   * punchLocService;
@property (nonatomic,strong) userObject           * userInfoObject;
@property (nonatomic,strong) MYCodeView           * codeView;
@property (nonatomic,strong)UITableView           * tmpTableView;
@property (strong,nonatomic)NoInternetView        * noInternetView;
/**灰色半透明view*/
@property (strong,nonatomic)UIView * grayBgView;
/**
    显示一个2秒的提示信息窗口
 */
- (void)showAlertWithInfo:(NSString *)str;
/**
    有一层透明蒙板，的提示view  ,这个方法已经不合适了，择日删除！！！
 */
-(void)showNoticeViewWithView:(UIView*)view;
/**
   隐藏透明蒙板，的提示view  ,这个方法已经不合适了，择日删除！！！
 */
-(void)hideNoticeBgView;
/**
 跳转登录界面
 */
-(void)gotoLogin;
/**
 刷新所有首页
 */
-(void)updateAllTabFirstPage;
/**跳转到web网页*/
- (void)gotoWebWithURL:(NSURL *)url Animated:(BOOL)animated;
/**
    通过百度地图SDK 获取地理位置
 */
-(void)getLocation;
/**
 拨打电话
 */
-(void)callPhoneWithNumber:(NSString *)phoneNumber;
/**
 报岗
 */
-(void)postAddressWithInfo:(NSDictionary*)info;
/**
    封装的根据经纬度，反编码出地点
 */
-(void)geoAddressWith:(CLLocationCoordinate2D)coorder Complete:(void(^)(BMKReverseGeoCodeResult*))completedSuccess error:(void(^)(BMKSearchErrorCode eroor))faild;
/**
    封装好，获取地理位置以及回调blocks
 */
-(void)startGetLocationOnCompleted:(void(^)(BMKUserLocation * loction))CompletedSuccess error:(void(^)(NSError * error))failed;
/**
    设置navigationBar 右按钮的title
 */
-(void)setRightButtonTitle:(NSString*)title;

/**
    设置NavigationBar 右按钮图片
 */
-(void)setRightButtonImage:(UIImage*)image;

/**
    设置navigationBar 左按钮title
 */
-(void)setLeftButtonTitle:(NSString*)title;
/**
 设置NavigationBar 左按钮图片
 */
-(void)setLeftButtonImage:(UIImage*)image;

/**
    导航条右按钮点击事件
 */
-(void)rightBarButtonClick:(id)barbutton;

/**
    导航条左按钮点击事件
 */
-(void)leftBarButtonClick:(id)sender;

/**
 导航条右按的类型
 */
-(void)setRightButtonItem:(UIBarButtonSystemItem)barButtonItem;
/**
    分享方法
 */
-(void)shareWithShareAmount:(NSNumber *)amount WithTitle:(NSString *)title WithInfo:(id)info;
/**
 获取Unix 时间戳
 */
-(NSString *)getUnixTimestampWith:(NSDate*)date;
/**
 十六进制mac 地址转十进制
 */
-(NSString *)getDecimalMacAddressWith:(NSString *)mac;

/**
 TTTAttribute label 添加点击link 事件
 */
-(void)setTTTattributeLabel:(TTTAttributedLabel*)tttLabel WithMessage:(NSString *)message WihtLinkMessage:(NSString *)linkMessage;

/**
 TTTAttribute label link click
 */
-(void)linkMessageClick:(id)sender;
#pragma mark ---------------- 网络请求
/**
 封装的GET简单请求
 */
-(void)requestGET:(NSString * )path
        parameter:(id)parameter
           result:(void (^)(NSDictionary * response)) result;
/**
 封装的GET请求，
 带进度,
 带错误的block
 */
-(void)requestGET:(NSString * )path
        parameter:(id)parameter
         progress:(void (^)(NSProgress * getProgress))getProgress
           result:(void (^)(NSDictionary * response)) result
           failed:(void(^)(NSURLSessionTask * task,NSError * error))fail;

/**
 封装的POST简单请求
 */
-(void)requestPOST:(NSString * )path
         parameter:(id)parameter
            result:(void (^)(NSDictionary * response)) result;
/**
 封装的POST请求，
 带进度,
 带错误的block
 */
-(void)requestPOST:(NSString * )path
         parameter:(id)parameter
          progress:(void (^)(NSProgress * getProgress))postProgress
            result:(void (^)(NSDictionary * response)) result
            failed:(void(^)(NSURLSessionTask * task,NSError * error))fail;
/**添加了无网的白板图*/
- (void)addNoInternetWithFrame:(CGRect)frame Click:(buttonClick)click;
/**
 根据SBName和SBID 跳转
 */
-(void)gotoVCWithStoryBoardName:(NSString * )sbname StoryBoardID:(NSString *)sbID targetInfo:(void (^)(BaseViewController * vc))target;
/**
 检查是否需要填写详细信息
 */
-(void)checkUerInfo;

/**
    播放器
 */
- (void)initAVPlayer:(NSURL *)url;

/**
 *  下载进度
 */
- (NSString *)downingResouse;

/**
 *  是否有下载
 */
- (BOOL)isDownTask;

/**
 json对象转json字符串
 */
- (NSString*)DicToString:(id)jsonObj;

/**
 json字符串转Dic
 */
-(NSDictionary *)StringToDic:(NSString *)temps;

/**
    userData
 */
-(NSMutableDictionary *)getCustomUserData;

/**
 *  自定义的alertTitle
 */
- (void)showAlertWithTitle:(NSString *)title msg:(NSString *)message cancelTitle:(NSString *)cancelTitle sTitle:(NSString *)sureTitle  cancelBlock:(void (^)())cancelBlock otherBlock:(void (^)())otherBlock;
/**
  系统弹框
 */
- (void)showAlertWithSystemInfo;
/**
 * 当前天
 */
- (NSString *)getCurrentDay;
/**
 判断字符是否为空或者只为空格
 空或者全是空格时返回YES
 */
- (BOOL)isBlankString:(NSString *)string;
/**
 获取当前controller
 */
- (UIViewController *)getCurrentVC;
@end
