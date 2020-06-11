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
    
    NSDictionary *statesDic = [dic objectForKey:@"c8y_Availability"];
    NSString *status = [NSString stringWithFormat:@"%@",[statesDic objectForKey:@"status"]];
    model.equipment_states = [status isEqualToString:@"AVAILABLE"]?@"在线":@"离线";

    NSDictionary *quark_GBSManageDevice = [dic objectForKey:@"quark_GBSManageDevice"];
    
    model.equipment_name = [NSString stringWithFormat:@"%@",[quark_GBSManageDevice objectForKey:@"name"]];
    model.equipment_address = [NSString stringWithFormat:@"%@",[quark_GBSManageDevice objectForKey:@"address"]];
    model.childDevices_id = [NSString stringWithFormat:@"%@",[quark_GBSManageDevice objectForKey:@"id"]];
    model.serial = [NSString stringWithFormat:@"%@",[quark_GBSManageDevice objectForKey:@"serial"]];

    
//    model.childDevices_info = [NSArray arrayWithArray:[dic objectForKey:@"device_num"]];
    
    
    NSDictionary *childDevices = (NSDictionary*)[dic objectForKey:@"childDevices"];
    NSArray *references = (NSArray*)[childDevices objectForKey:@"references"];
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:references.count];
    [references enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *childDic = obj;
        IndexChildDataModel *childModel = [IndexChildDataModel makeModelData:childDic];
        [tempArray addObject:childModel];
    }];
    
    model.equipment_nums = [NSArray arrayWithArray:tempArray];
    
    
    return model;
}

@end

@implementation IndexChildDataModel

+(IndexChildDataModel*)makeModelData:(NSDictionary*)dic
{
    IndexChildDataModel *model = [IndexChildDataModel new];
    
    NSDictionary *managedObject = (NSDictionary*)[dic objectForKey:@"managedObject"];
    
    model.childDevices_id = [NSString stringWithFormat:@"%@",[managedObject objectForKey:@"id"]];
    model.childDevices_name = [NSString stringWithFormat:@"%@",[managedObject objectForKey:@"name"]];

    
    return model;
}

@end

