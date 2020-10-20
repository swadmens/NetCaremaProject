//
//  LocalVideoViewController.h
//  NetCamera
//
//  Created by 汪伟 on 2020/4/29.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class CarmeaVideosModel;
@protocol LocalVideoDelegate <NSObject>

-(void)selectRowData:(CarmeaVideosModel*)model;

@end

@class MyEquipmentsModel;
@interface LocalVideoViewController : WWViewController

@property (nonatomic,weak) id<LocalVideoDelegate>delegate;

@property (nonatomic,assign) BOOL isFromIndex;
@property (nonatomic,strong) MyEquipmentsModel *model;//具体设备id,设备国标编号
@property (nonatomic,strong) NSString *recordType;//本地或云端录像


@end

NS_ASSUME_NONNULL_END
