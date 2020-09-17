//
//  TargetEngine.h
//  YaYaGongShe
//
//  Created by icash on 16-3-5.
//  Copyright (c) 2016年 iCash. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 收到的userInfo : @{@"id":1,@"num":2}
static NSString *const kCommentSuccessedNotice = @"notic.commentSuccessed";

typedef enum : NSUInteger {
    PushTargetNone = 0, /// 什么都不是
    PushTargetGoodsDetail = 1, /// 详情页，传goods_id
    PushTargetCartView = 2, /// 跳转购物车
    PushTargetCreateOrderView = 3, /// 申请订单界面
    PushTargetMyEquipments = 4, /// 我的设备
    PushTargetPersonInfoView = 5, /// 个人信息
    PushTargetEquipmentInformation = 6, /// 设备信息
    PushTargetVideoUpLoad = 7, /// 视频上传
    
    PushTargetRetrievePassword = 12, /// 找回密码
    PushTargetDownloadList = 13, /// 下载列表
    PushTargetLiveLiving = 14, /// live直播
    PushTargetAllGroups = 15, /// 全部分组
    PushTargetEquipmentOffline = 16, /// 设备离线
    PushTargetAddNewGroup = 17, /// 添加分组
    PushTargetLocalVideo = 18, /// 本地录像
    PushTargetCarmeraDetailInfo = 19, /// 设备详情
    PushTargetCarmeraMoreSystem = 20, /// 更多设置
    PushTargetEquimentBasicInfo = 21, /// 设备基本信息
    PushTargetMessageNoticesDeal = 22, /// 消息通知
    PushTargetChannelDetail = 23, /// 通道详情
    PushTargetChannelMoreSystem = 24, /// 更多设置
    PushTargetEquimentShared = 25, /// 设备共享
    PushTargetAddNewFriends = 26, /// 添加好友
    PushTargetDeleteGroups = 27, /// 删除分组
    PushTargetGlobalSearch = 28, /// 全局搜索
    PushTargetSuperPlayer = 29, /// 播放器
    PushTargetAddNewEquipment = 30, /// 添加设备

    
    

    
    PushTargetRegistered = 156,///快速注册


    
    
    
    PushTargetLogin = 220, /// 跳转登录
    PushTargetPreviewPhoto = 666, /// 大图查看
    PushTargetCopy = 1001, /// 复制
    PushTargetThirdPartyLogin = 1009,///第三方登录
    PushTargetAccountAssociated = 1010,///关联登录
    
    
    
    PushTargetTencentMapService = 2001, /// 腾讯地图服务
    
    PushTargetMyHomeView = 3000,///首页

    
    
    
} PushTargetType;

#define kTargetEngine [TargetEngine sharedInstance]
@interface TargetEngine : NSObject

/// 单例初始化
+ (instancetype)sharedInstance;
+ (CGSize)sizeWithXSizeString:(NSString *)str;
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentViewController;
/// 获取当前viewController
+ (UIViewController *)getRealViewController;
/**
 * 推送，如果fromController为nil，则会自动判断
 * target的格式 ： {"msg_type":"push","cmd":"story_preview","params":{"id":"1063201"}}
 * 增加share ,可同时被调用
 * 具体规则见：http://doc.epetbar.com:801/doku.php?id=target  或 实现方法
 * 一般是不需要toController的
 */
+ (void)pushViewController:(UIViewController *)toController fromController:(UIViewController *)fromController withTarget:(id)targetJson;
/**
 * 跳转某个界面
 * targetType = PushTargetWebView 时,pushId 是URL
 * 当targetType 是 PushTargetChat 时， pushId需要传入session_id 如：1_xx , 2_xx 。使用时，请询问我
 */
+ (void)controller:(UIViewController *)fromController pushToController:(PushTargetType)targetType WithTargetId:(NSString *)pushId;

@end
