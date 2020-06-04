//
//  PLPlayerView.h
//  NiuPlayer
//
//  Created by hxiongan on 2018/3/7.
//  Copyright © 2018年 hxiongan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLPlayerView;
@class DemandModel;
@protocol PLPlayerViewDelegate <NSObject>

- (void)playerViewEnterFullScreen:(PLPlayerView *)playerView;

- (void)playerViewExitFullScreen:(PLPlayerView *)playerView;

- (void)playerViewWillPlay:(PLPlayerView *)playerView;

- (void)theLocalFileDoesNotExist:(PLPlayerView *)playerView;

- (void)getSnapshot:(PLPlayerView *)playerView with:(UIImage*)image;
@end

@interface PLPlayerView : UIView

@property (nonatomic, weak) id<PLPlayerViewDelegate> delegate;

@property (nonatomic, strong) DemandModel *media;

@property (nonatomic,assign) BOOL isLocalVideo;//是否是本地视频


- (void)play;

- (void)stop;

- (void)pause;

- (void)resume;

- (void)configureVideo:(BOOL)enableRender;

-(void)clickEnterFullScreenButton;

-(void)clickSnapshotButton;

- (void)changeVolume:(float)volume;

@end


typedef enum : NSUInteger {
    PLPlayerRatioDefault,
    PLPlayerRatioFullScreen,
    PLPlayerRatio16x9,
    PLPlayerRatio4x3,
} PLPlayerRatio;


@class PLControlView;
@protocol PLControlViewDelegate <NSObject>

- (void)controlViewClose:(PLControlView *)controlView;

- (void)controlView:(PLControlView *)controlView speedChange:(CGFloat)speed;

- (void)controlView:(PLControlView *)controlView ratioChange:(PLPlayerRatio)ratio;

- (void)controlView:(PLControlView *)controlView backgroundPlayChange:(BOOL)isBackgroundPlay;

- (void)controlViewMirror:(PLControlView *)controlView;

- (void)controlViewRotate:(PLControlView *)controlView;

- (BOOL)controlViewCache:(PLControlView *)controlView;

@end

@interface PLControlView : UIView

@property (nonatomic, weak) id<PLControlViewDelegate> delegate;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UISegmentedControl *speedControl;
@property (nonatomic, strong) UISegmentedControl *ratioControl;
@property (nonatomic, strong) UILabel *speedValueLabel;
@property (nonatomic, strong) UILabel *speedTitleLabel;

@property (nonatomic, strong) UIButton *playBackgroundButton;
@property (nonatomic, strong) UIButton *mirrorButton;
@property (nonatomic, strong) UIButton *rotateButton;
@property (nonatomic, strong) UIButton *cacheButton;

- (void)resetStatus;
@end
