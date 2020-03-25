//
//  IndexDataModel.m
//  NetCamera
//
//  Created by 汪伟 on 2020/2/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "IndexDataModel.h"

@implementation IndexDataModel

+(IndexDataModel*)makeModelData:(NSDictionary *)dic
{
    IndexDataModel *model = [IndexDataModel new];
    
    model.equipment_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    model.equipment_name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    model.equipment_address = [NSString stringWithFormat:@"%@",[dic objectForKey:@""]];
    
    NSDictionary *statesDic = [dic objectForKey:@"c8y_Availability"];
    NSString *status = [NSString stringWithFormat:@"%@",[statesDic objectForKey:@"status"]];
    model.equipment_states = [status isEqualToString:@"UNAVAILABLE"]?@"离线":@"在线";

    
    
    
    return model;
}

@end
