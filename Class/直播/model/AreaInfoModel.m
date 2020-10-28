//
//  AreaInfoModel.m
//  NetCamera
//
//  Created by 汪伟 on 2020/10/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "AreaInfoModel.h"

@implementation AreaInfoModel

+(AreaInfoModel*)makeModelData:(NSDictionary*)dic
{
    AreaInfoModel *model = [AreaInfoModel new];
    
    model.areaType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"areaType"]];
    
    model.shortNames = [NSArray arrayWithArray:[dic objectForKey:@"shortNames"]];
    
    return model;
}


@end
