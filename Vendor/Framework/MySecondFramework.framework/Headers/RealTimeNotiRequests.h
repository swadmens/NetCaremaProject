//
//  RealTimeNotiRequests.h
//  MyFrameworkTestProject
//
//  Created by 汪伟 on 2020/9/7.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 请求完成
typedef void(^RequestSuccessBlock)(id obj);
/// 请求失败
typedef void(^RequestErrorBlock)(NSError *error , id result);

@interface RealTimeNotiRequests : NSObject

/*
 *会话初始化
 *实时通知用于应用接收设备侧上报平台后的实时数据。 订阅步骤：先执行握手会话化获得clientID，再建立会话连接，最后进行会话订阅，接收到响应后重新订阅（此时不需要重新握手）。 在不再使用时请执行会话销毁操作。
 * version  客户端使用的Bayeux协议版本  1.0
 * minimumVersion  客户端需要的服务器端最低Bayeux协议版本。 0.9
 * channel 通道名称 /meta/handshake
 * supportedConnectionTypes  客户端支持的连接类型列表，包括“long-polling”、“callback-polling”、“web-socket”等等类型。
 * advice.timeout 发送连接信息和服务器应答之间的最大毫秒数。60000
 * advice.interval 如果没有从客户端收到下一个连接消息, 超出此时长服务器关闭会话。 0
 *body  {
     "version": "1.0",
     "minimumVersion": "0.9",
     "channel": "/meta/handshake",
     "supportedConnectionTypes": [
         "long-polling"
     ],
     "advice": {
         "timeout": 60000,
         "interval": 0
     }
 }
*/
+(void)sessionInitializeAuthorization:(NSString*)authorization sessionObjects:(id)body success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *会话订阅、取消、连接、销毁
 * channel 通道名称 /meta/subscribe(订阅),/meta/unsubscribe(取消订阅),/meta/connect(连接),/meta/disconnect(销毁)
 * subscription  订阅通道  订阅通道列表如下：以下占位符可使用设备id也可使用“*”通配符
 ***   测量值    /measurement/《deviceId》    CREATE
 ***   托管对象（设备）    /managedobjects/《deviceId》    CREATE,DELETE,UPDATE
 ***   事件    /events/《deviceId》    CREATE,UPDATE
 ***   告警    /alarms/《deviceId》    CREATE,UPDATE
 ***   操作    /operations/《deviceId》    CREATE,UPDATE

 * clientId 握手报文中收到的客户端唯一ID
 *body  {
     "channel": "/meta/subscribe",
     "subscription": "/managedobjects/ * ",
     "clientId": "14z1kta3vdyvo78k11avwsgz4hoo7"
 }
 *会话连接body {
             "channel": "/meta/connect",
             "connectionType": "long-polling",
             "clientId": "14z1kta3vdyvo78k11avwsgz4hoo7"
             }
 
 *会话销毁body {
             "channel": "/meta/disconnect",
             "clientId": "14z1kta3vdyvo78k11avwsgz4hoo7"
             }

*/
+(void)sessionSubscriptionAuthorization:(NSString*)authorization sessionObjects:(id)body success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;



@end

NS_ASSUME_NONNULL_END
