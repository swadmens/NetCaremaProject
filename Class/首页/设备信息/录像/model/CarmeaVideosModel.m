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
    model.duration = [NSString stringWithFormat:@"%@",[dic objectForKey:@"duration"]];
    model.hls = [NSString stringWithFormat:@"%@",[dic objectForKey:@"hls"]];
    model.important = [NSString stringWithFormat:@"%@",[dic objectForKey:@"important"]];
    model.snap = [NSString stringWithFormat:@"%@",[dic objectForKey:@"snap"]];
    model.start_time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"start_time"]];
    model.time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"time"]];
     
    
    return model;
}
@end
