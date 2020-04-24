//
//  LGXSMSEngine.m
//  YaYaGongShe
//
//  Created by icash on 16-4-3.
//  Copyright (c) 2016年 iCash. All rights reserved.
//

#import "LGXSMSEngine.h"
//#import <SMS_SDK/SMSSDK.h>
#import "WWPublicMethod.h"
#import "RequestSence.h"
#import "MyMD5.h"


@implementation LGXSMSEngine

+ (void)setupSMS
{
//    [SMSSDK registerApp:_SMSAppKey withSecret:_SMSAppSecret];
}
/// 获取验证码
+ (void)getVerificationCodeWithPhone:(NSString *)phoneNumber withType:(VerificationType)vType result:(SMSFinishedResultHandler)result
{
    NSString *theString = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if (theString.length != 11) { // 不是电话号码
    if ([WWPublicMethod isNumberString:theString] == NO) { // 不是电话号码
        [_kHUDManager showFailedInView:nil withTitle:@"手机号码有误，请重新填写" hideAfter:_kHUDDefaultHideTime onHide:nil];
        if (result) {
            result(NO);
        }
        return;
    }
    [_kHUDManager showActivityInView:nil withTitle:@"正在获取"];
    RequestSence *sence = [[RequestSence alloc] init];
    switch (vType) {
        case VerificationRegister:
            sence.pathURL = @"auth/regcode";
            break;
        case VerificationForget:
            sence.pathURL = @"auth/rpasscode";
            break;
        default:
            break;
    }
    
    sence.params = [MyMD5 updataDic:phoneNumber];
    
    sence.successBlock = ^(id obj) {
        [_kHUDManager showSuccessInView:nil withTitle:[obj objectForKey:@"msg"] hideAfter:_kHUDDefaultHideTime onHide:nil];
        if (result) {
            result(YES);
        }
    };
    sence.errorBlock = ^(NSError *error){
        if (error.userInfo == nil) {
            [_kHUDManager showFailedInView:nil withTitle:@"验证码发送失败" hideAfter:_kHUDDefaultHideTime onHide:nil];
        } else {
            [_kHUDManager showFailedInView:nil withTitle:[error.userInfo objectForKey:@"msg"] hideAfter:_kHUDDefaultHideTime onHide:nil];
        }
        if (result) {
            result(NO);
        }
    };
    [sence sendRequest];
    
    
    /** shareSDK
    [_kHUDManager showActivityInView:nil withTitle:@"正在获取"];
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneNumber zone:@"86" customIdentifier:nil result:^(NSError *error) {
        
        if (error == nil) {
            [_kHUDManager showSuccessInView:nil withTitle:@"验证码已发送" hideAfter:_kHUDDefaultHideTime onHide:nil];
            if (result) {
                result(YES);
            }
        } else {
            [_kHUDManager showFailedInView:nil withTitle:@"验证码发送失败" hideAfter:_kHUDDefaultHideTime onHide:nil];
            if (result) {
                result(NO);
            }
        }
    }];
     */
}
/// 验证验证码
+ (void)commitVerificationCode:(NSString *)code withPhone:(NSString *)phoneNumber result:(SMSFinishedResultHandler)result
{
    NSString *theString = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([WWPublicMethod isNumberString:theString] == NO) { // 不是电话号码
        [_kHUDManager showFailedInView:nil withTitle:@"手机号码有误，请重新填写" hideAfter:_kHUDDefaultHideTime onHide:nil];
        if (result) {
            result(NO);
        }
        return;
    }
    if ([code stringByReplacingOccurrencesOfString:@" " withString:@""].length <=0) {
        [_kHUDManager showFailedInView:nil withTitle:@"请输入验证码" hideAfter:_kHUDDefaultHideTime onHide:nil];
        if (result) {
            result(NO);
        }
        return;
    }
    /*
    [SMSSDK commitVerificationCode:code phoneNumber:phoneNumber zone:@"86" result:^(NSError *error) {
        if (error) {
            if (result) {
                result(NO);
            }
        } else {
            if (result) {
                result(YES);
            }
        }
    }];
     */
}
@end






