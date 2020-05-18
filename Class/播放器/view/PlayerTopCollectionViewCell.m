//
//  PlayerTopCollectionViewCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/5/8.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "PlayerTopCollectionViewCell.h"
#import "PLPlayerView.h"
#import "DemandModel.h"

@interface PlayerTopCollectionViewCell ()<PLPlayerViewDelegate>

@property (nonatomic,strong) UIImageView *titleImageView;

@property (nonatomic,strong) UIView *playView;
@property (nonatomic, strong) PLPlayerView *playerView;
@property (nonatomic, assign) BOOL isFullScreen;   /// 是否全屏标记
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isLiving;//是否是直播

@property (nonatomic,strong) DemandModel *model;


@end


@implementation PlayerTopCollectionViewCell
-(void)doSetup
{
    [super doSetup];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    self.contentView.layer.borderWidth = 1;
    
    CGFloat width = (kScreenWidth-1)/2;
    
    
    _playView = [UIView new];
    _playView.backgroundColor = UIColorFromRGB(0x47484D, 1);
    [self.contentView addSubview:_playView];
    [_playView xCenterToView:self.contentView];
    [_playView yCenterToView:self.contentView];
    [_playView addWidth:width];
    [_playView addHeight:width*0.68];
    
    
    _titleImageView = [UIImageView new];
    _titleImageView.clipsToBounds = YES;
    _titleImageView.layer.borderColor = [UIColor clearColor].CGColor;
    _titleImageView.layer.borderWidth = 0.5;
    _titleImageView.userInteractionEnabled = YES;
    _titleImageView.layer.masksToBounds = YES;
    _titleImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_playView addSubview:_titleImageView];
    [_titleImageView xCenterToView:_playView];
    [_titleImageView yCenterToView:_playView];
    
    
//    self.playerView = [[PLPlayerView alloc] init];
//    self.playerView.delegate = self;
//    [_playView addSubview:self.playerView];
//    self.playerView.media = _model;
//    self.playerView.isLocalVideo = NO;
//    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.playView);
//    }];
//
//    [self configureVideo:NO];
//    if (self.isLiving) {
//        [self play];
//    }
}
- (void)play {
    [self.playerView play];
    self.isPlaying = YES;
}

- (void)stop {
    [self.playerView stop];
    self.isPlaying = NO;
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
}

- (void)playerViewWillPlay:(PLPlayerView *)playerView {
//    [self.playerView.delegate playerViewWillPlay:self.playerView];
}
-(void)makeCellData:(NSString*)icon
{
    _titleImageView.image = UIImageWithFileName(icon);
    
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.contentView.layer.borderColor = selected?UIColorFromRGB(0xFF7000, 1).CGColor:[UIColor clearColor].CGColor;
}


@end
