//
//  CarmeaVideosModel.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "CarmeaVideosModel.h"

@implementation CarmeaVideosModel
+(CarmeaVideosModel*)makeModelData:(NSDictionary *)dic
{
    CarmeaVideosModel *model = [CarmeaVideosModel new];
    
    model.video_name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    model.appKey = [NSString stringWithFormat:@"%@",[dic objectForKey:@"appKey"]];
    model.endTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"endTime"]];
    model.startTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"startTime"]];
    model.duration = [NSString stringWithFormat:@"%@",[dic objectForKey:@"duration"]];
    model.picUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"picUrl"]];
    model.size = [NSString stringWithFormat:@"%@",[dic objectForKey:@"size"]];
    model.token = [NSString stringWithFormat:@"%@",[dic objectForKey:@"token"]];
    model.url = [NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]];
    model.deviceId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"deviceId"]];
    model.accessToken = [NSString stringWithFormat:@"%@",[dic objectForKey:@"accessToken"]];
    model.recordId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"recordId"]];
    model.channel = [NSString stringWithFormat:@"%@",[dic objectForKey:@"channel"]];
    model.deviceSerial = [NSString stringWithFormat:@"%@",[dic objectForKey:@"deviceSerial"]];
    model.recordRegionId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"recordRegionId"]];
    model.playToken = [NSString stringWithFormat:@"%@",[dic objectForKey:@"playToken"]];
    model.recordType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"recordType"]];

    return model;
}
@end
