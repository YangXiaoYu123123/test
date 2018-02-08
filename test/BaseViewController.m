//
//  BaseViewController.m
//  jZB_iOS2.0
//
//  Created by jzb_iOS on 15/4/21.
//  Copyright (c) 2015年 jzb_iOS. All rights reserved.
//

#import "BaseViewController.h"
#import "WKWebViewController.h"
#import <UShareUI/UShareUI.h>
#import <UMSocialCore/UMSocialCore.h>
#import "WelcomeView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
//---------
#import "HSDownloadManager.h"

#import "redNoticeView.h"
#import "shareView.h"
#import "mainStatic.h"

#define kNotiPushToDetail @"notiPushToDetail"
#define KneedLogin @"needLogin"
#define KMainColor [UIColor colorWithRed:59.0/255.0 green:194.0/255.0 blue:168.0/255.0 alpha:1]

#define kScreen_Height   [[UIScreen mainScreen] bounds].size.height
#define kScreen_Width    [[UIScreen mainScreen] bounds].size.width

@interface BaseViewController ()<HideWelcomeDelegate,TTTAttributedLabelDelegate>
@property (nonatomic,strong)UIBarButtonItem * rightBarButton;
@property (nonatomic,strong)UIBarButtonItem * leftBarButton;
@property (nonatomic,strong)WelcomeView     * welcome;
@property (nonatomic,strong)UIView          * shareBgView;
@property (nonatomic,strong)UIView          * noticeBgView;
@property (nonatomic,strong)UIView          * noticeView;
@property (nonatomic,strong)UIView          * shareView;
@property (nonatomic,strong)NSDictionary    * shareDataDic;
@property (nonatomic,strong)MBProgressHUD   * shareHUD;
@end
@implementation BaseViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.locService.delegate = self;
    self.geoCodeSearch.delegate = self;
    self.punchLocService.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushToNotiPushToDetail:) name:kNotiPushToDetail object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoLogin) name:KneedLogin object:nil];
    NSLog(@"开始了 %@",self.title?:NSStringFromClass([self class]));
    //[MobClick beginLogPageView:self.title?:NSStringFromClass([self class])];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.locService.delegate =  nil;
    self.geoCodeSearch.delegate = nil;
    self.punchLocService.delegate = nil;
    
    [_shareBgView  removeFromSuperview];
    [_shareView    removeFromSuperview];
    [_noticeBgView removeFromSuperview];
    [_noticeView removeFromSuperview];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotiPushToDetail object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KneedLogin object:nil];
    //[MobClick endLogPageView:self.title?:NSStringFromClass([self class])];
    NSLog(@"结束了 %@",self.title?:NSStringFromClass([self class]));
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置navigationbar
    self.navigationController.navigationBar.barTintColor        = KMainColor;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:20.0], NSFontAttributeName, nil];
    //检测是否显示欢迎界面
    
    #define KisNewVersion @"isNewVersion"
    #define vCFBundleShortVersionStr [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
    #define KisFirstInstall @"isFirstInstall"
    
    if (!([[NSUserDefaults standardUserDefaults]objectForKey:KisNewVersion]&&[vCFBundleShortVersionStr isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KisNewVersion]]&&[[NSUserDefaults standardUserDefaults]boolForKey:KisFirstInstall])) {
    }
    //[[NSUserDefaults standardUserDefaults]removeObjectForKey:KisNewVersion];
    
    //设置背景颜色
    //self.view.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
}
-(void)showWelcom{
    WelcomeView * welcome = [[WelcomeView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    welcome.delegate      = self;
    self.welcome  = welcome;
    [[UIApplication sharedApplication].keyWindow addSubview:welcome];
}
-(void)gotoLogin{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"login" bundle:[NSBundle mainBundle]];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"loginV2VC"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc  animated:YES];
}
/**
 刷新所有首页
 */
-(void)updateAllTabFirstPage{
    [[NSNotificationCenter defaultCenter]postNotificationName:KUpdateJobCategory  object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:KUPdateMyJob        object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:KUPdateMessage      object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:KNeedUpdateUserinfo object:nil];
}
/**跳转到web网页*/
- (void)gotoWebWithURL:(NSURL *)url Animated:(BOOL)animated{
    WKWebViewController * webVC = [[WKWebViewController alloc]init];
    webVC.url = url;
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:animated];
}
-(void) showNoticeViewWithView:(UIView *)view{
    //-----------添加半透明模板
    if (!_noticeBgView) {
        _noticeBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width,kScreen_Height)];
    }
    _noticeBgView.backgroundColor        = [UIColor blackColor];
    _noticeBgView.userInteractionEnabled = YES;
    _noticeBgView.alpha                  = 0.5;
    UITapGestureRecognizer * singleTap   = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideNoticeBgView)];
    [_noticeBgView addGestureRecognizer:singleTap];
    _noticeView = view;
    [self.navigationController.view addSubview:_noticeBgView];
    [self.navigationController.view addSubview:view];
}
-(void)hideNoticeBgView{
    if (_noticeBgView || _noticeView) {
        [UIView animateWithDuration:0.3 animations:^{
            _noticeView.alpha   = 0;
            _noticeBgView.alpha = 0;
        } completion:^(BOOL finished) {
            [_noticeBgView removeFromSuperview];
            [_noticeView removeFromSuperview];
            if (_noticeView == _codeView) {
                _codeView = nil;
            }
        }];
    }
}
- (NSString *)getTimeNow{
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString * timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    return timeNow;
}
-(NSString *)getUnixTimestampWith:(NSDate *)date{
    long long recordTimelong  = [date timeIntervalSince1970];
    NSString * recordTimeStr = [NSString stringWithFormat:@"%lld",recordTimelong];
    return recordTimeStr;
}
-(NSString *)getDecimalMacAddressWith:(NSString *)mac{
    NSMutableString * decimaMac = [[NSMutableString alloc]init];
    NSArray     * macArray = [mac componentsSeparatedByString:@":"];
    for (NSString * s  in macArray) {
        NSString  * d = [NSString stringWithFormat:@"%ld", strtoul([s UTF8String],0,16)];
        [decimaMac appendString:d];
    }
    return decimaMac;
}
- (BOOL)isBlankString:(NSString *)string{
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    
    return NO;
    
}

- (UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
-(void)callPhoneWithNumber:(NSString *)phoneNumber{
    if (phoneNumber.length == 0) {
        return;
    }
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@",phoneNumber];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    });
}
#pragma mark HideWelcomDelegate
-(void)hideWelcomeView{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KisFirstInstall];
    [[NSUserDefaults standardUserDefaults] setObject:vCFBundleShortVersionStr forKey:KisNewVersion];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KNoticeUpdate];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (self.welcome) {
        [self.welcome removeFromSuperview];
        self.welcome = nil;
//        locationViewController * locationVC = [[locationViewController alloc]init];
//        locationVC.isHidebackButton = YES;
//        [self.navigationController pushViewController:locationVC animated:YES];
    } 
}
#pragma mark 设置TTTAttributeLabel
-(void)setTTTattributeLabel:(TTTAttributedLabel *)tttLabel WithMessage:(NSString *)message WihtLinkMessage:(NSString *)linkMessage{
    NSRange linkRange = [message rangeOfString:linkMessage];
    if (linkRange.length) {
        tttLabel.attributedText = [[NSAttributedString alloc]initWithString:message attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    }else{
        tttLabel.attributedText = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@  %@",message,linkMessage] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    }
    tttLabel.linkAttributes =  @{NSForegroundColorAttributeName:KMainColor,NSFontAttributeName:[UIFont systemFontOfSize:15]};
    tttLabel.delegate       = self;
    
    NSRange range = [tttLabel.text rangeOfString:linkMessage];
    if (range.length ) {
        NSURL     * telURL      = [NSURL URLWithString:@""];
        [tttLabel addLinkToURL:telURL withRange:range];
    }
}
-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    if ([self respondsToSelector:@selector(linkMessageClick:)]) {
        [self linkMessageClick:label];
    }
}
- (void)linkMessageClick:(id)sender{}
#pragma mark 添加左右导航条按钮
-(void)setRightButtonItem:(UIBarButtonSystemItem)barButtonItem{
    _rightBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:barButtonItem target:self action:@selector(rightBarButtonClick:)];
    self.navigationItem.rightBarButtonItem = _rightBarButton;
}
-(void)setRightButtonTitle:(NSString*)title{
    if ([title isEqualToString:@""]) {
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }
    if (!_rightBarButton) {
        _rightBarButton = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick:)];
    }
    [_rightBarButton setTitle:title];
    self.navigationItem.rightBarButtonItem = _rightBarButton;
}
-(void)setRightButtonImage:(UIImage *)image{
    if (!image) {
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }
    if (!_rightBarButton) {
        _rightBarButton = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick:)];
    }
    [_rightBarButton setImage:image];
    self.navigationItem.rightBarButtonItem = _rightBarButton;
}
-(void)rightBarButtonClick:(id)barbutton{
    NSLog(@"right bar button click");
}
-(void)setLeftButtonTitle:(NSString *)title{
    if ([title isEqualToString:@""]) {
        self.navigationItem.leftBarButtonItem = nil;
        return;
    }
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,36, 22)];
    UIButton *button = [[UIButton alloc] initWithFrame:contentView.bounds];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button addTarget:self action:@selector(leftBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:button];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:contentView];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -4;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,barButtonItem];
}
-(void)setLeftButtonImage:(UIImage*)image{
    if (!image) {
        self.navigationItem.leftBarButtonItem = nil;
        return;
    }
    if (!_leftBarButton) {
        _leftBarButton = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClick:)];
    }
    [_leftBarButton setImage:image];
    self.navigationItem.leftBarButtonItem = _leftBarButton;
}
-(void)leftBarButtonClick:(id)sender{
    NSLog(@"点击左边");
}
#pragma mark 网络
/**
 封闭的简单get请求
 */
-(void)requestGET:(NSString *)path parameter:(id)parameter result:(void (^)(NSDictionary *))result{
    [self requestGET:path parameter:parameter progress:nil result:result failed:nil];
}
/**
 封装的GET请求，
 带进度,
 带错误的block
 */
-(void)requestGET:(NSString * )path
        parameter:(id)parameter
         progress:(void (^)(NSProgress * getProgress))getProgress
           result:(void (^)(NSDictionary * response)) result
           failed:(void(^)(NSURLSessionTask * task,NSError * error))fail{
    NSString * compltePath = [NSString stringWithFormat:@"%@/%@",KMain_Domain,path];
    
    @WeakObj(self);
    [self.smanager GET:compltePath parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
        if (getProgress) {
            getProgress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success:%@",task.response);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"no"]) {
            NSString * msg = responseObject[@"msg"];
            if (msg.length) {
                [selfWeak showAlertWithInfo:[responseObject objectForKey:@"msg"]];
            }
        }else{
            if (result) {
                result(responseObject);
            }
        }
        if (selfWeak.tmpTableView) {
//            [selfWeak.tmpTableView.mj_header endRefreshing];
//            [selfWeak.tmpTableView.mj_footer endRefreshing];
        }
        [selfWeak.HUD hideAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",task.response);
        [selfWeak.HUD hideAnimated:YES];
        if (selfWeak.tmpTableView) {
//            [selfWeak.tmpTableView.mj_header endRefreshing];
//            [selfWeak.tmpTableView.mj_footer endRefreshing];
            if ([selfWeak.tmpTableView isKindOfClass:[UITableView class]]) {
                [selfWeak.tmpTableView reloadData];
            }
        }
        if (fail) {
            fail(task,error);
        }
        if (error.code == -1009){
            [self showAlertWithInfo:@"网络不可用，请检查网络设置"];
        }
        else {
            [self showAlertWithInfo:@"服务器错误，请稍后重试。"];
        }
    }];
}
/**
 封闭的简单POST请求
 */
-(void)requestPOST:(NSString *)path parameter:(id)parameter result:(void (^)(NSDictionary *))result{
    [self requestPOST:path parameter:parameter progress:nil result:result failed:nil];
}
/**
 封装的POST请求，带进度,带错误的block
 */
-(void)requestPOST:(NSString * )path
         parameter:(id)parameter
          progress:(void (^)(NSProgress * getProgress))postProgress
            result:(void (^)(NSDictionary * response)) result
            failed:(void(^)(NSURLSessionTask * task,NSError * error))fail{
    @WeakObj(self);
    NSString * compltePath = [NSString stringWithFormat:@"%@/%@",KMain_Domain,path];
    [self.smanager POST:compltePath parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        if (postProgress) {
            postProgress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"no"]) {
            NSString * msg = responseObject[@"msg"];
            if (msg.length) {
                [selfWeak showAlertWithInfo:[responseObject objectForKey:@"msg"]];
            }
        }else{
            if (result) {
                result(responseObject);
            }
        }
        if (selfWeak.tmpTableView) {
//            [selfWeak.tmpTableView.mj_header endRefreshing];
//            [selfWeak.tmpTableView.mj_footer endRefreshing];
        }
        [selfWeak.HUD hideAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (selfWeak.tmpTableView) {
//            [selfWeak.tmpTableView.mj_header endRefreshing];
//            [selfWeak.tmpTableView.mj_footer endRefreshing];
            [selfWeak.tmpTableView reloadData];
        }
        if (fail) {
            fail(task,error);
        }
        [selfWeak.HUD hideAnimated:YES];
        if (error.code == -1009){
            [self showAlertWithInfo:@"网络不可用，请检查网络设置"];
        }
        else {
            [self showAlertWithInfo:@"服务器错误，请稍后重试。"];
        }
    }];
}
/**添加了无网的白板图*/
- (void)addNoInternetWithFrame:(CGRect)frame Click:(buttonClick)click{
    [_noInternetView removeFromSuperview];
    _noInternetView = [[NoInternetView alloc]initWithFrame:frame RetryClick:click];
    [self.view addSubview:_noInternetView];
}
-(void)gotoVCWithStoryBoardName:(NSString *)sbname StoryBoardID:(NSString *)sbID targetInfo:(void (^)(BaseViewController *))target{
    UIStoryboard * loginSB   = [UIStoryboard storyboardWithName:sbname bundle:[NSBundle mainBundle]];
    BaseViewController * vc  = [loginSB instantiateViewControllerWithIdentifier:sbID];
    target(vc);
}
#pragma mark 获取推送后处理
-(void)pushToNotiPushToDetail:(NSNotification *)notification{
    @WeakObj(self);
    NSDictionary * apnsInfo       = (NSDictionary *)notification.object;
    NSString     * pushType       = [apnsInfo objectForKey:@"pageName"];
    ////////////首页//////////
    if ([pushType isEqualToString:@"first_page"]){
        [self.tabBarController setSelectedIndex:0];
    }
    //投递跟踪页
    else if ([pushType isEqualToString:@"deliverStatus"]){
        //applyStatusVC
        NSString * jobID = [apnsInfo objectForKey:@"jobID"];
        if (jobID) {
            [selfWeak gotoVCWithStoryBoardName:@"jobRecommend" StoryBoardID:@"applyStatusV2VC" targetInfo:^(BaseViewController *vc) {
//                applyStatusV2ViewController * applyVC = (applyStatusV2ViewController *)vc;
//                applyVC.jobID = jobID;
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
    }
    //我的钱包页
    else if ([pushType isEqualToString:@"myWallet"]){
        [self gotoVCWithStoryBoardName:@"aboutme" StoryBoardID:@"walletVC" targetInfo:^(BaseViewController *vc) {
            [[NSNotificationCenter defaultCenter]postNotificationName:KNeedUpdateUserinfo object:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    ////////////我的简历//////////
    else if ([pushType isEqualToString:@"my_resume"]){
//        resumeViewController * resumeVC = [[resumeViewController alloc]init];
//        resumeVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:resumeVC animated:YES];
    }
    //显示红包到账提示页 @{@"pageName":@"redNotice",@"money":@(newMoney)}
    else if ([pushType isEqualToString:@"redNotice"]){
        float money = [apnsInfo[@"money"]floatValue];
        redNoticeView * redView = [[redNoticeView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) WithMoney:money];
        redView.checkButtonClick = ^(UIButton *button) {
            [selfWeak gotoVCWithStoryBoardName:@"aboutme" StoryBoardID:@"walletVC" targetInfo:^(BaseViewController *vc) {
                [[NSNotificationCenter defaultCenter]postNotificationName:KNeedUpdateUserinfo object:nil];
                [selfWeak.navigationController pushViewController:vc animated:YES];
            }];
        }; 
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:redView];
    }
}
#pragma mark 通过获取用户信息接口,来判断是否需要填写某些内容.
-(void)checkUerInfo{
    [self.view endEditing:YES];
    if (!KUserID)
        return;
    [self.smanager GET:[NSString stringWithFormat:@"%@/user/%@",KMain_Domain,KUserID] parameters:@{@"longitude":KLongititude,@"latitude":KLatitude,@"city_id":[[NSUserDefaults standardUserDefaults]objectForKey:KLocationCityID]?[[NSUserDefaults standardUserDefaults]objectForKey:KLocationCityID]:@"102",@"device_id":KDeviceID} progress:^(NSProgress * _Nonnull downloadProgress){
    } success:^(NSURLSessionDataTask * task, id responseObject){
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"ok"]) {
            ////////////今日是否有签到//////////
            BOOL isSignToday = [responseObject[@"signToday"]boolValue];
            if (isSignToday) {
//                [self.tabBarController.tabBar showBadgeOnItemIndex:3];
            }
            else{
//                [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
            }
            NSDictionary * data = responseObject[@"data"];
            ////////////是否显示,快速面试条//////////
            [[NSUserDefaults standardUserDefaults]setObject:data[@"tipPerfectStep"]?:@(NO) forKey:KFastResumeAddKey];
            [[NSNotificationCenter defaultCenter]postNotificationName:KFastResumeAdd object:data[@"tipPerfectStep"]];
            ////////////检查是否需要显示红包页//////////
            float newMoney = [data[@"newMoney"]floatValue];
            BOOL needPerfact = [data[@"perfectInfoTips"]boolValue];
            if (newMoney > 0) {
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotiPushToDetail object:@{@"pageName":@"redNotice",@"money":@(newMoney)}];
            }
            //这两个只显示一个,提示填写简历弹框
            else if (needPerfact){
                //needPerfectInfo
                //[self.grayBgView removeAllSubviews];
                UIImageView * imageView = [[UIImageView alloc]init];
                imageView.image = [UIImage imageNamed:@"perface_info"];
                imageView.userInteractionEnabled = YES;
                [self.grayBgView addSubview:imageView];
//                [imageView makeConstraints:^(MASConstraintMaker *make) {
//                    make.center.equalTo(0);
//                }];
                UIButton * button = [[UIButton alloc]init];
                [button setTitle:@"立即完善" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.layer.cornerRadius = 3;
                [button setBackgroundColor:KMainColor];
                
                [button addTarget:self action:@selector(checkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:button];
//                [button makeConstraints:^(MASConstraintMaker *make) {
//                    make.size.equalTo(CGSizeMake(150, 40));
//                    make.bottom.equalTo(-35);
//                    make.centerX.equalTo(0);
//                }];
                [[UIApplication sharedApplication].keyWindow addSubview:self.grayBgView];
            }
            /** 
            NSDictionary * data = [responseObject objectForKey:@"data"];
            NSNumber * sinAuth  = [data objectForKey:@"sinAuth"];
            NSNumber * detailAuth = [data objectForKey:@"detailAuth"];
            NSNumber * bankAuth   = [data objectForKey:@"bankAuth"];
            //sinAuth = @1;
            //detailAuth = @1;
            //bankAuth = @1;
            NSDictionary * sinInfo    = @{@"stepNumber":[NSNumber numberWithInt:registerStep_personID],@"title":@"实名认证"};
            NSDictionary * bankInfo   = @{@"stepNumber":[NSNumber numberWithInt:registerStep_bindBank],@"title":@"添加银行卡"};
            NSDictionary * detailInfo1 = @{@"stepNumber":[NSNumber numberWithInt:registerStep_addtion_account],@"title":@"完善详细资料"};
            NSDictionary * detailInfo2 = @{@"stepNumber":[NSNumber numberWithInt:registerStep_addtion_contact],@"title":@"完善详细资料"};
            
            NSMutableArray * stepArray = [NSMutableArray array];
            if (sinAuth.integerValue == 1) {
                [stepArray addObject:sinInfo];
            }
            if (bankAuth.integerValue == 1) {
                [stepArray addObject:bankInfo];
            }
            if (detailAuth.integerValue == 1) {
                [stepArray addObject:detailInfo1];
                [stepArray addObject:detailInfo2];
            }
            if (stepArray.count > 0) {
                NSString * authContect = [responseObject objectForKey:@"authContent"];
                //可能会与键盘收起动画冲突，所以延迟0.6s执行
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:authContect delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            if (sinAuth.integerValue !=1 && bankAuth.integerValue !=1) {
                                [self gotoVCWithStoryBoardName:@"aboutme" StoryBoardID:@"addtionVC" targetInfo:^(BaseViewController *vc) {
                                    addtionInfoViewController * addtionVC = (addtionInfoViewController *)vc;
                                    addtionVC.stepArray = stepArray;
                                    addtionVC.currentIndex = 0;
                                    addtionVC.staringVC = self;
                                    [self.navigationController pushViewController:addtionVC animated:YES];
                                }];
                            }else{
                                [self gotoVCWithStoryBoardName:@"Main" StoryBoardID:@"registerInfoVC" targetInfo:^(BaseViewController *vc) {
                                    registerInfoViewController * registerVC = (registerInfoViewController *)vc;
                                    registerVC.currentIndex = 0;
                                    registerVC.stepArray = stepArray;
                                    registerVC.staringVC = self;
                                    [self.navigationController pushViewController:registerVC animated:YES];
                                }];
                            }
                        }
                    }];
                });//dispatch 结束

            }
             */
        }
    }failure:^(NSURLSessionDataTask * task, NSError *error) {
        
    }];
}
- (void)checkButtonClick:(UIButton *)button{
//    resumeViewController * resumeVC = [[resumeViewController alloc]init];
//    resumeVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:resumeVC animated:YES];
//    [self.grayBgView removeFromSuperview];
}
#pragma mark 分享事件
/**
 分享方法
 amount: 大于0是红包职位，等于 0 是普通职位 ，-1 是分享APP
 title : 分享的title
 info  : 分享的URL
 */
-(void)shareWithShareAmount:(NSNumber *)amount WithTitle:(NSString *)title WithInfo:(id)info{
    ////////////分享的渠道，根据手机里安装的APP，动态变化//////////
    NSMutableArray * shareChannels = [[NSMutableArray alloc]initWithObjects:@{@"image":@"weibo",@"type":@(UMSocialPlatformType_Sina)}, nil];
    if ([[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_QQ]) {
        [shareChannels insertObject:@{@"image":@"qq_qzone",@"type":@(UMSocialPlatformType_Qzone)} atIndex:0];
        [shareChannels insertObject:@{@"image":@"qq",@"type":@(UMSocialPlatformType_QQ)} atIndex:0];
    }
    if ([[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_WechatSession]) {
        [shareChannels insertObject:@{@"image":@"pengyouquan",@"type":@(UMSocialPlatformType_WechatTimeLine)} atIndex:0];
        [shareChannels insertObject:@{@"image":@"weixin",@"type":@(UMSocialPlatformType_WechatSession)} atIndex:0];
    }
    shareView * view;
    ////////////分享有红包的职位//////////
    if (amount.integerValue > 0) {
        NSString * sharetitle = [NSString stringWithFormat:@"分享赚%@元",amount.stringValue];
        NSString * message = [NSString stringWithFormat:@"分享本职位给好友，当他通过你分享的链接报名并完成面试后，你将获得%@元现金，并可立即提现。",amount.stringValue];
        NSString * cancelTitle = KUserID?@"取消分享":@"登录后可以分享赚钱，请先登录";
        view = [[shareView alloc]initWithTitle:sharetitle Message:message Channels:shareChannels ChannelClick:^(UIButton *button) {
            if (KUserID) {
                NSDictionary * channelInfo = shareChannels[button.tag];
                NSNumber * type = channelInfo[@"type"];
                NSString * shareTitle = [NSString stringWithFormat:@"【%@】%@",KAPPName,title];
                [self shareWebPageToPlatformType:type.integerValue WithTitle:shareTitle Desr:@"正规职位，实名认证。报名面试还会有红包哦，快来看看吧！" URL:(NSString *)info];
            }
        } CancelTitle:cancelTitle CancelClick:^(UIButton *button) {
            if (!KUserID) {
                [self gotoLogin];
            }
        }];
    }
    ////////////分享普通的职位//////////
    else if (amount.integerValue == 0){
        view = [[shareView alloc]initWithTitle:@"分享职位" Message:nil Channels:shareChannels ChannelClick:^(UIButton *button) {
            NSDictionary * channelInfo = shareChannels[button.tag];
            NSNumber * type = channelInfo[@"type"];
            NSString * shareTitle = [NSString stringWithFormat:@"【%@】%@",KAPPName,title];
            [self shareWebPageToPlatformType:type.integerValue WithTitle:shareTitle Desr:@"快来看看，距离近、工资高，感觉很适合你！" URL:(NSString *)info];
        } CancelTitle:@"取消分享" CancelClick:^(UIButton *button) {
            
        }];
    }
    ////////////分享APP//////////
    else if (amount.integerValue == -1){
        view = [[shareView alloc]initWithTitle:@"分享APP" Message:nil Channels:shareChannels ChannelClick:^(UIButton *button) {
            NSDictionary * channelInfo = shareChannels[button.tag];
            NSNumber * type = channelInfo[@"type"];
            [self shareWebPageToPlatformType:type.integerValue WithTitle:title Desr:@"当天报名、当天面试、快速上岗" URL:(NSString *)info];
        } CancelTitle:@"取消分享" CancelClick:^(UIButton *button) {
        }];
    }
    [self.tabBarController.view addSubview:view];
//    [view makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType WithTitle:(NSString * )title Desr:(NSString * )desr URL:(NSString *)url{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    NSString * shareTitle = title;
//    NSString * imageStr = TARGET == 2?@"icon_jzb":@"icon_xl";
        ////////////如果是新浪微博那么图文分享//////////
    if (platformType == UMSocialPlatformType_Sina) {
        //设置文本
        messageObject.text = [NSString stringWithFormat:@"%@，%@ %@",shareTitle,desr,url];
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        //如果有缩略图，则设置缩略图
//        shareObject.thumbImage = [UIImage imageNamed:imageStr];
//        shareObject.shareImage = [UIImage imageNamed:imageStr];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
    }
    else{
//        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareTitle descr:desr thumImage:[UIImage imageNamed:imageStr]];
//        //设置网页地址
//        shareObject.webpageUrl = url;
//        //分享消息对象设置分享内容对象
//        messageObject.shareObject = shareObject;
    }
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
//            NSDictionary * urlDic = [NSString resolveURLWithURLString:url];
//            NSString * path = @"/v4/jobs/share";
//            NSDictionary * parameter = @{@"user_id":KUserID?:@"",
//                                         @"job_id":urlDic[@"uuid"]?:@""};
//            [self requestPOST:path parameter:parameter result:nil];
        }
    }];
}
#pragma mark ---------------- 弹框提示
/**
    展示一些错误 或提示信息
 */
- (void)showAlertWithInfo:(NSString *)str{
    if (!str.length) {
        return;
    }
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = KMainColor;
    view.layer.cornerRadius = 10.0;
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowRadius = 10.0;
    view.layer.shadowOpacity = 5;
    view.clipsToBounds = YES;
    view.alpha = 0.0;
    
    UILabel *alert = [[UILabel alloc]init];
    alert.bounds   = CGRectMake(0, 0, 180, 30);
    alert.numberOfLines = 0;
    //alert.backgroundColor = [UIColor colorWithWhite:.2 alpha:.8];
    alert.text = str;
    alert.textColor = [UIColor whiteColor];
    alert.textAlignment = NSTextAlignmentCenter;
    alert.font = [UIFont systemFontOfSize:12];
    
    [alert sizeThatFits:CGSizeMake(180, 60)];
    view.frame   = CGRectMake(0, 0, 196,alert.frame.size.height +8);
    view.center  = CGPointMake(kScreen_Width / 2, kScreen_Height/2);
    
    alert.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
    
    [view addSubview:alert];
    [self.navigationController.view addSubview:view];
    [UIView animateWithDuration:.5 animations:^{
        view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.5 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
            view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
}
- (void)showAlertWithTitle:(NSString *)title msg:(NSString *)message cancelTitle:(NSString *)cancelTitle sTitle:(NSString *)sureTitle  cancelBlock:(void (^)())cancelBlock otherBlock:(void (^)())otherBlock{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if (cancelBlock) {
                cancelBlock();
            }
        }];
        [cancelAction setValue:[UIColor colorWithHexString:@"999999"] forKey:@"titleTextColor"];
        [alertController addAction:cancelAction];
    }
    if (sureTitle) {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (otherBlock) {
                otherBlock();
            }
        }];
        [otherAction setValue:KMainColor forKey:@"titleTextColor"];
        
        // Add the actions.
        
        [alertController addAction:otherAction];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)showAlertWithSystemInfo{
    //NSString * message  = [NSString stringWithFormat:@"请到设置->%@->位置->使用应用期间,打开定位服务，否则你将无法上岗",KAPPName];
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"警告" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
//        [[UIApplication sharedApplication] openURL:url];
//    }];
//    [alert show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 百度定位
/**
 开始定位
 */
-(void)getLocation{
    ////////////检测是否开启定位//////////
    if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        //定位不能用
        [self showAlertWithTitle:@"请允许小劳招聘获取位置信息" msg:@"我们需要获取位置信息，为您推荐附近职位；否则您将无法正常使用小劳招聘" cancelTitle:@"取消" sTitle:@"去开启" cancelBlock:nil otherBlock:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
    }
    [self.locService startUserLocationService];
}
-(void)startGetLocationOnCompleted:(void(^)(BMKUserLocation * loction))CompletedSuccess error:(void(^)(NSError * error))failed{
    ////////////检测是否开启定位//////////
    if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        //定位不能用
        NSString * title = [NSString stringWithFormat:@"请允许%@获取位置信息",KAPPName];
        NSString * message = [NSString stringWithFormat:@"我们需要获取位置信息，为您推荐附近职位；否则您将无法正常使用%@",KAPPName];
        [self showAlertWithTitle:title msg:message cancelTitle:@"取消" sTitle:@"去开启" cancelBlock:nil otherBlock:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        //执行failed
        if (failed) {
            NSError * error = [[NSError alloc]init];
            failed(error);
        }
    }
    [self.locService startUserLocationService];
    if (CompletedSuccess) {
        _CompletedGetLocation = CompletedSuccess;
    }else
        _CompletedGetLocation = ^(BMKUserLocation * location){};
    
    if (failed) {
        _failedGetLocation = failed;
    }else
        _failedGetLocation = ^(NSError * error){};
}
#pragma mark BMKLoctionDelegate
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser{
    
}
/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    NSLog(@"改变了位置");
    NSLog(@"_loca %f",userLocation.location.coordinate.latitude);
   // [self showAlertWithInfo:@"位置改了"];
    NSString * latitudestr = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    NSString * longititudestr = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    [[NSUserDefaults standardUserDefaults]setObject:latitudestr    forKey:kLatitudeKey];
    [[NSUserDefaults standardUserDefaults]setObject:longititudestr forKey:KLongititudeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if (_CompletedGetLocation) {
       _CompletedGetLocation(userLocation);
    }
    [self.locService stopUserLocationService];
}
/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser{
    NSLog(@"stop locate");
}
/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"location error ");
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:kLatitudeKey];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:KLongititudeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if (_failedGetLocation) {
        _failedGetLocation(error);
    }
    [self.locService stopUserLocationService];
    NSString     * urlPath = @"/baidu/log";
    NSDictionary * parmtar = @{@"user_id":KUserID?KUserID:@"",@"longitude":@"",@"latitude":@"",@"device_id":KDeviceID,@"error_code":[NSString stringWithFormat:@"%ldd",(long)error.code]};
    [self requestPOST:urlPath parameter:parmtar result:^(NSDictionary *response) {
    }];
}
#pragma mark
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    NSString * address = [NSString stringWithFormat:@"%@%@",result.addressDetail.streetName,result.addressDetail.streetNumber];
    NSLog(@"result %@",address);
    if (result && _CompletedGetGeo) {
         _CompletedGetGeo(result);
    }
    if (error && _failedGetGeo) {
        _failedGetGeo(error);
    }
}
-(void)geoAddressWith:(CLLocationCoordinate2D)coorder Complete:(void (^)(BMKReverseGeoCodeResult *))completedSuccess error:(void (^)(BMKSearchErrorCode))faild{
    BMKReverseGeoCodeOption * reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = coorder;
    [_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
    if (completedSuccess) {
        _CompletedGetGeo = completedSuccess;
    }else
        _CompletedGetGeo = ^(BMKReverseGeoCodeResult * result){};
    if (faild) {
        _failedGetGeo = faild;
    }else
        _failedGetGeo = ^(BMKSearchErrorCode  error){};
}
#pragma mark - 报告位置
-(void)postAddressWithInfo:(NSDictionary*)info{
    NSMutableArray * locArray = [[NSUserDefaults standardUserDefaults]objectForKey:KlocArray];
    if (!locArray) {
        locArray = [[NSMutableArray alloc]init];
    }
    [locArray addObject:info];
    NSString * json = [self DicToString:locArray];
    NSString     * urlPath = @"/registration/tracklocation";
    NSDictionary * parmtar = @{@"offline_data":json};
    [self requestPOST:urlPath parameter:parmtar progress:nil result:^(NSDictionary *response) {
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:KlocArray];
        [[NSUserDefaults standardUserDefaults]synchronize];
    } failed:^(NSURLSessionTask *task, NSError *error) {
        [[NSUserDefaults standardUserDefaults]setObject:locArray forKey:KlocArray];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }];
}
#pragma mark ---------------------------- 初始化播放器-------------------------
- (void)initAVPlayer:(NSURL *)url{

    AVPlayerViewController *playerView = [[AVPlayerViewController alloc]init];
    //AVPlayerItem 视频的一些信息  创建AVPlayer使用的
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:url];
    //通过AVPlayerItem创建AVPlayer
    AVPlayer *player = [[AVPlayer alloc]initWithPlayerItem:item];
    //给AVPlayer一个播放的layer层
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    layer.frame = CGRectMake(0, 64, self.view.frame.size.width, kScreen_Width - 66 - 64);
    //设置AVPlayer的填充模式
    layer.videoGravity = AVLayerVideoGravityResizeAspect;
    //设置AVPlayerViewController内部的AVPlayer为刚创建的AVPlayer
    playerView.player = player;
    //关闭AVPlayerViewController内部的约束
    playerView.view.translatesAutoresizingMaskIntoConstraints = YES;
    
    [self presentViewController:playerView animated:YES completion:nil];
    
}

#pragma mark ---------------------------- 正在下载 -------------------------
- (NSString *)downingResouse{
    NSArray *valueArray  = KGetDownArray;
    NSInteger count = 0;
    
    HSDownloadManager *manager =  [HSDownloadManager sharedInstance];
    for (int i = 0; i < valueArray.count; ++i) {
        NSDictionary *tmp = valueArray[i];
        //FilePath
        NSArray * fileArray = [tmp[@"FilePath"] componentsSeparatedByString:@"/"];
        NSString * userPath = [fileArray objectAtIndex:fileArray.count -2];
        if (userPath) {
            if ([userPath hasPrefix:KUserID]) {
                NSString *url = tmp[@"url"];
                count = [manager progress:url] != 1 ? count + 1 : count;
            }
        }
    }
    return [NSString stringWithFormat:@"%ld", (long)count];
}

- (BOOL)isDownTask{
    NSArray *valueArray  = KGetDownArray;
    
    HSDownloadManager *manager =  [HSDownloadManager sharedInstance];
    for (int i = 0; i < valueArray.count; ++i) {
        NSDictionary *tmp = valueArray[i];
        NSString *url = tmp[@"url"];
        if ([manager fileCurrentState:url] == DownloadStateStart){
            return YES;
        }
        
    }
    return  NO;
}
#pragma mark ---------------------------- IM Tools -------------------------
//json对象转json字符串
- (NSString*)DicToString:(id)jsonObj{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObj options:0 error:&parseError];
    NSString *policyStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    policyStr = [policyStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    policyStr = [policyStr stringByReplacingOccurrencesOfString:@" " withString:@""];

    return  policyStr;
}
/**
 josn转字符串
 */
-(NSDictionary *)StringToDic:(NSString *)temps{
    NSError *error = nil;
    NSDictionary *string2dic = [NSJSONSerialization JSONObjectWithData: [temps dataUsingEncoding:NSUTF8StringEncoding]
                                                               options: NSJSONReadingMutableContainers
                                                                 error: &error];
    return string2dic;
}

-(NSMutableDictionary *)getCustomUserData{
    NSMutableDictionary *customDic = [NSMutableDictionary dictionary];
    [customDic setObject:@"0" forKey:@"type"];
    [customDic setObject: [[NSUserDefaults standardUserDefaults] objectForKey:KUserIconKey] forKey:@"portrait"];
    [customDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KUserNameKey] forKey:@"nickname"];
    return customDic;
}

- (NSString *)getCurrentDay{
//    NSDate *date = [NSDate date];
//    NSString *string = [NSDate stringWithDate:date format:@"yyyy-MM-dd"];
//    return string;
    return @"";
}
- (void)dealloc{
        NSLog(@"dealloc: %@",self.title?:NSStringFromClass([self class]));
}
#pragma mark getter setter
-(AFAppDotNetAPIClient*)smanager{
    if (!_smanager) {
        _smanager = [AFAppDotNetAPIClient sharedClient];
        [_smanager.requestSerializer setValue:@"1631522762103358" forHTTPHeaderField:@""];
    }
    return _smanager;
}
-(BMKLocationService *)locService{
    if (!_locService) {
        _locService = [[BMKLocationService alloc]init];
    }
    return _locService;
}
-(BMKLocationService *)punchLocService{
    if (!_punchLocService) {
        _punchLocService = [[BMKLocationService alloc]init];
    }
    return _punchLocService;
}
-(BMKGeoCodeSearch*)geoCodeSearch{
    if (!_geoCodeSearch) {
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    }
    return _geoCodeSearch;
}
-(MBProgressHUD *)HUD{
    if (!_HUD) {
        _HUD = [[MBProgressHUD alloc]init]; //WithView:self.view];
        _HUD.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        UIActivityIndicatorView * activity = [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]];
        activity.color = KMainColor;
        _HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        _HUD.bezelView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_HUD];
//        [_HUD makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(0);
//            make.right.equalTo(0);
//            make.top.equalTo(0);
//            make.bottom.equalTo(0);
//        }];
    }
    return _HUD;
}

-(userObject *)userInfoObject{
    if (!_userInfoObject) {
        _userInfoObject = [userObject shareInstance];
    }
    return _userInfoObject;
}
-(MYCodeView *)codeView{
    if (!_codeView) {
        _codeView = [[MYCodeView alloc]initWithFrame:CGRectMake((kScreen_Width - 280)/2, 100, 280, 152)];
//        [_codeView.cancelButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
//            [self hideNoticeBgView];
//        }];
    }
    return _codeView;
}
- (UIView *)grayBgView{
    if (!_grayBgView) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
        view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(grayBgViewTap:)];
        [view addGestureRecognizer:tap];
        _grayBgView = view;
    }
    return _grayBgView;
}
- (void)grayBgViewTap:(UITapGestureRecognizer *)gester{
    UIView * view = gester.view;
    [view removeFromSuperview];
}
@end
