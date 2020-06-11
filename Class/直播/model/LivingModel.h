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

/*
@property (nonatomic,strong) NSString *actived;
@property (nonatomic,strong) NSString *authed;
@property (nonatomic,strong) NSString *beginAt;
@property (nonatomic,strong) NSString *clientID;
@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSString *createAt;
@property (nonatomic,strong) NSString *customRecordPlan;
@property (nonatomic,strong) NSString *customRecordReserve;
@property (nonatomic,strong) NSString *delay;
@property (nonatomic,strong) NSString *endAt;
@property (nonatomic,strong) NSString *live_id;
@property (nonatomic,strong) NSString *keeped;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *recordPlan;
@property (nonatomic,strong) NSString *recordReserve;
@property (nonatomic,strong) NSString *serial;
@property (nonatomic,strong) NSString *shared;
@property (nonatomic,strong) NSString *sharedLink;
@property (nonatomic,strong) NSString *sign;
@property (nonatomic,strong) NSString *storePath;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *updateAt;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *snapUrl;
@property (nonatomic,strong) NSString *Application;
@property (nonatomic,strong) NSString *AudioBitrate;
@property (nonatomic,strong) NSString *DHLS;
@property (nonatomic,strong) NSString *HLS;
@property (nonatomic,strong) NSString *HTTPFLV;
@property (nonatomic,strong) NSString *session_id;
@property (nonatomic,strong) NSString *InBitrate;
@property (nonatomic,strong) NSString *InBytes;
@property (nonatomic,strong) NSString *session_name;
@property (nonatomic,strong) NSString *NumOutputs;
@property (nonatomic,strong) NSString *OutBitrate;
@property (nonatomic,strong) NSString *OutBytes;
@property (nonatomic,strong) NSString *RTMP;
@property (nonatomic,strong) NSString *StartTime;
@property (nonatomic,strong) NSString *Time;
@property (nonatomic,strong) NSString *session_type;
@property (nonatomic,strong) NSString *VideoBitrate;
@property (nonatomic,strong) NSString *WSFLV;
*/

@property (nonatomic,strong) NSString *AudioEnable;
@property (nonatomic,strong) NSString *CDN;
@property (nonatomic,strong) NSString *CascadeSize;
@property (nonatomic,strong) NSString *ChannelID;
@property (nonatomic,strong) NSString *ChannelName;
@property (nonatomic,strong) NSString *DeviceID;
@property (nonatomic,strong) NSString *Duration;
@property (nonatomic,strong) NSString *FLV;
@property (nonatomic,strong) NSString *HLS;
@property (nonatomic,strong) NSString *InBitRate;
@property (nonatomic,strong) NSString *InBytes;
@property (nonatomic,strong) NSString *NumOutputs;
@property (nonatomic,strong) NSString *Ondemand;
@property (nonatomic,strong) NSString *OutBytes;
@property (nonatomic,strong) NSString *RTMP;
@property (nonatomic,strong) NSString *RTSP;
@property (nonatomic,strong) NSString *RecordStartAt;
@property (nonatomic,strong) NSString *RelaySize;
@property (nonatomic,strong) NSString *SnapURL;
@property (nonatomic,strong) NSString *SourceAudioCodecName;
@property (nonatomic,strong) NSString *SourceAudioSampleRate;
@property (nonatomic,strong) NSString *SourceVideoCodecName;
@property (nonatomic,strong) NSString *SourceVideoFrameRate;
@property (nonatomic,strong) NSString *SourceVideoHeight;
@property (nonatomic,strong) NSString *SourceVideoWidth;
@property (nonatomic,strong) NSString *StartAt;
@property (nonatomic,strong) NSString *StreamID;
@property (nonatomic,strong) NSString *Transport;
@property (nonatomic,strong) NSString *WS_FLV;


@end

NS_ASSUME_NONNULL_END
