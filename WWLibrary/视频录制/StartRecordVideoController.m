//
//  StartRecordVideoController.m
//  YuLaLa
//
//  Created by 汪伟 on 2018/6/5.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "StartRecordVideoController.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

#import <AVFoundation/AVFoundation.h>
#import "HAVPlayer.h"
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface StartRecordVideoController ()<AVCaptureFileOutputRecordingDelegate>

@property (nonatomic,strong) UIButton *lampBtn;//闪光灯
@property (nonatomic,strong) UIButton *CarmaBtn;//切换摄像头
@property (nonatomic,strong) UIButton *cancelBut;//重新录制
@property (nonatomic,strong) UIButton *completeBut;//完成录制
@property (nonatomic,strong) UIButton *sureBut;//确定
@property (nonatomic,strong) UIButton *exitRecordBtn;//退出登录
@property (nonatomic,strong) UIImageView *cursorImageView;//光标焦点
@property (nonatomic,strong) UILabel *longPreLabel;//长按拍摄


//动画
@property (strong, nonatomic) UIView *cycleView;
@property (strong, nonatomic) CAShapeLayer *ovalSShapeLayer;
@property (strong, nonatomic) CAShapeLayer *redShapeLayer;


//视频输出流
@property (strong,nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;
//图片输出流
//@property (strong,nonatomic) AVCaptureStillImageOutput *captureStillImageOutput;//照片输出流
//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;
//后台任务标识
@property (assign,nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property (assign,nonatomic) UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier;

//负责输入和输出设备之间的数据传递
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

//记录录制的时间 默认最大60秒
@property (assign, nonatomic) NSInteger seconds;

//记录需要保存视频的路径
@property (strong, nonatomic) NSURL *saveVideoUrl;

//是否在对焦
@property (assign, nonatomic) BOOL isFocus;
@property (strong, nonatomic) NSLayoutConstraint *afreshCenterX;
@property (strong, nonatomic) NSLayoutConstraint *ensureCenterX;
@property (strong, nonatomic) NSLayoutConstraint *backCenterX;

//视频播放
@property (strong, nonatomic) HAVPlayer *player;

////是否是摄像 YES 代表是录制  NO 表示拍照
//@property (assign, nonatomic) BOOL isVideo;
//
//@property (strong, nonatomic) UIImage *takeImage;
//@property (strong, nonatomic) UIImageView *takeImageView;
//
@property (nonatomic,strong)  NSString *savePath;


@end

@implementation StartRecordVideoController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.session stopRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)customCamera {
    
    //初始化会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc] init];
    //设置分辨率 (设备支持的最高分辨率)
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
    }
    //取得后置摄像头
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    //添加一个音频输入设备
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    
    //初始化输入设备
    NSError *error = nil;
    self.captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error) {
        DLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    //添加音频
    error = nil;
    AVCaptureDeviceInput *audioCaptureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    //输出对象
    self.captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];//视频输出
    
    //将输入设备添加到会话
    if ([self.session canAddInput:self.captureDeviceInput]) {
        [self.session addInput:self.captureDeviceInput];
        [self.session addInput:audioCaptureDeviceInput];
        //设置视频防抖
        AVCaptureConnection *connection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([connection isVideoStabilizationSupported]) {
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeCinematic;
        }
    }
    
    //将输出设备添加到会话 (刚开始 是照片为输出对象)
    if ([self.session canAddOutput:self.captureMovieFileOutput]) {
        [self.session addOutput:self.captureMovieFileOutput];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);//CGRectMake(0, 0, self.view.width, self.view.height);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//填充模式
    [self.view.layer addSublayer:self.previewLayer];
    
    [self addNotificationToCaptureDevice:captureDevice];
    [self addGenstureRecognizer];
    
    [self creadRecordUI];
    [self creatLayer];

}

- (AVCaptureVideoOrientation)getCaptureVideoOrientation {
    AVCaptureVideoOrientation result;
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            result = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            //如果这里设置成AVCaptureVideoOrientationPortraitUpsideDown，则视频方向和拍摄时的方向是相反的。
            result = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeLeft:
            result = AVCaptureVideoOrientationLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeRight:
            result = AVCaptureVideoOrientationLandscapeLeft;
            break;
        default:
            result = AVCaptureVideoOrientationPortrait;
            break;
    }
    
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.FDPrefersNavigationBarHidden = YES;
    
    [self customCamera];
    [self.session startRunning];
    
}
-(void)creadRecordUI
{
    
    self.seconds = 10;
    
    
    self.cycleView = [UIView new];
    self.cycleView.layer.cornerRadius = 55;
    self.cycleView.backgroundColor = kColorLineColor;
    [self.view addSubview:self.cycleView];
    [self.cycleView xCenterToView:self.view];
    [self.cycleView bottomToView:self.view withSpace:40];
    [self.cycleView addWidth:110];
    [self.cycleView addHeight:110];
    
    
    _sureBut = [UIButton new];
    [_sureBut setBGColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sureBut.clipsToBounds = YES;
    _sureBut.layer.cornerRadius = 35;
    [self.cycleView addSubview:_sureBut];
    [_sureBut centerToView:self.cycleView];
    [_sureBut addWidth:70];
    [_sureBut addHeight:70];
    
    
    //加载一个长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTouchClick:)];
    longPress.minimumPressDuration = 0.5;
    [_sureBut addGestureRecognizer:longPress];
    
    
    _longPreLabel = [UILabel new];
    _longPreLabel.text = @"长按拍摄";
    _longPreLabel.font = [UIFont customFontWithSize:kFontSizeFifty];
    _longPreLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_longPreLabel];
    [_longPreLabel xCenterToView:self.view];
    [_longPreLabel bottomToView:self.cycleView withSpace:10];
    
    
    
    _exitRecordBtn = [UIButton new];
    [_exitRecordBtn setImage:UIImageWithFileName(@"HVideo_back") forState:UIControlStateNormal];
    [_exitRecordBtn addTarget:self action:@selector(exitRecordBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_exitRecordBtn];
    [_exitRecordBtn yCenterToView:_sureBut];
    [_exitRecordBtn rightToView:_sureBut withSpace:35];
    [_exitRecordBtn addWidth:40];
    [_exitRecordBtn addHeight:40];
    
    
    
    _cancelBut = [UIButton new];
    _cancelBut.hidden = YES;
    [_cancelBut setImage:UIImageWithFileName(@"SE_quxiao") forState:UIControlStateNormal];
    [_cancelBut addTarget:self action:@selector(_cancelButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelBut];
    [_cancelBut yCenterToView:_sureBut];
    [_cancelBut rightToView:_sureBut];
//    [_cancelBut addWidth:40];
//    [_cancelBut addHeight:40];
    
    
    
    _completeBut = [UIButton new];
    _completeBut.hidden = YES;
    [_completeBut setImage:UIImageWithFileName(@"SX_confirm") forState:UIControlStateNormal];
    [_completeBut addTarget:self action:@selector(_completeButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_completeBut];
    [_completeBut yCenterToView:_sureBut];
    [_completeBut leftToView:_sureBut];
//    [_completeBut addWidth:40];
//    [_completeBut addHeight:40];
    
    
    
    
    _CarmaBtn = [UIButton new];
    [_CarmaBtn setImage:UIImageWithFileName(@"cameraex") forState:UIControlStateNormal];
    [_CarmaBtn addTarget:self action:@selector(switchButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_CarmaBtn];
    [_CarmaBtn rightToView:self.view withSpace:20];
    [_CarmaBtn topToView:self.view withSpace:25];
    //    [_CarmaBtn addWidth:40];
    //    [_CarmaBtn addHeight:40];
    
    
    _cursorImageView = [UIImageView new];
    _cursorImageView.hidden = YES;
    _cursorImageView.image = UIImageWithFileName(@"cursor_focus");
    [self.view addSubview:_cursorImageView];
    [_cursorImageView centerToView:self.view];
    
}

/**
 *  手势动作
 */
-(void)longTouchClick:(UILongPressGestureRecognizer *)longPress
{
    if(longPress.state ==UIGestureRecognizerStateBegan)
    {
        [self addAnimation];
        [self startRecordMovie];
        
        self.longPreLabel.hidden = YES;
        
    }else if (longPress.state == UIGestureRecognizerStateChanged){

    }else{
        
        [self endRecordMovie];
    }
    
}

/**
 *  开始录制
 */
-(void)startRecordMovie
{
    DLog(@"开始录制");
    //根据设备输出获得连接
    AVCaptureConnection *connection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeAudio];
    //根据连接取得设备输出的数据
    if (![self.captureMovieFileOutput isRecording]) {
        //如果支持多任务则开始多任务
        if ([[UIDevice currentDevice] isMultitaskingSupported]) {
            self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
        }
        if (self.saveVideoUrl) {
            [[NSFileManager defaultManager] removeItemAtURL:self.saveVideoUrl error:nil];
        }
        //预览图层和视频方向保持一致
//        connection.videoOrientation = [self.previewLayer connection].videoOrientation;
        if ([connection isVideoOrientationSupported]) {
            connection.videoOrientation = [self getCaptureVideoOrientation];
        }

        [self.captureMovieFileOutput startRecordingToOutputFileURL:[self outputCaches] recordingDelegate:self];
    } else {
        [self.captureMovieFileOutput stopRecording];
    }
}
- (NSURL *)outputCaches
{
    NSString *tempDir = NSTemporaryDirectory();
    _savePath = [NSString stringWithFormat:@"%@%@", tempDir, @"record_video.MOV"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:_savePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:_savePath error:nil];
    }
    return [NSURL fileURLWithPath:_savePath];
}
/**
 *  结束录制
 */
-(void)endRecordMovie
{
    
    [self.redShapeLayer removeAllAnimations];
    [self.captureMovieFileOutput stopRecording];//停止录制

    
    _sureBut.hidden = YES;
    _exitRecordBtn.hidden = YES;
    self.cycleView.hidden = YES;
    _longPreLabel.hidden = YES;
    _CarmaBtn.hidden = YES;
    
    //延迟将输入框变为第一响应者，解决一些IQKey的问题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __weak __typeof(&*self)weakSelf = self;
        weakSelf.cancelBut.hidden = NO;
        weakSelf.completeBut.hidden = NO;
    });
    
}


/**
 *  退出录制
 */
-(void)exitRecordBtnClick
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self.player stopPlayer];
    [[GCDQueue mainQueue] queueBlock:^{
        
        //主线程执行
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}
/**
 *  重新录制
 */
-(void)_cancelButClick
{
    _sureBut.hidden = NO;
    _exitRecordBtn.hidden = NO;
    self.cycleView.hidden = NO;
    _longPreLabel.hidden = NO;
    _CarmaBtn.hidden = NO;
    _cancelBut.hidden = YES;
    _completeBut.hidden = YES;
    
    [self.player stopPlayer];
    self.player.hidden = YES;
    
    [self.view bringSubviewToFront:_exitRecordBtn];
}
/**
 *  完成录制
 */
-(void)_completeButClick
{
    DLog(@"确定 这里进行保存或者发送出去");
    //结束录制，处理视频
    [self endRecordMovie];
    [_kHUDManager showActivityInView:nil withTitle:@"视频处理中..."];
    
    if (self.saveVideoUrl) {
        
        [self mov2mp4:self.saveVideoUrl];
    
//        return;
//        ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
//        [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:self.saveVideoUrl completionBlock:^(NSURL *assetURL, NSError *error) {
//            DLog(@"outputUrl:%@",self.saveVideoUrl);
//            [[NSFileManager defaultManager] removeItemAtURL:self.saveVideoUrl error:nil];
//            if (self.lastBackgroundTaskIdentifier!= UIBackgroundTaskInvalid) {
//                [[UIApplication sharedApplication] endBackgroundTask:self.lastBackgroundTaskIdentifier];
//            }
//            if (error) {
//                DLog(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
//            } else {
//                if (self.takeBlock) {
//                    self.takeBlock(assetURL);
//                }
//                DLog(@"成功保存视频到相簿.");
//                [self endRecordMovie];
//            }
//        }];
    }
}

- (void)previewVideoPath:(NSURL*)path withImage:(UIImage*)image
{
    [_kHUDManager hideAfter:0.1 onHide:nil];

    NSString *urlStr = [NSString stringWithFormat:@"%@",path];
    
    NSString *newStr = [urlStr substringFromIndex:7];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordVideoNormalPath:)])
    {
        [self.delegate recordVideoNormalPath:newStr];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordVideoTakeHomePath:withImage:)])
    {
        [self.delegate recordVideoTakeHomePath:newStr withImage:image];
    }
    
    [self exitRecordBtnClick];
}

/**
 *  切换摄像头
 */
-(void)switchButClick
{
    DLog(@"切换摄像头");
    AVCaptureDevice *currentDevice=[self.captureDeviceInput device];
    AVCaptureDevicePosition currentPosition=[currentDevice position];
    [self removeNotificationFromCaptureDevice:currentDevice];
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;//前
    if (currentPosition == AVCaptureDevicePositionUnspecified || currentPosition == AVCaptureDevicePositionFront) {
        toChangePosition = AVCaptureDevicePositionBack;//后
    }
    toChangeDevice=[self getCameraDeviceWithPosition:toChangePosition];
    [self addNotificationToCaptureDevice:toChangeDevice];
    //获得要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
    
    //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [self.session beginConfiguration];
    //移除原有输入对象
    [self.session removeInput:self.captureDeviceInput];
    //添加新的输入对象
    if ([self.session canAddInput:toChangeDeviceInput]) {
        [self.session addInput:toChangeDeviceInput];
        self.captureDeviceInput = toChangeDeviceInput;
    }
    //提交会话配置
    [self.session commitConfiguration];
}


/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == position) {
            return camera;
        }
    }
    return nil;
}

/**
 *  动画效果
 */
-(void)creatLayer
{
    
    CGFloat cySpace = 106;
    //添加底层白色圆环
    self.ovalSShapeLayer = [[CAShapeLayer alloc]init];
    //圆环颜色
    self.ovalSShapeLayer.strokeColor = [UIColor clearColor].CGColor;
    //内部填充颜色
    self.ovalSShapeLayer.fillColor = [UIColor clearColor].CGColor;
    //线宽
    self.ovalSShapeLayer.lineWidth = 3;
    
    self.ovalSShapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, cySpace, cySpace)].CGPath;
    self.ovalSShapeLayer.lineCap = kCALineCapRound;
    [self.cycleView.layer addSublayer:self.ovalSShapeLayer];
    
    //添加填充圆环
    self.redShapeLayer = [[CAShapeLayer alloc]init];
    self.redShapeLayer.strokeColor = kColorMainColor.CGColor;
    self.redShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.redShapeLayer.lineWidth = 5;
    
    self.redShapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, cySpace, cySpace)].CGPath;
    
    self.redShapeLayer.strokeStart = 0;
    self.redShapeLayer.strokeEnd = 0.0;
    
    [self.cycleView.layer addSublayer:self.redShapeLayer];
    //strokeStart为0时是从3点钟方向开始，故将其旋转270度从12点钟方向开始
    self.cycleView.transform = CGAffineTransformMakeRotation((M_PI * 2) / 4 * 3);
    
    
    
}

-(void)addAnimation{
    
    CABasicAnimation * strokeEndAnimate = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimate.fromValue = [NSNumber numberWithFloat:0.0];
    strokeEndAnimate.toValue = [NSNumber numberWithFloat:1.0];
    
    CAAnimationGroup *strokeAnimateGroup = [CAAnimationGroup animation];
    strokeAnimateGroup.duration = 10.0;
    strokeAnimateGroup.repeatCount = 1;
    strokeAnimateGroup.animations = @[strokeEndAnimate];
    
    [self.redShapeLayer addAnimation:strokeAnimateGroup forKey:nil];
}
- (void)onStartTranscribe:(NSURL *)fileURL {
    if ([self.captureMovieFileOutput isRecording]) {
        -- self.seconds;
        if (self.seconds > 0) {
//            if (self.HSeconds - self.seconds >= 1 && !self.isVideo) {
//                self.isVideo = YES;//长按时间超过TimeMax 表示是视频录制
//            }
            [self performSelector:@selector(onStartTranscribe:) withObject:fileURL afterDelay:1.0];
        } else {
            if ([self.captureMovieFileOutput isRecording]) {
                [self.captureMovieFileOutput stopRecording];
            }
        }
    }
}

#pragma mark - 视频输出代理
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    DLog(@"开始录制...");
//    self.seconds = self.HSeconds;
    [self performSelector:@selector(onStartTranscribe:) withObject:fileURL afterDelay:1.0];
}


-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    DLog(@"视频录制完成.");
//    [self changeLayout];
   
    self.saveVideoUrl = outputFileURL;
    
    if (!self.player) {
        self.player = [[HAVPlayer alloc] initWithFrame:self.view.bounds withShowInView:self.view url:outputFileURL];
        
        [self.view bringSubviewToFront:_cancelBut];
        [self.view bringSubviewToFront:_completeBut];
        
        
    } else {
        if (outputFileURL) {
            self.player.videoUrl = outputFileURL;
            self.player.hidden = NO;
        }
    }
    [self endRecordMovie];
}

- (void)videoHandlePhoto:(NSURL *)url {

    AVURLAsset *urlSet = [AVURLAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
    imageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向
    NSError *error = nil;
    CMTime time = CMTimeMake(0,30);//缩略图创建时间 CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要获取某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actucalTime; //缩略图实际生成的时间
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
    if (error) {
        DLog(@"截取视频图片失败:%@",error.localizedDescription);
    }
    CMTimeShow(actucalTime);
    UIImage *image = [UIImage imageWithCGImage:cgImage];

    CGImageRelease(cgImage);
    if (image) {
        DLog(@"视频截取成功");
        [self previewVideoPath:url withImage:image];
    } else {
        DLog(@"视频截取失败");
        [self previewVideoPath:url withImage:nil];

    }
    
}

#pragma mark - 通知

//注册通知
- (void)setupObservers
{
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationWillResignActiveNotification object:[UIApplication sharedApplication]];
}

//进入后台就退出视频录制
- (void)applicationDidEnterBackground:(NSNotification *)notification {
//    [self onCancelAction:nil];
}

/**
 *  给输入设备添加通知
 */
-(void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice{
    //注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled=YES;
    }];
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //捕获区域发生改变
    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
-(void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
/**
 *  移除所有通知
 */
-(void)removeNotification{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

-(void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //会话出错
    [notificationCenter addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}


/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
    AVCaptureDevice *captureDevice= [self.captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        //自动白平衡
        if ([captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
            [captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        }
        //自动根据环境条件开启闪光灯
        if ([captureDevice isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [captureDevice setFlashMode:AVCaptureFlashModeAuto];
        }
        
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        DLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

/**
 *  设置闪光灯模式
 *
 *  @param flashMode 闪光灯模式
 */
-(void)setFlashMode:(AVCaptureFlashMode )flashMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFlashModeSupported:flashMode]) {
            [captureDevice setFlashMode:flashMode];
        }
    }];
}
/**
 *  设置聚焦模式
 *
 *  @param focusMode 聚焦模式
 */
-(void)setFocusMode:(AVCaptureFocusMode )focusMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}
/**
 *  设置曝光模式
 *
 *  @param exposureMode 曝光模式
 */
-(void)setExposureMode:(AVCaptureExposureMode)exposureMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
    }];
}
/**
 *  设置聚焦点
 *
 *  @param point 聚焦点
 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {

        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
   
    }];
}

/**
 *  添加点按手势，点按时聚焦
 */
-(void)addGenstureRecognizer{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self.view addGestureRecognizer:tapGesture];
}

-(void)tapScreen:(UITapGestureRecognizer *)tapGesture{
    if ([self.session isRunning]) {
        CGPoint point= [tapGesture locationInView:self.view];
        //将UI坐标转化为摄像头坐标
        CGPoint cameraPoint= [self.previewLayer captureDevicePointOfInterestForPoint:point];
        [self setFocusCursorWithPoint:point];
        [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposureMode:AVCaptureExposureModeContinuousAutoExposure atPoint:cameraPoint];
    }
}

/**
 *  设置聚焦光标位置
 *
 *  @param point 光标位置
 */
-(void)setFocusCursorWithPoint:(CGPoint)point{
    if (!self.isFocus) {
        self.isFocus = YES;
        self.cursorImageView.center=point;
        self.cursorImageView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        self.cursorImageView.alpha = 1.0;
        [UIView animateWithDuration:0.5 animations:^{
            self.cursorImageView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [self performSelector:@selector(onHiddenFocusCurSorAction) withObject:nil afterDelay:0.5];
        }];
    }
}

- (void)onHiddenFocusCurSorAction {
    self.cursorImageView.alpha=0;
    self.isFocus = NO;
}

/**
 *  设备连接成功
 *
 *  @param notification 通知对象
 */
-(void)deviceConnected:(NSNotification *)notification{
    DLog(@"设备已连接...");
}
/**
 *  设备连接断开
 *
 *  @param notification 通知对象
 */
-(void)deviceDisconnected:(NSNotification *)notification{
    DLog(@"设备已断开.");
}
/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */
-(void)areaChange:(NSNotification *)notification{
    DLog(@"捕获区域改变...");
}

/**
 *  会话出错
 *
 *  @param notification 通知对象
 */
-(void)sessionRuntimeError:(NSNotification *)notification{
    DLog(@"会话发生错误.");
}


/**
 *  视频转换（mov 转 mp4）
 */
- (void)mov2mp4:(NSURL *)movUrl
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    NSLog(@"%@",compatiblePresets);
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];

        NSString *nsTmpDIr = NSTemporaryDirectory();
        NSString *resultPath = [NSString stringWithFormat:@"%@record_video_mp4_%3.f.%@", nsTmpDIr, [NSDate timeIntervalSinceReferenceDate], @"mp4"];
        

        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        CMTime start = CMTimeMakeWithSeconds(0, avAsset.duration.timescale);
        
        CMTime duration = avAsset.duration;
        
        CMTimeRange range = CMTimeRangeMake(start, duration);
        
        exportSession.timeRange = range;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         
         {
             
             switch (exportSession.status) {
                     
                 case AVAssetExportSessionStatusUnknown:
                     
                     NSLog(@"AVAssetExportSessionStatusUnknown");

                     break;
                     
                 case AVAssetExportSessionStatusWaiting:
                     
                     NSLog(@"AVAssetExportSessionStatusWaiting");

                     break;
                     
                 case AVAssetExportSessionStatusExporting:
                     
                     NSLog(@"AVAssetExportSessionStatusExporting");

                     break;
                     
                 case AVAssetExportSessionStatusCompleted:
                     
                     NSLog(@"AVAssetExportSessionStatusCompleted");
                     

//                     [self getVideoImage:exportSession.outputURL];
                     [self videoHandlePhoto:exportSession.outputURL];
                     
                     break;
                     
                 case AVAssetExportSessionStatusFailed:
                     
                     NSLog(@"AVAssetExportSessionStatusFailed");
                     [self exitRecordBtnClick];

                     break;
                     
                 case AVAssetExportSessionStatusCancelled:
                     NSLog(@"AVAssetExportSessionStatusCancelled");

                     break;
             }
             
         }];
        
    }
    
}

//获取视频的截图
-(void)getVideoImage:(NSURL*)outputURL
{
    //视频截图
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:outputURL options:nil];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:urlAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向
    CMTime time = CMTimeMakeWithSeconds(1.0, 30);   // 1.0为截取视频1.0秒处的图片，30为每秒30帧
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:nil error:nil];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    UIGraphicsBeginImageContext(CGSizeMake(240, 320));
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0,0, 240, 320)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    NSData *snapshotData = UIImageJPEGRepresentation(scaledImage, 0.75);
    
    //保存截图到临时目录
    NSString *tempDir = NSTemporaryDirectory();
    NSString *videoCoverUrl = [NSString stringWithFormat:@"%@%3.f", tempDir, [NSDate timeIntervalSinceReferenceDate]];
    
    NSError *err;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if (![fileMgr createFileAtPath:videoCoverUrl contents:snapshotData attributes:nil])
    {
        DLog(@"Upload Image Failed: fail to create uploadfile: %@", err);
        [self previewVideoPath:outputURL withImage:nil];
    }
    [self previewVideoPath:outputURL withImage:image];
}
//封面图片路径
-(NSString *)getCoverPath:(UIImage *)coverImage
{
    UIImage *image = coverImage;
    if (image == nil) {
        return nil;
    }
    
    NSString *coverPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"TXUGC"];
    coverPath = [coverPath stringByAppendingPathComponent:[self getFileNameByTimeNow:@"TXUGC" fileType:@"jpg"]];
    if (coverPath) {
        // 保证目录存在
        [[NSFileManager defaultManager] createDirectoryAtPath:[coverPath stringByDeletingLastPathComponent]
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
        
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:coverPath atomically:YES];
    }
    return coverPath;
}

-(NSString *)getFileNameByTimeNow:(NSString *)type fileType:(NSString *)fileType {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd_HHmmss"];
    NSDate * NowDate = [NSDate dateWithTimeIntervalSince1970:now];
    ;
    NSString * timeStr = [formatter stringFromDate:NowDate];
    NSString *fileName = ((fileType == nil) ||
                          (fileType.length == 0)
                          ) ? [NSString stringWithFormat:@"%@_%@",type,timeStr] : [NSString stringWithFormat:@"%@_%@.%@",type,timeStr,fileType];
    return fileName;
}






@end
