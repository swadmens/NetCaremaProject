//
//  AppDelegate.h
//  NetCamera
//
//  Created by 汪伟 on 2020/2/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (instancetype)sharedDelegate;
    @property (strong, nonatomic) MainViewController *tabBarController;
- (void)showGuideView;

@end

