//
//  EquipmentAbilityModel.h
//  NetCamera
//
//  Created by 汪伟 on 2020/10/15.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EquipmentAbilityModel : NSObject

+(EquipmentAbilityModel*)makeModelData:(NSDictionary*)dic;

@property (nonatomic,assign) BOOL ptz;  // 云台控制
@property (nonatomic,assign) BOOL preset;  //　预置点
@property (nonatomic,assign) BOOL cloudStorage;  //　云存储
@property (nonatomic,assign) BOOL mirror;  // 镜像翻转
@property (nonatomic,assign) BOOL capture;  // 抓图
@property (nonatomic,assign) BOOL defence;  // 布撤防/动检


@end

NS_ASSUME_NONNULL_END
