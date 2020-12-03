//
//  HostingDevicesRequests.h
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

@interface HostingDevicesRequests : NSObject

/*
*该接口用于创建托管对象，托管对象为抽象对象，其中可以结合前端和业务具化演进为设备，群组，配置，二进制文件等，该托管对象随着业务演进，响应体数据结构将会动态变化，可用片段的动态属性进行区分和查询，自定义业务片段的来源可以是前端，也可以是设备端。
 *name  设备名称
 *type  设备业务类型  air-conditioning
 *c8y_IsDevice  标识托管对象为设备的固定片段key
 *com_cumulocity_model_Agent  标识托管对象为可执行操作指令的固定片段key
 *body  @{
         @"name":@"computer",
         @"type":@"air-conditioning",
         @"c8y_IsDevice":@{},
         @"com_cumulocity_model_Agent":@{}
         };
*/
+(void)inventoryAuthorization:(NSString*)authorization managedObjects:(NSDictionary*)body success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *创建子设备
 *name  设备名称
 *type  设备业务类型  air-conditioning
 *body  @{
         @"name":@"keyboard",
         @"type":@"air-conditioning-child"
         };
 */
+(void)inventoryChildAuthorization:(NSString*)authorization managedObjects:(NSDictionary*)body success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *创建群组
 *name  设备名称
 *type  设备业务类型  c8y_IsDeviceGroup
 *c8y_IsDeviceGroup  标识符片段，标识为群组
 *body  @{
         @"name":@"电脑群组",
         @"type":@"c8y_IsDeviceGroup",
         @"c8y_IsDeviceGroup": @{}
         };
 */
+(void)inventoryGroupAuthorization:(NSString*)authorization managedObjects:(NSDictionary*)body success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *添加子设备
 *parentId 父设备id
 *body  @{
            @"managedObject":@{
                                @"id":@"22531"
                                }
         };
 */
+(void)inventoryAddChildDeviceAuthorization:(NSString*)authorization parentDevice:(NSString*)parentId managedObjects:(NSDictionary*)body success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *添加子资产，该接口用于给设备分组，将子设备分配到父群组中
 *parentId 父设备id
 *body  @{
         @"managedObject":@{
                             @"id":@"22531"
                            }
         };
 */
+(void)inventoryAddChildAssetsAuthorization:(NSString*)authorization parentDevice:(NSString*)parentId managedObjects:(NSDictionary*)body success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;


/*
 *查询指定ID托管对象
 *hostingId 需要查询的托管对象id，多个id用逗号分隔
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)inventoryQueryHostingAuthorization:(NSString*)authorization hostingId:(NSString*)hostingId pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;


/*
 *查询设备并排序
 *fragmentType c8y_IsDevice 设备标识符
 *orderby 根据id排序（降序desc，升序asce）
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)inventoryQueryDeviceSortingAuthorization:(NSString*)authorization fragmentType:(NSString*)fragment_type orderby:(NSString*)order pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;


/*
 *查询设备群组
 *fragmentType c8y_IsDeviceGroup 设备群组
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)inventoryQueryDeviceGroupAuthorization:(NSString*)authorization fragmentType:(NSString*)fragment_type pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;


/*
 *查询单个托管对象
 *deviceId 单个托管对象id
 */
+(void)inventorySingleHostingAuthorization:(NSString*)authorization device:(NSString*)deviceId success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;


/*
 *查询指定业务类型托管对象
 *type 托管对象业务类型
 */
+(void)inventorySpecifyBusinessAuthorization:(NSString*)authorization business:(NSString*)type success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询指定子资产的父群组
 *childAssetId 子资产id
 */
+(void)inventoryQueryChildAssetFatherGroupAuthorization:(NSString*)authorization childAsset:(NSString*)childAssetId success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询指定子设备的父设备
 *childDeviceId 子设备ID
 */
+(void)inventoryQueryChildDeviceFatherDeviceAuthorization:(NSString*)authorization childDevice:(NSString*)childDeviceId success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询特定关键字的设备
 *text 模糊查询文本匹配
 */
+(void)inventoryQueryKeywordDeviceAuthorization:(NSString*)authorization keyword:(NSString*)text success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询响应字段过滤
 *fields 筛选字段，多个字段用逗号分隔(id,type,name)
 *type 设备业务类型
 */
+(void)inventoryQueryFieldResponseAuthorization:(NSString*)authorization field:(NSString*)fields deviceType:(NSString*)type success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询指定用户的设备
 *owner 创建托管对象的用户
 */
+(void)inventoryQueryOwerDeviceAuthorization:(NSString*)authorization owner:(NSString*)owner success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *查询设备支持的测量值类型
 *deviceid 设备id
 */
+(void)inventoryQueryDeviceSupportedMeasurementsAuthorization:(NSString*)authorization supportedMeasurements:(NSString*)deviceid success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *根据filter查询集合
 *使用语法
 eq(Equal)  ---  City eq 'Redmond'
 gt(Greater than)  ---  Price gt 20
 ge(Greater than or equal)  ---  Price ge 10
 lt(Less than)  ---  Price lt 20
 and(Logical and)  ---  Price le 200 and Price gt 3.5
 or(Logical or)  ---  Price le 3.5 or Price gt 200
 has  ---  has(name）
 bygroupid  ---  bygroupid(12)
 $orderby  ---  $orderby=name des或 $orderby=name asc
 *filter 使用示例： 场景：查询含有业务片段my_Device，在线状态为在线，并且按照id倒序，返回内容为c8y_Availability,id,name,creationTime字段集合。 拼接示例： {{url}}/inventory/managedObjects?currentPage=1&pageSize=100&q=$filter%3D(c8y_Availability.status+eq+%27AVAILABLE%27 and has(my_Device))$orderby=id desc&withTotalPages=true&fields=c8y_Availability,id,name,creationTime
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)inventoryQueryFilterCollectionAuthorization:(NSString*)authorization filter:(NSString*)filter pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *修改设备名称
 *deviceid 设备id
 */
+(void)inventoryModifyDeviceNamesAuthorization:(NSString*)authorization device:(NSString*)deviceid managedObjects:(NSDictionary*)body success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *设置支持命令控制片段
 *使用该接口发送c8y_Command之后设备管理的单个设备详情页面将能出现命令行的ui页面
 *deviceid 设备id
 */
+(void)inventoryC8yCommandAuthorization:(NSString*)authorization device:(NSString*)deviceid managedObjects:(NSDictionary*)body success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *删除指定设备id
 *deviceId 要删除的设备id
 */
+(void)inventoryDeleteDeviceAuthorization:(NSString*)authorization device:(NSString*)deviceId success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *解除父子设备关系
 *parentId 父设备id
 *childId 子设备id
 */
+(void)inventoryDisconnectionFatherSonAuthorization:(NSString*)authorization fatherDevice:(NSString*)parentId sonDevice:(NSString*)childId success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *解除父子群组关系
 *parentId 父设备id
 *childId 子设备id
 */
+(void)inventoryDisconnectionFatherSonAssetAuthorization:(NSString*)authorization fatherDevice:(NSString*)parentId sonDevice:(NSString*)childId success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;
@end

NS_ASSUME_NONNULL_END
