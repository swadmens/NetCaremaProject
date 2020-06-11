//
//  LivingModel.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/25.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "LivingModel.h"

@implementation LivingModel
+(LivingModel*)makeModelData:(NSDictionary *)dic
{
    LivingModel *model = [LivingModel new];
    
    model.AudioEnable = [NSString stringWithFormat:@"%@",[dic objectForKey:@"AudioEnable"]];
    model.CDN = [NSString stringWithFormat:@"%@",[dic objectForKey:@"CDN"]];
    model.CascadeSize = [NSString stringWithFormat:@"%@",[dic objectForKey:@"CascadeSize"]];
    model.ChannelID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ChannelID"]];
    model.ChannelName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ChannelName"]];
    model.DeviceID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"DeviceID"]];
    model.Duration = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Duration"]];
    model.FLV = [NSString stringWithFormat:@"%@",[dic objectForKey:@"FLV"]];
    model.HLS = [NSString stringWithFormat:@"%@",[dic objectForKey:@"HLS"]];
    model.InBitRate = [NSString stringWithFormat:@"%@",[dic objectForKey:@"InBitRate"]];
    model.InBytes = [NSString stringWithFormat:@"%@",[dic objectForKey:@"InBytes"]];
    model.NumOutputs = [NSString stringWithFormat:@"%@",[dic objectForKey:@"NumOutputs"]];
    model.Ondemand = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Ondemand"]];
    model.OutBytes = [NSString stringWithFormat:@"%@",[dic objectForKey:@"OutBytes"]];
    model.RTMP = [NSString stringWithFormat:@"%@",[dic objectForKey:@"RTMP"]];
    model.RTSP = [NSString stringWithFormat:@"%@",[dic objectForKey:@"RTSP"]];
    model.RecordStartAt = [NSString stringWithFormat:@"%@",[dic objectForKey:@"RecordStartAt"]];
    model.RelaySize = [NSString stringWithFormat:@"%@",[dic objectForKey:@"RelaySize"]];
    model.SnapURL = [NSString stringWithFormat:@"%@",[dic objectForKey:@"SnapURL"]];
    model.SourceAudioCodecName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"SourceAudioCodecName"]];
    model.SourceAudioSampleRate = [NSString stringWithFormat:@"%@",[dic objectForKey:@"SourceAudioSampleRate"]];
    model.SourceVideoCodecName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"SourceVideoCodecName"]];
    model.SourceVideoFrameRate = [NSString stringWithFormat:@"%@",[dic objectForKey:@"SourceVideoFrameRate"]];
    model.SourceVideoHeight = [NSString stringWithFormat:@"%@",[dic objectForKey:@"SourceVideoHeight"]];
    model.SourceVideoWidth = [NSString stringWithFormat:@"%@",[dic objectForKey:@"SourceVideoWidth"]];
    model.StartAt = [NSString stringWithFormat:@"%@",[dic objectForKey:@"StartAt"]];
    model.StreamID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"StreamID"]];
    model.Transport = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Transport"]];
    model.WS_FLV = [NSString stringWithFormat:@"%@",[dic objectForKey:@"WS_FLV"]];

    
    
    
/*
    model.actived = [NSString stringWithFormat:@"%@",[dic objectForKey:@"actived"]];
    model.authed = [NSString stringWithFormat:@"%@",[dic objectForKey:@"authed"]];
    model.beginAt = [NSString stringWithFormat:@"%@",[dic objectForKey:@"beginAt"]];
    model.clientID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"clientID"]];
    model.code = [NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
    model.createAt = [NSString stringWithFormat:@"%@",[dic objectForKey:@"createAt"]];
    model.customRecordPlan = [NSString stringWithFormat:@"%@",[dic objectForKey:@"customRecordPlan"]];
    model.customRecordReserve = [NSString stringWithFormat:@"%@",[dic objectForKey:@"customRecordReserve"]];
    model.delay = [NSString stringWithFormat:@"%@",[dic objectForKey:@"delay"]];
    model.endAt = [NSString stringWithFormat:@"%@",[dic objectForKey:@"endAt"]];
    model.live_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    model.keeped = [NSString stringWithFormat:@"%@",[dic objectForKey:@"keeped"]];
    model.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    model.recordPlan = [NSString stringWithFormat:@"%@",[dic objectForKey:@"recordPlan"]];
    model.recordReserve = [NSString stringWithFormat:@"%@",[dic objectForKey:@"recordReserve"]];
    model.serial = [NSString stringWithFormat:@"%@",[dic objectForKey:@"serial"]];
    model.shared = [NSString stringWithFormat:@"%@",[dic objectForKey:@"shared"]];
    model.sharedLink = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sharedLink"]];
    model.sign = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sign"]];
    model.storePath = [NSString stringWithFormat:@"%@",[dic objectForKey:@"storePath"]];
    model.type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
    model.updateAt = [NSString stringWithFormat:@"%@",[dic objectForKey:@"updateAt"]];
    model.url = [NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]];
    model.snapUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"snapUrl"]];

    
    NSDictionary *session = (NSDictionary*)[dic objectForKey:@"session"];
    
    model.Application = [NSString stringWithFormat:@"%@",[session objectForKey:@"Application"]];
    model.AudioBitrate = [NSString stringWithFormat:@"%@",[session objectForKey:@"AudioBitrate"]];
    model.DHLS = [NSString stringWithFormat:@"%@",[session objectForKey:@"DHLS"]];
    model.HLS = [NSString stringWithFormat:@"%@",[session objectForKey:@"HLS"]];
    model.HTTPFLV = [NSString stringWithFormat:@"%@",[session objectForKey:@"HTTPFLV"]];
    model.session_id = [NSString stringWithFormat:@"%@",[session objectForKey:@"Id"]];
    model.InBitrate = [NSString stringWithFormat:@"%@",[session objectForKey:@"InBitrate"]];
    model.InBytes = [NSString stringWithFormat:@"%@",[session objectForKey:@"InBytes"]];
    model.session_name = [NSString stringWithFormat:@"%@",[session objectForKey:@"Name"]];
    model.NumOutputs = [NSString stringWithFormat:@"%@",[session objectForKey:@"NumOutputs"]];
    model.OutBitrate = [NSString stringWithFormat:@"%@",[session objectForKey:@"OutBitrate"]];
    model.OutBytes = [NSString stringWithFormat:@"%@",[session objectForKey:@"OutBytes"]];
    model.RTMP = [NSString stringWithFormat:@"%@",[session objectForKey:@"RTMP"]];
    model.StartTime = [NSString stringWithFormat:@"%@",[session objectForKey:@"StartTime"]];
    model.Time = [NSString stringWithFormat:@"%@",[session objectForKey:@"Time"]];
    model.session_type = [NSString stringWithFormat:@"%@",[session objectForKey:@"Type"]];
    model.VideoBitrate = [NSString stringWithFormat:@"%@",[session objectForKey:@"VideoBitrate"]];
    model.WSFLV = [NSString stringWithFormat:@"%@",[session objectForKey:@"WSFLV"]];
*/
 
    return model;
}
@end
