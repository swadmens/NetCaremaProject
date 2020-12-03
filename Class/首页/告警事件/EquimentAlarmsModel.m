//
//  EquimentAlarmsModel.m
//  NetCamera
//
//  Created by 汪伟 on 2020/12/1.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "EquimentAlarmsModel.h"

@implementation EquimentAlarmsModel

+(EquimentAlarmsModel*)makeModelData:(NSDictionary*)dic
{
    EquimentAlarmsModel *model = [EquimentAlarmsModel new];

    model.alarm_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    model.status = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
    model.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"text"]];
    model.time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"time"]];
    model.alarm_type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
    model.creationTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"creationTime"]];
    model.count = [NSString stringWithFormat:@"%@",[dic objectForKey:@"count"]];
    model.severity = [NSString stringWithFormat:@"%@",[dic objectForKey:@"severity"]];

    return model;
}
@end
