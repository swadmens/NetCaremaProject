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
#import "AFHTTPSessionManager.h"
#import "LGXVerticalButton.h"
#import "PlayBottomDateCell.h"
#import "LGXThirdEngine.h"
#import "ShareSDKMethod.h"
#import "LocalVideoViewController.h"
#import "DemandModel.h"
#import "CarmeaVideosModel.h"
#import "LivingModel.h"

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
    self.title = @"866262045665618";
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    [self setupTableView];

    
    self.clView = [CameraControlView new];
    self.clView.delegate = self;
    self.clView.isLiveGBS = [self.live_type isEqualToString:@"LiveGBS"];
    [self.view addSubview:self.clView];
    self.clView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight - KTopviewheight - 177);
    
    
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
    
    
    [self setupSaveView];
    if (_isLiving) {
        [self startLoadDataRequest];
    }
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
//        cell.isLiving = _isLiving;
//        cell.model = self.model;
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
        
        if (_isLiving) {
            PlayerLocalVideosCell *cell = [tableView dequeueReusableCellWithIdentifier:[PlayerLocalVideosCell getCellIDStr] forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            [cell makeCellData:self.localVideosArray];
            
            cell.allBtn = ^{
                 
                LocalVideoViewController *vc = [LocalVideoViewController new];
                vc.delegate = self;
                vc.isFromIndex = NO;
                vc.dataArray = [NSArray arrayWithArray:weakSelf.localVideosArray];
                [weakSelf.navigationController pushViewController:vc animated:YES];
               
            };
            cell.selectedRowData = ^(DemandModel * _Nonnull model) {
                weakSelf.model = model;
                weakSelf.isLiving = NO;
                [weakSelf.tableView reloadData];
            };
            
            return cell;
        }else{
            PlayBottomDateCell *cell = [tableView dequeueReusableCellWithIdentifier:[PlayBottomDateCell getCellIDStr] forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }
        
        
    }
}

#pragma mark - PlayerControlDelegate
-(void)playerControlwithState:(videoSate)state withButton:(UIButton *)sender
{
//    self.clView.transform = CGAffineTransformIdentity;
    
    self.controlBtn = (LGXVerticalButton*)sender;

    
    switch (state) {
        case videoSatePlay://播放暂停
            
            
            break;
        case videoSateVoice://声音控制
            
            
            break;
        case videoSateGongge://宫格变化
            
            
            break;
        case videoSateClarity://清晰度
        
        
            break;
        case videoSateFullScreen://全屏
        
        
            break;
        case videoSatesSreenshots://截图
                        
            self.controlBtn.selected = !self.controlBtn.selected;
            self.saveBackView.hidden = !self.controlBtn.selected;
           
            break;
        case videoSateVideing://录像
        
            self.controlBtn.selected = !self.controlBtn.selected;
            self.saveBackView.hidden = !self.controlBtn.selected;

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
            [self cameraControl:@"up"];
            break;
            
        case ControlStateDown:
            //下
            [self cameraControl:@"down"];
            break;
        
        case ControlStateLeft:
            //左
            [self cameraControl:@"left"];
            break;
        
        case ControlStaterRight:
            //右
            [self cameraControl:@"right"];
            break;
            
        case ControlStaterStop:
            //停
            [self cameraControl:@"stop"];
            break;
            
        case ControlStaterLeftUp:
            //左上
            [self cameraControl:@"upleft"];
            break;
            
        case ControlStaterLeftDown:
            //左下
            [self cameraControl:@"downleft"];
            break;
            
        case ControlStaterRightUp:
            //右上
            [self cameraControl:@"upright"];
            break;
            
        case ControlStaterRightDown:
            //右下
            [self cameraControl:@"downright"];
            break;
            
        case ControlStaterZoomin:
            //缩放
            [self cameraControl:@"zoomin"];
            break;
            
        case ControlStaterZoomout:
            //缩放
            [self cameraControl:@"zoomout"];
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
    NSString *url;
    
    if ([self.live_type isEqualToString:@"LiveGBS"]) {
        url = [NSString stringWithFormat:@"https://homebay.quarkioe.com/service/video/livegbs/api/v1/control/ptz?serial=%@&code=%@&command=%@",self.gbs_serial,self.gbs_code,controls];
    }else{
        url = [NSString stringWithFormat:@"https://homebay.quarkioe.com/service/video/livenvr/api/v1/ptzcontrol?channel=%@&command=%@",self.nvr_channel,controls];
    }
    
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
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
//        DLog(@"RecordCoverPhoto.Received: %@", responseObject);
//        DLog(@"RecordCoverPhoto.Received HTTP %ld", (long)httpResponse.statusCode);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        DLog(@"error: %@", error);
    }];
}

//图片，视频保存view
-(void)setupSaveView
{
    CGFloat ySpace = kScreenWidth * 0.68 - 43.5;
    
    _saveBackView = [UIView new];
    _saveBackView.hidden = YES;
    _saveBackView.backgroundColor = UIColorFromRGB(0x000000, 0.37);
    [self.view addSubview:_saveBackView];
    [_saveBackView addHeight:45];
    [_saveBackView addWidth:kScreenWidth];
    [_saveBackView topToView:self.view withSpace:ySpace];
    
    
    UIImageView *saveImageView = [UIImageView new];
    saveImageView.image = UIImageWithFileName(@"player_hoder_image");
    [_saveBackView addSubview:saveImageView];
    [saveImageView alignTop:@"5" leading:@"10" bottom:@"5" trailing:nil toView:_saveBackView];
    [saveImageView addWidth:49];
    
    
    UILabel *subTitleLabel = [UILabel new];
    subTitleLabel.text = @"视频已保存";
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
//右上角按钮
-(void)sharaBtnCLick
{
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
    //更多设置
    [TargetEngine controller:self pushToController:PushTargetChannelMoreSystem WithTargetId:nil];
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
    self.isLiving = NO;
    if (self.localVideosArray.count == 0) {
        return;
    }
    CarmeaVideosModel *model = [self.localVideosArray objectAtIndex:value];
    NSDictionary *dic = @{ @"name":model.video_name,
                           @"snapUrl":model.snap,
                           @"videoUrl":model.hls,
                           @"createAt":model.time,
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
- (void)startLoadDataRequest
{
//    [_kHUDManager showActivityInView:nil withTitle:nil];
    if (self.allDataArray.count == 0) {
        return;
    }
    LivingModel *mdl = self.allDataArray.firstObject;
    if (![WWPublicMethod isStringEmptyText:mdl.session_id]) {
        return;
    }
    NSDictionary *finalParams = @{
                                  @"id":mdl.session_id,
                                  @"day":[_kDatePicker dateStringWithDate:nil],
                                  @"start":@"0",
                                  @"limit":@"10",
                                  };
    //提交数据
    NSString *url = @"https://homebay.quarkioe.com/service/video/liveqing/record/query_records";
    
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
            
            NSString *originalSnap = [dic objectForKey:@"snap"];
            NSString *start_time = [dic objectForKey:@"start_time"];

//            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
//            NSString *snap = [NSString stringWithFormat:@"https://homebay.quarkioe.com/service/video/liveqing/record/getsnap?id=%@&period=%@",self.device_id,start_time];
            if (![WWPublicMethod isStringEmptyText:originalSnap]) {
//                [mutDic setValue:snap forKey:@"snap"];
                [self getRecordCoverPhoto:start_time withData:idx];
            }
            CarmeaVideosModel *model = [CarmeaVideosModel makeModelData:dic];
            [modelArray addObject:model];
        }];
        [weak_self.localVideosArray addObjectsFromArray:modelArray];
        [[GCDQueue mainQueue] queueBlock:^{
    
            [weak_self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }];
}
//获取录像封面快照
-(void)getRecordCoverPhoto:(NSString*)period withData:(NSInteger)indexInteger
{
    LivingModel *mdl = self.allDataArray.firstObject;
    if (![WWPublicMethod isStringEmptyText:mdl.session_id]) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"https://homebay.quarkioe.com/service/video/liveqing/record/getsnap?forUrl=true&id=%@&&period=%@",mdl.session_id,period];
    
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
