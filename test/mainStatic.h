//
//  mainStatic.h
//  jZB_iOS2.0
//
//  Created by jzb_iOS on 15/4/21.
//  Copyright (c) 2015年 jzb_iOS. All rights reserved.
//
#ifndef jZB_iOS2_0_mainStatic_h
#define jZB_iOS2_0_mainStatic_h

//#import "NSObject+extention.h"
//是否为当前版本
#define vCFBundleShortVersionStr [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define KisFirstInstall @"isFirstInstall"
#define KisNewVersion @"isNewVersion"
//不再提示更新
#define KNoticeUpdate @"notNoticeUpdate"
//服务器地址
//#define KMain_Domain @"http://123.207.163.197:4009/api"
#define KMain_Domain @"http://xiaolaoyiguan.com:4011/api"
//#define KMain_Domain @"http://yanshi.xiaolaoyiguan.com/api"
//cookie
#define KUserCookie @"userCookie"
//pgy APPID
#define KPGYAPPID @"9853cd79fe0c73cbe78ce5026caf7ee0"//上线版本
//#define KPGYAPPID @"c578dc4a42a563e1040857d7930ee969" //考勤版本

#define KUserDefault(key) [[NSUserDefaults standardUserDefaults]objectForKey:key]
//主颜色
#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define KMainColor [UIColor colorWithRed:59.0/255.0 green:194.0/255.0 blue:168.0/255.0 alpha:1]
//rgb颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//默认启动面
#define KStartPage @"KStartPage"
//应该去登录
#define KneedLogin @"needLogin"
//设备的宽高
#define kScreen_Height   [[UIScreen mainScreen] bounds].size.height
#define kScreen_Width    [[UIScreen mainScreen] bounds].size.width
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
//#define kTabBarHeight [[UITabBarController alloc] init].tabBar.frame.size.height
#define kMainTabVC  [UIApplication sharedApplication].keyWindow.rootViewController
#define kTabBarHeight ((UITabBarController *)kMainTabVC).tabBar.frame.size.height
#define kTopHeight (kStatusBarHeight + kNavBarHeight)
//设备device ID
#define KDeviceID        [[[UIDevice currentDevice] identifierForVendor] UUIDString]
//显示小红点的时间
#define KredcommendTime @"recmmentTime"
#define KmyRedTime      @"myRedTime"
#define KactivityTime   @"activityTime"
#define KisShowPoint    @"isShowPoint"
//是否显示评价cell
#define KShowScoreKey @"showScore"
#define KShowScore [[NSUserDefaults standardUserDefaults]objectForKey:KShowScoreKey]
//wifi更改
#define KWifiChange @"wifichange"
//刷新jobCategory 首页
#define KUpdateJobCategory @"updatejobcategory"
//是否显示快速填写简历条
#define KFastResumeAddKey @"fastResumeAddKey"
#define KFastResumeAddValue [[NSUserDefaults standardUserDefaults]objectForKey:KFastResumeAddKey]
#define KFastResumeAdd @"tipPerfectStep"
//刷新我的兼职
#define KUPdateMyJob @"updateMyjob"
//刷新消息
#define KUPdateMessage @"updatemessage"
//刷新首页兼职
#define KupdateMainList @"updateJobList"
//刷新兼职推荐列表
#define KUpdateJobRecommend @"UpdateJobRecommend"

//刷新我的钱包
#define KUpdateWallet @"updateMyWallet"
//是否需要持续获取后台位置
#define KlocArray       @"localArray"
//对于分页界面不同的操作
#define KReload @"reload"
#define KAdd    @"add"
//NSUserDefault
#define KSetDownDic(dic)    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"KDownValue"]
#define KGetDownArray       [[NSUserDefaults standardUserDefaults]objectForKey:@"KDownValue"]

#define KUserID       [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"]
#define KUserName     [[NSUserDefaults standardUserDefaults]objectForKey:@"KuserName"]
#define KUserIcon     [[NSUserDefaults standardUserDefaults]objectForKey:@"KUserIcon"]

#define KUserIDKey  @"userID"
#define KUserNameKey   @"KuserName"
#define KUserIconKey   @"KUserIcon"

#define KRegisterUserID     [[NSUserDefaults standardUserDefaults]objectForKey:@"registerUserID"]
#define KRegisterUserIDKey  @"registerUserID"
#define Kupdate      [[NSUserDefaults standardUserDefaults]objectForKey:@"update"]
#define KupdateIDKey @"update"
#define KNSUserDefaultsSynchronize [[NSUserDefaults standardUserDefaults]synchronize]
#define KDownCout   @"downCountChange"
//记住密码
#define KLogAccount  @"userAccount"
#define KLogPassword @"userPassword"
//地理位置
#define KLatitude    [[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"]?[[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"]:@""
#define kLatitudeKey @"latitude"
#define KLongititude    [[NSUserDefaults standardUserDefaults]objectForKey:@"longititude"]?[[NSUserDefaults standardUserDefaults]objectForKey:@"longititude"]:@""
#define KLongititudeKey @"longititude"
#define KLocationCity [[NSUserDefaults standardUserDefaults]objectForKey:@"LocationCityKey"]
#define KLocationCityKey @"LocationCityKey"
#define KLocationCityID @"locationcityID"
//需要更新用户信息
#define KNeedUpdateUserinfo @"updateUserinfo"
#define KreciveNotification @"reciveNotification"
//缓存头像
#define Kportrait       [NSString stringWithFormat:@"%@portraitURL",KUserID]
#define KstudentCardPic [NSString stringWithFormat:@"%@studentCardPicture",KUserID]
#define KpHealthCardPic [NSString stringWithFormat:@"%@pHealthCertificatePicture",KUserID]
#define KoHealthCardPic [NSString stringWithFormat:@"%@poHealthCertificatePicture",KUserID]
#define KpSinPic        [NSString stringWithFormat:@"%@pSINPicture",KUserID]
#define KoSinPic        [NSString stringWithFormat:@"%@oSINPicture",KUserID]

#define kDeviceTokenDefault @"deviceTokenDefault"
#define kNotiPushToDetail @"notiPushToDetail"

////////////第三方SDK区分//////////
#if TARGET == 0//xlzp_pgy
    #define KAPPName @"小劳招聘"
    #define BaiduMAPKey @"wWPCci1iBVfRluBp5TRi4ihq"//百度地图SDK
    #define YouMengAPP_Key @"564d356a67e58e4d69007230" //友盟上应用的key
    #define KWeiboAppKey @"833506188"
    #define KWeiboAPPSecret @"9e8c497057dd3fd790627085775a7a40"
    /********QQ空间*******/
    #define kQQ_APP_ID  @"1105436898"
    #define kQQ_APP_KEY  @"n6o2yOQ30kOyLTAQ"
    /*******微信************/ 
    #define kWeiXin_APP_KEY @"wxf3d9663a6a680a7c"
    #define kWeiXin_APP_Secret @"a0c5b09d9dd16f0380992d26bdcd5279"

#elif TARGET == 1//xlzp
    #define KAPPName @"小劳招聘"
    #define BaiduMAPKey @"4TTbGEPYYGbGANLG0P1QqCWTcQ0ln4CW"//百度地图SDK
    #define YouMengAPP_Key @"564d356a67e58e4d69007230" //友盟上应用的key
    #define KWeiboAppKey @"833506188"
    #define KWeiboAPPSecret @"9e8c497057dd3fd790627085775a7a40"
    /********QQ空间*******/
    #define kQQ_APP_ID  @"1105436898"
    #define kQQ_APP_KEY  @"n6o2yOQ30kOyLTAQ"
    /*******微信************/
    #define kWeiXin_APP_KEY @"wxf3d9663a6a680a7c"
    #define kWeiXin_APP_Secret @"a0c5b09d9dd16f0380992d26bdcd5279"
#else //jianzhibao
    #define KAPPName @"兼职宝"
    #define BaiduMAPKey @"YX9lMN8umWN3p0ZEt2YKTjiq"//百度地图SDK 
    #define YouMengAPP_Key @"536b96ad56240b0a65023564" //友盟上应用的key
    //weibo
    #define KWeiboAppKey @"1724289593"
    #define KWeiboAPPSecret @"e2be246e596fd966eaeeac08c81327ef"
    /********QQ空间*******/
    #define kQQ_APP_ID  @"1104362030"
    #define kQQ_APP_KEY  @"fUcqTCphK3VhICYK"
    /*******微信************/
    #define kWeiXin_APP_KEY @"wx8d1397c7f46ba8a6"
    #define kWeiXin_APP_Secret @"18f59249d63fd093dcd622108181bef0"
#endif
//测试环境，生产环境
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__);
#else
#define NSLog(...)
#endif
//#define kFinalDeviceTokenDefault @"finalDeviceTokenDefault"
//设备IOSVersion
#define IOSVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

#define SbId_VideoPlayerVC          @"VideoPlayerVC"
#define SbId_trainVideoVC           @"trainVideoVC"
#define SbId_scheduVC               @"scheduDetailVC"
#define SbId_autograph              @"autographVC"
#define SbId_DownVideo              @"downVideo"
#define SbId_attendanceVC           @"attendanceVC"
//----------weak self---------
#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define SbName_train                @"TrainVideo"

#define Rect(x, y, w, h)           CGRectMake(x, y, w, h)
#define StringWithFormat(str)   [NSString stringWithFormat:@"%@", str == nil ? @"" : str]


#define IOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 9.0)
#define IOS8_10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 10.0)
#define IOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define IOS10_3 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.3)

#define iPhoneX   (kScreen_Width == 375.f && kScreen_Height == 812.f)
#endif

