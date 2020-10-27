//
//  AreaSetupModel.m
//  NetCamera
//
//  Created by 汪伟 on 2020/10/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "AreaSetupModel.h"

@implementation AreaSetupModel

+(AreaSetupModel*)makeModelData:(NSDictionary*)dic
{
    AreaSetupModel *model = [AreaSetupModel new];

    model.creationTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"creationTime"]];
    model.area_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    model.lastUpdated = [NSString stringWithFormat:@"%@",[dic objectForKey:@"lastUpdated"]];
    model.locationDetail = [NSString stringWithFormat:@"%@",[dic objectForKey:@"locationDetail"]];
    model.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    model.nameEn = [NSString stringWithFormat:@"%@",[dic objectForKey:@"nameEn"]];
    model.owner = [NSString stringWithFormat:@"%@",[dic objectForKey:@"owner"]];
    model.shortName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"shortName"]];
    model.type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
    model.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"text"]];
    model.floor = [NSString stringWithFormat:@"%@",[dic objectForKey:@"floor"]];
    model.building = [NSString stringWithFormat:@"%@",[dic objectForKey:@"building"]];
    
    model.deviceIds = [NSArray arrayWithArray:[dic objectForKey:@"deviceIds"]];

    
    return model;
}
@end
