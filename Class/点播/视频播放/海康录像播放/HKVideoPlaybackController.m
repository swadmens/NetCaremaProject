//
//  HKVideoPlaybackController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/5.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "HKVideoPlaybackController.h"
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


@interface HKVideoPlaybackController ()<UICollectionViewDelegate,UICollectionViewDataSource,PLPlayerDelegate,PLPlayerViewDelegate>

@property (nonatomic, strong) UIView *playView;
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, assign) BOOL isFullScreen;   /// 是否全屏标记

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
@property (nonatomic,strong) UIButton *shareBtn;//分享按钮
@property (nonatomic,strong) UIButton *downLoadBtn;//下载按钮
@property (nonatomic,strong) UIButton *deleteBtn;//删除按钮


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
    [self setupOtherView];
    
    
    CGFloat heigt = kScreenWidth*0.65 + 110;
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
    
    //分享按钮
    _shareBtn = [UIButton new];
    _shareBtn.hidden = self.isRecordFile;
    [_shareBtn setImage:UIImageWithFileName(@"playback_shares_image") forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_shareBtn setBGColor:UIColorFromRGB(0xffffff, 0) forState:UIControlStateNormal];
    [self.view addSubview:_shareBtn];
    [_shareBtn yCenterToView:_backBtn];
    [_shareBtn rightToView:self.view withSpace:2];
    [_shareBtn addWidth:40];
    [_shareBtn addHeight:40];
    
    //如果是直播，获取该摄像头下的录像文件
    if (self.isLiving) {
        [self startLoadDataRequest];
    }
    
}
-(void)creadVideoPlayBackView
{
    self.playView = [UIView new];
    self.playView.backgroundColor = UIColorClearColor;
    [self.view addSubview:self.playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(kScreenWidth*0.65);
    }];

    self.playerView = [[PLPlayerView alloc] init];
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
    _shareBtn.hidden = YES;
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
    _shareBtn.hidden = NO;
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
    [_videoNameLabel topToView:self.view withSpace:kScreenWidth*0.65+15];
    
    _deleteBtn = [UIButton new];
    _deleteBtn.hidden = self.isLiving;
    [_deleteBtn setImage:UIImageWithFileName(@"video_delete_image") forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteVideoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deleteBtn];
    [_deleteBtn yCenterToView:_videoNameLabel];
    [_deleteBtn rightToView:self.view withSpace:10];
    [_deleteBtn addWidth:30];
    [_deleteBtn addHeight:30];
    
    
    _downLoadBtn = [UIButton new];
    _downLoadBtn.hidden = _isLiving;
    [_downLoadBtn setImage:UIImageWithFileName(@"mine_download_image") forState:UIControlStateNormal];
    [_downLoadBtn addTarget:self action:@selector(downloadVideoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_downLoadBtn];
    [_downLoadBtn yCenterToView:_videoNameLabel];
    [_downLoadBtn rightToView:_deleteBtn withSpace:5];
    [_downLoadBtn addWidth:30];
    [_downLoadBtn addHeight:30];
    
    
    _videoTimeLabel = [UILabel new];
    _videoTimeLabel.text = self.model.createAt;
    _videoTimeLabel.textColor = UIColorFromRGB(0xb5b5b5, 1);
    _videoTimeLabel.font = [UIFont customFontWithSize:kFontSizeTen];
    [_videoTimeLabel sizeToFit];
    [self.view addSubview:_videoTimeLabel];
    [_videoTimeLabel leftToView:self.view withSpace:15];
    [_videoTimeLabel topToView:_videoNameLabel withSpace:10];
    
    
    UILabel *otherLabel = [UILabel new];
    otherLabel.text = self.isLiving?@"近日录像":@"其他视频";
    otherLabel.textColor = UIColorFromRGB(0x2e2e2e, 1);
    otherLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [otherLabel sizeToFit];
    [self.view addSubview:otherLabel];
    [otherLabel leftToView:self.view withSpace:15];
    [otherLabel topToView:_videoTimeLabel withSpace:25];
    
    
    
    UIButton *allButton = [UIButton new];
    allButton.hidden = YES;
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
    vc.isRecord = self.isRecordFile;
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
//分享按钮
-(void)shareButtonClick
{
    //分享里面的内容
    self.shareParams = [[LGXShareParams alloc] init];
//        [self.shareParams makeShreParamsByData:self.model.share];
            
    [ShareSDKMethod ShareTextActionWithParams:self.shareParams QRCode:^{

        //视频播放地址生成二维码图片
        [self generatingTwoDimensionalCode:self.model.sharedLink];
    
     } url:^{
         //链接
         DLog(@"链接");
         UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
         pasteboard.string = self.model.sharedLink;
         [_kHUDManager showMsgInView:nil withTitle:@"链接已复制至剪切板" isSuccess:YES];
         
     } Result:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
         if (state == SSDKResponseStateSuccess) {
            
         }
     }];
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
    self.isLiving = NO;
    _deleteBtn.hidden = NO;
    _downLoadBtn.hidden = NO;
    
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
//生成二维码并保存到相册
-(void)generatingTwoDimensionalCode:(NSString *)value {
    // 创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 过滤器恢复默认
    [filter setDefaults];
    // 给过滤器添加数据
    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 获取二维码过滤器生成的二维码
    CIImage *image = [filter outputImage];// 此时的 image 是模糊的
    // 高清处理：将获取到的二维码添加到 imageview
    UIImage *images =[self createNonInterpolatedUIImageFormCIImage:image withSize:300];// withSize 大于等于视图显示的尺寸
    UIImageWriteToSavedPhotosAlbum(images, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}
//--生成高清二维码
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建 bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存 bitmap 到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}
//保存图片完成之后的回调
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        NSLog(@"保存图片失败%@", error.localizedDescription);
    }else {
        [_kHUDManager showMsgInView:nil withTitle:@"二维码图片已保存至您的相册" isSuccess:YES];
    }
}

//如果是直播，获取该摄像头下的录像文件
- (void)startLoadDataRequest
{
//    [_kHUDManager showActivityInView:nil withTitle:nil];
    
    NSDictionary *finalParams = @{
                                  @"id":self.device_id,
                                  @"day":[_kDatePicker dateStringWithDate:nil],
                                  @"start":@"0",
                                  @"limit":@"10",
                                  };
    //提交数据
    NSString *url = @"http://192.168.6.120:10102/outer/liveqing/record/query_records";
    
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
    __unsafe_unretained typeof(self) weak_self = self;

    NSURLSessionDataTask *task = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        
        if (error) {
            // 请求失败
            DLog(@"error  ==  %@",error.userInfo);
            DLog(@"responseObject  ==  %@",responseObject);
            [self failedOperation];
        }
        DLog(@"responseObject  ==  %@",responseObject);
        [weak_self handleObject:responseObject];
    }];
    [task resume];
}
- (void)failedOperation
{
    [_kHUDManager hideAfter:0.1 onHide:nil];
    [_kHUDManager showMsgInView:nil withTitle:@"请求失败" isSuccess:NO];
}
- (void)handleObject:(id)obj
{
    [_kHUDManager hideAfter:0.1 onHide:nil];
    __unsafe_unretained typeof(self) weak_self = self;
    [[GCDQueue globalQueue] queueBlock:^{
        NSDictionary *data = [obj objectForKey:@"data"];
        NSArray *months = [data objectForKey:@"months"];
        
        NSMutableArray *tempArray = [NSMutableArray array];

        [months enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *keys = obj;
            NSDictionary *mothsDic = [data objectForKey:keys];
            NSArray *days = [mothsDic objectForKey:[_kDatePicker dateStringWithDate:nil]];
            [tempArray addObjectsFromArray:days];
        }];
        
        NSMutableArray *modelArray = [NSMutableArray new];
        
        [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            
//            NSString *originalSnap = [dic objectForKey:@"snap"];
//            NSString *start_time = [dic objectForKey:@"start_time"];
//
//            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
//            NSString *snap = [NSString stringWithFormat:@"http://192.168.6.120:10102/outer/liveqing/record/getsnap?id=%@&period=%@",self.device_id,start_time];
//            if (![WWPublicMethod isStringEmptyText:originalSnap]) {
//                [mutDic setValue:snap forKey:@"snap"];
//                [self getRecordCoverPhoto:start_time withData:idx];
//            }
            CarmeaVideosModel *model = [CarmeaVideosModel makeModelData:dic];
            [modelArray addObject:model];
        }];
        [weak_self.dataArray addObjectsFromArray:modelArray];
        weak_self.allDataArray = [NSMutableArray arrayWithArray:weak_self.dataArray];
        
        [[GCDQueue mainQueue] queueBlock:^{
            [weak_self.collectionView reloadData];
        }];
    }];
}
//获取录像封面快照
-(void)getRecordCoverPhoto:(NSString*)period withData:(NSInteger)indexInteger
{
    NSString *url = [NSString stringWithFormat:@"http://192.168.6.120:10102/outer/liveqing/record/getsnap?forUrl=true&id=%@&&period=%@",self.device_id,period];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //配置用户名 密码
    NSString *str1 = [NSString stringWithFormat:@"%@/%@:%@",_kUserModel.userInfo.tenant_name,_kUserModel.userInfo.user_name,_kUserModel.userInfo.password];
    //进行加密  [str base64EncodedString]使用开源Base64.h分类文件加密
    NSString *str2 = [NSString stringWithFormat:@"Basic %@",[WWPublicMethod encodeBase64:str1]];
    // 设置Authorization的方法设置header
    [manager.requestSerializer setValue:str2 forHTTPHeaderField:@"Authorization"];

    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];

    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;

        DLog(@"RecordCoverPhoto.Received: %@", responseObject);
        DLog(@"RecordCoverPhoto.Received HTTP %ld", (long)httpResponse.statusCode);

        [self dealWithCoverPhoto:responseObject withData:indexInteger];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"error: %@", error);
    }];
}

-(void)dealWithCoverPhoto:(id)obj withData:(NSInteger)indexInteger
{
    if (obj == nil) {
        return;
    }
    __unsafe_unretained typeof(self) weak_self = self;
    CarmeaVideosModel *model = [self.dataArray objectAtIndex:indexInteger];
    model.snap = [NSString stringWithFormat:@"%@",[obj objectForKey:@"url"]];
    [weak_self.dataArray replaceObjectAtIndex:indexInteger withObject:model];
    weak_self.allDataArray = [NSMutableArray arrayWithArray:weak_self.dataArray];
//    [[GCDQueue mainQueue] queueBlock:^{
        [weak_self.collectionView reloadData];
//    }];
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
