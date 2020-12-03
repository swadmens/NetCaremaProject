//
//  AuditRecordsRequests.h
//  MyFrameworkTestProject
//
//  Created by 汪伟 on 2020/9/8.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 请求完成
typedef void(^RequestSuccessBlock)(id obj);
/// 请求失败
typedef void(^RequestErrorBlock)(NSError *error , id result);


@interface AuditRecordsRequests : NSObject

/*
 *创建日志
 * type  日志类型  Alarm
 * time  产生时间  2011-09-06T12:03:27.845Z
 * text 日志提示  Login failed after 3 attempts.
 * user  用户  xiaoming
 * application  应用名称
 * activity  活动描述
 * severity  日志级别 warning
 *
 *body  {
     "type": "Alarm",
     "time": "2011-09-06T12:03:27.845Z",
     "text": "Login failed after 3 attempts.",
     "user": "xiaoming",
     "application": "",
     "activity": "login",
     "severity": "warning"
 }
*/
+(void)auditCreateAuditRecordAuthorization:(NSString*)authorization managedObjects:(NSDictionary*)body success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询日志集合
 *startTime 开始时间 2020-09-01
 *endTime 结束时间 2020-09-02
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)auditQueryRecordsCollectionAuthorization:(NSString*)authorization dateFrom:(NSString*)startTime dateTo:(NSString*)endTime pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询指定类型日志集合
 *type 日志类型 Alarm
 *startTime 开始时间 2020-09-01
 *endTime 结束时间 2020-09-02
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)auditQueryRecordTypeAuthorization:(NSString*)authorization recordsType:(NSString*)type dateFrom:(NSString*)startTime dateTo:(NSString*)endTime pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *删除日志
 *startTime 开始时间 2020-09-01T15:00:00+08:00
 *endTime 结束时间 2020-09-02T15:00:00+08:00
 */
+(void)auditDeleteRecordsAuthorization:(NSString*)authorization dateFrom:(NSString*)startTime dateTo:(NSString*)endTime success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;


@end

NS_ASSUME_NONNULL_END
