//
//  SuperPlayerViewController.h
//  NetCamera
//
//  Created by 汪伟 on 2020/5/7.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SuperPlayerDelegate <NSObject>

//删除点播文件回调方法
-(void)deleteDemandSuccess;

@end


@class DemandModel;
@class CarmeaVideosModel;
@class MyEquipmentsModel;
@interface SuperPlayerViewController : WWViewController

@property (nonatomic,assign) id<SuperPlayerDelegate>delegate;

//直播
-(void)makeViewLiveData:(NSArray*)dataArray withTitle:(NSString*)title;

//摄像头录像（本地/云端）
-(void)makeViewVideoData:(MyEquipmentsModel*)model withCarmea:(CarmeaVideosModel*)carmeaModel;

//点播文件
-(void)makeViewDemandData:(DemandModel*)model;

+(UIViewController *)viewController:(UIView *)view;


@end

NS_ASSUME_NONNULL_END
