//
//  MyEquipmentsModel.h
//  NetCamera
//
//  Created by 汪伟 on 2020/2/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyEquipmentsModel : NSObject

+(MyEquipmentsModel*)makeModelData:(NSDictionary*)dic;

@property (nonatomic,strong) NSString *equipment_id;//设备id
@property (nonatomic,strong) NSString *equipment_name;//设备名称
@property (nonatomic,strong) NSString *equipment_Channel;//通道
@property (nonatomic,strong) NSString *equipment_states;//设备状态
@property (nonatomic,strong) NSString *c8y_Notes;
@property (nonatomic,strong) NSString *CameraId;
@property (nonatomic,strong) NSString *ClientId;
@property (nonatomic,strong) NSString *DeviceId;
@property (nonatomic,strong) NSString *owner;
@property (nonatomic,strong) NSString *lastUpdated;
@property (nonatomic,strong) NSString *creationTime;
@property (nonatomic,strong) NSString *responseInterval;





@end

NS_ASSUME_NONNULL_END
