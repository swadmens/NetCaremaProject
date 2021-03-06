//
//  PlayerTopCollectionViewCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/5/8.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "PlayerTopCollectionViewCell.h"
#import "PLPlayerView.h"
#import "PLPlayModel.h"
#import "LivingModel.h"
#import "MyEquipmentsModel.h"
#import "RequestSence.h"

@interface PlayerTopCollectionViewCell ()<PLPlayerViewDelegate>

@property (nonatomic,strong) UIImageView *titleImageView;

@property (nonatomic,strong) UIView *playView;
@property (nonatomic, strong) PLPlayerView *playerView;
@property (nonatomic, assign) BOOL isFullScreen;   /// 是否全屏标记
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isLiving;//是否是直播

@property (nonatomic,strong) LivingModel *lvModel;

@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,strong) UILabel *timeLabel;

@end


@implementation PlayerTopCollectionViewCell
-(void)doSetup
{
    [super doSetup];
    self.contentView.backgroundColor = UIColorFromRGB(0x47484D, 1);
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    self.contentView.layer.borderWidth = 1;
    
    
    _playView = [UIView new];
    _playView.backgroundColor = UIColorFromRGB(0x47484D, 1);
    [self.contentView addSubview:_playView];
    [_playView alignTop:@"1" leading:@"1" bottom:@"1" trailing:@"1" toView:self.contentView];
    
    
    _titleImageView = [UIImageView new];
    _titleImageView.image = UIImageWithFileName(@"player_hoder_image");
    [_playView addSubview:_titleImageView];
    [_titleImageView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:_playView];
    
    
    _coverView = [UIView new];
    _coverView.backgroundColor = UIColorFromRGB(0x060606, 0.55);
    [_playView addSubview:_coverView];
    [_coverView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:_playView];
    
    
    _timeLabel = [UILabel new];
    _timeLabel.text = @"2020-01-20  10:20:32";
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont customFontWithSize:kFontSizeTen];
    [_coverView addSubview:_timeLabel];
    [_timeLabel xCenterToView:_coverView];
    [_timeLabel addCenterY:-5 toView:_coverView];
    
    
    UILabel *outlineLabel = [UILabel new];
    outlineLabel.text = @"设备离线";
    outlineLabel.textColor = [UIColor whiteColor];
    outlineLabel.font = [UIFont customFontWithSize:kFontSizeTen];
    [_coverView addSubview:outlineLabel];
    [outlineLabel xCenterToView:_coverView];
    [outlineLabel bottomToView:_timeLabel withSpace:2];
    
    
    UIButton *helpBtn = [UIButton new];
    helpBtn.clipsToBounds = YES;
    helpBtn.layer.cornerRadius = 6.5;
    helpBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    helpBtn.layer.borderWidth = 0.5;
    [helpBtn setTitle:@"查看帮助" forState:UIControlStateNormal];
    [helpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [helpBtn setBGColor:UIColorFromRGB(0x949293, 1) forState:UIControlStateNormal];
    helpBtn.titleLabel.font = [UIFont customFontWithSize:8];
    [_coverView addSubview:helpBtn];
    [helpBtn xCenterToView:_coverView];
    [helpBtn topToView:_timeLabel withSpace:3];
    [helpBtn addWidth:52];
    [helpBtn addHeight:13];
    [helpBtn addTarget:self action:@selector(checkHelpClick) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)play {
    [self.playerView play];
    self.isPlaying = YES;
}

- (void)stop {
    
    [self.playerView stop];
    [self.playerView removeFromSuperview];
    self.isPlaying = NO;
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
    self.playerView.userInteractionEnabled = YES;
    [self.delegate playerViewCellEnterFullScreen:self];
}

- (void)playerViewExitFullScreen:(PLPlayerView *)playerView {
    
    [self.playerView removeFromSuperview];
    [self.playView addSubview:self.playerView];
    self.playerView.userInteractionEnabled = NO;
    [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playView);
    }];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];

    [UIView animateWithDuration:.3 animations:^{
        [self layoutIfNeeded];
    }];
    
    self.isFullScreen = NO;
    [self.delegate playerViewCellExitFullScreen:self];
}

- (void)playerViewWillPlay:(PLPlayerView *)playerView {
    [self.delegate playerViewCellWillPlay:self];
}
-(void)getSnapshot:(PLPlayerView *)playerView with:(UIImage *)image
{
    if ([self.delegate respondsToSelector:@selector(getTopCellSnapshot:with:)]) {
        [self.delegate getTopCellSnapshot:self with:image];
    }
}
- (void)changeVolume:(float)volume
{
    [self.playerView changeVolume:volume];
}
-(void)videoStandardClarity:(BOOL)standard
{
    [self.playerView videoStandardClarity:standard];
}
-(void)makeCellData:(id)obj
{
    MyEquipmentsModel *myModel = obj;
//    if ([self.lvModel.deviceId isEqualToString:myModel.model.deviceId]) {
//        [self.playerView resume];
//        return;
//    }

    if (self.playerView != nil) {
        [self.playerView removeFromSuperview];
    }
    self.lvModel = myModel.model;
    
    if (!myModel.online) {
        _coverView.hidden = NO;
        _titleImageView.hidden = NO;
        _timeLabel.text = self.lvModel.createdAt;
    }else{
        
        _coverView.hidden = YES;
        _titleImageView.hidden = YES;
        
        self.playerView = [[PLPlayerView alloc] init];
        self.playerView.delegate = self;
        [_playView addSubview:self.playerView];
        self.playerView.isLocalVideo = NO;
        self.playerView.isLiving = YES;
        self.playerView.playType = PlayerStatusGBS;
        [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.playView);
        }];
        [self configureVideo:NO];
        self.playerView.userInteractionEnabled = NO;
        
        NSString *url;
        NSString *urlHd;
        if ([self.lvModel.system_Source isEqualToString:@"DaHua"]) {
            url = self.lvModel.hls;
            urlHd = self.lvModel.hlsHd;
        }else{
            url = self.lvModel.rtmp;
            urlHd = self.lvModel.rtmpHd;
        }
        PLPlayModel *models = [PLPlayModel new];
        models.video_name = myModel.equipment_name;
        models.picUrl = myModel.model.snap;
        models.videoUrl = url;
        models.videoHDUrl = urlHd;
        models.deviceId = myModel.equipment_id;
        models.system_Source = myModel.system_Source;
        models.online = YES;
        
        self.playerView.plModel = models;
        [self.playerView play];
        
    }
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.contentView.layer.borderColor = selected?UIColorFromRGB(0xFF7000, 1).CGColor:[UIColor clearColor].CGColor;
}
-(void)checkHelpClick
{
    //设备离线，查看帮助
    [TargetEngine controller:nil pushToController:PushTargetEquipmentOffline WithTargetId:nil];
}
-(void)makePlayerViewFullScreen:(BOOL)selected
{
    if (selected) {
        [self.playerView clickEnterFullScreenButton];
    }
}
-(void)clickSnapshotButton
{
    [self.playerView clickSnapshotButton];
}

@end
