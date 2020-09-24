//
//  PlayLocalVideoView.m
//  NetCamera
//
//  Created by 汪伟 on 2020/5/13.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "PlayLocalVideoView.h"
#import "PLPlayerView.h"
#import "DemandModel.h"


@interface PlayLocalVideoView ()<PLPlayerViewDelegate>

@property (nonatomic,strong) UIImageView *titleImageView;

@property (nonatomic,strong) UIView *playView;
@property (nonatomic, strong) PLPlayerView *playerView;
@property (nonatomic, assign) BOOL isFullScreen;   /// 是否全屏标记
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic,strong) UIView *coverView;


@end

@implementation PlayLocalVideoView

-(void)dealloc
{
    [self stop];
//    [[NSNotificationCenter defaultCenter] removeObserver:@"FullScreebInfomation"];
}
- (void)prepareForReuse {
    [self stop];
//    [super prepareForReuse];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    _playView = [UIView new];
    _playView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_playView];
    [_playView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self];

    
    _coverView = [UIView new];
    _coverView.backgroundColor = UIColorFromRGB(0x060606, 0.55);
    [_titleImageView addSubview:_coverView];
    [_coverView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:_titleImageView];
    

    UILabel *outlineLabel = [UILabel new];
    outlineLabel.text = @"离线";
    outlineLabel.textColor = [UIColor whiteColor];
    outlineLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [_coverView addSubview:outlineLabel];
    [outlineLabel xCenterToView:_coverView];
    [outlineLabel yCenterToView:_coverView];

}
-(void)setModel:(DemandModel *)model
{
    self.playerView = [[PLPlayerView alloc] init];
    self.playerView.backgroundColor = [UIColor redColor];
    self.playerView.delegate = self;
    [_playView addSubview:self.playerView];
    self.playerView.media = model;
    self.playerView.isLocalVideo = YES;
    self.playerView.playType = PlayerStatusHk;
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playView);
    }];
    [self configureVideo:NO];
    [self.playerView play];
    
}
- (void)play {
    [self.playerView play];
    self.isPlaying = YES;
}

- (void)stop {
    [self.playerView stop];
    self.isPlaying = NO;
}
- (void)pause {
    [self.playerView pause];
    self.isPlaying = NO;
}
- (void)resume {
    [self.playerView resume];
    self.isPlaying = YES;
}
- (void)changeVolume:(float)volume
{
    [self.playerView changeVolume:volume];
}

- (void)configureVideo:(BOOL)enableRender {
    [self.playerView configureVideo:enableRender];
}

- (void)playerViewEnterFullScreen:(PLPlayerView *)playerView {
    
//    UIView *superView = [UIApplication sharedApplication].delegate.window.rootViewController.view;
    UIView *superView = [[UIApplication sharedApplication] keyWindow];
    [self.playerView removeFromSuperview];
    [superView addSubview:self.playerView];
    [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(superView.mas_height);
        make.height.equalTo(superView.mas_width);
        make.center.equalTo(superView);
    }];
    
    [superView setNeedsUpdateConstraints];
    [superView updateConstraintsIfNeeded];

    [UIView animateWithDuration:.3 animations:^{
        [superView layoutIfNeeded];
    }];

    self.isFullScreen = YES;
    [self.delegate tableViewCellEnterFullScreen:self];

}

- (void)playerViewExitFullScreen:(PLPlayerView *)playerView {
    
    [self.playerView removeFromSuperview];
    [self.playView addSubview:self.playerView];
    
    [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playView);
    }];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];

    [UIView animateWithDuration:.3 animations:^{
        [self layoutIfNeeded];
    }];
    
    self.isFullScreen = NO;
    [self.delegate tableViewCellExitFullScreen:self];

}
-(void)getSnapshot:(PLPlayerView *)playerView with:(UIImage *)image
{
    if ([self.delegate respondsToSelector:@selector(getLocalViewSnap:with:)]) {
        [self.delegate getLocalViewSnap:self with:image];
    }
}
-(void)clickSnapshotButton
{
    [self.playerView clickSnapshotButton];
}
-(void)makePlayerViewFullScreen
{
    [self.playerView clickEnterFullScreenButton];
}

- (void)playerViewWillPlay:(PLPlayerView *)playerView {
//    [self.playerView.delegate playerViewWillPlay:self.playerView];
    [self.delegate tableViewWillPlay:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
