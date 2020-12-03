//
//  ExternalSystemRequests.h
//  MyFrameworkTestProject
//
//  Created by 汪伟 on 2020/9/4.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 请求完成
typedef void(^RequestSuccessBlock)(id obj);
/// 请求失败
typedef void(^RequestErrorBlock)(NSError *error , id result);

@interface ExternalSystemRequests : NSObject

/*
 *创建设备外部id
 *设备在平台创建设备之后，平台将分配唯一的设备id，该接口用于绑定设备创建完成后与设备序列号的关联。 后续设备侧进行发送测量值和告警时可以根据设备序列号反向索引到平台侧分配的唯一id。
 *deviceid 设备id
 *body  @{@"externalId":@"32FFDA05344736315433993",@"type":@"air-c8y_Serial"};
*/
+(void)externalAuthorization:(NSString*)authorization device:(NSString*)deviceid managedObjects:(NSDictionary*)body success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询设备支持的外部id类型
 *deviceid 设备id
 */
+(void)externalQueryExternalTypeAuthorization:(NSString*)authorization device:(NSString*)deviceid success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询特定外部id关联的设备对象
 *deviceid 设备id
 */
+(void)externalQueryAssociatedDeviceAuthorization:(NSString*)authorization externalType:(NSString*)type externalId:(NSString*)externalid success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *解绑外部系统与设备的绑定
 *deviceid 设备id
 */
+(void)externalDisconnectionExternalDeviceAuthorization:(NSString*)authorization externalType:(NSString*)type externalId:(NSString*)externalid success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;



@end

NS_ASSUME_NONNULL_END
