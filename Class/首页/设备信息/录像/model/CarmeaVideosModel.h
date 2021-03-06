//
//  CarmeaVideosModel.h
//  NetCamera
//
//  Created by 汪伟 on 2020/3/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CarmeaVideosModel : NSObject

+(CarmeaVideosModel*)makeModelData:(NSDictionary*)dic;

@property (nonatomic,strong) NSString *video_name;//视频名称
@property (nonatomic,strong) NSString *duration;//时长
@property (nonatomic,strong) NSString *appKey;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,strong) NSString *picUrl;
@property (nonatomic,strong) NSString *size;
@property (nonatomic,strong) NSString *startTime;
@property (nonatomic,strong) NSString *token;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *deviceId;
@property (nonatomic,strong) NSString *accessToken;
@property (nonatomic,strong) NSString *recordId;
@property (nonatomic,strong) NSString *deviceSerial;
@property (nonatomic,strong) NSString *channel;
@property (nonatomic,strong) NSString *recordRegionId;
@property (nonatomic,strong) NSString *playToken;
@property (nonatomic,strong) NSString *recordType;//本地或云端录像
@property (nonatomic,strong) NSString *system_Source;
@property (nonatomic,strong) NSString *StreamID;


@end

NS_ASSUME_NONNULL_END
