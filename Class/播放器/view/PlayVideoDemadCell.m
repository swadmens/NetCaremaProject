//
//  PlayVideoDemadCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/10/15.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "PlayVideoDemadCell.h"
#import "PLPlayerView.h"
#import "CarmeaVideosModel.h"
#import "HikPlayerView.h"
#import "PLPlayModel.h"


@interface PlayVideoDemadCell ()<PLPlayerViewDelegate>

@property (nonatomic,strong) UIImageView *titleImageView;

@property (nonatomic,strong) UIView *playView;
@property (nonatomic, strong) PLPlayerView *playerView;
@property (nonatomic, strong) HikPlayerView *hkPlayerView;

@property (nonatomic, assign) BOOL isFullScreen;   /// 是否全屏标记
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic,strong) UIView *coverView;

@end
@implementation PlayVideoDemadCell
-(void)dealloc
{
    [self stop];
}

- (void)dosetup {
    [super dosetup];
    // Initialization code
    CGFloat height = kScreenWidth * 0.68 + 0.5;

    _playView = [UIView new];
    _playView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_playView];
    [_playView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self];
    [_playView addHeight:height];

    
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

-(void)makeModelData:(CarmeaVideosModel*)model
{
    if (model == nil) {
        return;
    }
    
    self.playerView = [[PLPlayerView alloc] init];
    self.playerView.delegate = self;
    [_playView addSubview:self.playerView];
    self.playerView.isLocalVideo = YES;
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playView);
    }];
    
    if ([model.url hasPrefix:@"ezopen://"]) {
        self.playerView.playType = PlayerStatusHk;
        NSDictionary *dic = @{@"name":model.video_name,
                              @"duration":model.duration,
                              @"url":model.url,
                              @"startTime":model.startTime,
                              @"endTime":model.endTime,
                              @"deviceId":model.deviceId,
                              @"token":model.token,
                              @"appKey":model.appKey,
                              @"recordType":model.recordType
        };
        PLPlayModel *pModel = [PLPlayModel makeModelData:dic];
        self.playerView.plModel = pModel;
    }else if ([model.url hasPrefix:@"imou://"]){
        self.playerView.playType = PlayerStatusDH;
        NSDictionary *dic = @{@"name":model.video_name,
                              @"duration":model.duration,
                              @"url":model.url,
                              @"startTime":model.startTime,
                              @"endTime":model.endTime,
                              @"deviceId":model.deviceId,
                              @"accessToken":model.accessToken,
                              @"recordId":model.recordId,
                              @"channel":model.channel,
                              @"deviceSerial":model.deviceSerial,
                              @"recordRegionId":model.recordRegionId,
                              @"playToken":model.playToken,
                              @"token":model.token,
                              @"appKey":model.appKey,
                              @"recordType":model.recordType
        };
        PLPlayModel *pModel = [PLPlayModel makeModelData:dic];
        self.playerView.plModel = pModel;
    }else{
        self.playerView.playType = PlayerStatusGBS;
        NSDictionary *dic = @{@"name":model.video_name,
                              @"duration":model.duration,
                              @"url":model.url,
                              @"startTime":model.startTime,
                              @"endTime":model.endTime,
                              @"deviceId":model.deviceId,
                              @"recordType":model.recordType
        };
        PLPlayModel *pModel = [PLPlayModel makeModelData:dic];
        self.playerView.plModel = pModel;
    }
//    [self configureVideo:NO];
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
-(void)videoStandardClarity:(BOOL)standard
{
    [self.playerView videoStandardClarity:standard];
}

- (void)configureVideo:(BOOL)enableRender {
    [self.playerView configureVideo:enableRender];
}

- (void)playerViewEnterFullScreen:(PLPlayerView *)playerView {
    
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
    [self.delegate tableViewWillPlay:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
