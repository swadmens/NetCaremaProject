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

@property (nonatomic, copy) NSString *imageUrl;//图片地址
@property (nonatomic, copy) NSString *downloadProgress;//下载进度
@property (nonatomic, copy) NSString *video_name;//视频名称
@property (nonatomic ,copy) NSString *video_time;//视频创建时间
@property (nonatomic ,copy) NSString *filePath;//视频本地地址
@property (nonatomic ,copy) NSString *download_url;//视频下载URL

+(instancetype)AddressModelWithDict:(NSDictionary *)dict;
-(instancetype)initAddressModelWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
