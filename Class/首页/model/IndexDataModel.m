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
    model.equipment_address = [NSString stringWithFormat:@"%@",[dic objectForKey:@"address"]];
    model.equipment_type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
    model.lastUpdated = [NSString stringWithFormat:@"%@",[dic objectForKey:@"lastUpdated"]];
//    model.creationTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"creationTime"]];
    model.owner = [NSString stringWithFormat:@"%@",[dic objectForKey:@"owner"]];
    model.system_Source = [NSString stringWithFormat:@"%@",[dic objectForKey:@"system_Source"]];
    model.deviceSerial = [NSString stringWithFormat:@"%@",[dic objectForKey:@"deviceSerial"]];
    
    NSArray *time1 = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"creationTime"]] componentsSeparatedByString:@"."];
    model.creationTime = [time1[0] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    
    NSDictionary *statesDic = [dic objectForKey:@"c8y_Availability"];
    NSString *status = [NSString stringWithFormat:@"%@",[statesDic objectForKey:@"status"]];
    model.equipment_states = [status hasPrefix:@"UN"]?@"离线":@"在线";
    model.online = [[status hasPrefix:@"UN"]?@(NO):@(YES) boolValue];

    
    NSDictionary *c8y_RequiredAvailability = [dic objectForKey:@"c8y_RequiredAvailability"];
    model.responseInterval = [NSString stringWithFormat:@"%@",[c8y_RequiredAvailability objectForKey:@"responseInterval"]];
    
    
    NSDictionary *c8y_ActiveAlarmsStatus = [dic objectForKey:@"c8y_ActiveAlarmsStatus"];
    model.major = [NSString stringWithFormat:@"%@",[c8y_ActiveAlarmsStatus objectForKey:@"major"]];
    

    NSDictionary *sourceInfo = [dic objectForKey:@"sourceInfo"];
    model.source_id = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"id"]];
    model.source_name = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"name"]];
    model.source_type = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"type"]];
    model.source_password = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"password"]];
    model.source_charset = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"charset"]];
    model.source_manufacturer = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"manufacturer"]];
    model.source_remoteIP = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"remoteIP"]];
    model.source_remotePort = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"remotePort"]];
    model.source_contactIP = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"contactIP"]];
    model.source_channelCount = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"channelCount"]];
    model.source_recvStreamIP = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"recvStreamIP"]];
    model.source_smsid = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"smsid"]];
    model.source_online = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"online"]];
    model.source_commandTransport = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"commandTransport"]];
    model.source_mediaTransport = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"mediaTransport"]];
    model.source_mediaTransportMode = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"mediaTransportMode"]];
    model.source_catalogInterval = [NSString stringWithFormat:@"%@",[sourceInfo objectForKey:@"catalogInterval"]];
    
    
    NSDictionary *childDevices = (NSDictionary*)[dic objectForKey:@"childDevices"];
    NSArray *references = (NSArray*)[childDevices objectForKey:@"references"];
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:references.count];
    [references enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *childDic = obj;
        IndexChildDataModel *childModel = [IndexChildDataModel makeModelData:childDic];
        [tempArray addObject:childModel];
        if (idx == 0) {
            model.childDevices_id = [NSString stringWithFormat:@"%@",childModel.childDevices_id];
        }
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

