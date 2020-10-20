//
//  EquimentBasicInfoController.h
//  NetCamera
//
//  Created by 汪伟 on 2020/3/2.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class MyEquipmentsModel;
@interface EquimentBasicInfoController : WWViewController

@property (nonatomic,strong) NSString *equiment_id;
@property (nonatomic,strong) MyEquipmentsModel *model;


@end

NS_ASSUME_NONNULL_END
