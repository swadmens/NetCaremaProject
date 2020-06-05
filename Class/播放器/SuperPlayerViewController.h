//
//  SuperPlayerViewController.h
//  NetCamera
//
//  Created by 汪伟 on 2020/5/7.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class DemandModel;
@class CarmeaVideosModel;
@interface SuperPlayerViewController : WWViewController

@property (nonatomic,strong) NSString *gbs_serial;
@property (nonatomic,strong) NSString *gbs_code;
@property (nonatomic,strong) NSString *live_type;
@property (nonatomic,strong) NSString *nvr_channel;

@property (nonatomic,assign) BOOL isLiving;//是否是直播
@property (nonatomic,strong) NSString *title_value;
@property (nonatomic,strong) DemandModel *model;
@property (nonatomic,strong) CarmeaVideosModel *carmeaModel;
@property (nonatomic,strong) NSArray *allDataArray;
@property (nonatomic,assign) NSInteger indexInteger;
@property (nonatomic, assign) BOOL isRecordFile;
@property (nonatomic,strong) NSString *device_id;//具体设备id

+(UIViewController *)viewController:(UIView *)view;


@end

NS_ASSUME_NONNULL_END
