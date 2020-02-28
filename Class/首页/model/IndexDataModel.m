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
    
    model.equipment_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@""]];
    model.equipment_name = [NSString stringWithFormat:@"%@",[dic objectForKey:@""]];
    model.equipment_address = [NSString stringWithFormat:@"%@",[dic objectForKey:@""]];
    model.equipment_states = [NSString stringWithFormat:@"%@",[dic objectForKey:@""]];

    
    
    
    return model;
}

@end
