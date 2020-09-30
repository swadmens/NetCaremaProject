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
@property (nonatomic,strong) NSString *equipment_type;
@property (nonatomic,strong) NSString *lastUpdated;
@property (nonatomic,strong) NSString *creationTime;
@property (nonatomic,strong) NSString *owner;
@property (nonatomic,strong) NSString *system_Source;
@property (nonatomic,strong) NSString *deviceSerial;
@property (nonatomic,strong) NSString *responseInterval;
@property (nonatomic,assign) BOOL online;



@property (nonatomic,strong) NSString *source_id;
@property (nonatomic,strong) NSString *source_name;
@property (nonatomic,strong) NSString *source_type;
@property (nonatomic,strong) NSString *source_password;
@property (nonatomic,strong) NSString *source_charset;
@property (nonatomic,strong) NSString *source_manufacturer;
@property (nonatomic,strong) NSString *source_remoteIP;
@property (nonatomic,strong) NSString *source_remotePort;
@property (nonatomic,strong) NSString *source_contactIP;
@property (nonatomic,strong) NSString *source_channelCount;
@property (nonatomic,strong) NSString *source_recvStreamIP;
@property (nonatomic,strong) NSString *source_smsid;
@property (nonatomic,strong) NSString *source_online;
@property (nonatomic,strong) NSString *source_commandTransport;
@property (nonatomic,strong) NSString *source_mediaTransport;
@property (nonatomic,strong) NSString *source_mediaTransportMode;
@property (nonatomic,strong) NSString *source_catalogInterval;


@property (nonatomic,strong) NSMutableArray *childDevices_info;//子设备组信息
@property (nonatomic,strong) NSString *childDevices_id;//子设备id
@property (nonatomic,strong) NSArray *equipment_nums;//设备数量





@end

@interface IndexChildDataModel : NSObject

+(IndexChildDataModel*)makeModelData:(NSDictionary*)dic;

@property (nonatomic,strong) NSString *childDevices_id;//子设备id
@property (nonatomic,strong) NSString *childDevices_name;//子设备名称

@end

NS_ASSUME_NONNULL_END
