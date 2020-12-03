//
//  AlarmSystemRequests.h
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

@interface AlarmSystemRequests : NSObject

/*
*该接口用于提示用户设备侧故障和希望用户得知的警告信息。 作用于已在平台侧创建的设备，同一设备只会存在一条一个类型的激活告警，当设备重复发送同一类型告警将持续增加，直至用户标记为clear。 支持动态的业务片段，如下方的customkey的键值对，存入后可通过fragmentType查询。
 * source  --  source.id  (21782)  设备的id
 * type (TestAlarm)报警类型
 * text （I am an alarm） 告警提示
 * severity 告警级别，CRITICAL（严重）,MAJOR（主要）,MINOR(一般), WARNING（警告)
 * status 告警状态，（ACTIVE（激活）,ACKNOWLEDGED（确认）,CLEARED（清除)
 * time （2014-03-03T12:03:27.845Z） 告警时间
 * customkey （customValue） 自定义业务片段，非必须可不使用
 *
 *body  @{@"type":@"testAlarm",@"text":@"I am an alarm",@"severity":@"MINOR",@"severity":@"MINOR",@status:@"ACTIVE",@"time":@"2020-09-04T12:03:27.845Z",@"customkey":@{@"id":@"12234"}};
*/
+(void)alarmCreateAlarmsAuthorization:(NSString*)authorization managedObjects:(NSDictionary*)body success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询报警集合
 *该接口可不填任何查询参数，将可以查询到对应租户下的所有的告警
 *startTime 开始时间 2020-07-12
 *endTime 结束时间 2020-09-04
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)alarmQueryAlarmCollectionAuthorization:(NSString*)authorization dateFrom:(NSString*)startTime dateTo:(NSString*)endTime pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询激活状态的报警集合
 *该接口描述获取激活状态的告警的方式，参数status在该情景下为必填
 *status 告警状态，（ACTIVE（激活）,ACKNOWLEDGED（确认）,CLEARED（清除)
 *startTime 开始时间 2020-07-12
 *endTime 结束时间 2020-09-04
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)alarmQueryAlarmActiveAuthorization:(NSString*)authorization alarmStatus:(NSString*)status dateFrom:(NSString*)startTime dateTo:(NSString*)endTime pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;


/*
 *查询指定设备激活状态的告警
 *该接口描述获取指定设备激活状态的告警的方式，参数status和source在该情景下为必填
 *status 告警状态，（ACTIVE（激活）,ACKNOWLEDGED（确认）,CLEARED（清除)
 *deviceid 设备id
 *startTime 开始时间 2020-07-12
 *endTime 结束时间 2020-09-04
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)alarmQueryDeviceAlarmStatusAuthorization:(NSString*)authorization alarmStatus:(NSString*)status source:(NSString*)deviceid dateFrom:(NSString*)startTime dateTo:(NSString*)endTime pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询指定设备激活状态的主要告警
 *该接口描述获取指定设备激活状态的告警的方式，参数status和source在该情景下为必填
 *status 告警状态，（ACTIVE（激活）,ACKNOWLEDGED（确认）,CLEARED（清除)
 *severity 告警级别，CRITICAL（严重）,MAJOR（主要）,MINOR(一般), WARNING（警告)
 *deviceid 设备id
 *startTime 开始时间 2020-07-12
 *endTime 结束时间 2020-09-04
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)alarmQueryDeviceAlarmStatusSeverityAuthorization:(NSString*)authorization alarmStatus:(NSString*)status alarmSeverity:(NSString*)severity source:(NSString*)deviceid dateFrom:(NSString*)startTime dateTo:(NSString*)endTime pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询含有指定片段的告警
 *该接口描述获取指定业务片段告警的方式，参数fragmentType在该情景下为必填
 *fragmentType 动态属性key值
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)alarmQueryAlarmFragmentTypeAuthorization:(NSString*)authorization fragment:(NSString*)fragmentType pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询含有指定类型的告警
 *该接口描述获取指定业务类型告警的方式，参数type在该情景下为必填
 *type 告警业务类型
 *startTime 开始时间 2020-07-12
 *endTime 结束时间 2020-09-04
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)alarmQueryAlarmSpecifiedStatusAuthorization:(NSString*)authorization alarmStaus:(NSString*)type dateFrom:(NSString*)startTime dateTo:(NSString*)endTime pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *确认报警
 *该接口用于修改告警中状态和key-value值变更
 *alarmid 确认设备id
 *status 告警状态，（ACTIVE（激活）,ACKNOWLEDGED（确认）,CLEARED（清除)
 *body  @{@"status":@"ACKNOWLEDGED"};
 */
+(void)alarmConfirmAuthorization:(NSString*)authorization alarmDevice:(NSString*)alarmid managedObjects:(NSDictionary*)body success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;



@end

NS_ASSUME_NONNULL_END
