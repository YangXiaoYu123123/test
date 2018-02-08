//
//  WKWebViewController.m
//  jZB_iOS2.0
//
//  Created by 马彦飞 on 2017/8/8.
//  Copyright © 2017年 jzb_iOS. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
#define KMainColor [UIColor colorWithRed:59.0/255.0 green:194.0/255.0 blue:168.0/255.0 alpha:1]

@interface WKWebViewController ()<UIWebViewDelegate,NSURLConnectionDelegate>
@property (nonatomic,strong)UIWebView * web;
@property (nonatomic,assign)BOOL  isAuthed;
@property (nonatomic,strong)NSURLRequest   * originRequest;

@property (nonatomic, strong) CALayer *progresslayer;
@property (nonatomic, strong)  WKWebView *webView;
@end

@implementation WKWebViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[MobClick beginLogPageView:@"H5"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[MobClick endLogPageView:@"H5"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 2)];
    progress.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:progress];
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 2);
    layer.backgroundColor = KMainColor.CGColor;
    [progress.layer addSublayer:layer];
    self.progresslayer = layer;
    NSLog(@"\n url ************ \n %@ \n ***********\n",_url.absoluteString);
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    if (_url) {
        WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 66, CGRectGetWidth(self.view.frame),screenHeight - 66)];
        [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [self.view addSubview:webView];
        NSURLRequest * re = [[NSURLRequest alloc]initWithURL:_url];
        [webView loadRequest:re];
        self.webView = webView;
        return;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progresslayer.opacity = 1;
        //不要让进度条倒着走...有时候goback会出现这种情况
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            return;
        }
        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[@"new"] floatValue], 3);
        if ([change[@"new"] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
@end
