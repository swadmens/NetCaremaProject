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

@property (nonatomic,strong) NSString *live_type;
@property (nonatomic,strong) NSString *title_value;
@property (nonatomic,strong) CarmeaVideosModel *model;
@property (nonatomic,strong) DemandModel *ddMdodel;
@property (nonatomic,strong) NSArray *allDataArray;
@property (nonatomic,assign) NSInteger indexInteger;
@property (nonatomic,assign) BOOL isLiving;//是否是直播
@property (nonatomic, assign) BOOL isVideoFile;//是否是录像文件
@property (nonatomic, assign) BOOL isDemandFile;//是否是点播文件

+(UIViewController *)viewController:(UIView *)view;


@end

NS_ASSUME_NONNULL_END
