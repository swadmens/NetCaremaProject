//
//  SingleEquipmentModel.m
//  NetCamera
//
//  Created by 汪伟 on 2020/10/15.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "SingleEquipmentModel.h"
#import "MyEquipmentsModel.h"

@implementation SingleEquipmentModel
+(SingleEquipmentModel*)makeModelData:(NSDictionary *)dic
{
    SingleEquipmentModel *model = [SingleEquipmentModel new];
    
    model.equipment_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    model.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    model.owner = [NSString stringWithFormat:@"%@",[dic objectForKey:@"owner"]];
    model.lastUpdated = [NSString stringWithFormat:@"%@",[dic objectForKey:@"lastUpdated"]];
    model.creationTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"creationTime"]];
    model.system_Source = [NSString stringWithFormat:@"%@",[dic objectForKey:@"system_Source"]];
    model.channel = [NSString stringWithFormat:@"%@",[dic objectForKey:@"channel"]];
    model.deviceSerial = [NSString stringWithFormat:@"%@",[dic objectForKey:@"deviceSerial"]];
    model.status = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
    model.type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];

    
    NSString *switchStatus = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cloudRecordStatus"]];
    model.cloudRecordStatus = [[switchStatus isEqualToString:@"on"] || [switchStatus isEqualToString:@"ON"]?@(YES):@(NO) boolValue];

    
    NSArray *preArr = [NSArray arrayWithArray:[dic objectForKey:@"presets"]];
    NSMutableArray *tempPreArr = [NSMutableArray arrayWithCapacity:preArr.count];
    [preArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *preDic = obj;
        PresetsModel *pModel = [PresetsModel makeModelData:preDic];
        [tempPreArr addObject:pModel];
    }];
    model.presets = [NSArray arrayWithArray:tempPreArr];//预置点数组


    
    NSDictionary *statesDic = [dic objectForKey:@"c8y_Availability"];
    NSString *status = [NSString stringWithFormat:@"%@",[statesDic objectForKey:@"status"]];
    model.online = [[status hasPrefix:@"UN"]?@(NO):@(YES) boolValue];
    
    NSDictionary *c8y_RequiredAvailability = [dic objectForKey:@"c8y_RequiredAvailability"];
    model.responseInterval = [NSString stringWithFormat:@"%@",[c8y_RequiredAvailability objectForKey:@"responseInterval"]];

    
    return model;
}


@end
