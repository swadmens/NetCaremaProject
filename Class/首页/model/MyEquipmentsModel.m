//
//  MyEquipmentsModel.m
//  NetCamera
//
//  Created by 汪伟 on 2020/2/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "MyEquipmentsModel.h"

@implementation MyEquipmentsModel
+(MyEquipmentsModel*)makeModelData:(NSDictionary *)dic
{
    MyEquipmentsModel *model = [MyEquipmentsModel new];
    
    NSDictionary *managedObject = [dic objectForKey:@"managedObject"];
    
    
    
    model.equipment_id = [NSString stringWithFormat:@"%@",[managedObject objectForKey:@"id"]];
    model.equipment_name = [NSString stringWithFormat:@"%@",[managedObject objectForKey:@"ClientId"]];
    model.equipment_Channel = [NSString stringWithFormat:@"%@",[managedObject objectForKey:@"Channel"]];
    NSDictionary *statesDic = [managedObject objectForKey:@"c8y_Availability"];
    NSString *status = [NSString stringWithFormat:@"%@",[statesDic objectForKey:@"status"]];
    model.equipment_states = [status isEqualToString:@"UNAVAILABLE"]?@"离线":@"在线";


    return model;
}

@end
