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
    
    model.creationTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"creationTime"]];
    model.filePath = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filePath"]];
    model.file_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    model.lastUpdated = [NSString stringWithFormat:@"%@",[dic objectForKey:@"lastUpdated"]];
    model.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    model.owner = [NSString stringWithFormat:@"%@",[dic objectForKey:@"owner"]];
    model.type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
    model.vodId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"vodId"]];
    model.size = [NSString stringWithFormat:@"%@",[dic objectForKey:@"size"]];
    model.describe = [NSString stringWithFormat:@"%@",[dic objectForKey:@"description"]];
    model.title = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];

    
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

