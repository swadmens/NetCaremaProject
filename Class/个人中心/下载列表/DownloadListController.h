//
//  DownloadListController.h
//  NetCamera
//
//  Created by 汪伟 on 2020/3/5.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class DemandModel;
@interface DownloadListController : WWViewController

@property (nonatomic,strong) NSString *downLoad_id;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) DemandModel *demandModel;

@end

NS_ASSUME_NONNULL_END
