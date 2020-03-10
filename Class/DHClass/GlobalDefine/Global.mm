//
//  Global.m
//  NetSDK_Demo
//
//  Created by NetSDK on 2018/7/9.
//  Copyright © 2018年 NetSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"


LLONG g_loginID = 0;
int g_ChannelCount = 0;
int g_AlarmInChannel = 0;
int g_AlarmOutChannel = 0;
const std::string g_docFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] UTF8String];


long g_nTableRow = 0;
NSData *g_deviceToken;
NSString *g_szIP;
int g_nPort;
NSString *g_szUser;
NSString *g_szPassword;

NSString *g_p2pUsername;

