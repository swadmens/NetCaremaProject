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
    
    model.creationDate = [NSString stringWithFormat:@"%@",[dic objectForKey:@"creationDate"]];
    model.duration = [NSString stringWithFormat:@"%@",[dic objectForKey:@"duration"]];
    model.filePath = [NSString stringWithFormat:@"http://39.108.208.122:5080/LiveApp/%@",[dic objectForKey:@"filePath"]];
    model.fileSize = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fileSize"]];
    model.streamId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"streamId"]];
    model.streamName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"streamName"]];
    model.type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
    model.vodId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"vodId"]];
    model.vodName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"vodName"]];

    
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

