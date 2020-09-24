//
//  SharedClient.m
//  AFTest
//
//  Created by icash on 15-7-22.
//  Copyright (c) 2015年 icash. All rights reserved.
//

#import "SharedClient.h"
#import "RequestSence.h"
#import "AFURLRequestSerialization.h"

#define _DEVURLKey @"ncore.iot.serverURL"



@interface SharedClient ()

@property (nonatomic, readwrite) AFNetworkReachabilityStatus networkStatus;
@property (nonatomic, strong) NSMutableArray *allNetBlocks;
@property (nonatomic, readwrite) NSMutableDictionary *returnDic;

@end

@implementation SharedClient
@synthesize serverURL = _serverURL;

-(NSMutableDictionary *)returnDic{
    if (!_returnDic) {
        _returnDic = [[NSMutableDictionary alloc] init];
    }
    return _returnDic;
}
+ (NSString *)domainURL
{
    NSString *url = nil;
#ifdef DEBUG
    url = [[NSUserDefaults standardUserDefaults] objectForKey:_DEVURLKey];
    if (url == nil) {
        url = @"http://ncore.iot/"; // 开发用的
//        url = @"https://homebay.quarkioe.com/";
    }
#else
    url = @"http://ncore.iot/"; // 正式服务器
//    url = @"https://homebay.quarkioe.com/";
#endif
    return url;
}
+ (NSString *)requestURL
{
    NSString *url = [self domainURL];
//    NSString *middle = @"v2/"; // v1.0.0/
//    url = [NSString stringWithFormat:@"%@/%@",url,middle];
    return url;
}
/// 初始化单例
+ (SharedClient *)sharedInstance
{
    static SharedClient *_client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURL *baseURL = [NSURL URLWithString:[SharedClient requestURL]];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        //        [config setHTTPAdditionalHeaders:@{ @"User-Agent" : @"TuneStore iOS 1.0"}];
        /*
        //设置我们的缓存大小 其中内存缓存大小设置10M  磁盘缓存5M
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                          diskCapacity:50 * 1024 * 1024
                                                              diskPath:nil];
        
        [config setURLCache:cache];
        */
        _client = [[SharedClient alloc] initWithBaseURL:baseURL
                                         sessionConfiguration:config];
        _client.responseSerializer = [AFJSONResponseSerializer serializer];
        _client.requestSerializer = [AFHTTPRequestSerializer serializer];

        _client.networkStatus = AFNetworkReachabilityStatusReachableViaWiFi; // 用_client.reachabilityManager.networkReachabilityStatus;读出来不正确。
        
        /// 注册网络变化
        [_client.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            _client.networkStatus = status;
            [_client.allNetBlocks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NetworkChangedHandle nblock = obj;
                nblock(status);
            }];
        }];
        [_client.reachabilityManager startMonitoring];
        
    });
    return _client;
}
- (NSMutableArray *)allNetBlocks
{
    if (!_allNetBlocks) {
        _allNetBlocks = [NSMutableArray array];
    }
    return _allNetBlocks;
}
- (void)setNetworkStatusDidChanged:(void (^)(AFNetworkReachabilityStatus))networkStatusDidChanged
{
    _networkStatusDidChanged = networkStatusDidChanged;
    if (_networkStatusDidChanged) {
        [self.allNetBlocks addObject:_networkStatusDidChanged];
    }
}
/// 根据参数重建URL
- (NSString *)rebuildURL:(NSString *)url byParams:(NSDictionary *)dict
{
    if ([url isKindOfClass:[NSString class]] == NO || url.length <=0) {
        return nil;
    }
    if ([dict isKindOfClass:[NSDictionary class]] == NO || dict.count <=0) {
        return url;
    }
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (id key in dict) {
        NSString *value = [NSString stringWithFormat:@"%@",[dict objectForKey:key]];
        NSString *exKey = [NSString stringWithFormat:@"%@",key];
        NSString *str = [NSString stringWithFormat:@"%@=%@",[exKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [mutablePairs addObject:str];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *query = [mutablePairs componentsJoinedByString:@"&"];
    
    NSString *finalURL = [[request.URL absoluteString] stringByAppendingFormat:request.URL.query ? @"&%@" : @"?%@", query];
    DLog(@"\n~~~~~拼装好的url=%@\n",finalURL);
    return finalURL;
}
/// 获取公共参
- (NSDictionary *)getPublicParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
//    [params setObject:@"ios" forKey:@"system"];
//    NSString *versionstr = [WWPhoneInfo getAPPVersion];
//    [params setObject:APPVersion forKey:@"version"];
//    if ([_kUserModel.userInfo.session_id isKindOfClass:[NSString class]]) {
//        [params setObject:_kUserModel.userInfo.session_id forKey:@"session_id"];
//    }
    
//    if (![_kUserModel.userInfo.language_lang isEqualToString:@"0"]) {
//        [params setObject:_kUserModel.userInfo.language_lang forKey:@"lang"];
//    }else{
//
//        NSString *udfLanguageCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0];
//        if ([udfLanguageCode isEqualToString:@"en-CN"]) {
//            [params setObject:@"english" forKey:@"lang"];
//        }else if ([udfLanguageCode isEqualToString:@"zh-Hans-CN"]){
//            [params setObject:@"zh_cn" forKey:@"lang"];
//        }else{
//            [params setObject:@"spanish" forKey:@"lang"];
//        }
//    }
 
    return params;
}
/// 添加一些公共参数
- (NSMutableDictionary *)paramsToPublicWith:(NSDictionary *)params
{
    if (params == nil) {
        params = @{};
    }
    NSMutableDictionary *finalParams = [NSMutableDictionary dictionaryWithDictionary:params];
#ifdef DEBUG
    //[finalParams setObject:@"epetdemo2012" forKey:@"testloginpass"];
#else
    
#endif
    [finalParams addEntriesFromDictionary:[self getPublicParams]];

    return finalParams;
}

/// 更新用户地址
- (void)shouldUploadUserLocation
{
//    [_kMapManager uploadUserCurrentLocation];
}

/// get请求
- (NSURLSessionDataTask *)requestGet:(NSString *)url parameters:(NSDictionary *)params completion:( void (^)(id results, NSError *error) )completion
{
    if (self.networkStatus == AFNetworkReachabilityStatusNotReachable || self.networkStatus == AFNetworkReachabilityStatusUnknown) {
        if (completion) {

            NSError *err = [NSError errorWithDomain:self.baseURL.absoluteString code:-1001 userInfo:nil];
            completion(nil, err);
        }
        return nil;
    }
    
    NSURLSessionDataTask *task = [self GET:url parameters:params headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                
        DLog(@"\n~~~~~完成请求地址:%@\n",httpResponse.URL.absoluteString);
            completion(responseObject, nil);
        
//        if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
//            [self.returnDic setValue:responseObject forKey:@"moid"];
//        }

//        DLog(@"Received: %@", responseObject);
//        DLog(@"Received HTTP %ld", (long)httpResponse.statusCode);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        completion(nil, error);
    }];
    return task;
}
/// POST 请求
- (NSURLSessionDataTask *)requestPost:(NSString *)url parameters:(NSDictionary *)params completion:( void (^)(id results, NSError *error) )completion
{
    if (self.networkStatus == AFNetworkReachabilityStatusNotReachable || self.networkStatus == AFNetworkReachabilityStatusUnknown) {
        if (completion) {
            
            NSError *err = [NSError errorWithDomain:self.baseURL.absoluteString code:-1001 userInfo:nil];
            completion(nil, err);
        }
        return nil;
    }
    NSURLSessionDataTask *task = [self POST:url parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        DLog(@"\n~~~~~完成请求地址:%@\n",httpResponse.URL.absoluteString);
        completion(responseObject, nil);
//        DLog(@"Received: %@", responseObject);
//        DLog(@"Received HTTP %ld", (long)httpResponse.statusCode);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        completion(nil, error);
    }];
    
    return task;
}
///上传文件（图片，视频）数据
- (NSURLSessionDataTask *)uploadFiles:(NSArray *)files with:(NSDictionary *)finalParams to:(NSString *)url completion:( void (^)(id results, NSError *error) )completion
{
    if (self.networkStatus == AFNetworkReachabilityStatusNotReachable || self.networkStatus == AFNetworkReachabilityStatusUnknown) {
        if (completion) {
            
            NSError *err = [NSError errorWithDomain:self.baseURL.absoluteString code:-1001 userInfo:nil];
            completion(nil, err);
        }
        return nil;
    }
    
    NSURLSessionDataTask *task = [self POST:url parameters:finalParams headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        for (int i =0; i<files.count; i++) {
            NSDictionary *dic = [files objectAtIndex:i];
            NSString *name = [dic objectForKey:@"name"];
            NSString *fileName = [dic objectForKey:@"fileName"];
            NSString *mimeType = [dic objectForKey:@"mimeType"];
            NSData *data = [dic objectForKey:@"data"];
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil,error);
    }];
  
    
    return task;
}

- (NSURLSessionDataTask*)requestPUTWithURLStr:(NSString *)urlStr paramDic:(NSDictionary *)paramDic Api_key:(NSString *)api_key completion:( void (^)(id results, NSError *error) )completion
{
    if (self.networkStatus == AFNetworkReachabilityStatusNotReachable || self.networkStatus == AFNetworkReachabilityStatusUnknown) {
        if (completion) {
            
            NSError *err = [NSError errorWithDomain:self.baseURL.absoluteString code:-1001 userInfo:nil];
            completion(nil, err);
        }
        return nil;
    }
    
    [self shouldUploadUserLocation];
    
    if (paramDic == nil) {
        paramDic = @{};
    }
    NSMutableDictionary *finalParams=[NSMutableDictionary dictionary];
    finalParams = [self paramsToPublicWith:paramDic];

    DLog(@"\n请求参数 = %@ \n",finalParams);


    NSURLSessionDataTask *task = [self PUT:urlStr parameters:finalParams headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        DLog(@"\n~~~~~完成请求地址:%@\n",httpResponse.URL.absoluteString);
        completion(responseObject, nil);
//        DLog(@"Received: %@", responseObject);
//        DLog(@"Received HTTP %ld", (long)httpResponse.statusCode);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        completion(nil, error);
        
    }];
    
    return task;
}

///DELETE请求
- (NSURLSessionDataTask*)requestDELETEWithURLStr:(NSString *)urlStr paramDic:(NSDictionary *)paramDic completion:( void (^)(id results, NSError *error) )completion
{
    if (self.networkStatus == AFNetworkReachabilityStatusNotReachable || self.networkStatus == AFNetworkReachabilityStatusUnknown) {
        if (completion) {
            
            NSError *err = [NSError errorWithDomain:self.baseURL.absoluteString code:-1001 userInfo:nil];
            completion(nil, err);
        }
        return nil;
    }

    NSURLSessionDataTask *task = [self DELETE:urlStr parameters:paramDic headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                NSLog(@"\n~~~~~完成请求地址:%@\n",httpResponse.URL.absoluteString);
                completion(responseObject, nil);
        //        NSLog(@"Received: %@", responseObject);
        //        NSLog(@"Received HTTP %ld", (long)httpResponse.statusCode);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        completion(nil, error);
    }];
    
    
    return task;
}

- (void)download
{
    
    
    
}
/// 读取cookie
- (NSArray *)readCookies
{
    NSHTTPCookieStorage * storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    // HTTPCookieAcceptPolicy  决定了什么情况下 session 应该接受从服务器发出的 cookie
    // HTTPShouldSetCookies 指定了请求是否应该使用 session 存储的 cookie，即 HTTPCookieSorage 属性的值
    NSArray *cookies = [storage cookies];
    DLog(@"\n cookies = %@ \n",cookies);
    return cookies;
}
/// 清除cookie
- (void)clearCookies
{
    NSArray *arr = [self readCookies];
    NSHTTPCookieStorage * storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [storage deleteCookie:obj];
    }];
}

#pragma mark - 自控参数

- (NSString *)serverURL
{
    if (!_serverURL) {
        _serverURL = [[NSUserDefaults standardUserDefaults] objectForKey:_DEVURLKey];
        if (!_serverURL) {
            _serverURL = @"https://api.vipet.com.cn/"; // 请求地址
        }
    }
    return _serverURL;
}
- (void)setServerURL:(NSString *)serverURL
{
    if ([serverURL isEqualToString:_serverURL]) {
        return;
    }
    _serverURL = serverURL;
    [[NSUserDefaults standardUserDefaults] setObject:_serverURL forKey:_DEVURLKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end








