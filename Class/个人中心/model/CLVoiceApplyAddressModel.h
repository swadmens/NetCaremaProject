//
//  CLVoiceApplyAddressModel.h
//  NetCamera
//
//  Created by 汪伟 on 2020/4/7.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLVoiceApplyAddressModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *snap;//图片地址
@property (nonatomic, copy) NSString *progress;//下载进度
@property (nonatomic, copy) NSString *name;//视频名称
@property (nonatomic ,copy) NSString *start_time;//视频创建时间
@property (nonatomic ,copy) NSString *time;//视频创建时间
@property (nonatomic ,copy) NSString *file_path;//视频本地地址
@property (nonatomic ,copy) NSString *url;//视频下载URL
@property (nonatomic ,copy) NSString *duration;//视频时长
@property (nonatomic ,copy) NSString *hls;//视频播放地址
@property (nonatomic ,copy) NSString *writeBytes;//视频下载大小


+(instancetype)AddressModelWithDict:(NSDictionary *)dict;
-(instancetype)initAddressModelWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
