//
//  Global.h
//  NetSDK_Demo
//
//  Created by NetSDK on 2018/7/9.
//  Copyright © 2018年 NetSDK. All rights reserved.
//

#ifndef Global_h
#define Global_h

#import "netsdk.h"
#import "configsdk.h"
#import <string>

#define TIME_OUT    10000
extern LLONG g_loginID;
extern int g_ChannelCount;
extern int g_AlarmInChannel;
extern int g_AlarmOutChannel;
extern const std::string g_docFolder;
extern long g_nTableRow;
extern NSData *g_deviceToken;
extern NSString *g_szIP;
extern int g_nPort;
extern NSString *g_szUser;
extern NSString *g_szPassword;
extern NSString *g_p2pUsername;


#endif /* Global_h */
