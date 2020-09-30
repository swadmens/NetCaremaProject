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

    
    return model;
}

@end
