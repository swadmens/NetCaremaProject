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
  
    model.channelId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"channelId"]];
    model.deviceSerial = [NSString stringWithFormat:@"%@",[dic objectForKey:@"deviceSerial"]];
    model.channel = [NSString stringWithFormat:@"%@",[dic objectForKey:@"channel"]];
    model.flv = [NSString stringWithFormat:@"%@",[dic objectForKey:@"flv"]];
    model.flvHd = [NSString stringWithFormat:@"%@",[dic objectForKey:@"flvHd"]];
    model.hls = [NSString stringWithFormat:@"%@",[dic objectForKey:@"hls"]];
    model.hlsHd = [NSString stringWithFormat:@"%@",[dic objectForKey:@"hlsHd"]];
    model.liveToken = [NSString stringWithFormat:@"%@",[dic objectForKey:@"liveToken"]];
    model.rtmp = [NSString stringWithFormat:@"%@",[dic objectForKey:@"rtmp"]];
    model.rtmpHd = [NSString stringWithFormat:@"%@",[dic objectForKey:@"rtmpHd"]];
    model.snap = [NSString stringWithFormat:@"%@",[dic objectForKey:@"snap"]];
    model.streamId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"streamId"]];
    model.createdAt = [NSString stringWithFormat:@"%@",[dic objectForKey:@"createdAt"]];
    model.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    model.deviceId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"deviceId"]];
    model.system_Source = [NSString stringWithFormat:@"%@",[dic objectForKey:@"system_Source"]];
    model.status = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
    
    model.online = [[model.status isEqualToString:@"on"]?@(YES):@(NO) boolValue];
    
    model.presets = [NSArray arrayWithArray:[dic objectForKey:@"presets"]];//预置点数组

    

    return model;
}
@end
