//
//  LocalVideoViewController.h
//  NetCamera
//
//  Created by 汪伟 on 2020/4/29.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LocalVideoDelegate <NSObject>

-(void)selectRowData:(NSInteger)value;

@end

@interface LocalVideoViewController : WWViewController

@property (nonatomic,weak) id<LocalVideoDelegate>delegate;

@property (nonatomic,assign) BOOL isFromIndex;
@property (nonatomic,strong) NSString *device_id;//具体设备id,设备国标编号
@property (nonatomic,strong) NSString *code;//通道国标编号
@property (nonatomic,strong) NSString *system_Source;


@end

NS_ASSUME_NONNULL_END
