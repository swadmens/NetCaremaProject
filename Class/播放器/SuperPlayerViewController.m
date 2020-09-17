//
//  SuperPlayerViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/5/7.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "SuperPlayerViewController.h"
#import "WWTableView.h"
#import "PlayerTableViewCell.h"
#import "PlayerControlCell.h"
#import "PlayerLocalVideosCell.h"
#import "CameraControlView.h"
#import "LGXVerticalButton.h"
#import "PlayBottomDateCell.h"
#import "LGXThirdEngine.h"
#import "ShareSDKMethod.h"
#import "LocalVideoViewController.h"
#import "DemandModel.h"
#import "CarmeaVideosModel.h"
#import "LivingModel.h"
#import "RequestSence.h"
#import "MyEquipmentsModel.h"
#import "DownLoadSence.h"

#define KTopviewheight kScreenWidth*0.68

@interface SuperPlayerViewController ()<UITableViewDelegate,UITableViewDataSource,PlayerControlDelegate,CameraControlDelete,LocalVideoDelegate,PlayerTableViewCellDelegate>

@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger page;

@property (nonatomic,strong) PlayerTableViewCell *topCell;

@property (nonatomic,strong) CameraControlView *clView;
@property (nonatomic,strong) LGXVerticalButton *controlBtn;


@property (nonatomic,strong) UIView *saveBackView;
@property (nonatomic, strong) LGXShareParams *shareParams;

@property (nonatomic, strong) NSMutableArray *localVideosArray;

@property (nonatomic,strong) NSString *carmer_id;//摄像头ID
@property (nonatomic,strong) NSString *streamid;

@property (nonatomic,strong) LivingModel *selectModel;
@property (nonatomic,assign) BOOL videoing;//是否正在录像
@property (nonatomic,strong) UIView *videoTipView;//录像提示view
@property (nonatomic,strong) UILabel *videoTipLabel;//录像提示view

@end

@implementation SuperPlayerViewController
-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray*)localVideosArray
{
    if (!_localVideosArray) {
        _localVideosArray = [NSMutableArray array];
    }
    return _localVideosArray;
}
- (void)setupTableView
{
    self.tableView = [[WWTableView alloc] init];
    [self.tableView setScrollEnabled:NO];
    self.tableView.backgroundColor = kColorBackgroundColor;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    [self.tableView alignTop:@"1" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[PlayerTableViewCell class] forCellReuseIdentifier:[PlayerTableViewCell getCellIDStr]];
    [self.tableView registerClass:[PlayerControlCell class] forCellReuseIdentifier:[PlayerControlCell getCellIDStr]];
    [self.tableView registerClass:[PlayerLocalVideosCell class] forCellReuseIdentifier:[PlayerLocalVideosCell getCellIDStr]];
    [self.tableView registerClass:[PlayBottomDateCell class] forCellReuseIdentifier:[PlayBottomDateCell getCellIDStr]];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.title_value;
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    [self setupTableView];

    
    self.clView = [CameraControlView new];
    self.clView.delegate = self;
    self.clView.isLiveGBS = [self.live_type isEqualToString:@"LiveGBS"];
    [self.view addSubview:self.clView];
    self.clView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight - KTopviewheight - 177);
    
    self.videoing = NO;
    _videoTipView = [UIView new];
    _videoTipView.layer.cornerRadius = 15;
    _videoTipView.backgroundColor = UIColorFromRGB(0x000000, 0.73);
    _videoTipView.hidden = !_isLiving;
    [self.view addSubview:_videoTipView];
    [_videoTipView xCenterToView:self.view];
    [_videoTipView bottomToView:self.view withSpace:35];
    [_videoTipView addWidth:108];
    [_videoTipView addHeight:30];
    
    _videoTipLabel = [UILabel new];
    _videoTipLabel.textColor = [UIColor whiteColor];
    _videoTipLabel.font = [UIFont customFontWithSize:kFontSizeEleven];
    [_videoTipView addSubview:_videoTipLabel];
    [_videoTipLabel xCenterToView:_videoTipView];
    [_videoTipLabel yCenterToView:_videoTipView];
    
    
    
    //右上角按钮组
    UIButton *sharaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sharaBtn addTarget:self action:@selector(sharaBtnCLick) forControlEvents:UIControlEventTouchUpInside];
    [sharaBtn setImage:UIImageWithFileName(@"super_player_shara_image") forState:UIControlStateNormal];
    [sharaBtn sizeToFit];
    UIBarButtonItem *sharaBtnItem = [[UIBarButtonItem alloc] initWithCustomView:sharaBtn];
    
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButtonItem.width = 16;

    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn addTarget:self action:@selector(systemBtnCLick) forControlEvents:UIControlEventTouchUpInside];
    [settingBtn setImage:UIImageWithFileName(@"super_player_system_image") forState:UIControlStateNormal];
    [settingBtn sizeToFit];
    UIBarButtonItem *settingBtnItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    
    self.navigationItem.rightBarButtonItems  = @[settingBtnItem,fixedSpaceBarButtonItem,sharaBtnItem];
    
    
//    [self setupSaveView];
    if (_isLiving) {
        self.selectModel = self.allDataArray.firstObject;
        self.carmer_id = self.selectModel.deviceId;
        self.streamid = self.selectModel.deviceSerial;
        [self startLoadDataRequest:self.selectModel.deviceId];
        [self tipViewHidden:YES withTitle:@"开始录像"];
    }
   
}
-(void)tipViewHidden:(BOOL)hidden withTitle:(NSString*)title
{
    _videoTipView.hidden = hidden;
    _videoTipLabel.text = title;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    
    if (indexPath.row == 0) {
        
        self.topCell = [tableView dequeueReusableCellWithIdentifier:[PlayerTableViewCell getCellIDStr] forIndexPath:indexPath];
        self.topCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.topCell makeCellDataNoLiving:self.model witnLive:_isLiving];
        [self.topCell makeCellDataLiving:self.allDataArray witnLive:_isLiving];
        self.topCell.delegate = self;
        
        
        return self.topCell;
        
    }else if (indexPath.row == 1){
        
        PlayerControlCell *cell = [tableView dequeueReusableCellWithIdentifier:[PlayerControlCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        cell.isLiving = _isLiving;

        return cell;
    }else{
        
//        if (_isLiving) {
            PlayerLocalVideosCell *cell = [tableView dequeueReusableCellWithIdentifier:[PlayerLocalVideosCell getCellIDStr] forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            [cell makeCellData:self.localVideosArray];
            
            cell.allBtn = ^{
                 
//                LivingModel *lmd = [self.allDataArray objectAtIndex:0];
                if (self.videoing) {
                    [_kHUDManager showMsgInView:nil withTitle:@"正在录像！" isSuccess:YES];
                    return;
                }
                LocalVideoViewController *vc = [LocalVideoViewController new];
                vc.delegate = self;
                vc.isFromIndex = NO;
                vc.device_id = self.carmer_id;
                [weakSelf.navigationController pushViewController:vc animated:YES];
               
            };
            cell.selectedRowData = ^(DemandModel * _Nonnull model) {
                weakSelf.model = model;
                weakSelf.isLiving = NO;
                [weakSelf.tableView reloadData];
            };
            
            return cell;
//        }else{
//            PlayBottomDateCell *cell = [tableView dequeueReusableCellWithIdentifier:[PlayBottomDateCell getCellIDStr] forIndexPath:indexPath];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//            return cell;
//        }
        
        
    }
}

#pragma mark - PlayerControlDelegate
-(void)playerControlwithState:(videoSate)state withButton:(UIButton *)sender
{
    if (![WWPublicMethod isStringEmptyText:self.streamid] && _isLiving == YES) {
        return;
    }
//    if (self.videoing) {
//        [_kHUDManager showMsgInView:nil withTitle:@"正在录像！" isSuccess:YES];
//        return;
//    }
    
    self.controlBtn = (LGXVerticalButton*)sender;
    switch (state) {
        case videoSatePlay://播放暂停
 
            if (!_isLiving) {
                self.controlBtn.selected = !self.controlBtn.selected;
                if (self.controlBtn.selected) {
                    [self.topCell pause];
                }else{
                    [self.topCell resume];
                }
            }
            
            break;
        case videoSateVoice://声音控制
            
                
            self.controlBtn.selected = !self.controlBtn.selected;
            float volume = self.controlBtn.selected?0.01:1.0;
            [self.topCell changeVolume:volume];
            
            break;
        case videoSateGongge://宫格变化
            
            if (_isLiving) {
                self.controlBtn.selected = !self.controlBtn.selected;
                [self.topCell makeCellScale:self.controlBtn.selected];
            }
            
            break;
        case videoSateClarity://清晰度
        
        
            break;
        case videoSateFullScreen://全屏

            [self.topCell makePlayerViewFullScreen];
        
            break;
        case videoSatesSreenshots://截图

            [self.topCell clickSnapshotButton];
           
            break;
        case videoSateVideing://录像

            self.controlBtn.selected = !self.controlBtn.selected;
            [self startOrStopVideo:self.controlBtn.selected?@"start":@"stop"];
            [self.topCell startOrStopVideo:self.controlBtn.selected];
            self.videoing = self.controlBtn.selected;
            [self tipViewHidden:NO withTitle:@"正在录像"];

            break;
        case videoSateYuntai://云台控制
            
            self.controlBtn.selected = !self.controlBtn.selected;
            
            if (!self.controlBtn.isSelected) {
                self.clView.transform = CGAffineTransformIdentity;
            }else{
               [self clickMoreButton];
            }
        
        break;
        default:
            break;
    }
}

//云台操作
-(void)clickMoreButton
{
    [UIView animateWithDuration:0.3 animations:^{
        //Y轴向上平移
        self.clView.transform = CGAffineTransformMakeTranslation(0, -kScreenHeight + KTopviewheight + 114);
    }];
    
}
//摄像头控制回调
-(void)cameraControl:(CameraControlView *)CameraControlView withState:(ControlState)state
{
    switch (state) {
        case ControlStateUp:
            //上
            [self cameraControl:@"UP"];
            break;
            
        case ControlStateDown:
            //下
            [self cameraControl:@"DOWN"];
            break;
        
        case ControlStateLeft:
            //左
            [self cameraControl:@"LEFT"];
            break;
        
        case ControlStaterRight:
            //右
            [self cameraControl:@"RIGHT"];
            break;
            
        case ControlStaterStop:
            //停
            [self cameraControl:@"STOP"];
            break;
            
        case ControlStaterLeftUp:
            //左上
            [self cameraControl:@"UP_LEFT"];
            break;
            
        case ControlStaterLeftDown:
            //左下
            [self cameraControl:@"DOWN_LEFT"];
            break;
            
        case ControlStaterRightUp:
            //右上
            [self cameraControl:@"UP_RIGHT"];
            break;
            
        case ControlStaterRightDown:
            //右下
            [self cameraControl:@"DOWN_RIGHT"];
            break;
            
        case ControlStaterZoomin:
            //缩放
            [self cameraControl:@"ZOOM_IN"];
            break;
            
        case ControlStaterZoomout:
            //缩放
            [self cameraControl:@"ZOOM_OUT"];
            break;
            
        case ControlStaterFocusin:
            //聚焦
            [self cameraControl:@"focusin"];
            break;
       
        case ControlStaterFocusout:
            //聚焦
            [self cameraControl:@"focusout"];
            break;
        
        case ControlStaterAperturein:
             //光圈
             [self cameraControl:@"aperturein"];
             break;
        
         case ControlStaterApertureout:
             //光圈
             [self cameraControl:@"apertureout"];
             break;
            
        default:
            break;
    }
}
-(void)cameraColseControl:(CameraControlView *)CameraControlView
{
    [self playerControlwithState:videoSateYuntai withButton:self.controlBtn];
}
-(void)cameraControl:(NSString*)controls
{
    //提交数据
//    NSString *url;
//
//    if ([self.live_type isEqualToString:@"LiveGBS"]) {
//        url = [NSString stringWithFormat:@"service/video/livegbs/api/v1/control/ptz?serial=%@&code=%@&command=%@",self.gbs_serial,self.gbs_code,controls];
//    }else{
//        url = [NSString stringWithFormat:@"service/video/livenvr/api/v1/ptzcontrol?channel=%@&command=%@",self.nvr_channel,controls];
//    }
    
    NSString *url = [NSString stringWithFormat:@"service/cameraManagement/camera/operation/ptz?systemSource=GBS&id=%@&command=%@",self.carmer_id,controls];
    
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
    sence.successBlock = ^(id obj) {
        DLog(@"Received: %@", obj);
    };
    sence.errorBlock = ^(NSError *error) {
        DLog(@"error: %@", error);
    };
    [sence sendRequest];
}

#pragma mark - PlayerTableViewCellDelegate
- (void)getPlayerCellSnapshot:(PlayerTableViewCell *_Nullable)cell with:(UIImage*_Nullable)image
{
    [self setupSaveView:image witnTitle:@"图片已保存"];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __weak __typeof(&*self)weakSelf = self;
        [weakSelf.saveBackView removeFromSuperview];
    });
}
//图片，视频保存view
-(void)setupSaveView:(UIImage*)image witnTitle:(NSString*)title
{
    if (image == nil) {
        return;
    }
    CGFloat ySpace = kScreenWidth * 0.68 - 43.5;
    
    _saveBackView = [UIView new];
    _saveBackView.backgroundColor = UIColorFromRGB(0x000000, 0.37);
    [self.view addSubview:_saveBackView];
    [_saveBackView addHeight:45];
    [_saveBackView addWidth:kScreenWidth];
    [_saveBackView topToView:self.view withSpace:ySpace];
    
    
    UIImageView *saveImageView = [UIImageView new];
    saveImageView.image = image;
    [_saveBackView addSubview:saveImageView];
    [saveImageView alignTop:@"5" leading:@"10" bottom:@"5" trailing:nil toView:_saveBackView];
    [saveImageView addWidth:49];
    
    
    UILabel *subTitleLabel = [UILabel new];
    subTitleLabel.text = title;
    subTitleLabel.textColor = [UIColor whiteColor];
    subTitleLabel.font = [UIFont customFontWithSize:kFontSizeEleven];
    [_saveBackView addSubview:subTitleLabel];
    [subTitleLabel yCenterToView:_saveBackView];
    [subTitleLabel leftToView:saveImageView withSpace:8];
    
    
    UIButton *lookBtn = [UIButton new];
    [lookBtn setTitle:@"查看" forState:UIControlStateNormal];
    [lookBtn setTitleColor:kColorMainColor forState:UIControlStateNormal];
    lookBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEleven];
    [lookBtn addTarget:self action:@selector(lookPictureClick) forControlEvents:UIControlEventTouchUpInside];
    [_saveBackView addSubview:lookBtn];
    [lookBtn yCenterToView:_saveBackView];
    [lookBtn rightToView:_saveBackView withSpace:10];
    [lookBtn addWidth:30];
    [lookBtn addHeight:30];
    
}
-(void)lookPictureClick
{
    //打开本地相册查看 photos-redirect:// cGhvdG9zLXJlZGlyZWN0Oi8v
    NSURL * url = [NSURL URLWithString:[WWPublicMethod dencodeBase64:@"cGhvdG9zLXJlZGlyZWN0Oi8v"]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
    
}

//开始或停止录像
-(void)startOrStopVideo:(NSString*)states
{
    NSString *url = [NSString stringWithFormat:@"service/video/livegbs/api/v1/record/%@?streamid=%@",states,self.streamid];
    
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"Received: %@", obj);
        if ([states isEqualToString:@"stop"]) {
            [weak_self videoFinishDownload:obj];
        }
    };
    sence.errorBlock = ^(NSError *error) {

        [_kHUDManager hideAfter:0.1 onHide:nil];
        // 请求失败
        DLog(@"error  ==  %@",error.userInfo);
    };
    [sence sendRequest];
}
//录像完成，下载录像
-(void)videoFinishDownload:(id)obj
{
    if (obj == nil) {
        return;
    }
    NSArray *data = [obj objectForKey:@"RecordList"];
    NSDictionary *dic = (NSDictionary*)data.firstObject;
    
    NSString *DownloadURL = [dic objectForKey:@"DownloadURL"];
    NSString *EndTime = [dic objectForKey:@"EndTime"];
    NSString *StartTime = [dic objectForKey:@"StartTime"];

    [self tipViewHidden:NO withTitle:@"正在处理录像"];

    DownLoadSence *sence = [[DownLoadSence alloc]init];
    sence.url = DownloadURL;
//    sence.filePath = @"";
//    sence.fileName = @"";
    __unsafe_unretained typeof(self) weak_self = self;
    sence.finishedBlock = ^(NSString *filePath) {
        DLog(@"filePath ==  %@",filePath);
        NSURL *url = [NSURL URLWithString:filePath];
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
        if (compatible){
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum([url path], weak_self, @selector(savedVideo:didFinishSavingWithError:contextInfo:), nil);
        }
    };
    sence.progressBlock = ^(float progress, NSString *writeBytes) {
    
        DLog(@"writeBytes ==  %@",writeBytes);

    };
    [sence startDownload];
}
//下载完成保存视频到本地相册
- (void)savedVideo:(NSString*)videoURL didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"保存图片失败%@", error.localizedDescription);
    }else {
        
        [self tipViewHidden:YES withTitle:@" "];
        [self setupSaveView:[self getImage:videoURL] witnTitle:@"视频已保存"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __weak __typeof(&*self)weakSelf = self;
            [weakSelf.saveBackView removeFromSuperview];
        });

    }
}
//根据本地视频地址获取视频缩略图
-(UIImage *)getImage:(NSString *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}


- (void)selectCellCarmera:(PlayerTableViewCell *)cell withData:(LivingModel *)model
{
    if ([self.streamid isEqualToString:model.deviceSerial]) {
        return;
    }
    
    self.selectModel = model;
    
    self.carmer_id = model.deviceId;
    self.streamid = model.deviceSerial;
    [self startLoadDataRequest:model.deviceId];
}
//右上角按钮
-(void)sharaBtnCLick
{
    if (self.videoing) {
        [_kHUDManager showMsgInView:nil withTitle:@"正在录像！" isSuccess:YES];
        return;
    }
    
    //分享里面的内容
    self.shareParams = [[LGXShareParams alloc] init];
//        [self.shareParams makeShreParamsByData:self.model.share];
            
    [ShareSDKMethod ShareTextActionWithParams:self.shareParams QRCode:^{

        //视频播放地址生成二维码图片
        [self generatingTwoDimensionalCode:@"这是用来测试的"];

     } url:^{
         //链接
         DLog(@"链接");
         UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
         pasteboard.string = @"这个也是用来测试的";
         [_kHUDManager showMsgInView:nil withTitle:@"链接已复制至剪切板" isSuccess:YES];
         
     } Result:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
         if (state == SSDKResponseStateSuccess) {
            
         }
     }];
}
-(void)systemBtnCLick
{
    if (self.videoing) {
        [_kHUDManager showMsgInView:nil withTitle:@"正在录像！" isSuccess:YES];
        return;
    }
    
    //更多设置
    if (self.selectModel == nil) {
        return;
    }
    NSDictionary *dic = @{@"SnapURL":self.selectModel.snap,@"ChannelName":self.selectModel.rtmp};
    NSString *pushid = [WWPublicMethod jsonTransFromObject:dic];
    
    [TargetEngine controller:self pushToController:PushTargetChannelMoreSystem WithTargetId:pushid];
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

#pragma LocalVideoDelegate
-(void)selectRowData:(NSInteger)value
{
    if (self.videoing) {
        [_kHUDManager showMsgInView:nil withTitle:@"正在录像！" isSuccess:YES];
        return;
    }
    
    self.isLiving = NO;
    if (self.localVideosArray.count == 0) {
        return;
    }
    CarmeaVideosModel *model = [self.localVideosArray objectAtIndex:value];
    NSDictionary *dic = @{ @"name":model.video_name,
                           @"snapUrl":model.snap,
                           @"videoUrl":model.hls,
                           @"createAt":model.start_time,
                          };
    DemandModel *models = [DemandModel makeModelData:dic];
    self.model = models;
    
    [self.tableView reloadData];
}
+(UIViewController *)viewController:(UIView *)view{
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    return nil;
}
- (void)tableViewWillPlay:(PlayerTableViewCell *)cell
{
    
}

- (void)tableViewCellEnterFullScreen:(PlayerTableViewCell *)cell
{
    [self setNeedsStatusBarAppearanceUpdate];

}

- (void)tableViewCellExitFullScreen:(PlayerTableViewCell *)cell
{
    [self setNeedsStatusBarAppearanceUpdate];
}


//如果是直播，获取该摄像头下的录像文件
- (void)startLoadDataRequest:(NSString*)carmeraId;
{
   if (self.allDataArray.count == 0) {
          return;
      }
    if (![WWPublicMethod isStringEmptyText:carmeraId]) {
        return;
    }
//    NSString *url = [NSString stringWithFormat:@"service/cameraManagement/camera/record/list?systemSource=LiveGBS&id=%@&date=%@",carmeraId,[_kDatePicker getCurrentTimes:@"YYYYMMdd"]];
    NSString *url = [NSString stringWithFormat:@"service/cameraManagement/camera/record/list?systemSource=GBS&id=%@&date=%@",@"524508",@"20200916"];

    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"Received: %@", obj);
        [weak_self handleObject:obj];
    };
    sence.errorBlock = ^(NSError *error) {

        [_kHUDManager hideAfter:0.1 onHide:nil];
        // 请求失败
        DLog(@"error  ==  %@",error.userInfo);
        [weak_self failedOperation];
    };
    [sence sendRequest];
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

        NSArray *list = [obj objectForKey:@"list"];
        NSMutableArray *tempArray = [NSMutableArray array];
        
        [self.localVideosArray removeAllObjects];
        
        [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            CarmeaVideosModel *model = [CarmeaVideosModel makeModelData:dic];
            [tempArray addObject:model];
        }];
        [self.localVideosArray addObjectsFromArray:tempArray];

        [[GCDQueue mainQueue] queueBlock:^{
    
            [weak_self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }];
}
//获取录像封面快照
-(void)getRecordCoverPhoto:(NSString*)period withData:(NSInteger)indexInteger
{
    LivingModel *mdl = self.allDataArray.firstObject;
    if (![WWPublicMethod isStringEmptyText:mdl.deviceSerial]) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"service/video/liveqing/record/getsnap?forUrl=true&id=%@&&period=%@",mdl.deviceSerial,period];
    
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"Received: %@", obj);
        [weak_self dealWithCoverPhoto:obj withData:indexInteger];

    };
    sence.errorBlock = ^(NSError *error) {

        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"error: %@", error);
    };
    [sence sendRequest];
}

-(void)dealWithCoverPhoto:(id)obj withData:(NSInteger)indexInteger
{
    if (obj == nil) {
        return;
    }
    __unsafe_unretained typeof(self) weak_self = self;
    CarmeaVideosModel *model = [self.localVideosArray objectAtIndex:indexInteger];
    model.snap = [NSString stringWithFormat:@"%@",[obj objectForKey:@"url"]];
    [weak_self.localVideosArray replaceObjectAtIndex:indexInteger withObject:model];
//    weak_self.allDataArray = [NSMutableArray arrayWithArray:weak_self.dataArray];
    [[GCDQueue mainQueue] queueBlock:^{

//        [weak_self.tableView reloadData];
        [weak_self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

    }];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.topCell stop];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.topCell play];
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
