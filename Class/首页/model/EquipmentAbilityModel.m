//
//  EquipmentAbilityModel.m
//  NetCamera
//
//  Created by 汪伟 on 2020/10/15.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "EquipmentAbilityModel.h"

@implementation EquipmentAbilityModel
+(EquipmentAbilityModel*)makeModelData:(NSDictionary*)dic
{
    EquipmentAbilityModel *model = [[EquipmentAbilityModel alloc]init];
    
    model.capture = [[dic objectForKey:@"capture"] boolValue];
    model.cloudStorage = [[dic objectForKey:@"cloudStorage"] boolValue];
    model.defence = [[dic objectForKey:@"defence"] boolValue];
    model.mirror = [[dic objectForKey:@"mirror"] boolValue];
    model.preset = [[dic objectForKey:@"preset"] boolValue];
    model.ptz = [[dic objectForKey:@"ptz"] boolValue];

    return model;
}

@end
