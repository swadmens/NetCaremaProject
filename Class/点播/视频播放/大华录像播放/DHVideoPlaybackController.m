//
//  DHVideoPlaybackController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/5.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "DHVideoPlaybackController.h"
#import "WWCollectionView.h"
#import "VideoPlaybackViewCell.h"
//#import "VideoWnd.h"
//#import "dhplayEx.h"
//#import <Photos/Photos.h>
//#import "DHHudPrecess.h"
#import "LGXThirdEngine.h"
#import "ShareSDKMethod.h"



//#define kIndicatorViewSize 50
//static NSTimeInterval const kToastDuration = 1;
///// 电子放大系数
//static CGFloat const kZoomMinScale   = 1.0f;
//static CGFloat const kZoomMaxScale   = 10.0f;

@interface DHVideoPlaybackController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIView *playView;
@property (nonatomic, strong) UIButton *fullScreenBtn;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UILabel *currentPlayTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UITextField *playbackTextField;
@property (nonatomic, strong) UIButton *recordButton;
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


@end

@implementation DHVideoPlaybackController
//{
//    DH_RealPlayType _rType;
//}
//
//@synthesize viewPlay, lPlayHandle;
//
//-(id)initWithValue:(NSString *)value
//{
//    if (self = [super initWithNibName:nil bundle:nil]) {
//        self.fname = value;
//    }
//    return self;
//}



#pragma mark - Setter or Getter
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
    [self creadVideoPlayBackView];
    [self setupStartEndTime];
    [self setupOtherView];
    
    
    
    CGFloat heigt = kScreenWidth*0.6 + 110;
    NSString *heiStr = [NSString stringWithFormat:@"%f",heigt];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView alignTop:heiStr leading:@"0" bottom:nil trailing:@"0" toView:self.view];
    [self.collectionView addHeight:130];
    
    
//    viewPlay = [[VideoWnd alloc] init];
//    viewPlay.backgroundColor = [UIColor whiteColor];
//    [self.playView addSubview:viewPlay];
//    viewPlay.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth*3/4);
//    viewPlay.center = CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5);
//
//
//    self.view.backgroundColor = BASE_BACKGROUND_COLOR;
//
//    PLAY_GetFreePort(&(_playPort));
//    std::string strFile = [_fname UTF8String];
//    NSLog(@"%s", strFile.c_str());
//    PLAY_OpenFile(_playPort, (char*)strFile.c_str());
//    PLAY_Play(_playPort, (__bridge void*)viewPlay);
//    PLAY_PlaySoundShare(_playPort);
//
//    UIButton *btnSave = [[UIButton alloc] init];
//    btnSave.frame = CGRectMake(0, 0, kScreenWidth/2, kScreenHeight/20);
//    btnSave.center = CGPointMake(kScreenWidth/2, kScreenHeight*0.8);
//    btnSave.backgroundColor = UIColor.lightGrayColor;
//    btnSave.layer.cornerRadius = 10;
//    btnSave.layer.borderWidth = 1;
//    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
//    [btnSave addTarget:self action:@selector(onBtnSave) forControlEvents:UIControlEventTouchUpInside];
//    //[self.view addSubview:btnSave];
    
    
    
    
    
    
    
    
}
-(void)creadVideoPlayBackView
{
    self.playView = [UIView new];
    self.playView.backgroundColor = UIColorClearColor;
    [self.view addSubview:self.playView];
    self.playView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth*0.6);

    
    UIImageView *backImageView = [UIImageView new];
    backImageView.image = UIImageWithFileName(@"playback_back_image");
    [self.playView addSubview:backImageView];
    [backImageView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.playView];
    
    
    
    //返回按钮
    UIButton *backBtn = [UIButton new];
    [backBtn setImage:UIImageWithFileName(@"icon_back_gray") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.playView addSubview:backBtn];
    [backBtn topToView:self.playView withSpace:35];
    [backBtn leftToView:self.playView withSpace:15];
    
    
    //分享按钮
    UIButton *shareBtn = [UIButton new];
    [shareBtn setImage:UIImageWithFileName(@"playback_shares_image") forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.playView addSubview:shareBtn];
    [shareBtn yCenterToView:backBtn];
    [shareBtn rightToView:self.playView withSpace:15];
    
    //播放按钮
    UIButton *playBtn = [UIButton new];
    [playBtn setImage:UIImageWithFileName(@"playback_play_white_image") forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playbackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.playView addSubview:playBtn];
    [playBtn leftToView:self.playView withSpace:15];
    [playBtn bottomToView:self.playView withSpace:10];
    
    
    //全屏按钮
    UIButton *fullBtn = [UIButton new];
    [fullBtn setImage:UIImageWithFileName(@"playback_full_image") forState:UIControlStateNormal];
    [fullBtn addTarget:self action:@selector(fullScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.playView addSubview:fullBtn];
    [fullBtn yCenterToView:playBtn];
    [fullBtn xCenterToView:shareBtn];
    
    
    
    //当前播放时长
    _currentPlayTimeLabel = [UILabel new];
    _currentPlayTimeLabel.text = @"03:16";
    _currentPlayTimeLabel.textColor = [UIColor whiteColor];
    _currentPlayTimeLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    _currentPlayTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.playView addSubview:_currentPlayTimeLabel];
    [_currentPlayTimeLabel yCenterToView:playBtn];
    [_currentPlayTimeLabel leftToView:playBtn withSpace:15];
    
    //总时长
    _endTimeLabel = [UILabel new];
    _endTimeLabel.text = @"/39:31";
    _endTimeLabel.textColor = [UIColor whiteColor];
    _endTimeLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    _endTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.playView addSubview:_endTimeLabel];
    [_endTimeLabel yCenterToView:playBtn];
    [_endTimeLabel leftToView:_currentPlayTimeLabel];
    
    //进度条
    _progressSlider = [UISlider new];
    _progressSlider.minimumTrackTintColor = UIColorFromRGB(0xff3b23, 1);
    _progressSlider.maximumTrackTintColor = [UIColor whiteColor];
    _progressSlider.thumbTintColor = UIColorFromRGB(0xff3b23, 1);
//    // 通常状态下
//    [_progressSlider setThumbImage:[UIImage imageNamed:@"iconfont-yuandian"] forState:UIControlStateNormal];
//    // 滑动状态下
//    [_progressSlider setThumbImage:[UIImage imageNamed:@"iconfont-yuandian"] forState:UIControlStateHighlighted];
    
    [self.playView addSubview:_progressSlider];
    [_progressSlider yCenterToView:playBtn];
    [_progressSlider leftToView:_endTimeLabel withSpace:20];
    [_progressSlider addWidth:kScreenWidth-210];
    
}

-(void)setupOtherView
{
    _videoNameLabel = [UILabel new];
    _videoNameLabel.text = @"高清延时拍摄城市路口人流车流";
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
    [downLoadBtn addTarget:self action:@selector(deleteVideoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downLoadBtn];
    [downLoadBtn yCenterToView:_videoNameLabel];
    [downLoadBtn rightToView:deleteBtn withSpace:5];
    [downLoadBtn addWidth:30];
    [downLoadBtn addHeight:30];
    
    
    _videoTimeLabel = [UILabel new];
    _videoTimeLabel.text = @"2020.2.20";
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
    
    
    
}
//删除视频按钮
-(void)deleteVideoClick
{
    
}
//全部视频
-(void)allVideosClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//返回按钮
-(void)backButtonClick
{
    if (self.isFullScreen) {
        if (!self.isFullScreen) {
            return;
        }
        
        CGRect frame = [self.playerSuperView convertRect:self.playerFrame toView:[UIApplication sharedApplication].keyWindow];
        [UIView animateWithDuration:0.3 animations:^{
            self.playView.transform = CGAffineTransformIdentity;
            self.playView.frame = frame;
        } completion:^(BOOL finished) {
            [self.playView removeFromSuperview];
            [self.fullScreenBtn removeFromSuperview];
            self.playView.frame = self.playerFrame;
            [self.playerSuperView addSubview:self.playView];
            [self.playerSuperView addSubview:self.fullScreenBtn];
            self.isFullScreen = NO;
//            [self.fullScreenBtn setTitle:@"切为全屏" forState:UIControlStateNormal];
        }];
    }else{
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
    

}

//分享按钮
-(void)shareButtonClick
{
    //分享里面的内容
        
    self.shareParams = [[LGXShareParams alloc] init];
//        [self.shareParams makeShreParamsByData:self.model.share];
            
    [ShareSDKMethod ShareTextActionWithParams:self.shareParams IsBlack:NO IsReport:NO IsDelete:NO Black:nil Report:nil Delete:nil Result:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        if (state == SSDKResponseStateSuccess) {
            
        }
        
    }];

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
//            NSError *error;
//            NSString *osdTime = [_player getOSDTime:&error];
//            if (!error) {
//                NSLog(@"osdTime : %@", osdTime);
//                _currentPlayTimeLabel.text = [osdTime componentsSeparatedByString:@" "].lastObject;
//                NSDate *date = [dateFormatter dateFromString:osdTime];
//                NSTimeInterval currentPlayTime = date.timeIntervalSince1970;
//                _currentPlayTime = currentPlayTime;
//                _progressSlider.value =  (currentPlayTime - _startTime) / (_endTime - _startTime);
//            }
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
    return 6;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

     VideoPlaybackViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[VideoPlaybackViewCell getCellIDStr] forIndexPath:indexPath];

    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
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
