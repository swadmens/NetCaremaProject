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

@end

NS_ASSUME_NONNULL_END
