//
//  MyEquipmentsModel.m
//  NetCamera
//
//  Created by 汪伟 on 2020/2/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "MyEquipmentsModel.h"
#import "LivingModel.h"

@implementation MyEquipmentsModel
+(MyEquipmentsModel*)makeModelData:(NSDictionary *)dic
{
    MyEquipmentsModel *model = [MyEquipmentsModel new];
    
    NSDictionary *managedObject = [dic objectForKey:@"managedObject"];
    model.equipment_id = [NSString stringWithFormat:@"%@",[managedObject objectForKey:@"id"]];
    model.equipment_name = [NSString stringWithFormat:@"%@",[managedObject objectForKey:@"name"]];
    model.owner = [NSString stringWithFormat:@"%@",[managedObject objectForKey:@"owner"]];
    model.lastUpdated = [NSString stringWithFormat:@"%@",[managedObject objectForKey:@"lastUpdated"]];
    model.system_Source = [NSString stringWithFormat:@"%@",[managedObject objectForKey:@"system_Source"]];
    model.channel = [NSString stringWithFormat:@"%@",[managedObject objectForKey:@"channel"]];
    model.deviceSerial = [NSString stringWithFormat:@"%@",[managedObject objectForKey:@"deviceSerial"]];
    
    NSArray *time1 = [[NSString stringWithFormat:@"%@",[managedObject objectForKey:@"creationTime"]] componentsSeparatedByString:@"."];
    model.creationTime = [time1[0] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    
    NSString *switchStatus = [NSString stringWithFormat:@"%@",[managedObject objectForKey:@"status"]];
    model.cloudStatus = [[switchStatus isEqualToString:@"on"] || [switchStatus isEqualToString:@"ON"]?@(YES):@(NO) boolValue];

    
    NSArray *preArr = [NSArray arrayWithArray:[managedObject objectForKey:@"presets"]];
    NSMutableArray *tempPreArr = [NSMutableArray arrayWithCapacity:preArr.count];
    [preArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *preDic = obj;
        PresetsModel *pModel = [PresetsModel makeModelData:preDic];
        [tempPreArr addObject:pModel];
    }];
    model.presets = [NSArray arrayWithArray:tempPreArr];//预置点数组


    
    NSDictionary *statesDic = [managedObject objectForKey:@"c8y_Availability"];
    NSString *status = [NSString stringWithFormat:@"%@",[statesDic objectForKey:@"status"]];
    model.equipment_states = [status hasPrefix:@"UN"]?@"离线":@"在线";
    model.online = [[status hasPrefix:@"UN"]?@(NO):@(YES) boolValue];

    
    NSDictionary *sourceInfo = [managedObject objectForKey:@"sourceInfo"];
    model.address = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"address"]];
    model.createdAt = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"createdAt"]];
    model.deviceID = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"deviceID"]];
    model.childDevice_id = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"id"]];
    model.updatedAt = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"updatedAt"]];
    model.manufacturer = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"manufacturer"]];
    model.civilCode = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"civilCode"]];
    model.snapURL = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"snapURL"]];

    
    NSDictionary *c8y_RequiredAvailability = [managedObject objectForKey:@"c8y_RequiredAvailability"];
    model.responseInterval = [NSString stringWithFormat:@"%@",[c8y_RequiredAvailability objectForKey:@"responseInterval"]];

    

    return model;
}

@end

@implementation PresetsModel
+(PresetsModel*)makeModelData:(NSDictionary *)dic
{
    PresetsModel *model = [PresetsModel new];
    model.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    model.index = [NSString stringWithFormat:@"%@",[dic objectForKey:@"index"]];
    
    return model;

}
@end
