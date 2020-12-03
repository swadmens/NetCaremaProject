//
//  EquimentAlarmsModel.h
//  NetCamera
//
//  Created by 汪伟 on 2020/12/1.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EquimentAlarmsModel : NSObject

+(EquimentAlarmsModel*)makeModelData:(NSDictionary*)dic;

@property (nonatomic,strong) NSString *alarm_id;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *alarm_type;
@property (nonatomic,strong) NSString *creationTime;
@property (nonatomic,strong) NSString *count;
@property (nonatomic,strong) NSString *severity;



@end

NS_ASSUME_NONNULL_END
