//
//  PLPlayerView.m
//  NiuPlayer
//
//  Created by hxiongan on 2018/3/7.
//  Copyright © 2018年 hxiongan. All rights reserved.
//

#import "PLPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "PLPlayModel.h"
#import <UIImageView+YYWebImage.h>
#import <UIImageView+WebCache.h>
#import <EZUIKit/EZUIPlayer.h>
#import <EZUIKit/EZUIError.h>
#import <LCOpenSDKDynamic/LCOpenSDKDynamic.h>
#import <EZUIKit/EZUIKit.h>
#import <EZOpenSDKFramework/EZOpenSDK.h>
#import <EZOpenSDKFramework/EZPlayer.h>
#import "RequestSence.h"
#import "LivingModel.h"


typedef NS_ENUM(NSInteger, PlayLCState) {
    Play = 0,
    Pause = 1,
    Stop = 2
};
#define HikSecret @"0a042989a3dc9fc8c1bd2f26ac88e99d"
#define EZOPENSDK [EZOpenSDK class]

@class PLControlView;

@interface PLPlayerView ()
<
PLPlayerDelegate,
PLControlViewDelegate,
UIGestureRecognizerDelegate,
EZUIPlayerDelegate,
LCOpenSDK_EventListener,
EZPlayerDelegate
>

@property (nonatomic, strong) UIView *topBarView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIButton *exitfullScreenButton;

@property (nonatomic, strong) UIView *bottomBarView;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *playTimeLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIProgressView *bufferingView;
@property (nonatomic, strong) UIButton *enterFullScreenButton;

// 在bottomBarView上面的播放暂停按钮，全屏的时候，显示
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *pauseButton;

@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, assign) UIDeviceOrientation deviceOrientation;

@property (nonatomic, strong) PLPlayer *player;
@property (nonatomic, strong) PLPlayerOption *playerOption;
@property (nonatomic, assign) BOOL isNeedSetupPlayer;
@property (nonatomic, assign) BOOL isFullScreen;//是否是全屏
@property (nonatomic, assign) BOOL clarity;//是否是标清

@property (nonatomic, strong) NSTimer *playTimer;

// 在屏幕中间的播放和暂停按钮，全屏的时候，隐藏
@property (nonatomic, strong) UIButton *centerPlayButton;
@property (nonatomic, strong) UIButton *centerPauseButton;

@property (nonatomic, strong) UIButton *snapshotButton;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) PLControlView *controlView;

// 很多时候调用stop之后，播放器可能还会返回其它状态，导致逻辑混乱，记录一下，只要调用了播放器的 stop 方法，就将 isStop 置为 YES 做标记
@property (nonatomic, assign) BOOL isStop;

@property (nonatomic, assign) BOOL isStartPlay;

// 当底部的 bottomBarView 因隐藏的时候，提供两个 progrssview 在最底部，随时能看到播放进度和缓冲进度
@property (nonatomic, strong) UIProgressView *bottomPlayProgreeeView;
@property (nonatomic, strong) UIProgressView *bottomBufferingProgressView;

// 适配iPhone X
@property (nonatomic, assign) CGFloat edgeSpace;

@property (nonatomic,strong) EZUIPlayer *ePlayer;//海康播放器
@property (nonatomic,strong) EZPlayer *ezPlayer;//海康播放器
@property (nonatomic,strong) NSDate *mBeginDate;//滚动视图开始日期点
@property (nonatomic,strong) NSDateFormatter *mFormatter;//格式化日期

@property (nonatomic,strong) LCOpenSDK_PlayWindow* m_play;//大华播放器
@property (nonatomic,assign) PlayLCState m_playState;
@property (nonatomic,strong) LCOpenSDK_Api* m_hc;
@property (nonatomic,assign) NSTimeInterval m_deltaTime;
@property (nonatomic,assign) BOOL m_isSeeking;
@property (nonatomic,strong) NSString* m_streamPath;


@end

@implementation PLPlayerView

-(void)dealloc {
    [self unsetupPlayer];
}
- (void)configureVideo:(BOOL)enableRender {
    self.player.enableRender = enableRender;
    
    // 避免在未更新画面渲染的情况下，动态翻转移动画布 2020-02-13 hera
    if (!enableRender) {
        [self removeFullStreenNotify];
    } else{
        [self addFullStreenNotify];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        if (CGRectEqualToRect([UIScreen mainScreen].bounds, CGRectMake(0, 0, 375, 812))) {
            // iPhone X
            self.edgeSpace = 20;
        } else {
            self.edgeSpace = 5;
        }
        
        [self initTopBar];
        [self initBottomBar];
        [self initOtherUI];
        [self doStableConstraint];
        
        self.bottomBarView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.2];
        self.topBarView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.2];
        
        self.deviceOrientation = UIDeviceOrientationUnknown;
        [self transformWithOrientation:UIDeviceOrientationPortrait];
        
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:self.tapGesture];
        
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        self.panGesture.delegate = self;
    }
    return self;
   
        
}
- (BOOL)isFullScreen {
    return UIDeviceOrientationPortrait != self.deviceOrientation;
}

- (void)initTopBar {
    self.topBarView = [[UIView alloc] init];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.exitfullScreenButton = [[UIButton alloc] init];
    [self.exitfullScreenButton setImage:[UIImage imageNamed:@"player_back"] forState:(UIControlStateNormal)];
    [self.exitfullScreenButton addTarget:self action:@selector(clickExitFullScreenButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.moreButton = [[UIButton alloc] init];
    [self.moreButton setImage:[UIImage imageNamed:@"more"] forState:(UIControlStateNormal)];
    [self.moreButton addTarget:self action:@selector(clickMoreButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.topBarView addSubview:self.titleLabel];
    [self.topBarView addSubview:self.exitfullScreenButton];
    [self.topBarView addSubview:self.moreButton];
    
    [self addSubview:self.topBarView];
}

- (void)initBottomBar {
    
    self.bottomBarView = [[UIView alloc] init];
    
    self.playTimeLabel = [[UILabel alloc] init];
    self.playTimeLabel.font = [UIFont systemFontOfSize:12];
    if (@available(iOS 9, *)) {
        self.playTimeLabel.font= [UIFont monospacedDigitSystemFontOfSize:12 weight:(UIFontWeightRegular)];
    }
    self.playTimeLabel.textColor = [UIColor whiteColor];
    self.playTimeLabel.text = @"00:00:00";
    [self.playTimeLabel sizeToFit];
    
    self.durationLabel = [[UILabel alloc] init];
    self.durationLabel.font = [UIFont systemFontOfSize:12];
    if (@available(iOS 9.0, *)) {
        self.durationLabel.font= [UIFont monospacedDigitSystemFontOfSize:12 weight:(UIFontWeightRegular)];
    }
    self.durationLabel.textColor = [UIColor whiteColor];
    self.durationLabel.text = @"00:00:00";
    [self.durationLabel sizeToFit];
    
    self.slider = [[UISlider alloc] init];
    self.slider.continuous = NO;
    [self.slider setThumbImage:[UIImage imageNamed:@"slider_thumb"] forState:(UIControlStateNormal)];
    self.slider.maximumTrackTintColor = [UIColor clearColor];
    self.slider.minimumTrackTintColor = [UIColor colorWithRed:.2 green:.2 blue:.8 alpha:1];
    [self.slider addTarget:self action:@selector(sliderValueChange) forControlEvents:(UIControlEventValueChanged)];
    
    self.bufferingView = [[UIProgressView alloc] init];
    self.bufferingView.progressTintColor = [UIColor colorWithWhite:1 alpha:1];
    self.bufferingView.trackTintColor = [UIColor colorWithWhite:1 alpha:.33];
    
    self.enterFullScreenButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.enterFullScreenButton setTintColor:[UIColor whiteColor]];
    [self.enterFullScreenButton setImage:[UIImage imageNamed:@"full-screen"] forState:(UIControlStateNormal)];
    [self.enterFullScreenButton addTarget:self action:@selector(clickEnterFullScreenButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.playButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.playButton setTintColor:[UIColor whiteColor]];
    [self.playButton setImage:[UIImage imageNamed:@"player_play"] forState:(UIControlStateNormal)];
    [self.playButton addTarget:self action:@selector(clickPlayButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.pauseButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.pauseButton setTintColor:[UIColor whiteColor]];
    [self.pauseButton setImage:[UIImage imageNamed:@"player_stop"] forState:(UIControlStateNormal)];
    [self.pauseButton addTarget:self action:@selector(clickPauseButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addSubview:self.bottomBarView];
    [self.bottomBarView addSubview:self.playButton];
    [self.bottomBarView addSubview:self.pauseButton];
    [self.bottomBarView addSubview:self.playTimeLabel];
    [self.bottomBarView addSubview:self.durationLabel];
    [self.bottomBarView addSubview:self.bufferingView];
    [self.bottomBarView addSubview:self.slider];
    [self.bottomBarView addSubview:self.enterFullScreenButton];
}

- (void)initOtherUI {
    
    self.thumbImageView = [[UIImageView alloc] init];
    self.thumbImageView.contentMode =UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    
    self.controlView = [[PLControlView alloc] initWithFrame:self.bounds];
    self.controlView.hidden = YES;
    self.controlView.delegate = self;
    
    self.centerPlayButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.centerPlayButton setTintColor:[UIColor whiteColor]];
    [self.centerPlayButton setImage:[UIImage imageNamed:@"player_play"] forState:(UIControlStateNormal)];
    [self.centerPlayButton addTarget:self action:@selector(clickPlayButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.centerPauseButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.centerPauseButton setTintColor:[UIColor whiteColor]];
    [self.centerPauseButton setImage:[UIImage imageNamed:@"player_stop"] forState:(UIControlStateNormal)];
    [self.centerPauseButton addTarget:self action:@selector(clickPauseButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.snapshotButton = [[UIButton alloc] init];
    self.snapshotButton.hidden = YES;
    [self.snapshotButton addTarget:self action:@selector(clickSnapshotButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.snapshotButton setImage:[UIImage imageNamed:@"screen-cut"] forState:(UIControlStateNormal)];
    
    self.bottomPlayProgreeeView = [[UIProgressView alloc] init];
    self.bottomPlayProgreeeView.progressTintColor = [UIColor colorWithRed:.2 green:.2 blue:.8 alpha:1];
    self.bottomPlayProgreeeView.trackTintColor = [UIColor clearColor];
    
    self.bottomBufferingProgressView = [[UIProgressView alloc] init];
    self.bottomBufferingProgressView.progressTintColor = [UIColor colorWithWhite:1 alpha:1];
    self.bottomBufferingProgressView.trackTintColor = [UIColor colorWithWhite:1 alpha:.33];
    
    [self insertSubview:self.thumbImageView atIndex:0];
    [self addSubview:self.snapshotButton];
    [self addSubview:self.centerPauseButton];
    [self addSubview:self.centerPlayButton];
    [self addSubview:self.controlView];
    [self addSubview:self.bottomBufferingProgressView];
    [self addSubview:self.bottomPlayProgreeeView];
    
    self.pauseButton.hidden = YES;
    self.centerPauseButton.hidden = YES;
    self.clarity = YES;
}

// 这些控件的 Constraints 不会随着全屏和非全屏而需要做改变的
- (void)doStableConstraint {
    
    [self.topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_top);
        make.height.equalTo(@(44));
    }];
    
    [self.exitfullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.topBarView);
        make.left.equalTo(self.topBarView).offset(self.edgeSpace);
        make.width.equalTo(self.exitfullScreenButton.mas_height);
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.topBarView);
        make.right.equalTo(self.topBarView).offset(-self.edgeSpace);
        make.width.equalTo(self.moreButton.mas_height);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.exitfullScreenButton.mas_right);
        make.right.equalTo(self.moreButton.mas_left);
        make.centerY.equalTo(self.topBarView);
    }];
    
    [self.bottomBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_bottom);
        make.height.equalTo(@(44));
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomBarView);
        make.left.equalTo(self.playTimeLabel.mas_right).offset(5);
        make.right.equalTo(self.durationLabel.mas_left).offset(-5);
    }];
    
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.enterFullScreenButton.mas_left);
        make.centerY.equalTo(self.bottomBarView);
        make.size.equalTo(@(self.durationLabel.bounds.size));
    }];
    
    [self.pauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playButton);
    }];
    
    [self.centerPlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.equalTo(@(CGSizeMake(64, 64)));
    }];
    
    [self.centerPauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.centerPlayButton);
    }];
    
    [self.bufferingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.slider);
        make.centerY.equalTo(self.slider).offset(.5);
    }];
    
    [self.playTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playButton.mas_right);
        make.width.equalTo(@(self.playTimeLabel.bounds.size.width));
        make.centerY.equalTo(self.bottomBarView);
    }];
    
    [self.thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.snapshotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-self.edgeSpace);
        make.size.equalTo(@(CGSizeMake(60, 60)));
    }];
    
    [self.bottomBufferingProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(3));
    }];
    
    [self.bottomPlayProgreeeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bottomBufferingProgressView);
    }];
    
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(290);
    }];
    self.controlView.hidden = YES;
}

- (void)addTimer {
    [self removeTimer];
    self.playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)removeTimer {
    if (self.playTimer) {
        [self.playTimer invalidate];
        self.playTimer = nil;
    }
}

- (void)timerAction {
    if (self.playType == PlayerStatusHk || self.playType == PlayerStatusDH) {
        return;
    }
    
    if ([_plModel.recordType isEqualToString:@"local"]) {
        self.slider.value = CMTimeGetSeconds(self.player.currentTime);
        int duration = self.slider.value + .5;
        int hour = duration / 3600;
        int min  = (duration % 3600) / 60;
        int sec  = duration % 60;
        self.playTimeLabel.text = [NSString stringWithFormat:@"%d:%02d:%02d", hour, min, sec];
        self.bottomPlayProgreeeView.progress = self.slider.value / CMTimeGetSeconds(self.player.totalDuration);
    }else{
        self.slider.value = CMTimeGetSeconds(self.player.currentTime);
        if (CMTimeGetSeconds(self.player.totalDuration)) {
            int duration = self.slider.value + .5;
            int hour = duration / 3600;
            int min  = (duration % 3600) / 60;
            int sec  = duration % 60;
            self.playTimeLabel.text = [NSString stringWithFormat:@"%d:%02d:%02d", hour, min, sec];
            self.bottomPlayProgreeeView.progress = self.slider.value / CMTimeGetSeconds(self.player.totalDuration);
        }
    }
    
    
    
}

- (void)panGesture:(UIPanGestureRecognizer *)panGesture {

    if (UIGestureRecognizerStateChanged == panGesture.state) {
        CGPoint location  = [panGesture locationInView:panGesture.view];
        CGPoint translation = [panGesture translationInView:panGesture.view];
        [panGesture setTranslation:CGPointZero inView:panGesture.view];

#define FULL_VALUE 200.0f
        CGFloat percent = translation.y / FULL_VALUE;
        if (location.x > self.bounds.size.width / 2) {// 调节音量
            
            CGFloat volume = [self.player getVolume];
            volume -= percent;
            if (volume < 0.01) {
                volume = 0.01;
            } else if (volume > 3) {
                volume = 3;
            }
            [self.player setVolume:volume];
        } else {// 调节亮度f
            CGFloat currentBrightness = [[UIScreen mainScreen] brightness];
            currentBrightness -= percent;
            if (currentBrightness < 0.1) {
                currentBrightness = 0.1;
            } else if (currentBrightness > 1) {
                currentBrightness = 1;
            }
            [[UIScreen mainScreen] setBrightness:currentBrightness];
        }
    }
}
-(void)changeVolume:(float)volume
{
    [self.player setVolume:volume];
}
- (void)singleTap:(UIGestureRecognizer *)gesture {
    
    
    switch (_playType) {
        case PlayerStatusGBS:
            
            // 如果还木有初始化，直接初始化播放
            if (self.isNeedSetupPlayer || PLPlayerStatusStopped == self.player.status) {
                [self play];
                return;
            }
            
            if (PLPlayerStatusPaused == self.player.status) {
                [self resume];
                return;
            }
            
            if (PLPlayerStatusPlaying == self.player.status) {
                if (self.bottomBarView.frame.origin.y >= self.bounds.size.height) {
                    [self showBar];
                } else {
                    [self hideBar];
                }
            }
            
            break;
        case PlayerStatusHk:
            
            // 如果还木有初始化，直接初始化播放
            if (self.isNeedSetupPlayer) {
                [self play];
                return;
            }
            
            if (self.bottomBarView.frame.origin.y >= self.bounds.size.height) {
                [self showBar];
            } else {
                [self hideBar];
            }
   
            break;
        case PlayerStatusDH:
            
            break;
            
        default:
            break;
    }
      
}

- (void)hideBar {

    if (self.playType == PlayerStatusGBS) {
        if (PLPlayerStatusPlaying != self.player.status) return;
    }
    
    
    [self hideTopBar];
    [self hideBottomBar];
    self.centerPauseButton.hidden = YES;
    [self doConstraintAnimation];
    
}

- (void)showBar {
    
    if (!_isLiving) {
        [self showBottomBar];
    }
    self.centerPauseButton.hidden = NO;
    
    if ([self isFullScreen]) {
        [self showTopBar];
    }
    
    [self doConstraintAnimation];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBar) object:nil];
    [self performSelector:@selector(hideBar) withObject:nil afterDelay:3];
}

- (void)showControlView {
    
    [self hideBar];
    [self hideTopBar];
    self.centerPauseButton.hidden = YES;
    self.centerPlayButton.hidden = YES;
    
    self.controlView.hidden = NO;
    [self.controlView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self doConstraintAnimation];
}

- (void)hideControlView {
    
    [self.controlView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(290);
    }];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.controlView.hidden = YES;
    }];
}

- (void)clickExitFullScreenButton
{
    [self hideBottomBar];
    [self hideBottomProgressView];
    self.centerPauseButton.hidden = !self.isLiving;
    
    self.isFullScreen = NO;
    [self transformWithOrientation:UIDeviceOrientationPortrait];
}

- (void)clickEnterFullScreenButton {
    
    self.isFullScreen = YES;
    if (UIDeviceOrientationLandscapeRight == [[UIDevice currentDevice]orientation]) {
        [self transformWithOrientation:UIDeviceOrientationLandscapeRight];
    } else {
        [self transformWithOrientation:UIDeviceOrientationLandscapeLeft];
    }
}
- (void)clickMoreButton {
    [self removeGestureRecognizer:self.tapGesture];
    [self removeGestureRecognizer:self.panGesture];
    [self showControlView];
}

- (void)clickSnapshotButton {
    
    __weak typeof(self) wself = self;

    [NSObject haveAlbumAccess:^(BOOL isAuth) {
        if (!isAuth) return;
        
        [wself.player getScreenShotWithCompletionHandler:^(UIImage * _Nullable image) {
            if (image) {
//                [wself showTip:@"拍照成功"];
                if ([self.delegate respondsToSelector:@selector(getSnapshot:with:)]) {
                       [self.delegate getSnapshot:self with:image];
                   }
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
               
            }
        }];
    }];
}

- (void)sliderValueChange {
    
    NSInteger currentProgess = self.slider.value * [_plModel.duration floatValue]/1000;
    NSInteger hour = currentProgess / 3600;
    NSInteger minutes = currentProgess / 60;
    NSInteger second = currentProgess % 60;

    Float64 delta = self.slider.maximumValue - self.slider.value;
    
    switch (_playType) {
        case PlayerStatusGBS:
            
            if ([_plModel.recordType isEqualToString:@"local"]) {
                NSInteger timeInte = [[NSString stringWithFormat:@"%ld",(long)self.slider.value] integerValue];
                NSString *range = [NSString stringWithFormat:@"%ld",(long)timeInte];
                [self gbsLocalVideoPlayControl:@"play" withScale:@"1" withRange:range];
            }else{
                [self.player seekTo:CMTimeMake(self.slider.value * 1000, 1000)];
            }
            
            break;
        case PlayerStatusHk:
            
            [self showFullLoading];
            [self.ePlayer seekToTime:[self dateStringAfterFor:hour minutes:minutes second:second]];

            break;
        case PlayerStatusDH:
            _m_isSeeking = YES;
            [self showFullLoading];

            if (Pause == _m_playState) {
                [self.m_play resume];
                if ([self.plModel.recordType isEqualToString:@"local"]) {
                    return;
                }
            }
            _m_playState = Play;
            
            // seek到录像最后2秒内，录像可能无法播放,强制使seek在录像最后2秒以外
            if (delta < (2.0 / self.m_deltaTime)) {
                self.slider.value = (self.slider.maximumValue - 2.0 / _m_deltaTime) < self.slider.minimumValue ? self.slider.minimumValue : (self.slider.maximumValue - 2.0 / _m_deltaTime);
            }
            Float64 rate = self.slider.value / (self.slider.maximumValue - self.slider.minimumValue);
            [self.m_play seek:rate * _m_deltaTime];
            
            break;
            
        default:
            break;
    }
    
    
}

//HikPlayer时间处理
-(NSDate*)dateStringAfterFor:(NSInteger)hour minutes:(NSInteger)minutes second:(NSInteger)second
{
    //视频开始时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSDate *start_time = [dateFormatter dateFromString:_plModel.startTime];
    
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc]init];
    [offsetComponents setHour:hour];
    [offsetComponents setMinute:minutes];
    [offsetComponents setSecond:second];
    
    //结果时间
    NSDate *resultDate = [gregorian dateByAddingComponents:offsetComponents toDate:start_time options:0];
//    NSString *strDate = [dateFormatter stringFromDate:resultDate];
//    NSDate *newDate = [dateFormatter dateFromString:strDate];
    DLog(@"resultDate == %@",resultDate)

    return resultDate;
}



- (void)doConstraintAnimation {
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];

    [UIView animateWithDuration:.3 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)hideTopBar {
    [self.topBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_top);
        make.height.equalTo(@(44));
    }];
}

- (void)hideBottomBar {
    [self.bottomBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_bottom);
        make.height.equalTo(@(44));
    }];
    
    self.snapshotButton.hidden = YES;

//    if (PLPlayerStatusPlaying == self.player.status ||
//        PLPlayerStatusPaused == self.player.status ||
//        PLPlayerStatusCaching == self.player.status) {
//        [self showBottomProgressView];
//    }
    
//    if (self.playType != PlayerStatusGBS) {
//        [self showBottomProgressView];
//    }
    
}

- (void)showTopBar {
    [self.topBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@(44));
    }];
    self.snapshotButton.hidden = NO;
}

- (void)showBottomBar {
    [self.bottomBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@(44));
    }];
    
    [self hideBottomProgressView];
}

- (void)showBottomProgressView {
//    self.bottomBufferingProgressView.hidden = NO;
//    self.bottomPlayProgreeeView.hidden = NO;
}

- (void)hideBottomProgressView {
    self.bottomBufferingProgressView.hidden = YES;
    self.bottomPlayProgreeeView.hidden = YES;
}

- (void)transformWithOrientation:(UIDeviceOrientation)or {
    
    if (or == self.deviceOrientation) return;
       if (!(UIDeviceOrientationPortrait == or || UIDeviceOrientationLandscapeLeft == or || UIDeviceOrientationLandscapeRight == or)) return;
       
       BOOL isFirst = UIDeviceOrientationUnknown == self.deviceOrientation;
       
       if (or == UIDeviceOrientationPortrait) {
           
           [self removeGestureRecognizer:self.panGesture];
           self.snapshotButton.hidden = YES;
           
           [self.playButton mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.top.bottom.equalTo(self.bottomBarView);
               make.left.equalTo(self.bottomBarView).offset(5);
               make.width.equalTo(0);
           }];
           
           [self.enterFullScreenButton mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.right.top.bottom.equalTo(self.bottomBarView);
               make.width.equalTo(self.enterFullScreenButton.mas_height);
           }];
           
           [self.centerPlayButton mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.center.equalTo(self);
               make.size.equalTo(CGSizeMake(64, 64));
           }];
           
           CGFloat height = kScreenWidth * 0.68 + 0.5;
           [self.ePlayer setPreviewFrame:CGRectMake(0, 0, kScreenWidth, height)];
           [self.ePlayer.previewView mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.center.equalTo(self);
               make.size.equalTo(CGSizeMake(kScreenWidth, height));
           }];
           
           [self.m_play setWindowFrame:CGRectMake(0, 0, kScreenHeight, height)];
           [self.m_play.getWindowView mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.center.equalTo(self);
               make.size.equalTo(CGSizeMake(kScreenHeight, height));
           }];
          
           
           if (!isFirst) {
               [self hideTopBar];
               [self hideControlView];
               [self doConstraintAnimation];
               [self.delegate playerViewExitFullScreen:self];
               if (![self.gestureRecognizers containsObject:self.tapGesture]) {
                   [self addGestureRecognizer:self.tapGesture];
               }
               if (_isLiving) {
                   [self hideBottomBar];
                   self.centerPauseButton.hidden = YES;
                   self.centerPlayButton.hidden = YES;
               }
               
           }
           
           
           [UIView animateWithDuration:.3 animations:^{
               self.transform = CGAffineTransformMakeRotation(0);
           }];
           
       } else {

           if (![[self gestureRecognizers] containsObject:self.panGesture]) {
               [self addGestureRecognizer:self.panGesture];
           }
           
           CGFloat duration = .5;
           if (!UIDeviceOrientationIsLandscape(self.deviceOrientation)) {
               duration = .3;
               
               [self.playButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                   make.top.bottom.equalTo(self.bottomBarView);
                   make.left.equalTo(self.bottomBarView).offset(self.edgeSpace);
                   make.width.equalTo(self.playButton.mas_height);
               }];
               
               [self.enterFullScreenButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                   make.top.bottom.equalTo(self.bottomBarView);
                   make.right.equalTo(self.bottomBarView).offset(-self.edgeSpace);
                   make.width.equalTo(0);
               }];
               
               [self.centerPlayButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                   make.center.equalTo(self);
                   make.size.equalTo(CGSizeMake(0, 0));
               }];
               
               [self.ePlayer setPreviewFrame:CGRectMake(0, 0, kScreenHeight, kScreenWidth)];
               [self.ePlayer.previewView mas_remakeConstraints:^(MASConstraintMaker *make) {
                   make.center.equalTo(self);
                   make.size.equalTo(CGSizeMake(kScreenHeight, kScreenWidth));
               }];
               
               [self.m_play setWindowFrame:CGRectMake(0, 0, kScreenHeight, kScreenWidth)];
               [self.m_play.getWindowView mas_remakeConstraints:^(MASConstraintMaker *make) {
                   make.center.equalTo(self);
                   make.size.equalTo(CGSizeMake(kScreenHeight, kScreenWidth));
               }];
               
               [self doConstraintAnimation];
           }
           
           [UIView animateWithDuration:duration animations:^{
               self.transform = UIDeviceOrientationLandscapeLeft == or ? CGAffineTransformMakeRotation(M_PI/2) : CGAffineTransformMakeRotation(3*M_PI/2);
           }];
           
           if (UIDeviceOrientationUnknown != self.deviceOrientation) {
               [self.delegate playerViewEnterFullScreen:self];
           }
           

           
       }
       
       self.deviceOrientation = or;
}
-(void)addFullStreenNotify{
    
    [self removeFullStreenNotify];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvDeviceOrientationChangeNotify:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)removeFullStreenNotify{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)recvDeviceOrientationChangeNotify:(NSNotification*)info{
    UIDeviceOrientation or = [[UIDevice currentDevice]orientation];
    [self transformWithOrientation:or];
}

- (void)clickPauseButton {
    [self pause];
}

- (void)clickPlayButton {
        
    if (PLPlayerStatusPaused == self.player.status) {
        [self resume];
    } else {
        [self play];
    }
    
//    if (<#condition#>) {
//        <#statements#>
//    }
    
}

- (void)setupPlayer {
    [self unsetupPlayer];
    
    NSString *playUrl = self.clarity?_plModel.videoUrl:_plModel.videoHDUrl;
    NSLog(@"播放地址: %@", playUrl);
    if (![WWPublicMethod isStringEmptyText:playUrl]) {
        [_kHUDManager showMsgInView:nil withTitle:@"视频地址有误！！！" isSuccess:YES];
        return;
    }
    
    
    
    if (![WWPublicMethod isStringEmptyText:_plModel.videoHDUrl]) {
        _plModel.videoHDUrl = _plModel.videoUrl;
    }
    
    self.thumbImageView.hidden = NO;
    [self.thumbImageView yy_setImageWithURL:[NSURL URLWithString:_plModel.picUrl] options:YYWebImageOptionProgressive];
    
    CGFloat height = kScreenWidth * 0.68 + 0.5;

    if (self.playType == PlayerStatusGBS) {
        
        self.playerOption = [PLPlayerOption defaultOption];
        PLPlayFormat format = kPLPLAY_FORMAT_UnKnown;
        NSString *urlString = _plModel.videoUrl.lowercaseString;
        if ([urlString hasSuffix:@"mp4"]) {
            format = kPLPLAY_FORMAT_MP4;
        } else if ([urlString hasPrefix:@"rtmp:"]) {
            format = kPLPLAY_FORMAT_FLV;
        } else if ([urlString hasSuffix:@".mp3"]) {
            format = kPLPLAY_FORMAT_MP3;
        } else if ([urlString hasSuffix:@".m3u8"]) {
            format = kPLPLAY_FORMAT_M3U8;
        }
        
        [self.playerOption setOptionValue:@(format) forKey:PLPlayerOptionKeyVideoPreferFormat];
        [self.playerOption setOptionValue:@(kPLLogNone) forKey:PLPlayerOptionKeyLogLevel];

        NSDate *date = [NSDate date];
        self.player = [PLPlayer playerWithURL:[NSURL URLWithString:self.clarity?_plModel.videoUrl:_plModel.videoHDUrl] option:self.playerOption];
        NSLog(@"playerWithURL 耗时： %f s",[[NSDate date] timeIntervalSinceDate:date]);
        
        self.player.delegateQueue = dispatch_get_main_queue();
        self.player.playerView.contentMode = UIViewContentModeScaleAspectFit;
        self.player.delegate = self;
        self.player.loopPlay = YES;
        
        [self insertSubview:self.player.playerView atIndex:0];
        self.player.playerView.frame = self.bounds;
        [self.player.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        //更多操作，直播时隐藏
        self.moreButton.hidden = _isLiving;
        
    }else if (self.playType == PlayerStatusHk){
        
        self.isLiving = NO;
        
        [EZUIKit initWithAppKey:_plModel.appKey];
        [EZUIKit setAccessToken:_plModel.token];

        [EZOpenSDK initLibWithAppKey:_plModel.appKey];
        [EZOpenSDK setAccessToken:_plModel.token];

        _m_deltaTime = [self transformToDeltaTime:_plModel.startTime EndTime:_plModel.endTime];

//        NSString *url = @"http://hls01open.ys7.com/openlive/ed751f99c9a9446f8235f09152e3abd3.m3u8";
//        self.ePlayer = [EZUIPlayer createPlayerWithUrl:url];

        self.ePlayer = [EZUIPlayer createPlayerWithUrl:self.clarity?_plModel.videoUrl:_plModel.videoHDUrl];
        self.ePlayer.mDelegate = self;
        self.ePlayer.previewView.userInteractionEnabled = YES;
       //添加预览视图到当前界面
        self.ePlayer.previewView.contentMode = UIViewContentModeScaleAspectFit;
        [self insertSubview:self.ePlayer.previewView atIndex:0];
        self.ePlayer.previewView.frame = self.bounds;
        [self.ePlayer.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.equalTo(CGSizeMake(kScreenWidth, height));
        }];
        
        
//        EZCloudRecordFile *cloudFile = [[EZCloudRecordFile alloc]init];
//        cloudFile.
//        self.ezPlayer = [EZPlayer createPlayerWithUrl:self.clarity?_plModel.videoUrl:_plModel.videoHDUrl];
//        self.ezPlayer.delegate = self;
//        [self.ezPlayer setPlayerView:self];
//        [self.ezPlayer startPlaybackFromCloud:cloudFile];
        
        
        
    }else{
        _m_isSeeking = NO;
        
        //接口初始化
        LCOpenSDK_ApiParam * apiParam = [[LCOpenSDK_ApiParam alloc] init];
        apiParam.procotol =  PROCOTOL_TYPE_HTTPS;
        apiParam.addr = @"openapi.lechange.cn";
        apiParam.port = 443;
        apiParam.token = _plModel.accessToken;
        self.m_hc = [[LCOpenSDK_Api shareMyInstance] initOpenApi:apiParam];

        //大华视频加载
        self.m_play = [[LCOpenSDK_PlayWindow alloc] initPlayWindow:CGRectMake(0, 0,kScreenWidth,height) Index:0];
        [self.m_play setSurfaceBGColor:[UIColor blackColor]];
        [self insertSubview:[self.m_play getWindowView] atIndex:0];
        [self.m_play setWindowListener:self];

        _m_deltaTime = [self transformToDeltaTime:_plModel.startTime EndTime:_plModel.endTime];

    }
}
- (NSTimeInterval)timeIntervalOfString:(NSString*)strTime
{
    NSString* regex = @"[1-9]\\d{3}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}"; //正常字符范围
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex]; //比较处理

    //不符合格式的返回0
    if (![pred evaluateWithObject:strTime]) {
        NSLog(@"Time format error:%@", strTime);
        return 0;
    }

    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:strTime];
    return [date timeIntervalSince1970];
}


- (void)unsetupPlayer {
    
    [self stop];
    
    if (self.player.playerView.superview) {
        [self.player.playerView removeFromSuperview];
    }

    if (self.ePlayer.previewView.superview) {
        [self.ePlayer.previewView removeFromSuperview];
    }
    if (self.m_play.getWindowView.superview) {
        [self.m_play.getWindowView removeFromSuperview];
    }
    
    [self removeTimer];
}
-(void)setPlModel:(PLPlayModel *)plModel
{
    _plModel = plModel;
    self.titleLabel.text = plModel.video_name;
    self.isNeedSetupPlayer = YES;
    [self.thumbImageView yy_setImageWithURL:[NSURL URLWithString:_plModel.picUrl] options:YYWebImageOptionProgressive];
//    [self play];
}
//清晰度变化
-(void)videoStandardClarity:(BOOL)standard
{
    self.clarity = standard;
    self.isNeedSetupPlayer = YES;
    [self play];
}
- (void)play
{
    if (self.isNeedSetupPlayer) {
        [self setupPlayer];
        self.isNeedSetupPlayer = NO;
    }
    self.isStop = NO;
    self.isStartPlay = YES;

    [self.delegate playerViewWillPlay:self];
    [self addFullStreenNotify];
    [self addTimer];
    [self resetButton:YES];

    switch (_playType) {
        case PlayerStatusGBS:
            if (!(PLPlayerStatusReady == self.player.status ||
                PLPlayerStatusOpen == self.player.status ||
                PLPlayerStatusCaching == self.player.status ||
                PLPlayerStatusPlaying == self.player.status ||
                PLPlayerStatusPreparing == self.player.status)
                ) {
                NSDate *date = [NSDate date];
                [self.player play];
                NSLog(@"play 耗时： %f s",[[NSDate date] timeIntervalSinceDate:date]);
            }
            break;
        case PlayerStatusHk:
            
            [self.ePlayer startPlay];
//            [self.ezPlayer startRealPlay];
            self.centerPauseButton.hidden = YES;

            break;
        case PlayerStatusDH:
            
            [self showFullLoading];
            self.centerPauseButton.hidden = YES;
            _m_isSeeking = NO;
            
            CGFloat fduration = [_plModel.duration floatValue];
            int duration = fduration / 1000 + .5;
            int hour = duration / 3600;
            int min  = (duration % 3600) / 60;
            int sec  = duration % 60;
            self.durationLabel.text = [NSString stringWithFormat:@"%d:%02d:%02d", hour, min, sec];

            if ([_plModel.recordType isEqualToString:@"cloud"]) {
                //播放云录像
                LCOpenSDK_ParamCloudRecord *paramCloudRecord = [[LCOpenSDK_ParamCloudRecord alloc] init];
                paramCloudRecord.accessToken = self.plModel.accessToken;
                paramCloudRecord.deviceID = self.plModel.deviceSerial;
                paramCloudRecord.channel = [self.plModel.channel integerValue];
                paramCloudRecord.psk = @"";
                paramCloudRecord.recordRegionID = self.plModel.recordRegionId;
                paramCloudRecord.offsetTime = 0;
                paramCloudRecord.recordType = RECORD_TYPE_ALL;
                paramCloudRecord.timeOut = 60;
                [self.m_play playCloudRecord:paramCloudRecord];
            }else{
                //播放本地录像
                
            }
            
            break;

        default:
            break;
    }
   
}

- (void)pause {
    
    if (_playType == PlayerStatusGBS && [_plModel.recordType isEqualToString:@"local"]) {
        [self gbsLocalVideoPlayControl:@"pause" withScale:@"1" withRange:@"range"];
    }else{
        [self.player pause];
    }
    
    [self.ePlayer pausePlay];
    [self.m_play pause];
    [self resetButton:NO];
    
    
    
}

- (void)resume {
    
    if (_playType == PlayerStatusGBS && [_plModel.recordType isEqualToString:@"local"]) {
        [self gbsLocalVideoPlayControl:@"play" withScale:@"1" withRange:@"now"];
    }else{
        [self.player resume];
    }
    
    [self.delegate playerViewWillPlay:self];
    [self.ePlayer resumePlay];
    [self.m_play resume];
    [self resetButton:YES];
}

- (void)stop
{
    [self.ePlayer stopPlay];
    [self.ePlayer releasePlayer];

    [self.m_play stopCloud:YES];
    [self.m_play stopDeviceRecord:YES];
    [self.m_hc uninitOpenApi];
    self.m_playState = Stop;
    
    
    NSDate *date = nil;
    if ([self.player isPlaying]) {
        date = [NSDate date];
    }
    [self.player stop];
    
    if (date) {
        NSLog(@"stop 耗时： %f s",[[NSDate date] timeIntervalSinceDate:date]);
    }
 
    [self removeFullStreenNotify];
    [self resetUI];
    [self.controlView resetStatus];
    [self hideFullLoading];
    self.isStop = YES;
    self.isStartPlay = NO;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)resetUI {
    
    self.bufferingView.progress = 0;
    self.slider.value = 0;
    self.playTimeLabel.text = @"00:00:00";
    self.durationLabel.text = @"00:00:00";
    self.thumbImageView.hidden = NO;
    
    [self resetButton:NO];
    [self hideFullLoading];
    
    [self hideTopBar];
    [self hideBottomBar];
    [self hideBottomProgressView];
    [self doConstraintAnimation];
    
}

- (void)resetButton:(BOOL)isPlaying {
    
    self.playButton.hidden = isPlaying;
    self.pauseButton.hidden = !isPlaying;
    
    self.centerPauseButton.hidden = isPlaying;
    self.centerPlayButton.hidden  = isPlaying;
    
    if (!isPlaying) {
        [self.centerPlayButton show];
    }

}

// 避免 pan 手势将 slider 手势给屏蔽掉
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGesture) {
        CGPoint point = [gestureRecognizer locationInView:self];
        return !CGRectContainsPoint(self.bottomBarView.frame, point);
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.panGesture) {
        CGPoint point = [touch locationInView:self];
        return !CGRectContainsPoint(self.bottomBarView.frame, point);
    }
    return YES;    
}

// PLControlViewDelegate
- (void)controlViewClose:(PLControlView *)controlView {
    
    [self hideControlView];
    
    if (![[self gestureRecognizers] containsObject:self.panGesture]) {
        [self addGestureRecognizer:self.panGesture];
    }
    if (![[self gestureRecognizers] containsObject:self.tapGesture]) {
        [self addGestureRecognizer:self.tapGesture];
    }
}

- (void)controlView:(PLControlView *)controlView speedChange:(CGFloat)speed {
    [self.player setPlaySpeed:speed];
}

- (void)controlView:(PLControlView *)controlView ratioChange:(PLPlayerRatio)ratio {
    CGRect rc = CGRectMake(0, 0, self.player.width, self.player.height);
    if (PLPlayerRatioDefault == ratio) {
        [self.player setVideoClipFrame:CGRectZero];
    } else if (PLPlayerRatioFullScreen == ratio) {
        [self.player setVideoClipFrame:rc];
    } else if (PLPlayerRatio16x9 == ratio) {
        CGFloat width = 0;
        CGFloat height = 0;
        if (rc.size.width / rc.size.height > 16.0 / 9.0) {
            height = rc.size.height;
            width = rc.size.height * 16.0 / 9.0;
            rc.origin.x = (rc.size.width - width ) / 2;
        } else {
            width = rc.size.width;
            height = rc.size.width * 9.0 / 16.0;
            rc.origin.y = (rc.size.height - height ) / 2;
        }
        rc.size.width = width;
        rc.size.height = height;
        [self.player setVideoClipFrame:rc];
    } else if (PLPlayerRatio4x3 == ratio) {
        CGFloat width = 0;
        CGFloat height = 0;
        if (rc.size.width / rc.size.height > 4.0 / 3.0) {
            height = rc.size.height;
            width = rc.size.height * 4.0 / 3.0;
            rc.origin.x = (rc.size.width - width ) / 2;
        } else {
            width = rc.size.width;
            height = rc.size.width * 3.0 / 4.0;
            rc.origin.y = (rc.size.height - height ) / 2;
        }
        rc.size.width = width;
        rc.size.height = height;
        [self.player setVideoClipFrame:rc];
    }
}

- (void)controlView:(PLControlView *)controlView backgroundPlayChange:(BOOL)isBackgroundPlay {
    [self.player setBackgroundPlayEnable:isBackgroundPlay];
}

- (void)controlViewMirror:(PLControlView *)controlView {
    if (PLPlayerFlipHorizonal != self.player.rotationMode) {
        self.player.rotationMode = PLPlayerFlipHorizonal;
    } else {
        self.player.rotationMode = PLPlayerNoRotation;
    }
}

- (void)controlViewRotate:(PLControlView *)controlView {
    
    PLPlayerRotationsMode mode = self.player.rotationMode;
    mode ++;
    if (mode > PLPlayerRotate180) {
        mode = PLPlayerNoRotation;
    }
    self.player.rotationMode = mode;
}

- (BOOL)controlViewCache:(PLControlView *)controlView {
    if ([self.playerOption optionValueForKey:PLPlayerOptionKeyVideoCacheFolderPath]) {
        [_playerOption setOptionValue:nil forKey:PLPlayerOptionKeyVideoCacheFolderPath];
        [_playerOption setOptionValue:nil forKey:PLPlayerOptionKeyVideoCacheExtensionName];
        return NO;
    } else {
        NSString* docPathDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        docPathDir = [docPathDir stringByAppendingString:@"/PLCache/"];
        [_playerOption setOptionValue:docPathDir forKey:PLPlayerOptionKeyVideoCacheFolderPath];
        [_playerOption setOptionValue:@"mp4" forKey:PLPlayerOptionKeyVideoCacheExtensionName];
        return YES;
    }
}


#pragma mark - PLPlayerDelegate

- (void)playerWillBeginBackgroundTask:(PLPlayer *)player {
}

- (void)playerWillEndBackgroundTask:(PLPlayer *)player {
}

- (void)player:(PLPlayer *)player statusDidChange:(PLPlayerStatus)state
{    
    if (self.isStop) {
        static NSString * statesString[] = {
            @"PLPlayerStatusUnknow"
            @"PLPlayerStatusPreparing",
            @"PLPlayerStatusReady",
            @"PLPlayerStatusOpen",
            @"PLPlayerStatusCaching",
            @"PLPlayerStatusPlaying",
            @"PLPlayerStatusPaused",
            @"PLPlayerStatusStopped",
            @"PLPlayerStatusError",
            @"PLPlayerStateAutoReconnecting",
            @"PLPlayerStatusCompleted"
        };
        NSLog(@"stop statusDidChange self,= %p state = %@", self, statesString[state]);
        
        if (state == PLPlayerStatusError) {
            if (_playType == PlayerStatusGBS && [_plModel.recordType isEqualToString:@"local"]) {
                self.isNeedSetupPlayer = YES;
                [self pause];
            }else{
                [self stop];
            }
        }
        
        return;
    }
    
    if (state == PLPlayerStatusPlaying ||
        state == PLPlayerStatusPaused ||
        state == PLPlayerStatusStopped ||
        state == PLPlayerStatusError ||
        state == PLPlayerStatusUnknow ||
        state == PLPlayerStatusCompleted) {
        [self hideFullLoading];
    } else if (state == PLPlayerStatusPreparing ||
               state == PLPlayerStatusReady ||
               state == PLPlayerStatusCaching) {
        [self showFullLoading];
        self.centerPauseButton.hidden = YES;
    } else if (state == PLPlayerStateAutoReconnecting) {
        [self showFullLoading];
        self.centerPauseButton.hidden = YES;
        // alert 重新
        [self showTip:@"重新连接..."];
    }
    
    //开始播放之后，如果 bar 是显示的，则 3 秒之后自动隐藏
    if (PLPlayerStatusPlaying == state) {
        if (self.bottomBarView.frame.origin.y >= self.bounds.size.height) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBar) object:nil];
            [self performSelector:@selector(hideBar) withObject:nil afterDelay:3];
        }
    }
}

- (void)player:(PLPlayer *)player stoppedWithError:(NSError *)error
{
    
//    NSString *info = error.userInfo[@"NSLocalizedDescription"];
//    [self showTip:info];

    [self stop];
    if (self.isFullScreen) {
        [self clickExitFullScreenButton];
    }
    
    if (self.isLocalVideo) {
        [self.delegate theLocalFileDoesNotExist:self];
        return;
    }
    
//    [_kHUDManager showMsgInView:nil withTitle:@"播放错误" isSuccess:YES];
    
}

- (void)player:(nonnull PLPlayer *)player willRenderFrame:(nullable CVPixelBufferRef)frame pts:(int64_t)pts sarNumerator:(int)sarNumerator sarDenominator:(int)sarDenominator {
    
    dispatch_main_async_safe(^{
        if (![UIApplication sharedApplication].isIdleTimerDisabled) {
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        }
    });
}

- (AudioBufferList *)player:(PLPlayer *)player willAudioRenderBuffer:(AudioBufferList *)audioBufferList asbd:(AudioStreamBasicDescription)audioStreamDescription pts:(int64_t)pts sampleFormat:(PLPlayerAVSampleFormat)sampleFormat{
    return audioBufferList;
}

- (void)player:(nonnull PLPlayer *)player firstRender:(PLPlayerFirstRenderType)firstRenderType {
    if (PLPlayerFirstRenderTypeVideo == firstRenderType) {
        self.thumbImageView.hidden = YES;
    }
    
    self.slider.minimumValue = 0;
    
    CGFloat fduration;
    
    if (_playType == PlayerStatusGBS && [_plModel.recordType isEqualToString:@"local"]) {
        fduration = [_plModel.duration floatValue];
        self.slider.maximumValue = [_plModel.duration floatValue];
    }else{
        self.slider.maximumValue = CMTimeGetSeconds(self.player.totalDuration);
        fduration = CMTimeGetSeconds(self.player.totalDuration);
    }
    
    int duration = fduration + .5;
    int hour = duration / 3600;
    int min  = (duration % 3600) / 60;
    int sec  = duration % 60;
    self.durationLabel.text = [NSString stringWithFormat:@"%d:%02d:%02d", hour, min, sec];
}

- (void)player:(PLPlayer *)player codecError:(NSError *)error {
    NSString *info = error.userInfo[@"NSLocalizedDescription"];
    [self showTip:info];
    
    [self stop];
}

- (void)player:(PLPlayer *)player loadedTimeRange:(CMTime)timeRange {
    
    float startSeconds = 0;
    float durationSeconds = CMTimeGetSeconds(timeRange);
    CGFloat totalDuration = CMTimeGetSeconds(self.player.totalDuration);
    self.bufferingView.progress = (durationSeconds - startSeconds) / totalDuration;
    self.bottomBufferingProgressView.progress = self.bufferingView.progress;
}
#pragma mark - EZUIPlayerDelegate

/**
 播放失败

 @param player 播放器对象
 @param error 错误码对象
 */
- (void) EZUIPlayer:(EZUIPlayer *) player didPlayFailed:(EZUIError *) error
{    
//    [self stop];
    if (self.isFullScreen) {
        [self clickExitFullScreenButton];
    }
    
    if ([error.errorString isEqualToString:UE_ERROR_INNER_VERIFYCODE_ERROR])
    {
        [_kHUDManager showMsgInView:nil withTitle:@"验证码错误" isSuccess:YES];
    }
    else if ([error.errorString isEqualToString:UE_ERROR_TRANSF_DEVICE_OFFLINE])
    {
        [_kHUDManager showMsgInView:nil withTitle:@"设备不在线" isSuccess:YES];
    }
    else if ([error.errorString isEqualToString:UE_ERROR_CAMERA_NOT_EXIST] ||
             [error.errorString isEqualToString:UE_ERROR_DEVICE_NOT_EXIST])
    {
        [_kHUDManager showMsgInView:nil withTitle:@"通道不存在" isSuccess:YES];
    }
    else if ([error.errorString isEqualToString:UE_ERROR_INNER_STREAM_TIMEOUT])
    {
        [_kHUDManager showMsgInView:nil withTitle:@"连接超时" isSuccess:YES];
    }
    else if ([error.errorString isEqualToString:UE_ERROR_CAS_MSG_PU_NO_RESOURCE])
    {
        [_kHUDManager showMsgInView:nil withTitle:@"设备连接数过大" isSuccess:YES];
    }
    else
    {
//        [_kHUDManager showMsgInView:nil withTitle:@"播放失败" isSuccess:YES];
//        [self play];
    }

    NSLog(@"play error:%@(%ld)",error.errorString,error.internalErrorCode);
}

/**
 播放成功

 @param player 播放器对象
 */
- (void) EZUIPlayerPlaySucceed:(EZUIPlayer *) player
{
    [self hideFullLoading];
    self.centerPauseButton.hidden = YES;
    if (self.bottomBarView.frame.origin.y >= self.bounds.size.height) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBar) object:nil];
        [self performSelector:@selector(hideBar) withObject:nil afterDelay:3];
    }
}

/**
 播放器回调返回视频宽高

 @param player 播放器对象
 @param pWidth 视频宽度
 @param pHeight 视频高度
 */
- (void) EZUIPlayer:(EZUIPlayer *)player previewWidth:(CGFloat)pWidth previewHeight:(CGFloat)pHeight
{
    CGFloat ratio = pWidth/pHeight;

    CGFloat destWidth = CGRectGetWidth(self.bounds);
    CGFloat destHeight = destWidth/ratio;

    [player setPreviewFrame:CGRectMake(0, CGRectGetMinY(player.previewView.frame), destWidth, destHeight)];
}

/**
 播放器准备完成回调
 @param player 播放器对象
 */
- (void) EZUIPlayerPrepared:(EZUIPlayer *) player
{
    if ([EZUIPlayer getPlayModeWithUrl:_plModel.videoUrl] ==  EZUIKIT_PLAYMODE_REC)
    {
        NSArray *startArr = [self.plModel.startTime componentsSeparatedByString:@" "];
        NSArray *endArr = [self.plModel.endTime componentsSeparatedByString:@" "];
        self.playTimeLabel.text = startArr.lastObject;
        self.durationLabel.text = endArr.lastObject;
 
        [self showFullLoading];
        self.centerPauseButton.hidden = YES;
    }
    [self play];

}

/**
 播放结束，回放模式可用
 @param player 播放器对象
 */
- (void) EZUIPlayerFinished:(EZUIPlayer *) player
{
    [self stop];
}
/**
 回放模式有效，播放的当前时间点回调，每1秒回调一次

 @param osdTime osd时间点
 */
- (void) EZUIPlayerPlayTime:(NSDate *) osdTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    self.playTimeLabel.text = [dateFormatter stringFromDate:osdTime];
    
    NSDateFormatter *date1Formatter = [[NSDateFormatter alloc] init];
    [date1Formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTime = [date1Formatter stringFromDate:osdTime];
    Float64 rate = [self transformToDeltaTime:self.plModel.startTime EndTime:currentTime] / self.m_deltaTime;
    Float64 slider_value = rate * (self.slider.maximumValue - self.slider.minimumValue);
    [self.slider setValue:slider_value animated:YES];
    self.bottomPlayProgreeeView.progress = self.slider.value / [_plModel.duration floatValue];
}
- (NSTimeInterval)pleaseInsertStarTime:(NSString *)starTime andInsertEndTime:(NSString *)endTime{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"mm:ss"];//根据自己的需求定义格式
    NSDate* startDate = [formater dateFromString:starTime];
    NSDate* endDate = [formater dateFromString:endTime];
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    return time;
}

#pragma mark - 设备录像播放回调
-(void)onPlayerResult:(NSString *)code Type:(NSInteger)type Index:(NSInteger)index
{
    DLog(@"code[%@] type[%ld]", code, (long)type);
    if ([_plModel.recordType isEqualToString:@"local"]) {
        [self onPlayDeviceRecordResult:code Type:type];
    }else{
        [self onPlayCloudRecordResult:code Type:type];
    }
}
- (void)onPlayDeviceRecordResult:(NSString*)code Type:(NSInteger)type
{
    if (99 == type) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingHUD];
            self.m_playState = Stop;
            self.playTimeLabel.text = @"00:00:00";
            [self.slider setValue:0];
        });
        return;
    }
}

#pragma mark - 云录像播放回调
- (void)onPlayCloudRecordResult:(NSString*)code Type:(NSInteger)type
{
    if (99 == type) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoadingHUD];
            self.m_playState = Stop;
            self.playTimeLabel.text = @"00:00:00";
            [self.slider setValue:0];
        });
        return;
    }
    if ([@"3" isEqualToString:code]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"HLS SEEK SUCCESS!");
            self.m_isSeeking = NO;
            [self hideFullLoading];
        });
        return;
    }
}

#pragma mark - 录像开始播放回调
- (void)onPlayBegan:(NSInteger)index
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideFullLoading];
        self.m_playState = Play;
        self.m_isSeeking = NO;
        if (self.bottomBarView.frame.origin.y >= self.bounds.size.height) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBar) object:nil];
            [self performSelector:@selector(hideBar) withObject:nil afterDelay:3];
        }
    });
    
}

#pragma mark - 录像播放结束回调
- (void)onPlayFinished:(NSInteger)index
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.plModel.recordType isEqualToString:@"local"]) {
            [self.m_play stopDeviceRecord:YES];
        } else {
            [self.m_play stopCloud:YES];
        }
        [self hiddenLoading];
        [self.slider setValue:self.slider.minimumValue animated:YES];
        self.m_playState = Stop;
    });
}

#pragma mark - 录像时间状态回调
- (void)onPlayerTime:(long)time Index:(NSInteger)index
{
    if (YES == _m_isSeeking) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString* currentTime = [self transformTimeFromLong:time];
        [self.playTimeLabel setText:[self transformToShortTime:currentTime]];
        NSLog(@"self.playTimeLabel.text = %@", self.playTimeLabel.text);
        Float64 rate = [self transformToDeltaTime:self.plModel.startTime EndTime:currentTime] / self.m_deltaTime;
        Float64 slider_value = rate * (self.slider.maximumValue - self.slider.minimumValue);
        [self.slider setValue:slider_value animated:YES];

    });
}
- (NSString*)transformTimeFromLong:(long)time
{
    NSDate* resDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";

    NSString* strTime = [formatter stringFromDate:resDate];
    NSLog(@"时间戳转日期%@", strTime);
    return strTime;
}
- (NSString*)transformToShortTime:(NSString*)time
{
    NSString* regex = @"[1-9]\\d{3}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}"; //正常字符范围
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex]; //比较处理
    if (![pred evaluateWithObject:time]) {
        NSLog(@"Time format error:%@", time);
        return 0;
    }
    NSString* shortTime;
    NSArray* array = [time componentsSeparatedByString:@" "]; //从字符' '中分隔成2个元素的数组
    NSLog(@"array:%@", array); //结果是"yyyy-mm-dd"和"HH:MM:SS"
    shortTime = array[1];

    return shortTime;
}
- (NSTimeInterval)transformToDeltaTime:(NSString*)beginTime EndTime:(NSString*)endTime
{
    NSTimeInterval t_beginTime;
    NSTimeInterval t_endTime;
    NSTimeInterval t_deltaTime;

    t_beginTime = [self timeIntervalOfString:beginTime];
    t_endTime = [self timeIntervalOfString:endTime];

    if (t_endTime >= t_beginTime && t_beginTime != 0 && t_endTime != 0) {
        t_deltaTime = t_endTime - t_beginTime;
    } else {
        return 0;
    }
    return t_deltaTime;
}

#pragma mark - TS/PS标准流数据回调
- (void)onStreamCallback:(NSData*)data Index:(NSInteger)index
{
    DLog(@"onStreamCallback  data == %@",data)
    if (_m_streamPath) {
        NSFileHandle* fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:_m_streamPath];

        [fileHandle seekToEndOfFile]; //将节点跳到文件的末尾

        [fileHandle writeData:data]; //追加写入数据

        [fileHandle closeFile];
        return;
    }
    NSDateFormatter* dataFormat = [[NSDateFormatter alloc] init];
    [dataFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString* strDate = [dataFormat stringFromDate:[NSDate date]];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
        NSUserDomainMask, YES);
    NSString* libraryDirectory = [paths objectAtIndex:0];

    NSString* myDirectory =
        [libraryDirectory stringByAppendingPathComponent:@"lechange"];
    NSString* davDirectory =
        [myDirectory stringByAppendingPathComponent:@"HLSexportStream"];
    _m_streamPath = [davDirectory stringByAppendingFormat:@"/%@.ps", strDate];
    NSFileManager* fileManage = [NSFileManager defaultManager];
    NSError* pErr;
    BOOL isDir;
    if (NO == [fileManage fileExistsAtPath:myDirectory isDirectory:&isDir]) {
        [fileManage createDirectoryAtPath:myDirectory
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:&pErr];
    }
    if (NO == [fileManage fileExistsAtPath:davDirectory isDirectory:&isDir]) {
        [fileManage createDirectoryAtPath:davDirectory
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:&pErr];
    }
    if (NO == [fileManage fileExistsAtPath:_m_streamPath]) //如果不存在
    {
        [data writeToFile:_m_streamPath atomically:YES];
    }
}
/**
 *  单击回调
 *
 *  @param dx    [out]  窗口X坐标
 *  @param dy    [out]  窗口Y坐标
 *  @param index [out]  窗口索引值
 */
- (void)onControlClick:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index
{
    // 如果还木有初始化，直接初始化播放
    if (self.isNeedSetupPlayer) {
        [self play];
        return;
    }

    if (self.bottomBarView.frame.origin.y >= self.bounds.size.height) {
        [self showBar];
    } else {
        [self hideBar];
    }
}

//GBS本地录像播放控制
-(void)gbsLocalVideoPlayControl:(NSString*)command withScale:(NSString*)scale withRange:(NSString*)range
{
    
    NSString *url = [NSString stringWithFormat:@"service/cameraManagement/camera/record/playback/control?streamid=%@&command=%@&scale=%@",_plModel.StreamID,command,scale];
    
    NSDictionary *finalParams = @{
                                  @"streamid": _plModel.StreamID,
                                  @"command": command,
                                  @"range": range,
                                  @"scale": scale
                                  };

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:finalParams
                                                       options:0
                                                         error:nil];
    
    
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"BODY";
    sence.pathHeader = @"application/json";
    sence.body = jsonData;
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"Received: %@", obj);
//        if (![range isEqualToString:@"now"]) {
//            [weak_self.player play];
//            return;
//        }

        if ([command isEqualToString:@"play"]) {
            [weak_self.player resume];
        }else if ([command isEqualToString:@"pause"]){
            [weak_self.player pause];
        }else if ([command isEqualToString:@"stop"]){
            [weak_self.player stop];
        }
        
    };
    sence.errorBlock = ^(NSError *error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        // 请求失败
        DLog(@"error  ==  %@",error);
    };
    [sence sendRequest];
}


@end



@implementation PLControlView

static NSString * speedString[] = {@"0.5", @"0.75", @"1.0", @"1.25", @"1.5"};

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
        bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.top.equalTo(self);
            make.width.equalTo(@(290));
        }];
        
        UIButton *dismissButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [dismissButton addTarget:self action:@selector(clickCloseButton) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:dismissButton];
        [dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.right.equalTo(bgView.mas_left);
        }];
        
        
        self.scrollView = [[UIScrollView alloc] init];
        UIView *contentView = [[UIView alloc] init];
        
        UIView *barView = [[UIView alloc] init];
        [barView setBackgroundColor:[UIColor colorWithWhite:0 alpha:.5]];
        
        UILabel *title = [[UILabel alloc] init];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont systemFontOfSize:18];
        title.textColor = [UIColor whiteColor];
        title.text = @"播放设置";
        
        UIButton *closeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [closeButton setTintColor:[UIColor whiteColor]];
        [closeButton setImage:[UIImage imageNamed:@"player_close"] forState:(UIControlStateNormal)];
        [closeButton addTarget:self action:@selector(clickCloseButton) forControlEvents:(UIControlEventTouchUpInside)];
        
        [bgView addSubview:barView];
        [bgView addSubview:self.scrollView];
        [barView addSubview:title];
        [barView addSubview:closeButton];
        [self.scrollView addSubview:contentView];
        
        [barView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(bgView);
            make.height.equalTo(@(50));
        }];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(barView);
        }];
        
        if (CGRectEqualToRect([UIScreen mainScreen].bounds, CGRectMake(0, 0, 375, 812))) {
            // iPhone X
            [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(barView);
                make.right.equalTo(barView).offset(-20);
                make.width.equalTo(closeButton.mas_height);
            }];
        } else {
            [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(barView);
                make.right.equalTo(barView).offset(-5);
                make.width.equalTo(closeButton.mas_height);
            }];
        }
        
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(bgView);
            make.top.equalTo(barView.mas_bottom);
        }];
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.width.equalTo(bgView);
        }];
        
        self.speedTitleLabel = [[UILabel alloc] init];
        self.speedTitleLabel.font = [UIFont systemFontOfSize:12];
        self.speedTitleLabel.textColor = [UIColor colorWithWhite:.8 alpha:1];
        self.speedTitleLabel.text = @"播放速度：";
        [self.speedTitleLabel sizeToFit];
        
        self.speedValueLabel = [[UILabel alloc] init];
        self.speedValueLabel.font = [UIFont systemFontOfSize:12];
        self.speedValueLabel.textColor = [UIColor colorWithRed:.33 green:.66 blue:1 alpha:1];
        self.speedValueLabel.text = @"1.0";
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithWhite:1 alpha:.5], NSForegroundColorAttributeName, [UIFont systemFontOfSize:12],NSFontAttributeName,nil];
        NSDictionary *dicS = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:.33 green:.66 blue:1 alpha:1],NSForegroundColorAttributeName, [UIFont systemFontOfSize:12],NSFontAttributeName ,nil];

        self.speedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:speedString count:ARRAY_SIZE(speedString)]];
        [self.speedControl addTarget:self action:@selector(speedControlChange:) forControlEvents:(UIControlEventValueChanged)];
        [self.speedControl setTitleTextAttributes:dicS forState:UIControlStateSelected];
        [self.speedControl setTitleTextAttributes:dic forState:UIControlStateNormal];
        self.speedControl.tintColor = [UIColor clearColor];
        
        self.ratioControl = [[UISegmentedControl alloc] initWithItems:@[@"默认", @"全屏", @"16:9", @"4:3"]];
        [self.ratioControl addTarget:self action:@selector(ratioControlChange:) forControlEvents:(UIControlEventValueChanged)];
        [self.ratioControl setTitleTextAttributes:dicS forState:UIControlStateSelected];
        [self.ratioControl setTitleTextAttributes:dic forState:UIControlStateNormal];
        self.ratioControl.tintColor = [UIColor clearColor];

        UIButton *button[4];
        NSString *buttonTitles[4] = {@"后台播放", @"镜像反转", @"旋转", @"本地缓存"};
        NSString *buttonImages[4] = {@"background_play", @"mirror_swtich", @"rotate", @"save"};
        for (int i = 0; i < 4; i ++) {
            button[i] = [[UIButton alloc] init];
            [button[i] setImage:[UIImage imageNamed:buttonImages[i]] forState:(UIControlStateNormal)];
            [button[i] setTitle:buttonTitles[i] forState:(UIControlStateNormal)];
            button[i].titleLabel.font = [UIFont systemFontOfSize:14];
        }
        
        self.playBackgroundButton = button[0];
        self.mirrorButton = button[1];
        self.rotateButton = button[2];
        self.cacheButton  = button[3];
        
        [self.playBackgroundButton addTarget:self action:@selector(clickPlayBackgroundButton) forControlEvents:(UIControlEventTouchUpInside)];
        [self.mirrorButton addTarget:self action:@selector(clickMirrorButton) forControlEvents:(UIControlEventTouchUpInside)];
        [self.rotateButton addTarget:self action:@selector(clickRotateButton) forControlEvents:(UIControlEventTouchUpInside)];
        [self.cacheButton addTarget:self action:@selector(clickCacheButton) forControlEvents:(UIControlEventTouchUpInside)];
        
        [contentView addSubview:_speedTitleLabel];
        [contentView addSubview:_speedValueLabel];
        [contentView addSubview:_speedControl];
        [contentView addSubview:_ratioControl];
        [contentView addSubview:_playBackgroundButton];
        [contentView addSubview:_mirrorButton];
        [contentView addSubview:_rotateButton];
        [contentView addSubview:_cacheButton];
        
        // 这几句对齐的代码太 low 了，Demo中用用
        [_playBackgroundButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        [_mirrorButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        [_cacheButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        [_rotateButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [_rotateButton setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
        
        [_cacheButton setTitle:@"缓存已开" forState:(UIControlStateSelected)];
        
        [self.speedTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(contentView).offset(20);
            make.width.equalTo(@(self.speedTitleLabel.bounds.size.width));
        }];
        
        [self.speedValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.speedTitleLabel.mas_right).offset(5);
            make.centerY.equalTo(self.speedTitleLabel);
        }];
        
        [_speedControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.speedTitleLabel);
            make.right.equalTo(contentView).offset(-20);
            make.top.equalTo(self.speedTitleLabel.mas_bottom).offset(10);
            make.height.equalTo(@(44));
        }];
        
        [_ratioControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.left.right.equalTo(_speedControl);
            make.top.equalTo(_speedControl.mas_bottom).offset(20);
        }];
        
        [_playBackgroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_speedControl);
            make.right.equalTo(contentView.mas_centerX);
            make.top.equalTo(_ratioControl.mas_bottom).offset(20);
            make.height.equalTo(@(50));
        }];
        
        [_mirrorButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_playBackgroundButton.mas_right);
            make.size.centerY.equalTo(_playBackgroundButton);
        }];
        
        [_rotateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(_playBackgroundButton);
            make.top.equalTo(_playBackgroundButton.mas_bottom).offset(20);
        }];
        
        [_cacheButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_mirrorButton);
            make.height.equalTo(_mirrorButton);
            make.centerY.equalTo(_rotateButton);
            make.bottom.equalTo(contentView).offset(-20);
        }];
        
        [self resetStatus];
    }
    return self;
}

- (void)resetStatus {
    self.speedControl.selectedSegmentIndex = 2;
    self.ratioControl.selectedSegmentIndex = 0;
    self.playBackgroundButton.selected     = NO;
    self.cacheButton.selected = NO;
    self.speedValueLabel.text =  speedString[self.speedControl.selectedSegmentIndex];
}

- (void)speedControlChange:(UISegmentedControl *)control {
    self.speedValueLabel.text =  speedString[control.selectedSegmentIndex];
    [self.delegate controlView:self speedChange:[speedString[control.selectedSegmentIndex] floatValue]];
}

- (void)ratioControlChange:(UISegmentedControl *)control {
    [self.delegate controlView:self ratioChange:control.selectedSegmentIndex];
}

- (void)clickPlayBackgroundButton {
    self.playBackgroundButton.selected = !self.playBackgroundButton.isSelected;
    [self.delegate controlView:self backgroundPlayChange:self.playBackgroundButton.isSelected];
}

- (void)clickMirrorButton {
    [self.delegate controlViewMirror:self];
}

- (void)clickRotateButton {
    [self.delegate controlViewRotate:self];
}

- (void)clickCacheButton {
    self.cacheButton.selected = [self.delegate controlViewCache:self];
}

- (void)clickCloseButton {
    [self.delegate controlViewClose:self];
}

@end


