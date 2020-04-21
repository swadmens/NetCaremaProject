//
//  AppDelegate.m
//  NetCamera
//
//  Created by 汪伟 on 2020/2/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "GuideViewController.h" // 引导页
#import "GuideNewController.h"//新的引导页

#import "LGXThirdEngine.h" // 第三方管理
//#import <TXLiteAVSDK_Professional/TXLiteAVSDK.h>

//#import "netsdk.h"
//#import "Global.h"


@interface AppDelegate ()
{
    GuideViewController *_guideController;
    GuideNewController *_guideNewController;
}

@end

@implementation AppDelegate

//- (MainViewController *)tabBarController
//{
//    if (_tabBarController == nil) {
//        _tabBarController = (MainViewController *)self.window.rootViewController;
//    }
//    return _tabBarController;
//}
+ (instancetype)sharedDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
- (void)showGuideView
{
        @autoreleasepool {
            _guideController = [[GuideViewController alloc] init];
            _guideController.view.frame = self.window.bounds;
            [self.window addSubview:_guideController.view];
        }
    
//    @autoreleasepool {
//        _guideNewController = [[GuideNewController alloc] init];
//        _guideNewController.view.frame = self.window.bounds;
//        [self.window addSubview:_guideNewController.view];
//    }
    
    
}
- (void)setupGuideView
{
    BOOL isused = [[NSUserDefaults standardUserDefaults] boolForKey:(NSString *)_USEDKEY];
    
    if (!isused) {
        [self showGuideView];
    }else{
        
        NSString *oldversionstring = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)_VERSIONKEY]; //
        NSString *versionstring = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
        if (oldversionstring) {
            if (![versionstring isEqualToString:oldversionstring]) {
                
                // 重新开启打分
                //                [GTOthersMananger openNewVersionScore];
                
                //欢迎界面
                //                _guideController = [[GuideViewController alloc] initWithNibName:@"GuideViewController" bundle:nil];
                //                _guideController.view.frame = self.window.bounds;
                //                [self.window addSubview:_guideController.view];
            }
        }else{
            [[NSUserDefaults standardUserDefaults] setValue:versionstring forKey:(NSString *)_VERSIONKEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    MainViewController *mvc=[[MainViewController alloc]init];
    self.window.rootViewController = mvc;
    
    [self.window makeKeyAndVisible];
    
    
    /// 第三方分享初始化
    [_kThirdManager setupShareSDK];
    /// cookie设置
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

    /// 引导页，判断是否是第一次
//    [self setupGuideView];
    
//    // 如果登录了
//    if (_kUserModel.isLogined) {
//        // 每次进来，进行一次更新用户信息
//        [_kUserModel updateUserInfo];
//    }else{
//        [_kUserModel showLoginView];
//    }
    
    
//    //启动定时器任务
//    [WWPublicMethod timeOneMinutesUploadDevicestatus];
//    [WWPublicMethod timeTwoMinutesUploadDevice];
    
    
    
//    NSString * const licenceURL = @"http://license.vod2.myqcloud.com/license/v1/b658adc20b7dff21c516dcb467c70349/TXLiveSDK.licence";
//    NSString * const licenceKey = @"3312d754191a835966beae0569198869";
//    //TXLiveBase 位于 "TXLiveBase.h" 头文件中
//    [TXLiveBase setLicenceURL:licenceURL key:licenceKey];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
    //注册通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveDownloadList" object:nil userInfo:nil];
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    //注册通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveDownloadList" object:nil userInfo:nil];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    DLog(@"程序被终止了")
    //保存用户登录状态
    _kUserModel.isLogined = _kUserModel.userInfo.save_password;
}



@end
