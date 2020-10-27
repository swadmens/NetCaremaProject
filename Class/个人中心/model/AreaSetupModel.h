//
//  AreaSetupModel.h
//  NetCamera
//
//  Created by 汪伟 on 2020/10/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AreaSetupModel : NSObject

+(AreaSetupModel*)makeModelData:(NSDictionary*)dic;

@property (nonatomic,strong) NSString *creationTime;
@property (nonatomic,strong) NSString *area_id;
@property (nonatomic,strong) NSString *lastUpdated;
@property (nonatomic,strong) NSString *locationDetail;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *nameEn;
@property (nonatomic,strong) NSString *owner;
@property (nonatomic,strong) NSString *shortName;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) NSString *floor;
@property (nonatomic,strong) NSString *building;

@property (nonatomic,strong) NSArray *deviceIds;//设备id集合


@end

NS_ASSUME_NONNULL_END
