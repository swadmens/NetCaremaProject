//
//  SingleEquipmentModel.h
//  NetCamera
//
//  Created by 汪伟 on 2020/10/15.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SingleEquipmentModel : NSObject

+(SingleEquipmentModel*)makeModelData:(NSDictionary*)dic;

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *equipment_id;
@property (nonatomic,strong) NSString *channel;
@property (nonatomic,strong) NSString *creationTime;
@property (nonatomic,strong) NSString *deviceSerial;
@property (nonatomic,strong) NSString *lastUpdated;
@property (nonatomic,strong) NSString *owner;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *system_Source;
@property (nonatomic,strong) NSString *responseInterval;
@property (nonatomic,assign) BOOL online;//是否在线
@property (nonatomic,strong) NSString *type;

@property (nonatomic,assign) BOOL cloudRecordStatus;//云端录像开关状态

@property (nonatomic,strong) NSArray *presets;//预置点

@end

NS_ASSUME_NONNULL_END
