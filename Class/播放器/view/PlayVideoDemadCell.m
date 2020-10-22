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
#import "RequestSence.h"
#import "DemandModel.h"


@interface PlayVideoDemadCell ()<PLPlayerViewDelegate>

@property (nonatomic,strong) UIImageView *titleImageView;

@property (nonatomic,strong) UIView *playView;
@property (nonatomic, strong) PLPlayerView *playerView;
@property (nonatomic, strong) HikPlayerView *hkPlayerView;
@property (nonatomic, strong) CarmeaVideosModel *model;
@property (nonatomic, strong) DemandModel *ddModel;

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

-(void)makeModelData:(id)obj
{
    if (obj == nil) {
        return;
    }

    self.playerView = [[PLPlayerView alloc] init];
    self.playerView.delegate = self;
    [_playView addSubview:self.playerView];
    self.playerView.isLocalVideo = YES;
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playView);
    }];
    
    if (self.model != nil) {
        [self.playerView stop];
    }
    
    if ([obj isKindOfClass:[CarmeaVideosModel class]]) {
        
        self.model = obj;
        
        if ([self.model.url hasPrefix:@"ezopen://"]) {
            self.playerView.playType = PlayerStatusHk;
            PLPlayModel *pModel = [PLPlayModel new];
            pModel.video_name = self.model.video_name;
            pModel.duration = self.model.duration;
            pModel.videoUrl = self.model.url;
            pModel.startTime = self.model.startTime;
            pModel.endTime = self.model.endTime;
            pModel.deviceId = self.model.deviceId;
            pModel.token = self.model.token;
            pModel.appKey = self.model.appKey;
            pModel.recordType = self.model.recordType;
            self.playerView.plModel = pModel;
        }else if ([self.model.url hasPrefix:@"imou://"]){
            self.playerView.playType = PlayerStatusDH;
            PLPlayModel *pModel = [PLPlayModel new];
            pModel.video_name = self.model.video_name;
            pModel.duration = self.model.duration;
            pModel.videoUrl = self.model.url;
            pModel.startTime = self.model.startTime;
            pModel.endTime = self.model.endTime;
            pModel.deviceId = self.model.deviceId;
            pModel.accessToken = self.model.accessToken;
            pModel.channel = self.model.channel;
            pModel.deviceSerial = self.model.deviceSerial;
            pModel.recordRegionId = self.model.recordRegionId;
            pModel.playToken = self.model.playToken;
            pModel.token = self.model.token;
            pModel.appKey = self.model.appKey;
            pModel.recordType = self.model.recordType;
            self.playerView.plModel = pModel;
        }else{
            self.playerView.playType = PlayerStatusGBS;
            PLPlayModel *pModel = [PLPlayModel new];
            pModel.video_name = self.model.video_name;
            pModel.duration = self.model.duration;
            pModel.videoUrl = self.model.url;
            pModel.startTime = self.model.startTime;
            pModel.endTime = self.model.endTime;
            pModel.deviceId = self.model.deviceId;
            pModel.StreamID = [self.model.recordType isEqualToString:@"local"]?self.model.StreamID:@" ";
            pModel.recordType = self.model.recordType;
            self.playerView.plModel = pModel;
        }
        [self configureVideo:NO];
        [self.playerView play];
        
    }else{
        self.ddModel = obj;
        self.playerView.playType = PlayerStatusGBS;
        PLPlayModel *pModel = [PLPlayModel new];
        pModel.video_name = self.ddModel.name;
        pModel.videoUrl = self.ddModel.filePath;
        self.playerView.plModel = pModel;
        [self.playerView play];
    }
    
}
- (void)play {
    [self.playerView play];
    self.isPlaying = YES;
}

- (void)stop {
    
    if ([self.model.system_Source isEqualToString:@"GBS"] && [self.model.recordType isEqualToString:@"local"]) {
        
        NSString *url = [NSString stringWithFormat:@"service/cameraManagement/camera/record/playback/stop?streamid=%@",self.model.StreamID];
        RequestSence *sence = [[RequestSence alloc] init];
        sence.requestMethod = @"GET";
        sence.pathHeader = @"application/json";
        sence.pathURL = url;
        __unsafe_unretained typeof(self) weak_self = self;
        sence.successBlock = ^(id obj) {
            [_kHUDManager hideAfter:0.1 onHide:nil];
            DLog(@"Received: %@", obj);
            
            [weak_self.playerView stop];
        };
        sence.errorBlock = ^(NSError *error) {
            [_kHUDManager hideAfter:0.1 onHide:nil];
            // 请求失败
            DLog(@"error  ==  %@",error);
        };
        [sence sendRequest];
    }else{
        [self.playerView stop];

    }
    
    self.isPlaying = NO;
}
-(void)theLocalFileDoesNotExist:(PLPlayerView *)playerView
{
    
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
