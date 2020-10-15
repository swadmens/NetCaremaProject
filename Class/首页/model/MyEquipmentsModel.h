//
//  MyEquipmentsModel.h
//  NetCamera
//
//  Created by 汪伟 on 2020/2/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LivingModel;
@interface MyEquipmentsModel : NSObject

+(MyEquipmentsModel*)makeModelData:(NSDictionary*)dic;

@property (nonatomic,strong) NSString *equipment_id;//设备id
@property (nonatomic,strong) NSString *equipment_name;//设备名称
@property (nonatomic,strong) NSString *equipment_Channel;//通道
@property (nonatomic,strong) NSString *equipment_states;//设备状态
@property (nonatomic,strong) NSString *c8y_Notes;
@property (nonatomic,strong) NSString *CameraId;
@property (nonatomic,strong) NSString *ClientId;
@property (nonatomic,strong) NSString *owner;
@property (nonatomic,strong) NSString *lastUpdated;
@property (nonatomic,strong) NSString *creationTime;
@property (nonatomic,strong) NSString *responseInterval;
@property (nonatomic,assign) BOOL online;//是否在线
@property (nonatomic,strong) NSString *system_Source;

@property (nonatomic,strong) LivingModel *model;

@property (nonatomic,strong) NSString *deviceSerial;
@property (nonatomic,assign) BOOL cloudStatus;//云端录像开关状态


@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *createdAt;
@property (nonatomic,strong) NSString *deviceID;
@property (nonatomic,strong) NSString *childDevice_id;
@property (nonatomic,strong) NSString *snapURL;
@property (nonatomic,strong) NSString *updatedAt;
@property (nonatomic,strong) NSString *manufacturer;
@property (nonatomic,strong) NSString *civilCode;
@property (nonatomic,strong) NSString *channel;

@property (nonatomic,strong) NSArray *presets;



@end

@interface PresetsModel : NSObject

+(PresetsModel*)makeModelData:(NSDictionary*)dic;

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *index;


@end

NS_ASSUME_NONNULL_END
