//
//  DemandModel.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/25.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "DemandModel.h"

@implementation DemandModel
+(DemandModel*)makeModelData:(NSDictionary *)dic
{
    DemandModel *model = [DemandModel new];
    
    model.video_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    model.video_name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    model.size = [NSString stringWithFormat:@"%@",[dic objectForKey:@"size"]];
    model.type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
    model.status = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
    model.duration = [NSString stringWithFormat:@"%@",[dic objectForKey:@"duration"]];
    model.aspect = [NSString stringWithFormat:@"%@",[dic objectForKey:@"aspect"]];
    model.audioCodec = [NSString stringWithFormat:@"%@",[dic objectForKey:@"audioCodec"]];
    model.createAt = [NSString stringWithFormat:@"%@",[dic objectForKey:@"createAt"]];
    model.error = [NSString stringWithFormat:@"%@",[dic objectForKey:@"error"]];
    model.flowNum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    model.progress = [NSString stringWithFormat:@"%@",[dic objectForKey:@"progress"]];
    model.resolution = [NSString stringWithFormat:@"%@",[dic objectForKey:@"resolution"]];
    model.resolutiondefault = [NSString stringWithFormat:@"%@",[dic objectForKey:@"resolutiondefault"]];
    model.rotate = [NSString stringWithFormat:@"%@",[dic objectForKey:@"rotate"]];
    model.shared = [NSString stringWithFormat:@"%@",[dic objectForKey:@"shared"]];
    model.sharedLink = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sharedLink"]];
    model.snapUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"snapUrl"]];
    model.transvideo = [NSString stringWithFormat:@"%@",[dic objectForKey:@"transvideo"]];
    model.updateAt = [NSString stringWithFormat:@"%@",[dic objectForKey:@"updateAt"]];
    model.videoUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"videoUrl"]];
    model.videoCodec = [NSString stringWithFormat:@"%@",[dic objectForKey:@"videoCodec"]];

    
    model.hls = [NSString stringWithFormat:@"%@",[dic objectForKey:@"hls"]];
    model.important = [NSString stringWithFormat:@"%@",[dic objectForKey:@"important"]];
    model.snap = [NSString stringWithFormat:@"%@",[dic objectForKey:@"snap"]];
    model.start_time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"start_time"]];
    model.time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"time"]];

    
    
 
    return model;
}
@end


@implementation DemandSubcatalogModel

+(DemandSubcatalogModel*)makeModelData:(NSDictionary*)dic
{
    DemandSubcatalogModel *model = [DemandSubcatalogModel new];
  
    model.createAt = [NSString stringWithFormat:@"%@",[dic objectForKey:@"createAt"]];
    model.desc = [NSString stringWithFormat:@"%@",[dic objectForKey:@"desc"]];
    model.folder = [NSString stringWithFormat:@"%@",[dic objectForKey:@"folder"]];
    model.sub_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    model.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    model.realPath = [NSString stringWithFormat:@"%@",[dic objectForKey:@"realPath"]];
    model.sort = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sort"]];
    model.updateAt = [NSString stringWithFormat:@"%@",[dic objectForKey:@"updateAt"]];

    return model;
}
@end

