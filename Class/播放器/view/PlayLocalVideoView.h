//
//  PlayLocalVideoView.h
//  NetCamera
//
//  Created by 汪伟 on 2020/5/13.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PlayLocalVideoView;
@protocol PlayLocalVideoViewDelegate <NSObject>

- (void)tableViewWillPlay:(PlayLocalVideoView *)view;

- (void)tableViewCellEnterFullScreen:(PlayLocalVideoView *)view;

- (void)tableViewCellExitFullScreen:(PlayLocalVideoView *)view;

- (void)getLocalViewSnap:(PlayLocalVideoView *)view with:(UIImage*)image;

@end


@class DemandModel;
@interface PlayLocalVideoView : UIView

@property (nonatomic, assign) id<PlayLocalVideoViewDelegate> delegate;

@property (nonatomic,strong) DemandModel *model;
- (void)stop;
- (void)play;
- (void)pause;
- (void)resume;

-(void)clickSnapshotButton;
-(void)makePlayerViewFullScreen;
- (void)changeVolume:(float)volume;


@end

NS_ASSUME_NONNULL_END
