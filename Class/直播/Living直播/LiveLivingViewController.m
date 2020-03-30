//
//  LiveLivingViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/30.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "LiveLivingViewController.h"
#import "LGXThirdEngine.h"
#import "ShareSDKMethod.h"
#import <UIImageView+YYWebImage.h>

@interface LiveLivingViewController ()<PLPlayerDelegate>

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) NSString *videoUrl;

@property (nonatomic, strong) LGXShareParams *shareParams;

@property (nonatomic, strong) PLPlayer *player;

//是否启用手指滑动调节音量和亮度, default YES
@property (nonatomic, assign) BOOL enableGesture;

@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, assign) BOOL isDisapper;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIImageView   *thumbImageView;
@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, strong) NSURL *thumbImageURL;

@property (nonatomic,strong) NSDictionary *dataDic;


@end

@implementation LiveLivingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.FDPrefersNavigationBarHidden = YES;

    self.thumbImageView = [[UIImageView alloc] init];
    self.thumbImageView.image = [UIImage imageWithColor:kColorMainColor];
    self.thumbImageView.clipsToBounds = YES;
    self.thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
    if (self.thumbImageURL) {
        [self.thumbImageView yy_setImageWithURL:self.thumbImageURL placeholder:self.thumbImageView.image];
    }
    if (self.thumbImage) {
        self.thumbImageView.image = self.thumbImage;
    }
    
    [self.view addSubview:self.thumbImageView];
    [self.thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    [self.thumbImageView addSubview:_effectView];
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.thumbImageView);
    }];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    [self.view addGestureRecognizer:singleTap ];
    
    
    NSDictionary *dic = [WWPublicMethod objectTransFromJson:self.live_id];
    self.dataDic = [NSDictionary dictionaryWithDictionary:dic];

    [self setupPlayer:[self.dataDic objectForKey:@"RTMP"]];
    
    self.enableGesture = YES;
    
}
//返回
-(void)goBackButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
//分享按钮
-(void)shareButtonClick
{
     //分享里面的内容
        self.shareParams = [[LGXShareParams alloc] init];
//        [self.shareParams makeShreParamsByData:self.model.share];
        
//        [ShareSDKMethod ShareTextActionWithParams:self.shareParams IsBlack:NO IsReport:NO IsDelete:NO Black:^{
//            DLog(@"拉黑");
//    //        [self shiedTheContentClick];
//        } Report:^{
//            DLog(@"举报");
////            [self deleteTheContentClick];
//        } Delete:^{
//            DLog(@"删除");
////            [self deleteTheContentClick];
//        } Result:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//
//            if (state == SSDKResponseStateSuccess) {
////                [self shareSuccessData];
//            }
//
//        }];
    
    
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


- (void) setupPlayer:(NSString*)living_url {
    
    if (![WWPublicMethod isStringEmptyText:living_url]) {
        [_kHUDManager showMsgInView:nil withTitle:@"直播地址有误！" isSuccess:YES];
        
        //GCD延迟
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
        return;
    }
    NSURL *url = [NSURL URLWithString:living_url];
    NSLog(@"播放地址: %@", url.absoluteString);
    
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    PLPlayFormat format = kPLPLAY_FORMAT_UnKnown;
    NSString *urlString = url.absoluteString.lowercaseString;
    if ([urlString hasSuffix:@"mp4"]) {
        format = kPLPLAY_FORMAT_MP4;
    } else if ([urlString hasPrefix:@"rtmp:"]) {
        format = kPLPLAY_FORMAT_FLV;
    } else if ([urlString hasSuffix:@".mp3"]) {
        format = kPLPLAY_FORMAT_MP3;
    } else if ([urlString hasSuffix:@".m3u8"]) {
        format = kPLPLAY_FORMAT_M3U8;
    }else{
        [_kHUDManager showMsgInView:nil withTitle:@"直播地址有误！" isSuccess:YES];
        //GCD延迟
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        return;
    }
    [option setOptionValue:@(format) forKey:PLPlayerOptionKeyVideoPreferFormat];
    [option setOptionValue:@(kPLLogNone) forKey:PLPlayerOptionKeyLogLevel];
    
    self.player = [PLPlayer playerWithURL:url option:option];
    [self.view insertSubview:self.player.playerView atIndex:0];
    [self.player.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.player.delegateQueue = dispatch_get_main_queue();
    self.player.playerView.contentMode = UIViewContentModeScaleAspectFit;
    self.player.delegate = self;
    self.player.loopPlay = YES;
    
    
    
    
    UIButton *backButton = [UIButton new];
    [backButton setImage:UIImageWithFileName(@"icon_back_gray") forState:UIControlStateNormal];
    [self.player.playerView addSubview:backButton];
    [backButton leftToView:self.player.playerView withSpace:2];
    [backButton topToView:self.player.playerView withSpace:32];
    [backButton addWidth:40];
    [backButton addHeight:40];
    [backButton setBGColor:UIColorFromRGB(0xffffff, 0) forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _titleLabel = [UILabel new];
    _titleLabel.clipsToBounds = YES;
    _titleLabel.layer.cornerRadius = 15;
    _titleLabel.backgroundColor = UIColorFromRGB(0x000000, 0.6);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = [self.dataDic objectForKey:@"name"];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [self.player.playerView addSubview:_titleLabel];
    [_titleLabel yCenterToView:backButton];
    [_titleLabel xCenterToView:self.player.playerView];
    [_titleLabel addWidth:135];
    [_titleLabel addHeight:30];


    //右下角分享
    UIButton *sharaButton = [UIButton new];
    sharaButton.clipsToBounds = YES;
    sharaButton.layer.cornerRadius = 16.5;
    [sharaButton setBGColor:UIColorFromRGB(0x000000, 0.4) forState:UIControlStateNormal];
    [sharaButton setImage:UIImageWithFileName(@"living_share_image") forState:UIControlStateNormal];
    [sharaButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.player.playerView addSubview:sharaButton];
    [sharaButton bottomToView:self.player.playerView withSpace:10];
    [sharaButton rightToView:self.player.playerView withSpace:25];
    [sharaButton addWidth:33];
    [sharaButton addHeight:33];
    
}

- (void)clickCloseButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.isDisapper = YES;
    [self stop];
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isDisapper = NO;
    if (![self.player isPlaying]) {
        [self.player play];
    }
}

- (void)singleTapAction:(UIGestureRecognizer *)gesture {
    if ([self.player isPlaying]) {
        [self.player pause];
    } else {
        [self.player resume];
    }
}

- (void)clickPlayButton:(UIButton *)button {
    [self.player resume];
}

- (void)stop {
    [self.player stop];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)showWaiting {
//    [self.playButton hide];
    [self.view showFullLoading];
//    [self.view bringSubviewToFront:self.closeButton];
}

- (void)hideWaiting {
    [self.view hideFullLoading];
    if (PLPlayerStatusPlaying != self.player.status) {
//        [self.playButton show];
    }
}

- (void)setEnableGesture:(BOOL)enableGesture {
    if (_enableGesture == enableGesture) return;
    _enableGesture = enableGesture;
    
    if (nil == self.panGesture) {
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    }
    if (enableGesture) {
        if (![[self.view gestureRecognizers] containsObject:self.panGesture]) {
            [self.view addGestureRecognizer:self.panGesture];
        }
    } else {
        [self.view removeGestureRecognizer:self.panGesture];
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)panGesture {
    
    if (UIGestureRecognizerStateChanged == panGesture.state) {
        CGPoint location  = [panGesture locationInView:panGesture.view];
        CGPoint translation = [panGesture translationInView:panGesture.view];
        [panGesture setTranslation:CGPointZero inView:panGesture.view];
        
#define FULL_VALUE 200.0f
        CGFloat percent = translation.y / FULL_VALUE;
        if (location.x > self.view.bounds.size.width / 2) {// 调节音量
            
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

#pragma mark - PLPlayerDelegate

- (void)playerWillBeginBackgroundTask:(PLPlayer *)player {
}

- (void)playerWillEndBackgroundTask:(PLPlayer *)player {
}

- (void)player:(PLPlayer *)player statusDidChange:(PLPlayerStatus)state
{
    if (self.isDisapper) {
        [self stop];
        [self hideWaiting];
        return;
    }
    
    if (state == PLPlayerStatusPlaying ||
        state == PLPlayerStatusPaused ||
        state == PLPlayerStatusStopped ||
        state == PLPlayerStatusError ||
        state == PLPlayerStatusUnknow ||
        state == PLPlayerStatusCompleted) {
        [self hideWaiting];
    } else if (state == PLPlayerStatusPreparing ||
               state == PLPlayerStatusReady ||
               state == PLPlayerStatusCaching) {
        [self showWaiting];
    } else if (state == PLPlayerStateAutoReconnecting) {
        [self showWaiting];
    }
}

- (void)player:(PLPlayer *)player stoppedWithError:(NSError *)error
{
    [self hideWaiting];
    NSString *info = error.userInfo[@"NSLocalizedDescription"];
    [self.view showTip:info];
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
}

- (void)player:(nonnull PLPlayer *)player SEIData:(nullable NSData *)SEIData {
    
}

- (void)player:(PLPlayer *)player codecError:(NSError *)error {
    
    NSString *info = error.userInfo[@"NSLocalizedDescription"];
    [self.view showTip:info];
    
    [self hideWaiting];
}

- (void)player:(PLPlayer *)player loadedTimeRange:(CMTimeRange)timeRange {}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
