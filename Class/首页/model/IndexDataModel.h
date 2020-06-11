//
//  IndexDataModel.h
//  NetCamera
//
//  Created by 汪伟 on 2020/2/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IndexDataModel : NSObject

+(IndexDataModel*)makeModelData:(NSDictionary*)dic;

@property (nonatomic,strong) NSString *equipment_id;//设备id
@property (nonatomic,strong) NSString *equipment_name;//设备名称
@property (nonatomic,strong) NSString *equipment_address;//设备地址
@property (nonatomic,strong) NSString *equipment_states;//设备状态
@property (nonatomic,strong) NSArray *equipment_nums;//设备数量
@property (nonatomic,strong) NSArray *childDevices_info;//子设备组信息
@property (nonatomic,strong) NSString *childDevices_id;//子设备id
@property (nonatomic,strong) NSString *serial;//子设备serial

@property (nonatomic,strong) NSArray *liveModelArray;//直播集合


@end

@interface IndexChildDataModel : NSObject

+(IndexChildDataModel*)makeModelData:(NSDictionary*)dic;

@property (nonatomic,strong) NSString *childDevices_id;//子设备id
@property (nonatomic,strong) NSString *childDevices_name;//子设备名称

@end

NS_ASSUME_NONNULL_END
