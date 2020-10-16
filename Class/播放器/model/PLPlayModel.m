//
//  PLPlayModel.m
//  NetCamera
//
//  Created by 汪伟 on 2020/9/29.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "PLPlayModel.h"

@implementation PLPlayModel

+(PLPlayModel*)makeModelData:(NSDictionary *)dic
{
    PLPlayModel *model = [PLPlayModel new];
    
    model.video_name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    model.endTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"endTime"]];
    model.startTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"startTime"]];
    model.duration = [NSString stringWithFormat:@"%@",[dic objectForKey:@"duration"]];
    model.picUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"picUrl"]];
    model.size = [NSString stringWithFormat:@"%@",[dic objectForKey:@"size"]];
    model.videoUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]];
    model.videoHDUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"urlHd"]];
    model.appKey = [NSString stringWithFormat:@"%@",[dic objectForKey:@"appKey"]];
    model.token = [NSString stringWithFormat:@"%@",[dic objectForKey:@"token"]];
    model.deviceId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"deviceId"]];
    model.channel = [NSString stringWithFormat:@"%@",[dic objectForKey:@"channel"]];
    model.deviceSerial = [NSString stringWithFormat:@"%@",[dic objectForKey:@"deviceSerial"]];
    model.accessToken = [NSString stringWithFormat:@"%@",[dic objectForKey:@"accessToken"]];
    model.recordId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"recordId"]];
    model.recordRegionId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"recordRegionId"]];
    model.playToken = [NSString stringWithFormat:@"%@",[dic objectForKey:@"playToken"]];
    model.recordType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"recordType"]];
    model.StreamID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"StreamID"]];

    return model;
}

@end
