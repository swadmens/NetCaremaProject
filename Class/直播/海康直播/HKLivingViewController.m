//
//  HKLivingViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/5.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

@import AVKit;
@import AVFoundation;
@import Photos;

#import "HKLivingViewController.h"
#import <Toast/Toast.h>
#import <HikVideoPlayer/HVPError.h>
#import <HikVideoPlayer/HVPPlayer.h>
#import "HikUtils.h"
#import "LGXThirdEngine.h"
#import "ShareSDKMethod.h"

#define kIndicatorViewSize 50
static NSTimeInterval const kToastDuration = 1;

@interface HKLivingViewController ()<HVPPlayerDelegate>

@property (nonatomic, strong) UIView *playView;
@property (nonatomic, strong) HVPPlayer *player;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) NSString *videoUrl;

@property (nonatomic, strong) LGXShareParams *shareParams;

@end

@implementation HKLivingViewController

#pragma mark - Setter or Getter

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
- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _indicatorView;
}

- (UIView *)playView {
    if (!_playView) {
        _playView = [[UIView alloc] init];
        _playView.backgroundColor = [UIColor redColor];
    }
    return _playView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.FDPrefersNavigationBarHidden = YES;
    
    
    
    [self.view addSubview:self.playView];
    self.playView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
       
    
    UIButton *backButton = [UIButton new];
    [backButton setImage:UIImageWithFileName(@"icon_back_gray") forState:UIControlStateNormal];
    [self.playView addSubview:backButton];
    [backButton leftToView:self.playView withSpace:2];
    [backButton topToView:self.playView withSpace:32];
    [backButton addWidth:40];
    [backButton addHeight:40];
    [backButton setBGColor:UIColorFromRGB(0xffffff, 0) forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _titleLabel = [UILabel new];
    _titleLabel.clipsToBounds = YES;
    _titleLabel.layer.cornerRadius = 15;
    _titleLabel.backgroundColor = UIColorFromRGB(0x000000, 0.6);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"001研发中心";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [self.playView addSubview:_titleLabel];
    [_titleLabel yCenterToView:backButton];
    [_titleLabel xCenterToView:self.playView];
    [_titleLabel addWidth:135];
    [_titleLabel addHeight:30];
    
    
    //右下角分享
    UIButton *sharaButton = [UIButton new];
    sharaButton.clipsToBounds = YES;
    sharaButton.layer.cornerRadius = 16.5;
    [sharaButton setBGColor:UIColorFromRGB(0x000000, 0.4) forState:UIControlStateNormal];
    [sharaButton setImage:UIImageWithFileName(@"living_share_image") forState:UIControlStateNormal];
    [sharaButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.playView addSubview:sharaButton];
    [sharaButton bottomToView:self.playView withSpace:10];
    [sharaButton rightToView:self.playView withSpace:25];
    [sharaButton addWidth:33];
    [sharaButton addHeight:33];
    
    
    // 退出当前页面，需要停止播放
    if (_isPlaying) {
        [_player stopPlay:nil];
    }
    
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

//开始预览
-(void)startRealPlay
{
    if (_videoUrl.length == 0) {
        [self.view makeToast:@"请输入预览URL" duration:kToastDuration position:CSToastPositionCenter];
        return;
    }
    // 开始加载动画
    [self.indicatorView startAnimating];
    // 为避免卡顿，开启预览可以放到子线程中，在应用中灵活处理
    if (![self.player startRealPlay:_videoUrl]) {
        [self.indicatorView stopAnimating];
    }
//    return;
//
//    [_player stopPlay:nil];
//    _isPlaying = NO;
}
//停止预览
-(void)stopRealPlay
{
    [self.indicatorView stopAnimating];
    if (![_player startRealPlay:_videoUrl]) {
        [self.indicatorView stopAnimating];
    }
}


#pragma mark - HVPPlayerDelegate

- (void)player:(HVPPlayer *)player playStatus:(HVPPlayStatus)playStatus errorCode:(HVPErrorCode)errorCode {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 如果有加载动画，结束加载动画
        if ([self.indicatorView isAnimating]) {
            [self.indicatorView stopAnimating];
        }
        _isPlaying = NO;
        NSString *message;
        // 预览时，没有HVPPlayStatusFinish状态，该状态表明录像片段已播放完
        if (playStatus == HVPPlayStatusSuccess) {
            _isPlaying = YES;
            // 默认开启声音
            [_player enableSound:YES error:nil];
        }
        else if (playStatus == HVPPlayStatusFailure) {
            if (errorCode == HVPErrorCodeURLInvalid) {
                message = @"URL输入错误请检查URL或者URL已失效请更换URL";
            }
            else {
                message = [NSString stringWithFormat:@"开启预览失败, 错误码是 : 0x%08lx", errorCode];
            }
            _player = nil;
        }
        else if (playStatus == HVPPlayStatusException) {
            // 预览过程中出现异常, 可能是取流中断，可能是其他原因导致的，具体根据错误码进行区分
            // 做一些提示操作
            message = [NSString stringWithFormat:@"播放异常, 错误码是 : 0x%08lx", errorCode];
            // 关闭播放
            [_player stopPlay:nil];
        }
        if (message) {
            [self.view makeToast:message duration:kToastDuration position:CSToastPositionCenter];
        }
    });
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
