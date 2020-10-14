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
#import "AFHTTPSessionManager.h"

#define KTopviewheight kScreenWidth*0.68

@interface SuperPlayerViewController ()<UITableViewDelegate,UITableViewDataSource,PlayerControlDelegate,CameraControlDelete,LocalVideoDelegate,PlayerTableViewCellDelegate
>

@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger page;

@property (nonatomic,strong) PlayerTableViewCell *topCell;

@property (nonatomic,strong) CameraControlView *clView;
@property (nonatomic,strong) LGXVerticalButton *controlBtn;

@property (nonatomic,strong) UIButton *backLiveBtn;//返回直播按钮

@property (nonatomic,strong) UIView *saveBackView;
@property (nonatomic, strong) LGXShareParams *shareParams;
@property (nonatomic, strong) NSMutableArray *localVideosArray;//本地录像数据
@property (nonatomic, strong) NSMutableArray *cloudVideosArray;//云端录像数据

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
-(NSMutableArray*)cloudVideosArray
{
    if (!_cloudVideosArray) {
        _cloudVideosArray = [NSMutableArray array];
    }
    return _cloudVideosArray;
}
- (void)setupTableView
{
    self.tableView = [[WWTableView alloc] init];
//    [self.tableView setScrollEnabled:NO];
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
//控制台
-(void)setupControllView
{
    //摄像头控制
    self.clView = [CameraControlView new];
    self.clView.delegate = self;
    [self.view addSubview:self.clView];
    self.clView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight - KTopviewheight - 177);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.title_value;
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    [self setupTableView];
    [self setupControllView];

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
    
    
    if (_isLiving) {
        MyEquipmentsModel *MyModel = self.allDataArray.firstObject;
        self.selectModel = MyModel.model;
        self.carmer_id = self.selectModel.deviceId;
        self.streamid = self.selectModel.deviceSerial;
        [self startLoadDataRequest:self.selectModel.deviceId withRecordType:@"local"];//本地录像
        [self startLoadDataRequest:self.selectModel.deviceId withRecordType:@"cloud"];//云端录像
        [self tipViewHidden:YES withTitle:@"开始录像"];
        if (MyModel.model != nil) {
            //控制台信息
            [self getCarmarPresetInfo];
        }
    }
   
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
    
    /**
     //返回直播按钮
     self.backLiveBtn = [UIButton new];
     self.backLiveBtn.hidden = YES;
     [self.backLiveBtn setBGColor:UIColorFromRGB(0x000000, 0.3) forState:UIControlStateNormal];
     [self.backLiveBtn setTitle:@"返回\n直播" forState:UIControlStateNormal];
     self.backLiveBtn.titleLabel.lineBreakMode = 0;
     [self.backLiveBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
     self.backLiveBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
     [self.backLiveBtn addTarget:self action:@selector(backLivBtnClick) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:self.backLiveBtn];
     [self.backLiveBtn leftToView:self.view];
     [self.backLiveBtn addCenterY:42 toView:self.view];
     [self.backLiveBtn addWidth:50];
     [self.backLiveBtn addHeight:40];
     */
    
    
    
}
-(void)backLivBtnClick
{
    self.isLiving = YES;
    self.backLiveBtn.hidden = YES;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

}


-(void)tipViewHidden:(BOOL)hidden withTitle:(NSString*)title
{
    _videoTipView.hidden = hidden;
    _videoTipLabel.text = title;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _isDemandFile?2:4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    
    if (indexPath.row == 0) {
        
        self.topCell = [tableView dequeueReusableCellWithIdentifier:[PlayerTableViewCell getCellIDStr] forIndexPath:indexPath];
        self.topCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_isLiving) {
            [self.topCell makeCellDataLiving:self.allDataArray witnLive:YES];
        }else{
            [self.topCell makeCellDataNoLiving:self.model witnLive:NO];
        }
        self.topCell.delegate = self;
        return self.topCell;
        
    }else if (indexPath.row == 1){
        
        PlayerControlCell *cell = [tableView dequeueReusableCellWithIdentifier:[PlayerControlCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        cell.isLiving = _isLiving;

        return cell;
    }else{
        
        PlayerLocalVideosCell *cell = [tableView dequeueReusableCellWithIdentifier:[PlayerLocalVideosCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (indexPath.row == 2) {
            [cell makeCellData:self.localVideosArray withTitle:@"本地录像"];
        }else{
            [cell makeCellData:self.cloudVideosArray withTitle:@"云端录像"];
        }
        
        cell.allBtn = ^{
             
            if (self.videoing) {
                [_kHUDManager showMsgInView:nil withTitle:@"正在录像！" isSuccess:YES];
                return;
            }
            LocalVideoViewController *vc = [LocalVideoViewController new];
            vc.delegate = self;
            vc.isFromIndex = NO;
            vc.device_id = self.carmer_id;
            vc.system_Source = self.selectModel.system_Source;
            vc.channel = self.selectModel.channel;
            vc.deviceSerial = self.selectModel.deviceSerial;
            vc.recordType = indexPath.row == 2?@"local":@"cloud";
            [weakSelf.navigationController pushViewController:vc animated:YES];
           
        };
        cell.selectedRowData = ^(CarmeaVideosModel * _Nonnull model) {
            weakSelf.model = model;
            weakSelf.isLiving = NO;
            weakSelf.backLiveBtn.hidden = NO;
            [weakSelf.tableView reloadData];
        };
   
        return cell;

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
            self.controlBtn.selected = !self.controlBtn.selected;
            [self.topCell videoStandardClarity:!self.controlBtn.selected];
        
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
//获取预置点信息
-(void)getCarmarPresetInfo
{
    [_kHUDManager showActivityInView:nil withTitle:nil];
    NSString *url = [NSString stringWithFormat:@"inventory/managedObjects/%@",self.selectModel.deviceId];
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"obj ==  %@",obj)
        NSArray *data = [obj objectForKey:@"presets"];
        NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:data.count];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *Mdic = obj;
            PresetsModel *model = [PresetsModel makeModelData:Mdic];
            [tempArr addObject:model];
        }];
        [weak_self.clView makeAllData:tempArr withSystemSource:weak_self.selectModel.system_Source withDevice_id:weak_self.selectModel.deviceId withIndex:0];
    };
    sence.errorBlock = ^(NSError *error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"error: %@", error);
    };
    [sence sendRequest];
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
    NSString *url = [NSString stringWithFormat:@"service/cameraManagement/camera/operation/ptz?systemSource=%@&id=%@&command=%@",self.selectModel.system_Source,self.carmer_id,controls];
    
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
    NSString *url = [NSString stringWithFormat:@"service/cameraManagement/camera/record/%@?systemSource=%@&id=%@",states,self.selectModel.system_Source,self.selectModel.deviceId];
    
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"Received: %@", obj);
        if ([states isEqualToString:@"stop"]) {
//            [weak_self videoFinishDownload:obj];
            [weak_self tipViewHidden:YES withTitle:@"录像完成"];

        }
    };
    sence.errorBlock = ^(NSError *error) {

        [_kHUDManager hideAfter:0.1 onHide:nil];
        [weak_self tipViewHidden:YES withTitle:@"录像未完成"];
        // 请求失败
        DLog(@"error  ==  %@",error);
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


- (void)selectCellCarmera:(PlayerTableViewCell *)cell withData:(MyEquipmentsModel *)model withIndex:(NSInteger)index
{
    if ([self.streamid isEqualToString:model.deviceSerial]) {
        return;
    }
    
    self.selectModel = model.model;
    
    self.carmer_id = self.selectModel.deviceId;
    self.streamid = self.selectModel.deviceSerial;
    [self startLoadDataRequest:self.selectModel.deviceId withRecordType:@"local"];
    if (self.selectModel != nil) {
        [self.clView makeAllData:self.selectModel.presets withSystemSource:self.selectModel.system_Source withDevice_id:self.selectModel.deviceId withIndex:index];
    }
    
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
-(void)selectRowData:(CarmeaVideosModel *)model
{
    if (self.videoing) {
        [_kHUDManager showMsgInView:nil withTitle:@"正在录像！" isSuccess:YES];
        return;
    }
    self.isLiving = NO;
    self.model = model;
    self.backLiveBtn.hidden = NO;
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
- (void)startLoadDataRequest:(NSString*)carmeraId withRecordType:(NSString*)type
{
   if (self.allDataArray.count == 0) {
          return;
      }
    if (![WWPublicMethod isStringEmptyText:carmeraId]) {
        return;
    }
    __unsafe_unretained typeof(self) weak_self = self;
//    NSString *recordType = [self.selectModel.system_Source isEqualToString:@"Hik"]?@"local":@"cloud";

    NSString *recordUrl = [NSString stringWithFormat:@"http://ncore.iot/service/cameraManagement/camera/record/list?systemSource=%@&id=%@&date=%@&type=%@",self.selectModel.system_Source,carmeraId,[_kDatePicker getCurrentTimes:@"YYYYMMdd"],type];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"multipart/form-data",nil];

    // 设置请求头
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//@{@"accept":@"video/*"}

    //添加授权
    [manager.requestSerializer setValue:_kUserModel.userInfo.Authorization forHTTPHeaderField:@"Authorization"];

    NSURLSessionDataTask *task = [manager GET:recordUrl parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"%@ == %@",type,responseObject);
        [weak_self handleObject:responseObject withRecordType:type];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        // 请求失败
        DLog(@"error  ==  %@",error.userInfo);
        [weak_self failedOperation];

    }];
    [task resume];
    return;
    NSString *url = [NSString stringWithFormat:@"service/cameraManagement/camera/record/list?systemSource=%@&id=%@&date=%@",self.selectModel.system_Source,@"524508",@"20200918"];
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
//    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"Received: %@", obj);
        [weak_self handleObject:obj withRecordType:type];
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
//    [_kHUDManager showMsgInView:nil withTitle:@"请求失败" isSuccess:NO];
}
- (void)handleObject:(id)obj withRecordType:(NSString*)type
{
    [_kHUDManager hideAfter:0.1 onHide:nil];
    __unsafe_unretained typeof(self) weak_self = self;
    [[GCDQueue globalQueue] queueBlock:^{

        NSArray *list = (NSArray*)obj;
        NSMutableArray *tempArray = [NSMutableArray array];
        
        [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [mutDic setObject:self.selectModel.deviceId forKey:@"deviceId"];
            [mutDic setObject:self.selectModel.channel forKey:@"channel"];
            [mutDic setObject:self.selectModel.deviceSerial forKey:@"deviceSerial"];
            [mutDic setObject:type forKey:@"recordType"];
            CarmeaVideosModel *model = [CarmeaVideosModel makeModelData:mutDic];
            [tempArray addObject:model];
        }];
        if ([type isEqualToString:@"local"]) {
            [self.localVideosArray addObjectsFromArray:tempArray];
        }else{
            [self.cloudVideosArray addObjectsFromArray:tempArray];
        }

        [[GCDQueue mainQueue] queueBlock:^{
    
            [weak_self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0],[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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
    model.picUrl = [NSString stringWithFormat:@"%@",[obj objectForKey:@"url"]];
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
