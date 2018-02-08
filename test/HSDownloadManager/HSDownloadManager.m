//
//  HSDownloadManager.m
//  HSDownloadManagerExample
//
//  Created by hans on 15/8/4.
//  Copyright © 2015年 hans. All rights reserved.
//



#import "HSDownloadManager.h"
#import "NSString+Hash.h"

#define KGetDownArray       [[NSUserDefaults standardUserDefaults]objectForKey:@"KDownValue"]

#define KUserID       [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"]

#define HSCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"HSCache/%@",KUserID]]

#define HSTotalLengthFullpath [HSCachesDirectory stringByAppendingPathComponent:@"totalLength.plist"]

#define HSFileName(url)  [NSString stringWithFormat:@"%@.%@",url.md5String, url.urlType]

#define KSetDownDic(dic)    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"KDownValue"]

#define KNSUserDefaultsSynchronize [[NSUserDefaults standardUserDefaults]synchronize]

@interface HSDownloadManager()<NSCopying, NSURLSessionDelegate>

/** 保存所有任务(注：用下载地址md5后作为key) */
@property (nonatomic, strong) NSMutableDictionary *tasks;
/** 保存所有下载相关信息 */
@property (nonatomic, strong) NSMutableDictionary *sessionModels;


@end

@implementation HSDownloadManager

- (NSMutableDictionary *)tasks
{
    if (!_tasks) {
        _tasks = [NSMutableDictionary dictionary];
    }
    return _tasks;
}

- (NSMutableDictionary *)sessionModels
{
    if (!_sessionModels) {
        _sessionModels = [NSMutableDictionary dictionary];
    }
    return _sessionModels;
}


static HSDownloadManager *_downloadManager;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _downloadManager = [super allocWithZone:zone];
        _downloadManager.taskCount = 0;
    });
    
    return _downloadManager;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone
{
    return _downloadManager;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _downloadManager = [[self alloc] init];
    });
    
    return _downloadManager;
}

/**
 *  创建缓存目录文件
 */
- (void)createCacheDirectory{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:HSCachesDirectory]) {
        [fileManager createDirectoryAtPath:HSCachesDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

/**
 *  仅仅替换block 解决页面不刷新问题
 */
- (void)downloadChangeBlock:(NSString *)url progress:(void (^)(NSInteger, NSInteger, CGFloat))progressBlock state:(void (^)(DownloadState))stateBlock{
    NSURLSessionDataTask *task = [self getTask:url];
    [self getSessionModel:task.taskIdentifier].progressBlock = progressBlock;
    [self getSessionModel:task.taskIdentifier].stateBlock = stateBlock;
    return;
}


/**
 *  开启任务下载资源
 */
- (void)download:(NSString *)url name:(NSString *)name progress:(void (^)(NSInteger, NSInteger, CGFloat))progressBlock state:(void (^)(DownloadState))stateBlock{
    if (!url) return;
    if ([self isCompletion:url]) {
        stateBlock(DownloadStateCompleted);
        NSLog(@"----该资源已下载完成");
        return;
    }
    
    // 暂停
    if ([self.tasks valueForKey:HSFileName(url)]) {
         NSURLSessionDataTask *task = [self getTask:url];
        [self getSessionModel:task.taskIdentifier].progressBlock = progressBlock;
        [self getSessionModel:task.taskIdentifier].stateBlock = stateBlock;
        
        
        [self handle:url];
        
        return;
    }
    
    // 创建缓存目录文件
    [self createCacheDirectory];
    
    NSMutableArray *array =  [[NSMutableArray alloc] initWithArray:KGetDownArray];
    NSDictionary *dic = @{@"name":name,
                          @"url":url,
                          @"FilePath":HSFileFullpath(url)};
    BOOL isHave = YES;
    for (int i = 0; i < array.count; ++i) {
        NSDictionary *dic = array[i];
        if ([dic[@"url"] isEqualToString:url]) {
            isHave = NO;
        }
    }
    if (isHave == YES) {
        [array insertObject:dic atIndex:0];
        KSetDownDic(array);
        KNSUserDefaultsSynchronize;
    }
    
   NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    
    // 创建流
    NSOutputStream *stream = [NSOutputStream outputStreamToFileAtPath:HSFileFullpath(url) append:YES];
    
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // 设置请求头
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", HSDownloadLength(url)];
    [request setValue:range forHTTPHeaderField:@"Range"];
        
    // 创建一个Data任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    //NSDate *date = [NSDate date];
    //[date timeIntervalSince1970];
    NSUInteger taskIdentifier =   arc4random() % ((arc4random() % 10000 + arc4random() % 10000));
    [task setValue:@(taskIdentifier) forKeyPath:@"taskIdentifier"];

    // 保存任务
    [self.tasks setValue:task forKey:HSFileName(url)];

    HSSessionModel *sessionModel = [[HSSessionModel alloc] init];
    sessionModel.url = url;
    sessionModel.progressBlock = progressBlock;
    sessionModel.stateBlock = stateBlock;
    sessionModel.stream = stream;
    [self.sessionModels setValue:sessionModel forKey:@(task.taskIdentifier).stringValue];
    
    _taskCount++;
    
    [self start:url];
}


- (void)handle:(NSString *)url
{
    NSURLSessionDataTask *task = [self getTask:url];
    if (task.state == NSURLSessionTaskStateRunning) {
        [self pause:url];
        _taskCount--;
    } else {
        [self start:url];
        _taskCount++;
    }
}

/**
 *  开始下载
 */
- (void)start:(NSString *)url
{
    NSURLSessionDataTask *task = [self getTask:url];
    [task resume];

    [self getSessionModel:task.taskIdentifier].stateBlock(DownloadStateStart);
}

/**
 *  暂停下载
 */
- (void)pause:(NSString *)url
{
    NSURLSessionDataTask *task = [self getTask:url];
    [task suspend];

    [self getSessionModel:task.taskIdentifier].stateBlock(DownloadStateSuspended);
}

/**
 *  根据url获得对应的下载任务
 */
- (NSURLSessionDataTask *)getTask:(NSString *)url
{
    return (NSURLSessionDataTask *)[self.tasks valueForKey:HSFileName(url)];
}

/**
 *  根据url获取对应的下载信息模型
 */
- (HSSessionModel *)getSessionModel:(NSUInteger)taskIdentifier
{
    return (HSSessionModel *)[self.sessionModels valueForKey:@(taskIdentifier).stringValue];
}

/**
 *  判断该文件是否下载完成
 */
- (BOOL)isCompletion:(NSString *)url{
    if ([self fileTotalLength:url] < 10240) {
        return NO;
    }
    
    if ([self fileTotalLength:url] && HSDownloadLength(url) == [self fileTotalLength:url] ) {
        return YES;
    }
    return NO;
}

/**
 *  查询该资源的下载进度值
 */
- (CGFloat)progress:(NSString *)url
{
    return [self fileTotalLength:url] == 0 ? 0.0 : 1.0 * HSDownloadLength(url) /  [self fileTotalLength:url];
}

/**
 *  获取状态
 */
- (DownloadState )fileCurrentState:(NSString *)url{
    NSURLSessionDataTask *task = [self getTask:url];
    DownloadState state;
    switch (task.state) {
        case NSURLSessionTaskStateCompleted:
        {
            state =  DownloadStateCompleted;
        }
            break;
        case NSURLSessionTaskStateRunning:
        {
            state =  DownloadStateStart;
            if (task == nil) {
                state =  DownloadStateSuspended;
            }
            if ([[HSDownloadManager sharedInstance] progress:url] == 1) {
                state =  DownloadStateCompleted;
            }
        }
            break;
        case NSURLSessionTaskStateSuspended:
        {
            state =  DownloadStateSuspended;
        }
            break;
        case NSURLSessionTaskStateCanceling:
        {
            state =  DownloadStateFailed;
        }
            break;            
        default:
            break;
    }
    
    
    return state;
}


/**
 *  获取该资源总大小
 */
- (NSInteger)fileTotalLength:(NSString *)url
{
    return [[NSDictionary dictionaryWithContentsOfFile:HSTotalLengthFullpath][HSFileName(url)] integerValue];
}

#pragma mark - 删除
/**
 *  删除该资源
 */
- (void)deleteFile:(NSString *)url
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:HSFileFullpath(url)]) {

        NSURLSessionDataTask *task = self.tasks[HSFileName(url)];
        [task cancel];
        
        // 删除沙盒中的资源
        [fileManager removeItemAtPath:HSFileFullpath(url) error:nil];
        // 删除任务
        [self.tasks removeObjectForKey:HSFileName(url)];
        [self.sessionModels removeObjectForKey:@([self getTask:url].taskIdentifier).stringValue];
        // 删除资源总长度
        if ([fileManager fileExistsAtPath:HSTotalLengthFullpath]) {
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:HSTotalLengthFullpath];
            [dict removeObjectForKey:HSFileName(url)];
            [dict writeToFile:HSTotalLengthFullpath atomically:YES];
        }
    }
}

/**
 *  清空所有下载资源
 */
- (void)deleteAllFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:HSCachesDirectory]) {
        // 删除沙盒中所有资源
        [fileManager removeItemAtPath:HSCachesDirectory error:nil];
        // 删除任务
        [[self.tasks allValues] makeObjectsPerformSelector:@selector(cancel)];
        [self.tasks removeAllObjects];
        
        for (HSSessionModel *sessionModel in [self.sessionModels allValues]) {
            [sessionModel.stream close];
        }
        [self.sessionModels removeAllObjects];
        
        // 删除资源总长度
        if ([fileManager fileExistsAtPath:HSTotalLengthFullpath]) {
            [fileManager removeItemAtPath:HSTotalLengthFullpath error:nil];
        }
    }
}

/**
 * stop所有下载
 */
- (void)StopAllFile{
    NSArray *valueArray   = KGetDownArray;
    for (int i = 0; i < valueArray.count; ++i) {
        NSDictionary *tmp = valueArray[i];
        NSString *url = tmp[@"url"];
        NSURLSessionDataTask *task = [self getTask:url];
        [task suspend];
    }
    

}

#pragma mark - 代理
#pragma mark NSURLSessionDataDelegate
/**
 * 接收到响应
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    
    HSSessionModel *sessionModel = [self getSessionModel:dataTask.taskIdentifier];
    
    // 打开流
    [sessionModel.stream open];
    
    if ([response.allHeaderFields[@"Content-Length"] isEqualToString:@"application/xml"]) {
        return;
    }
    // 获得服务器这次请求 返回数据的总长度
    NSInteger totalLength = [response.allHeaderFields[@"Content-Length"] integerValue] + HSDownloadLength(sessionModel.url);
    sessionModel.totalLength = totalLength;
    
    // 存储总长度
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:HSTotalLengthFullpath];
    if (dict == nil) dict = [NSMutableDictionary dictionary];
    dict[HSFileName(sessionModel.url)] = @(totalLength);
    [dict writeToFile:HSTotalLengthFullpath atomically:YES];
    
    // 接收这个请求，允许接收服务器的数据
    completionHandler(NSURLSessionResponseAllow);
}

/**
 * 接收到服务器返回的数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    HSSessionModel *sessionModel = [self getSessionModel:dataTask.taskIdentifier];
    
    // 写入数据
    [sessionModel.stream write:data.bytes maxLength:data.length];
    
    // 下载进度
    NSUInteger receivedSize = HSDownloadLength(sessionModel.url);
    NSUInteger expectedSize = sessionModel.totalLength;
    CGFloat progress = 1.0 * receivedSize / expectedSize;
    
    sessionModel.progressBlock(receivedSize, expectedSize, progress);
    
}

/**
 * 请求完毕（成功|失败）
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    HSSessionModel *sessionModel = [self getSessionModel:task.taskIdentifier];
    if (!sessionModel) return;
    
    if ([self isCompletion:sessionModel.url]) {
        // 下载完成
        _taskCount--;
        sessionModel.stateBlock(DownloadStateCompleted);
    } else if (error){
        
        // 下载失败
        sessionModel.stateBlock(DownloadStateFailed);
     //   [self deleteFile:sessionModel.url];
    }
    // 关闭流
    [sessionModel.stream close];
    sessionModel.stream = nil;
    
    // 清除任务
    [self.tasks removeObjectForKey:HSFileName(sessionModel.url)];
    [self.sessionModels removeObjectForKey:@(task.taskIdentifier).stringValue];
}

- (NSString *)getDownURL:(NSString *)url{
    return  HSFileFullpath(url);
}

@end