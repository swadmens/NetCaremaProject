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
    model.equipment_name = [NSString stringWithFormat:@"%@",[managedObject objectForKey:@"name"]];
    model.equipment_Channel = [NSString stringWithFormat:@"%@",[managedObject objectForKey:@"Channel"]];
    model.c8y_Notes = [NSString stringWithFormat:@"%@",[managedObject objectForKey:@"c8y_Notes"]];
    model.CameraId = [NSString stringWithFormat:@"%@",[managedObject objectForKey:@"CameraId"]];
    model.DeviceId = [NSString stringWithFormat:@"%@",[managedObject objectForKey:@"DeviceId"]];
    model.ClientId = [NSString stringWithFormat:@"%@",[managedObject objectForKey:@"ClientId"]];
    model.owner = [NSString stringWithFormat:@"%@",[managedObject objectForKey:@"owner"]];
    model.lastUpdated = [NSString stringWithFormat:@"%@",[managedObject objectForKey:@"lastUpdated"]];
    model.creationTime = [NSString stringWithFormat:@"%@",[managedObject objectForKey:@"creationTime"]];

    
    
    
    NSDictionary *statesDic = [managedObject objectForKey:@"c8y_Availability"];
    NSString *status = [NSString stringWithFormat:@"%@",[statesDic objectForKey:@"status"]];
    model.equipment_states = [status isEqualToString:@"UNAVAILABLE"]?@"离线":@"在线";

    
    NSDictionary *c8y_RequiredAvailability = [managedObject objectForKey:@"c8y_RequiredAvailability"];
    model.responseInterval = [NSString stringWithFormat:@"%@",[c8y_RequiredAvailability objectForKey:@"responseInterval"]];

    

    return model;
}

@end
