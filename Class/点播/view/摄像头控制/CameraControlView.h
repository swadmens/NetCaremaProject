//
//  CameraControlView.h
//  NetCamera
//
//  Created by 汪伟 on 2020/4/20.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    ControlStateUp = 0,
    ControlStateDown = 1,
    ControlStateLeft = 2,
    ControlStaterRight = 3,
    ControlStaterLeftUp = 4,
    ControlStaterLeftDown = 5,
    ControlStaterRightUp = 6,
    ControlStaterRightDown = 7,
    ControlStaterStop = 8,
    ControlStaterZoomin = 9,//大小
    ControlStaterZoomout = 10,
    ControlStaterFocusin = 11,//聚焦
    ControlStaterFocusout = 12,
    ControlStaterAperturein = 13,//光圈
    ControlStaterApertureout = 14,
}ControlState;

@class CameraControlView;
@protocol CameraControlDelete <NSObject>

-(void)cameraControl:(CameraControlView *_Nullable)CameraControlView withState:(ControlState)state;

@end


NS_ASSUME_NONNULL_BEGIN

@interface CameraControlView : UIView

@property (nonatomic, weak) id<CameraControlDelete> delegate;

@property (nonatomic,assign) BOOL isLiveGBS;//是否是GBS摄像

@end

NS_ASSUME_NONNULL_END
