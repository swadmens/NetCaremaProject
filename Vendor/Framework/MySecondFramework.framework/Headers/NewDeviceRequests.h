//
//  newDeviceRequests.h
//  MyFrameworkTestProject
//
//  Created by 汪伟 on 2020/9/3.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 请求完成
typedef void(^RequestSuccessBlock)(id obj);
/// 请求失败
typedef void(^RequestErrorBlock)(NSError *error , id result);


@interface NewDeviceRequests : NSObject

/*
 *该接口用于注册设备凭证，填写的id可为设备序列号或其它，在此之后将需要进行设备申请接入，用户接受设备接入，设备拉取凭证三个步骤。 亦可使用平台管理页面--设备管理--注册设备来进行注册。
 * number 一般填写设备序列号
 */
+(void)deviceNewRequestsAuthorization:(NSString*)authorization deviceSerialNumber:(NSString*)number success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
*申请接入使用的是平台给予的设备接入账号如下，该账号无页面登录权限。 该接口默认会抛异常，客户端可定时调用直至用户接受了设备接入
*/
+(void)deviceCredentialsAuthorization:(NSString*)authorization deviceSerialNumber:(NSString*)number success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
*该接口用于用户接受设备接入。 可使用平台管理页面--设备管理--注册设备来进行接收。
*/
+(void)deviceAcceptAuthorization:(NSString*)authorization deviceSerialNumber:(NSString*)number success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
*拉取设备凭证的是平台给予的设备接入账号如下，该账号无页面登录权限。 2.将动态下发动态且唯一的账号密码，生成的设备凭证默认为device权限，见平台页面--设备管理--设备凭证
*/
+(void)deviceGetCredentialsAuthorization:(NSString*)authorization deviceSerialNumber:(NSString*)number success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;




@end

NS_ASSUME_NONNULL_END
