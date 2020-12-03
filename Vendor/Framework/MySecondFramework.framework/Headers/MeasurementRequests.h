//
//  MeasurementRequests.h
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

@interface MeasurementRequests : NSObject

/*
 *创建新的事件
 *事件用于描述设备希望告知用户的信息。
 * temperature  --  测量值片段对象（动态属性）
 * temperature.T 测量值系列对象
 * temperature.T.value 测量值对应系列的值
 * temperature.T.unit 测量值对应系列的单位
 *time (2014-03-03T12:03:27.845Z） 产生时间
 * source 设备的id对象
 * source.id (10200) 设备的id
 * type (temperature)测量值业务类型
 *
 *body  @{@"type":@"temperature",@"time":@"2020-09-04T12:03:27.845Z",@"source":@{@"id":@"12234"},@"temperature":@{@"T":@{@"value":@"32",@"unit":@"C"}}};
*/
+(void)measurementCreateMeasurementAuthorization:(NSString*)authorization managedObjects:(NSDictionary*)body success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询测量值集合
 *startTime 开始时间 2020-09-01T15:00:00+08:00
 *endTime 结束时间 2020-09-02T15:00:00+08:00
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)measurementQueryMeasurementCollectionAuthorization:(NSString*)authorization dateFrom:(NSString*)startTime dateTo:(NSString*)endTime pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询指定设备的测量值
 *source 设备的id对象
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)measurementQuerySpecifiedDeviceMeasurementAuthorization:(NSString*)authorization device:(NSString*)source pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询指定fragmentType测量值集合
 *type 测量值的片段key
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)measurementQuerySpecifiedFragmentTypeMeasurementAuthorization:(NSString*)authorization fragmentType:(NSString*)type pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询指定id测量值
 *measid 测量值id
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)measurementQuerySpecifiedMeasurementIdMeasurementAuthorization:(NSString*)authorization measurementId:(NSString*)measid success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询设备系列测量值集合
 *source 设备的id对象
 *startTime 开始时间 2020-09-01T15:00:00+08:00
 *endTime 结束时间 2020-09-02T15:00:00+08:00
 */
+(void)measurementQueryDeviceSeriesMeasurementCollectionAuthorization:(NSString*)authorization device:(NSString*)source dateFrom:(NSString*)startTime dateTo:(NSString*)endTime success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询时间聚合的系列测量值集合
 *aggregationType  参数 DAILY，HOURLY，MINUTELY
 *revert true为倒序，false为正序
 *deviceid 设备id
 *series 测量值系列  temperature.T
 *startTime 起始时间 2020-08-30T15:00:00
 *endTime 结束时间 2020-09-02T17:00:00
 *numbers  请求数据数量
 */
+(void)measurementQueryTimeAggregationSeriesAuthorization:(NSString*)authorization aggregationType:(NSString*)type source:(NSString*)deviceid sorting:(NSString*)revert temperature:(NSString*)series dateFrom:(NSString*)startTime dateTo:(NSString*)endTime pageSize:(NSString*)numbers success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *删除测量值
 *startTime 开始时间 2020-09-01T15:00:00+08:00
 *endTime 结束时间 2020-09-02T15:00:00+08:00
 */
+(void)measurementDeleteMeasurementAuthorization:(NSString*)authorization dateFrom:(NSString*)startTime dateTo:(NSString*)endTime success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;


@end

NS_ASSUME_NONNULL_END
