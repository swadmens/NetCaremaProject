//
//  GlobalDefine.h
//  NetSDK_Demo
//
//  Created by NetSDK on 2018/7/5.
//  Copyright © 2018年 NetSDK. All rights reserved.
//

#ifndef GlobalDefine_h
#define GlobalDefine_h

//MARK: - 屏幕尺寸
#define kScreenWidth            [UIScreen mainScreen].bounds.size.width
#define kScreenHeight           [UIScreen mainScreen].bounds.size.height
#define kScreenBounds           [UIScreen mainScreen].bounds

// 苹果X宽高
#define IPHONE_X_SCREEN_WIDTH   375
#define IPHONE_X_SCREEN_HEITHT  812

// 是否是手机
#define isIPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
// 是否是iPhoneX
#define isIPhoneX (kScreenWidth >= IPHONE_X_SCREEN_WIDTH && kScreenHeight >= IPHONE_X_SCREEN_HEITHT && isIPhone)

// 底部安全高度
#define BOTTOM_SAFE_HEIGHT  (isIPhoneX ? 34 : 0)
// 系统手势高度
#define SYSTEM_GESTURE_HEIGHT (isIPhoneX ? 13 : 0)
// 标签栏高度
#define kTabBarHeight   (49 + BOTTOM_SAFE_HEIGHT)
// 状态栏高度
#define kStatusBarHeight   (isIPhoneX ? 44 : 20)
// 导航栏高度
#define kNavigationBarHeight   (isIPhoneX ? 88 : 64)

//MARK: -
#define kUserDefaults           [NSUserDefaults standardUserDefaults]
#define kApplication            [UIApplication sharedApplication]
#define kNotificationCenter     [NSNotificationCenter defaultCenter]

//MARK: - color
#define BUTTON_COLOR [UIColor colorWithRed:0.333 green:0.784 blue:1 alpha:1]
#define BASE_COLOR [UIColor colorWithRed:104/255.0 green:187/255.0 blue:30/255.0 alpha:1]
#define BASE_BACKGROUND_COLOR [UIColor colorWithRed:236/255.0 green:236/255.0 blue:244/255.0 alpha:1]
//#define UIColorFromRGB(rgbValue)                                   \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0    \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]  \

#define kRGBA(r, g, b, a)                                          \
[UIColor colorWithRed:r/255.0                                      \
green:g/255.0                                      \
blue:b/255.0 alpha:a]                             \

#define kRGB(r, g, b) kRGBA(r, g, b, 1)

#define _L(str) NSLocalizedString(str, nil)

#endif /* GlobalDefine_h */
