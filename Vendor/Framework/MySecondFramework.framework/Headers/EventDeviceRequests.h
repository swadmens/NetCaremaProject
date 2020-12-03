//
//  EventDeviceRequests.h
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

@interface EventDeviceRequests : NSObject

/*
 *创建新的事件
 *事件用于描述设备希望告知用户的信息。
 * source  --  source.id  (22251)  设备的id
 * type (TestEvent)事件业务类型
 * text （I am an alarm） 事件提示
 * time （2014-03-03T12:03:27.845Z） 产生时间
 * hotToCool （true
 *
 *body  @{@"type":@"testAlarm",@"text":@"I am an alarm",@"severity":@"MINOR",@"severity":@"MINOR",@status:@"ACTIVE",@"time":@"2020-09-04T12:03:27.845Z",@"customkey":@{@"id":@"12234"}};
*/
+(void)eventCreateNewThingAuthorization:(NSString*)authorization managedObjects:(NSDictionary*)body success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询事件集合
 *startTime 开始时间 2020-07-12
 *endTime 结束时间 2020-09-04
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)eventQueryEventCollectionAuthorization:(NSString*)authorization dateFrom:(NSString*)startTime dateTo:(NSString*)endTime pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询指定类型的事件
 *type 事件类型
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)eventQuerySpecifiedEventAuthorization:(NSString*)authorization enevtStatus:(NSString*)type pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询特定设备的事件
 *source 设备的id
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)eventQuerySpecifiedDeviceEventAuthorization:(NSString*)authorization deviceEvent:(NSString*)source pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询指定fragmentType的事件
 *fragmentType 事件片段key
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)eventQuerySpecifiedFragmentTypeAuthorization:(NSString*)authorization fragmentType:(NSString*)type pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

@end

NS_ASSUME_NONNULL_END
