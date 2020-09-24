//
//  LivingModel.h
//  NetCamera
//
//  Created by 汪伟 on 2020/3/25.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LivingModel : NSObject
+(LivingModel*)makeModelData:(NSDictionary*)dic;

@property (nonatomic,strong) NSString *channelId;
@property (nonatomic,strong) NSString *deviceSerial;
@property (nonatomic,strong) NSString *flv;
@property (nonatomic,strong) NSString *hls;
@property (nonatomic,strong) NSString *hlsHd;
@property (nonatomic,strong) NSString *liveToken;
@property (nonatomic,strong) NSString *rtmp;
@property (nonatomic,strong) NSString *rtmpHd;
@property (nonatomic,strong) NSString *snap;
@property (nonatomic,assign) BOOL status;
@property (nonatomic,strong) NSString *streamId;
@property (nonatomic,strong) NSString *createdAt;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *deviceId;
@property (nonatomic,strong) NSString *system_Source;
@property (nonatomic,strong) NSArray *presets;


@end

NS_ASSUME_NONNULL_END
