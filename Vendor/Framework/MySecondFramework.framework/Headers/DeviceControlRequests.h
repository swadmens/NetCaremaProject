//
//  DeviceControlRequests.h
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

@interface DeviceControlRequests : NSObject

/*
 *创建shell操作
 *设备操作用于在平台侧下发指令到设备，设备识别指令后需要反馈执行状态如“已收到指令，执行中”，“执行结果（成功或失败原因）”
 * deviceId  设备id
 *c8y_Command  命令操作片段对象
 * text 命令内容
 * description  描述
 *
 *body  {
     "deviceId": "22251",
     "c8y_Command": {
         "text": "restart"
     },
     "description": "重启"
 }
*/
+(void)operationsCreateDeviceControlAuthorization:(NSString*)authorization managedObjects:(NSDictionary*)body success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询操作集合
 *startTime 开始时间 2020-09-01
 *endTime 结束时间 2020-09-02
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)operationsQueryOperationsCollectionAuthorization:(NSString*)authorization dateFrom:(NSString*)startTime dateTo:(NSString*)endTime pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询指定设备的操作集合
 *source 设备的id对象
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)operationsQuerySpecifiedDeviceOperationsAuthorization:(NSString*)authorization device:(NSString*)source pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询单个设备操作状态的操作集合
 *source 设备的id对象
 *status status字段("SUCCESSFUL","FAIL","EXECUTING"(执行中)
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)operationsQuerySpecifiedDeviceStatusAuthorization:(NSString*)authorization device:(NSString*)source deviceStatus:(NSString*)status pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询单个设备最后一条操作指令
 *source 设备的id对象
 *revert true为倒序，false为正序
 *numbers  请求数据数量
 */
+(void)operationsQuerySingleDeviceLastOperationsAuthorization:(NSString*)authorization device:(NSString*)source sorting:(NSString*)revert pageSize:(NSString*)numbers success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询指定fragmentType测量值集合
 *type 测量值的片段key c8y_Command
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)operationsQuerySpecifiedFragmentTypeOperationsAuthorization:(NSString*)authorization fragmentType:(NSString*)type pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询挂起状态的操作
 *status 当前待执行的操作状态  PENDING
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)operationsQueryPendingStatusOperationsAuthorization:(NSString*)authorization operationsStatus:(NSString*)status pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询特定操作id的操作
 *opid 操作id
 */
+(void)operationsQuerySpecifiedOperationsIdAuthorization:(NSString*)authorization operationId:(NSString*)opid success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *指定操作id更新操作状态
 *opid 操作id
 *status status字段[PENDING(挂起), SUCCESSFUL(成功), FAILED(失败), EXECUTING(执行中)]
 * 状态为FAIL时，body加入failureReason字段，表示失败原因
 *body
 {
     "status": "FAILED"
     "failureReason": "Could not handle operation"
 }
 */
+(void)operationsUpdataStausSpecifiedOperationsIdAuthorization:(NSString*)authorization operationId:(NSString*)opid operationsObjects:(NSDictionary*)body success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *删除操作
 *startTime 开始时间 2020-09-01T15:00:00+08:00
 *endTime 结束时间 2020-09-02T15:00:00+08:00
 */
+(void)operationsDeleteOperationsAuthorization:(NSString*)authorization dateFrom:(NSString*)startTime dateTo:(NSString*)endTime success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;




@end

NS_ASSUME_NONNULL_END
