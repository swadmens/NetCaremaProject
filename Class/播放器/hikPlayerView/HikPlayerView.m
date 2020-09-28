//
//  HikPlayerView.m
//  NetCamera
//
//  Created by 汪伟 on 2020/9/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "HikPlayerView.h"
#import <EZUIKit/EZUIPlayer.h>
#import <EZUIKit/EZUIKit.h>
#import <EZUIKit/EZUIError.h>
#import <EZOpenSDKFramework/EZCloudRecordFile.h>
#import <EZOpenSDKFramework/EZDeviceRecordFile.h>
#import "EZPlaybackProgressBar.h"

@interface HikPlayerView()<EZUIPlayerDelegate,EZPlaybackProgressDelegate>


@property (nonatomic,strong) EZUIPlayer *mPlayer;
@property (nonatomic,strong) EZPlaybackProgressBar *playProgressBar;

@end

@implementation HikPlayerView

-(instancetype)initWithFrame:(CGRect)frame url:(NSString*)url
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _urlStr = url;
        NSLog(@"当前播放的url = %@",_urlStr);
        [self initUI];
    }
    
    return self;
}

-(void)initUI
{
    self.backgroundColor = [UIColor blackColor];
    //    if (self.mPlayer)
    //    {
    //        [self.mPlayer startPlay];
    //        return;
    //    }
        
        
    self.mPlayer = [EZUIPlayer createPlayerWithUrl:self.urlStr];
    self.mPlayer.mDelegate = self;
//    self.mPlayer.customIndicatorView = nil;//设置为nil则去除加载动画
    self.mPlayer.previewView.frame = CGRectMake(0, 0,
                                                CGRectGetWidth(self.mPlayer.previewView.frame),
                                                CGRectGetHeight(self.mPlayer.previewView.frame));
    [self addSubview:self.mPlayer.previewView];
   
}
#pragma mark - play bar delegate

- (void) EZPlaybackProgressBarScrollToTime:(NSDate *)time
{
    if (!self.mPlayer)
    {
        return;
    }
    [self.mPlayer seekToTime:time];
}

#pragma mark - player delegate

- (void) EZUIPlayerPlayTime:(NSDate *)osdTime
{
    [self.playProgressBar scrollToDate:osdTime];
}

- (void) EZUIPlayerFinished:(EZUIPlayer*) player
{
    [self stop];
}

- (void) EZUIPlayerPrepared:(EZUIPlayer*) player
{
    if ([EZUIPlayer getPlayModeWithUrl:self.urlStr] ==  EZUIKIT_PLAYMODE_REC)
    {
        [self createProgressBarWithList:self.mPlayer.recordList];
    }
    [self play];
}

- (void) EZUIPlayerPlaySucceed:(EZUIPlayer *)player
{
//    self.playBtn.selected = YES;
}

- (void) EZUIPlayer:(EZUIPlayer *)player didPlayFailed:(EZUIError *) error
{
    [self stop];
    
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
        [_kHUDManager showMsgInView:nil withTitle:@"播放失败" isSuccess:YES];
    }
    
    NSLog(@"play error:%@(%ld)",error.errorString,error.internalErrorCode);
}

- (void) EZUIPlayer:(EZUIPlayer *)player previewWidth:(CGFloat)pWidth previewHeight:(CGFloat)pHeight
{
    CGFloat ratio = pWidth/pHeight;
    
    CGFloat destWidth = CGRectGetWidth(self.bounds);
    CGFloat destHeight = destWidth/ratio;
    
    [player setPreviewFrame:CGRectMake(0, CGRectGetMinY(player.previewView.frame), destWidth, destHeight)];
}

#pragma mark - support

- (void) createProgressBarWithList:(NSArray *) list
{
    NSMutableArray *destList = [NSMutableArray array];
    for (id fileInfo in list)
    {
        EZPlaybackInfo *info = [[EZPlaybackInfo alloc] init];
        
        if  ([fileInfo isKindOfClass:[EZDeviceRecordFile class]])
        {
            info.beginTime = ((EZDeviceRecordFile*)fileInfo).startTime;
            info.endTime = ((EZDeviceRecordFile*)fileInfo).stopTime;
            info.recType = 2;
        }
        else
        {
            info.beginTime = ((EZCloudRecordFile*)fileInfo).startTime;
            info.endTime = ((EZCloudRecordFile*)fileInfo).stopTime;
            info.recType = 1;
        }
        
        [destList addObject:info];
    }
    
    if (self.playProgressBar)
    {
        [self.playProgressBar updateWithDataList:destList];
        [self.playProgressBar scrollToDate:((EZPlaybackInfo*)[destList firstObject]).beginTime];
        return;
    }
    
    self.playProgressBar = [[EZPlaybackProgressBar alloc] initWithFrame:CGRectMake(0, 430,
                                                                                   [UIScreen mainScreen].bounds.size.width,
                                                                                   100)
                                                               dataList:destList];
    self.playProgressBar.delegate = self;
    self.playProgressBar.backgroundColor = [UIColor clearColor];
    [self addSubview:self.playProgressBar];
}
-(void)play
{
    if (!self.mPlayer)
    {
        return;
    }
    
    [self.mPlayer startPlay];
}
-(void)stop
{
    if (!self.mPlayer)
    {
        return;
    }
    
    [self.mPlayer stopPlay];
}
-(void)pause
{
    if (!self.mPlayer)
    {
        return;
    }
    
    [self.mPlayer pausePlay];
}
- (void) releasePlayer
{
    if (!self.mPlayer)
    {
        return;
    }
    
    [self.mPlayer.previewView removeFromSuperview];
    [self.mPlayer releasePlayer];
    self.mPlayer = nil;
}

#pragma mark - orientation

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    CGRect frame = CGRectZero;
    if (size.height > size.width)
    {
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
        frame = CGRectMake(0, 64,size.width,size.width*9/16);
    }
    else
    {
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
        frame = CGRectMake(0, 0,size.width,size.height);
    }
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.mPlayer setPreviewFrame:frame];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
