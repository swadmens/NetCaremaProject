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
-(void)cameraColseControl:(CameraControlView *_Nullable)CameraControlView;
-(void)addNewPerSet:(CameraControlView *_Nullable)CameraControlView withName:(NSString*_Nonnull)name;

@end


NS_ASSUME_NONNULL_BEGIN
@class EquipmentAbilityModel;
@interface CameraControlView : UIView

@property (nonatomic, weak) id<CameraControlDelete> delegate;

-(void)makeAllData:(NSArray*)presets withSystemSource:(NSString*)systemSource withDevice_id:(NSString*)device_id withIndex:(NSInteger)index withAbility:(EquipmentAbilityModel*)model;


@end

NS_ASSUME_NONNULL_END
