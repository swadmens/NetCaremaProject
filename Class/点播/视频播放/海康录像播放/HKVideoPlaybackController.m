//
//  HKVideoPlaybackController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/5.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "HKVideoPlaybackController.h"
#import <Toast/Toast.h>
#import <HikVideoPlayer/HVPError.h>
#import <HikVideoPlayer/HVPPlayer.h>
#import "HikUtils.h"
#import "WWCollectionView.h"
#import "VideoPlaybackViewCell.h"
#import "LGXThirdEngine.h"
#import "ShareSDKMethod.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import "PLPlayerView.h"
#import "DemandModel.h"
#import "CarmeaVideosModel.h"
#import "DownloadListController.h"
#import "AFHTTPSessionManager.h"


#define kIndicatorViewSize 50
static NSTimeInterval const kToastDuration = 1;
/// 电子放大系数
static CGFloat const kZoomMinScale   = 1.0f;
static CGFloat const kZoomMaxScale   = 10.0f;

@interface HKVideoPlaybackController ()<HVPPlayerDelegate, UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,PLPlayerDelegate,PLPlayerViewDelegate>

@property (nonatomic, strong) UIView *playView;
@property (nonatomic, strong) UIButton *fullScreenBtn;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UILabel *currentPlayTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UITextField *playbackTextField;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) HVPPlayer *player;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval endTime;
@property (nonatomic, assign) NSTimeInterval currentPlayTime;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, copy) NSString *recordPath;

@property (nonatomic, strong) UIView *playerSuperView;
@property (nonatomic, assign) CGRect playerFrame;  /// 记录原始frame
@property (nonatomic, assign) BOOL isFullScreen;   /// 是否全屏标记
@property (nonatomic, strong) UIPinchGestureRecognizer *zoomPinchRecognizer; ///电子放大捏合手势
@property (nonatomic, assign) CGFloat currentZoomScale;   ///当前电子放大的系数
@property (nonatomic, assign) CGFloat previousZoomScale;  ///上次电子放大的系数
@property (nonatomic, assign) CGRect specificRect;


@property (nonatomic,strong) UILabel *videoNameLabel;//视频名称
@property (nonatomic,strong) UILabel *videoTimeLabel;//视频时间


@property (nonatomic, strong) WWCollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArray;


@property (nonatomic, strong) LGXShareParams *shareParams;


//七牛播放器
@property (nonatomic, strong) PLPlayer  *PLPlayer;

@property (nonatomic, assign) BOOL isNeedReset;
@property (nonatomic, strong) PLPlayerView *playerView;

@property (nonatomic,strong) UIButton *backBtn;//返回按钮

@end

@implementation HKVideoPlaybackController
#pragma mark - Setter or Getter
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (HVPPlayer *)player {
    if (!_player) {
        // 创建player
        _player = [[HVPPlayer alloc] initWithPlayView:self.playView];
        // 或者 _player = [HVPPlayer playerWithPlayView:self.playView];
        // 设置delegate
        _player.delegate = self;
    }
    return _player;
}
- (WWCollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向
        flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //左右间距
        flowlayout.minimumLineSpacing = 10;
        //上下间距
        flowlayout.minimumInteritemSpacing = 0.1;
        
        flowlayout.itemSize = CGSizeMake(135, 121);
        
        _collectionView = [[WWCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        // 注册
        [_collectionView registerClass:[VideoPlaybackViewCell class] forCellWithReuseIdentifier:[VideoPlaybackViewCell getCellIDStr]];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.FDPrefersNavigationBarHidden = YES;
    
//
//    NSDictionary *dic = [WWPublicMethod objectTransFromJson:self.video_id];
//    _model = [dic objectForKey:@"video"];
//

    [self creadVideoPlayBackView];
    [self setupStartEndTime];
    [self setupOtherView];
    
    
    
    CGFloat heigt = kScreenWidth*0.6 + 110;
    NSString *heiStr = [NSString stringWithFormat:@"%f",heigt];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView alignTop:heiStr leading:@"0" bottom:nil trailing:@"0" toView:self.view];
    [self.collectionView addHeight:130];
    
    //返回按钮
    _backBtn = [UIButton new];
    [_backBtn setImage:UIImageWithFileName(@"icon_back_gray") forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setBGColor:UIColorFromRGB(0xffffff, 0) forState:UIControlStateNormal];
    [self.view addSubview:_backBtn];
    [_backBtn leftToView:self.view withSpace:2];
    [_backBtn topToView:self.view withSpace:32];
    [_backBtn addWidth:40];
    [_backBtn addHeight:40];
    
}
-(void)creadVideoPlayBackView
{
    self.playView = [UIView new];
    self.playView.backgroundColor = UIColorClearColor;
    [self.view addSubview:self.playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(kScreenWidth*0.6);
    }];
    
//    PLPlayerOption *option = [PLPlayerOption defaultOption];
//    [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
//    NSURL *url = [NSURL URLWithString:self.video_id];
//    self.PLPlayer = [PLPlayer playerWithURL:url option:option];
//    self.PLPlayer.delegate = self;
//    [self.playView addSubview:self.PLPlayer.playerView];
//    self.PLPlayer.playerView.frame = self.playView.frame;

    
//    UIImageView *backImageView = [UIImageView new];
//    backImageView.image = UIImageWithFileName(@"playback_back_image");
//    [self.playView addSubview:backImageView];
//    [backImageView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.playView];
    
   

    
//    //分享按钮
//    UIButton *shareBtn = [UIButton new];
//    [shareBtn setImage:UIImageWithFileName(@"playback_shares_image") forState:UIControlStateNormal];
//    [shareBtn addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.playView addSubview:shareBtn];
//    [shareBtn yCenterToView:backBtn];
//    [shareBtn rightToView:self.playView withSpace:15];
//
//    //播放按钮
//    UIButton *playBtn = [UIButton new];
//    [playBtn setImage:UIImageWithFileName(@"playback_play_white_image") forState:UIControlStateNormal];
//    [playBtn addTarget:self action:@selector(playbackButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.playView addSubview:playBtn];
//    [playBtn leftToView:self.playView withSpace:15];
//    [playBtn bottomToView:self.playView withSpace:10];
//
//
//    //全屏按钮
//    UIButton *fullBtn = [UIButton new];
//    [fullBtn setImage:UIImageWithFileName(@"playback_full_image") forState:UIControlStateNormal];
//    [fullBtn addTarget:self action:@selector(fullScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.playView addSubview:fullBtn];
//    [fullBtn yCenterToView:playBtn];
//    [fullBtn xCenterToView:shareBtn];
//
//
//
//    //当前播放时长
//    _currentPlayTimeLabel = [UILabel new];
//    _currentPlayTimeLabel.text = @"03:16";
//    _currentPlayTimeLabel.textColor = [UIColor whiteColor];
//    _currentPlayTimeLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
//    _currentPlayTimeLabel.textAlignment = NSTextAlignmentCenter;
//    [self.playView addSubview:_currentPlayTimeLabel];
//    [_currentPlayTimeLabel yCenterToView:playBtn];
//    [_currentPlayTimeLabel leftToView:playBtn withSpace:15];
//
//    //总时长
//    _endTimeLabel = [UILabel new];
//    _endTimeLabel.text = @"/39:31";
//    _endTimeLabel.textColor = [UIColor whiteColor];
//    _endTimeLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
//    _endTimeLabel.textAlignment = NSTextAlignmentCenter;
//    [self.playView addSubview:_endTimeLabel];
//    [_endTimeLabel yCenterToView:playBtn];
//    [_endTimeLabel leftToView:_currentPlayTimeLabel];
//
//    //进度条
//    _progressSlider = [UISlider new];
//    _progressSlider.minimumTrackTintColor = UIColorFromRGB(0xff3b23, 1);
//    _progressSlider.maximumTrackTintColor = [UIColor whiteColor];
//    _progressSlider.thumbTintColor = UIColorFromRGB(0xff3b23, 1);
////    // 通常状态下
////    [_progressSlider setThumbImage:[UIImage imageNamed:@"iconfont-yuandian"] forState:UIControlStateNormal];
////    // 滑动状态下
////    [_progressSlider setThumbImage:[UIImage imageNamed:@"iconfont-yuandian"] forState:UIControlStateHighlighted];
//
//    [self.playView addSubview:_progressSlider];
//    [_progressSlider yCenterToView:playBtn];
//    [_progressSlider leftToView:_endTimeLabel withSpace:20];
//    [_progressSlider addWidth:kScreenWidth-210];
    
    
     
    self.playerView = [[PLPlayerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    self.playerView.delegate = self;
    [self.playView addSubview:self.playerView];
    self.playerView.media = _model;
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playView);
    }];

    [self configureVideo:NO];
    if (self.isLiving) {
        [self play];
    }
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
    _backBtn.hidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)playerViewExitFullScreen:(PLPlayerView *)playerView {
    
    [self.playerView removeFromSuperview];
    [self.playView addSubview:self.playerView];
    
    [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playView);
    }];
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];

    [UIView animateWithDuration:.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    self.isFullScreen = NO;
    _backBtn.hidden = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)playerViewWillPlay:(PLPlayerView *)playerView {
//    [self.playerView.delegate playerViewWillPlay:self.playerView];
}
-(void)setupOtherView
{
    _videoNameLabel = [UILabel new];
    _videoNameLabel.text = self.model.video_name;
    _videoNameLabel.textColor = kColorMainTextColor;
    _videoNameLabel.font = [UIFont customFontWithSize:kFontSizeSixteen];
    [_videoNameLabel sizeToFit];
    [self.view addSubview:_videoNameLabel];
    [_videoNameLabel leftToView:self.view withSpace:15];
    [_videoNameLabel topToView:self.view withSpace:kScreenWidth*0.6+15];
    
    
    
    UIButton *deleteBtn = [UIButton new];
    [deleteBtn setImage:UIImageWithFileName(@"video_delete_image") forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteVideoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBtn];
    [deleteBtn yCenterToView:_videoNameLabel];
    [deleteBtn rightToView:self.view withSpace:10];
    [deleteBtn addWidth:30];
    [deleteBtn addHeight:30];
    
    
    UIButton *downLoadBtn = [UIButton new];
    [downLoadBtn setImage:UIImageWithFileName(@"mine_download_image") forState:UIControlStateNormal];
    [downLoadBtn addTarget:self action:@selector(downloadVideoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downLoadBtn];
    [downLoadBtn yCenterToView:_videoNameLabel];
    [downLoadBtn rightToView:deleteBtn withSpace:5];
    [downLoadBtn addWidth:30];
    [downLoadBtn addHeight:30];
    
    
    _videoTimeLabel = [UILabel new];
    _videoTimeLabel.text = self.model.createAt;
    _videoTimeLabel.textColor = UIColorFromRGB(0xb5b5b5, 1);
    _videoTimeLabel.font = [UIFont customFontWithSize:kFontSizeTen];
    [_videoTimeLabel sizeToFit];
    [self.view addSubview:_videoTimeLabel];
    [_videoTimeLabel leftToView:self.view withSpace:15];
    [_videoTimeLabel topToView:_videoNameLabel withSpace:10];
    
    
    UILabel *otherLabel = [UILabel new];
    otherLabel.text = @"其他视频";
    otherLabel.textColor = UIColorFromRGB(0x2e2e2e, 1);
    otherLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [otherLabel sizeToFit];
    [self.view addSubview:otherLabel];
    [otherLabel leftToView:self.view withSpace:15];
    [otherLabel topToView:_videoTimeLabel withSpace:25];
    
    
    
    UIButton *allButton = [UIButton new];
    [allButton setTitle:@"全部" forState:UIControlStateNormal];
    allButton.titleLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    [allButton setTitleColor:kColorThirdTextColor forState:UIControlStateNormal];
    [allButton setImage:UIImageWithFileName(@"mine_right_arrows") forState:UIControlStateNormal];
    allButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
//    下面是设置图片跟文字的间距：
    CGFloat margin = (45 - CGRectGetWidth(allButton.imageView.frame) - CGRectGetWidth(allButton.titleLabel.frame)) *0.5;
    CGFloat marginGay = 22;
    allButton.imageEdgeInsets = UIEdgeInsetsMake(0, marginGay, 0, margin - marginGay);
    [self.view addSubview:allButton];
    [allButton yCenterToView:otherLabel];
    [allButton rightToView:self.view withSpace:25];
    [allButton addTarget:self action:@selector(allVideosClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (_isLiving) {
        downLoadBtn.hidden = YES;
        deleteBtn.hidden = YES;
    }
    
}
//删除视频按钮
-(void)deleteVideoClick
{
    [[TCNewAlertView shareInstance] showAlert:nil message:@"确认删除该视频吗？" cancelTitle:@"取消" viewController:self confirm:^(NSInteger buttonTag) {
        if (buttonTag == 0 ) {
            
            if (self.isPlaying) {
                [self stop];
            }
            id obj = [self.allDataArray objectAtIndex:self.indexInteger+1];
            if ([obj isKindOfClass:[DemandModel class]]) {
                self.playerView.media = obj;
            }else{
                CarmeaVideosModel *model = obj;
                NSDictionary *dic = @{ @"name":model.video_name,
                                       @"snapUrl":model.snap,
                                       @"videoUrl":model.hls,
                                       @"createAt":model.time,
                                      };
                
                DemandModel *models = [DemandModel makeModelData:dic];
                self.playerView.media = models;
            }
            
            [self deleteNumbersVideo];
        }
    } buttonTitles:@"确定", nil];
}
//下载视频
-(void)downloadVideoClick
{
    DownloadListController *vc = [DownloadListController new];
    vc.demandModel = self.model;
    vc.dataArray = [NSArray arrayWithObject:self.model];
    [self.navigationController pushViewController:vc animated:YES];
}
//全部视频
-(void)allVideosClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//返回按钮
-(void)backButtonClick
{
    if (!self.isFullScreen) {
        [self stop];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//全屏按钮
-(void)fullScreenButtonClick
{
    if (self.isFullScreen) {
            return;
        }
        
        self.playerSuperView = self.playView.superview;
        self.playerFrame = self.playView.frame;

        CGRect rectInWindow = [self.playView convertRect:self.playView.bounds toView:[UIApplication sharedApplication].keyWindow];
        CGRect btnRect = [self.fullScreenBtn convertRect:self.fullScreenBtn.bounds toView:[UIApplication sharedApplication].keyWindow];
        [self.playView removeFromSuperview];
        [self.fullScreenBtn removeFromSuperview];
        self.playView.frame = rectInWindow;
        self.fullScreenBtn.frame = btnRect;
        
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.playView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.fullScreenBtn];
        
        [UIView animateWithDuration:0.3 animations:^{

            self.playView.transform = CGAffineTransformMakeRotation(M_PI_2);
            
    //        self.fullScreenBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.playView.bounds = CGRectMake(0, 0, CGRectGetHeight([UIApplication sharedApplication].keyWindow.bounds), CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds));
            self.playView.center = CGPointMake(CGRectGetMidX([UIApplication sharedApplication].keyWindow.bounds), CGRectGetMidY([UIApplication sharedApplication].keyWindow.bounds));
        } completion:^(BOOL finished) {
//            [self.fullScreenBtn setTitle:@"退出全屏" forState:UIControlStateNormal];
            self.isFullScreen = YES;
        }];
}
//播放按钮
-(void)playbackButtonClick
{
    [self.PLPlayer play];
    
    return;
   
    
//    if (_playbackTextField.text.length == 0) {
//        [self.view makeToast:@"请输入回放的URL" duration:kToastDuration position:CSToastPositionCenter];
//        return;
//    }
    // 开始加载动画
    [self.indicatorView startAnimating];
    // 为避免卡顿，开启回放可以放到子线程中，在应用中灵活处理
    if (![self.player startPlayback:@"http://gslb.miaopai.com/stream/24fONfescp-SRz61DjJz62WO1LLIwjIQXHthNg__.mp4" startTime:_startTime endTime:_endTime]) {
        [self.indicatorView stopAnimating];
    }
    
    
//    if (!_isPlaying) {
//        [self.view makeToast:@"未播放视频，不能操作" duration:kToastDuration position:CSToastPositionCenter];
//        return;
//    }
//    NSError *error;
//    if ([sender.currentTitle isEqualToString:@"暂停"]) {
//        if ([_player pause:&error]) {
////            [sender setTitle:@"恢复" forState:UIControlStateNormal];
//        }
//        else {
//            NSString *message = [NSString stringWithFormat:@"暂停失败，错误码是 0x%08lx", error.code];
//            [self.view makeToast:message duration:kToastDuration position:CSToastPositionCenter];
//        }
//        return;
//    }
//    // 恢复
//    if ([_player resume:&error]) {
////        [sender setTitle:@"暂停" forState:UIControlStateNormal];
//    }
//    else {
//        NSString *message = [NSString stringWithFormat:@"恢复回放失败，错误码是 0x%08lx", error.code];
//        [self.view makeToast:message duration:kToastDuration position:CSToastPositionCenter];
//    }
}

#pragma mark -PLPlayerDelegate
// 实现 <PLPlayerDelegate> 来控制流状态的变更
- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
  // 这里会返回流的各种状态，你可以根据状态做 UI 定制及各类其他业务操作
  // 除了 Error 状态，其他状态都会回调这个方法
  // 开始播放，当连接成功后，将收到第一个 PLPlayerStatusCaching 状态
  // 第一帧渲染后，将收到第一个 PLPlayerStatusPlaying 状态
  // 播放过程中出现卡顿时，将收到 PLPlayerStatusCaching 状态
  // 卡顿结束后，将收到 PLPlayerStatusPlaying 状态
  // 点播结束后，将收到 PLPlayerStatusCompleted 状态
    
    
    
    
}

//分享按钮
-(void)shareButtonClick
{
    //分享里面的内容
        
    self.shareParams = [[LGXShareParams alloc] init];
//        [self.shareParams makeShreParamsByData:self.model.share];
            
    [ShareSDKMethod ShareTextActionWithParams:self.shareParams QRCode:^{
        
         //二维码
         DLog(@"二维码");
    
     } url:^{
        //链接
        DLog(@"链接");
     } Result:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
         if (state == SSDKResponseStateSuccess) {
            
         }
    
     }];

}




#pragma mark - HVPPlayerDelegate

- (void)player:(HVPPlayer *)player playStatus:(HVPPlayStatus)playStatus errorCode:(HVPErrorCode)errorCode {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 如果有加载动画，结束加载动画
        if (self.indicatorView.isAnimating) {
            [self.indicatorView stopAnimating];
        }
        _isPlaying = NO;
        NSString *message;
        if (playStatus == HVPPlayStatusSuccess) {
            _isPlaying = YES;
            [_playButton setTitle:@"停止回放" forState:UIControlStateNormal];
            // 默认开启声音
            [_player enableSound:YES error:nil];
            // 开启定时器更新播放进度条
            [self startUpdatePlayProgressTimer];
        }
        else if (playStatus == HVPPlayStatusFailure) {
            if (errorCode == HVPErrorCodeURLInvalid) {
                message = @"URL输入错误请检查URL或者URL已失效请更换URL";
            }
            else {
                // 提示,自己判断是start还是seek
                message = [NSString stringWithFormat:@"开启预览失败, 错误码是 : 0x%08lx", errorCode];
            }
            _player = nil;
            // 关闭播放
            [_player stopPlay:nil];
        }
        else if (playStatus == HVPPlayStatusException) {
            // 预览过程中出现异常, 可能是取流中断，可能是其他原因导致的，具体根据错误码进行区分
            // 做一些提示操作
            message = [NSString stringWithFormat:@"播放异常, 错误码是 : 0x%08lx", errorCode];
//            if (_isRecording) {
//                //如果在录像，先关闭录像
////                [self recordVideo:_recordButton];
//            }
            // 关闭播放
            [_player stopPlay:nil];
            _progressSlider.value = 0;
            _currentPlayTimeLabel.text = @"00:00:00";
        }
        else {
            message = @"回放结束";
        }
        if (message) {
            [self.view makeToast:message duration:kToastDuration position:CSToastPositionCenter];
        }
    });
}

#pragma mark - Private Method

/**
 每秒刷新两次
 */
- (void)startUpdatePlayProgressTimer {
    if (!_timer) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.001 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, ^{
            NSError *error;
            NSString *osdTime = [_player getOSDTime:&error];
            if (!error) {
                NSLog(@"osdTime : %@", osdTime);
                _currentPlayTimeLabel.text = [osdTime componentsSeparatedByString:@" "].lastObject;
                NSDate *date = [dateFormatter dateFromString:osdTime];
                NSTimeInterval currentPlayTime = date.timeIntervalSince1970;
                _currentPlayTime = currentPlayTime;
                _progressSlider.value =  (currentPlayTime - _startTime) / (_endTime - _startTime);
            }
        });
        dispatch_resume(timer);
        _timer = timer;
    }
}
- (void)setupStartEndTime {
    // 这里startTime和endTime是测试时随便指定的(当天0点到当天23点59分59秒)，真实情况下，应该从平台获取录像片段，然后取第一个片段的开始时间和最后一个片段的结束时间
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    NSString *startTimeStr = [NSString stringWithFormat:@"%02ld-%02ld-%02ld 00:00:00", dateComponents.year, dateComponents.month, dateComponents.day];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *startTime = [dateFormatter dateFromString:startTimeStr];
    // 当天的0点0分0秒
    _startTime = [startTime timeIntervalSince1970];
    // 当天的23点59分59秒
    _endTime = _startTime + 24 * 3600 - 1;
    dateFormatter.dateFormat = @"HH:mm:ss";
    startTimeStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_startTime]];
    NSString *endTimeStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_endTime]];
    _currentPlayTimeLabel.text = startTimeStr;
    _endTimeLabel.text = endTimeStr;
}

#pragma mark - UICollectionViewDataSourec
//定义展示的Section的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allDataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoPlaybackViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[VideoPlaybackViewCell getCellIDStr] forIndexPath:indexPath];

    id objt = [self.allDataArray objectAtIndex:indexPath.row];
    [cell makeCellData:objt];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     
    if (self.isPlaying) {
        [self stop];
    }
    id obj = [self.allDataArray objectAtIndex:indexPath.row];
    
    if ([obj isKindOfClass:[DemandModel class]]) {
        DemandModel *model = obj;
        self.playerView.media = obj;
        self.playerView.media = model;
        self.model = model;
        self.indexInteger = indexPath.row;
        _videoNameLabel.text = self.model.video_name;
        _videoTimeLabel.text = self.model.createAt;
        
    }else{
        CarmeaVideosModel *model = obj;
        NSDictionary *dic = @{ @"name":model.video_name,
                               @"snapUrl":model.snap,
                               @"videoUrl":model.hls,
                               @"createAt":model.time,
                              };
        DemandModel *models = [DemandModel makeModelData:dic];
        self.playerView.media = models;
        self.model = models;
        self.indexInteger = indexPath.row;
        _videoNameLabel.text = self.model.video_name;
        _videoTimeLabel.text = self.model.createAt;
   }

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

//删除视频
-(void)deleteNumbersVideo
{
       
    //提交数据
    NSDictionary *finalParams;
    NSString *url;
    
    if (self.isRecordFile) {
        url = @"http://192.168.6.120:10102/outer/liveqing/record/remove";
        finalParams = @{
                        @"id":self.device_id,
                        @"period": self.carmeaModel.start_time,
                        };
    }else{
        url = @"http://192.168.6.120:10102/outer/liveqing/vod/remove";
        finalParams = @{
                        @"id":self.model.video_id,
                        };
    }
        
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:finalParams
                                                       options:0
                                                         error:nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"application/vnd.com.nsn.cumulocity.managedobject+json",@"multipart/form-data", nil];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    
    // 设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //配置用户名 密码
    NSString *str1 = [NSString stringWithFormat:@"%@/%@:%@",_kUserModel.userInfo.tenant_name,_kUserModel.userInfo.user_name,_kUserModel.userInfo.password];
    //进行加密  [str base64EncodedString]使用开源Base64.h分类文件加密
    NSString *str2 = [NSString stringWithFormat:@"Basic %@",[WWPublicMethod encodeBase64:str1]];
    // 设置Authorization的方法设置header
    [request setValue:str2 forHTTPHeaderField:@"Authorization"];
    
    // 设置body
    [request setHTTPBody:jsonData];
    
    NSURLSessionDataTask *task = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        
        if (error) {
            // 请求失败
            DLog(@"error  ==  %@",error.userInfo);
            [_kHUDManager showMsgInView:nil withTitle:@"删除失败，请重试！" isSuccess:YES];
            
            return ;
        }
        DLog(@"responseObject  ==  %@",responseObject);
        
        [self.allDataArray removeObjectAtIndex:self.indexInteger];
        if (self.allDataArray.count == self.indexInteger) {
            self.indexInteger = self.allDataArray.count - 1;
        }
        id obj = [self.allDataArray objectAtIndex:self.indexInteger];
        
        if ([obj isKindOfClass:[DemandModel class]]) {
            DemandModel *models = obj;
            self.playerView.media = obj;
            
            self.videoNameLabel.text = models.video_name;
            self.videoTimeLabel.text = models.createAt;
        }else{
            CarmeaVideosModel *model = obj;
            NSDictionary *dic = @{ @"name":model.video_name,
                                   @"snapUrl":model.snap,
                                   @"videoUrl":model.hls,
                                   @"createAt":model.time,
                                  };
            
            DemandModel *models = [DemandModel makeModelData:dic];
            self.playerView.media = models;
            self.videoNameLabel.text = models.video_name;
            self.videoTimeLabel.text = models.createAt;
        }
        
        
        [self.collectionView reloadData];
        
    }];
    
    [task resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
