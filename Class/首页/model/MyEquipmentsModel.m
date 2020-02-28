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
    
    model.equipment_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@""]];
    model.equipment_name = [NSString stringWithFormat:@"%@",[dic objectForKey:@""]];
    model.equipment_address = [NSString stringWithFormat:@"%@",[dic objectForKey:@""]];
    model.equipment_states = [NSString stringWithFormat:@"%@",[dic objectForKey:@""]];


    return model;
}

@end
