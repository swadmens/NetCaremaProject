//
//  HKVideoPlaybackController.h
//  NetCamera
//
//  Created by 汪伟 on 2020/3/5.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class DemandModel;
@class CarmeaVideosModel;
@interface HKVideoPlaybackController : WWViewController
@property (nonatomic,strong) NSString *video_id;
@property (nonatomic,strong) DemandModel *model;
@property (nonatomic,strong) CarmeaVideosModel *carmeaModel;

@end

NS_ASSUME_NONNULL_END
