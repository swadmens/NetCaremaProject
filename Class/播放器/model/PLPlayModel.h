//
//  PLPlayModel.h
//  NetCamera
//
//  Created by 汪伟 on 2020/9/29.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLPlayModel : NSObject

+(PLPlayModel*)makeModelData:(NSDictionary*)dic;

@property (nonatomic,strong) NSString *video_name;
@property (nonatomic,strong) NSString *duration;
@property (nonatomic,strong) NSString *startTime;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,strong) NSString *picUrl;
@property (nonatomic,strong) NSString *size;
@property (nonatomic,strong) NSString *videoUrl;
@property (nonatomic,strong) NSString *videoHDUrl;
@property (nonatomic,strong) NSString *appKey;
@property (nonatomic,strong) NSString *token;
@property (nonatomic,strong) NSString *deviceId;
@property (nonatomic,strong) NSString *channel;
@property (nonatomic,strong) NSString *deviceSerial;
@property (nonatomic,strong) NSString *accessToken;
@property (nonatomic,strong) NSString *recordId;
@property (nonatomic,strong) NSString *recordRegionId;
@property (nonatomic,strong) NSString *playToken;
@property (nonatomic,strong) NSString *recordType;//本地或云端录像

@end

NS_ASSUME_NONNULL_END
