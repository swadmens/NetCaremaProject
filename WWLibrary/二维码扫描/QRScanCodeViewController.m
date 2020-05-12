//
//  QRScanCodeViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/5/12.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "QRScanCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LGXVerticalButton.h"

@interface QRScanCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
       NSTimer *_timer;
    BOOL upOrDown;
    int num;
}
@property (strong, nonatomic) AVCaptureDevice * device;
@property (strong, nonatomic) AVCaptureDeviceInput * input;
@property (strong, nonatomic) AVCaptureMetadataOutput * output;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * preview;
@property (strong, nonatomic) UIImageView *imageView;
@property (retain, nonatomic) UIImageView *line;
@property (nonatomic, strong) NSString     *identifier;

@property (nonatomic,strong) LGXVerticalButton *lightBtn;
@property (nonatomic,assign) BOOL isTurnON;

@end
 
@implementation QRScanCodeViewController
- (AVCaptureDevice *)device{
    if (_device == nil) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}
 
- (AVCaptureDeviceInput *)input{
    if (_input == nil) {
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    }
    return _input;
}
 
- (AVCaptureMetadataOutput *)output{
    
    if (_output == nil) {
        _output = [[AVCaptureMetadataOutput alloc]init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //限制扫描区域(上下左右)
        [_output setRectOfInterest:[self rectOfInterestByScanViewRect:_imageView.frame]];
    }
    return _output;
}
 
- (CGRect)rectOfInterestByScanViewRect:(CGRect)rect {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    CGFloat x = (height - CGRectGetHeight(rect)) / 2 / height;
    CGFloat y = (width - CGRectGetWidth(rect)) / 2 / width;
    CGFloat w = CGRectGetHeight(rect) / height;
    CGFloat h = CGRectGetWidth(rect) / width;
    return CGRectMake(x, y, w, h);
}
 
- (AVCaptureSession *)session{
    if (_session == nil) {
        //session
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([_session canAddInput:self.input]) {
            [_session addInput:self.input];
        }
        if ([_session canAddOutput:self.output]) {
            [_session addOutput:self.output];
        }
    }
    return _session;
}
 
- (AVCaptureVideoPreviewLayer *)preview{
    if (_preview == nil) {
        _preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
    return _preview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    
//    self.title = @"扫描二维码";
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
//
//
//    UIButton *rightBtn = [UIButton new];
//    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    rightBtn.titleLabel.font=[UIFont customFontWithSize:kFontSizeFourteen];
//    [rightBtn.titleLabel setTextAlignment: NSTextAlignmentRight];
//    rightBtn.frame = CGRectMake(0, 0, 65, 40);
//    [rightBtn addTarget:self action:@selector(right_clicked) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    [rightBtn setTitle:@"设备ID添加" forState:UIControlStateNormal];
//    [self.navigationItem setRightBarButtonItem:rightItem];

}
-(void)right_clicked
{
    [TargetEngine controller:nil pushToController:PushTargetAddNewEquipment WithTargetId:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    NSString* mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];

    if(authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied) {
        [[TCNewAlertView shareInstance] showAlert:nil message:@"请在iphone的“设置-隐私-相机”选项中，允许定时宝访问你的相机" cancelTitle:@"取消" viewController:self confirm:^(NSInteger buttonTag) {
            if (buttonTag == 0) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        } buttonTitles:@"确定", nil];
    }else{
        [self initView];
    }
}
 
- (void)initView {
    if (self.device == nil) {
        [[TCNewAlertView shareInstance] showAlert:nil message:@"未检测到摄像头！" cancelTitle:nil viewController:self confirm:^(NSInteger buttonTag) {
            if (buttonTag == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } buttonTitles:@"确定", nil];
        return;
    }
    [self addTimer];
    [self addImageView];
    [self scanSetup];
    [self addCoverBackView];
}
 
//添加覆盖背景框
-(void)addCoverBackView
{
    UIView *topView = [UIView new];
    topView.backgroundColor = UIColorFromRGB(0x000000, 0.3);
    [self.view addSubview:topView];
    [topView alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:self.view];
    [topView addHeight:(kScreenHeight-300)/2];
    
    UIImage *aimage = UIImageWithFileName(@"icon_back_gray");
    CGFloat leftWidth = aimage.size.width;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:aimage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, leftWidth, 64.0);
    [button addTarget:self action:@selector(action_goback) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:button];
    [button leftToView:topView withSpace:12];
    [button topToView:topView withSpace:30];
    
    
    UIButton *rightBtn = [UIButton new];
    [rightBtn setTitle:@"设备ID添加" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font=[UIFont customFontWithSize:kFontSizeFourteen];
    [rightBtn.titleLabel setTextAlignment: NSTextAlignmentRight];
    rightBtn.frame = CGRectMake(0, 0, 65, 40);
    [rightBtn addTarget:self action:@selector(right_clicked) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rightBtn];
    [rightBtn yCenterToView:button];
    [rightBtn rightToView:topView withSpace:10];
    
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"扫描二维码";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont customFontWithSize:kFontSizeEighTeen];
    [topView addSubview:titleLabel];
    [titleLabel yCenterToView:button];
    [titleLabel xCenterToView:topView];
    
    
    UIView *leftView = [UIView new];
    leftView.backgroundColor = UIColorFromRGB(0x000000, 0.3);
    [self.view addSubview:leftView];
    [leftView topToView:topView];
    [leftView leftToView:self.view];
    [leftView addWidth:(kScreenWidth-200)/2];
    [leftView addHeight:200];
    
    UIView *rightView = [UIView new];
    rightView.backgroundColor = UIColorFromRGB(0x000000, 0.3);
    [self.view addSubview:rightView];
    [rightView topToView:topView];
    [rightView rightToView:self.view];
    [rightView addWidth:(kScreenWidth-200)/2];
    [rightView addHeight:200];
    
    
    CGFloat botHeight = kScreenHeight - ((kScreenHeight-300)/2 + 200);
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = UIColorFromRGB(0x000000, 0.3);
    [self.view addSubview:bottomView];
    [bottomView alignTop:nil leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    [bottomView addHeight:botHeight];
    
    
    _lightBtn = [LGXVerticalButton new];
    [_lightBtn setImage:UIImageWithFileName(@"qrcode_light_close_image") forState:UIControlStateNormal];
    [_lightBtn setImage:UIImageWithFileName(@"qrcode_light_image") forState:UIControlStateSelected];
    [_lightBtn setTitle:@"轻触开灯" forState:UIControlStateNormal];
    [_lightBtn setTitle:@"轻触关灯" forState:UIControlStateSelected];
    [_lightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _lightBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeTen];
    [bottomView addSubview:_lightBtn];
    [_lightBtn topToView:bottomView withSpace:35];
    [_lightBtn addCenterX:-60 toView:bottomView];
    [_lightBtn addTarget:self action:@selector(opnLightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    

    
    LGXVerticalButton *picBtn = [LGXVerticalButton new];
    [picBtn setImage:UIImageWithFileName(@"qrcode_xiangce_image") forState:UIControlStateNormal];
    [picBtn setTitle:@"相册" forState:UIControlStateNormal];
    [picBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    picBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeTen];
    [bottomView addSubview:picBtn];
    [picBtn topToView:bottomView withSpace:35];
    [picBtn addCenterX:60 toView:bottomView];
    [picBtn addTarget:self action:@selector(opnPicturesBtnClick) forControlEvents:UIControlEventTouchUpInside];

    
}
-(void)opnLightBtnClick
{
    _lightBtn.selected = !_lightBtn.selected;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    if ([device hasTorch]) {

        if (_isTurnON) {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];//关
            [device unlockForConfiguration];
        }else{
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOn];//开
            [device unlockForConfiguration];
        }
        
        _isTurnON = !_isTurnON;
    }
}

//选择本地相册中的图片
-(void)opnPicturesBtnClick
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.delegate = self;
        
        [self presentViewController:controller animated:YES completion:NULL];
    }
    else
    {
        [_kHUDManager showMsgInView:nil withTitle:@"设备不支持访问相册" isSuccess:YES];
    }
}
-(void)action_goback
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        [self findQRCodeFromImage:image];
    }];
}
//识别图片中的二维码
- (void)findQRCodeFromImage:(UIImage *)image
{
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                              context:nil
                                              options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >= 1)
    {
        CIQRCodeFeature *feature = [features firstObject];
        [TargetEngine controller:nil pushToController:PushTargetAddNewEquipment WithTargetId:feature.messageString];
    }
    else
    {
        [_kHUDManager showMsgInView:nil withTitle:@"图片里没有二维码" isSuccess:YES];
    }
}
//添加扫描框
- (void)addImageView{
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-200)/2, (kScreenHeight-300)/2, 200, 200)];
    //显示扫描框
    _imageView.image = [UIImage imageNamed:@"qrcode_border_new"];
    [self.view addSubview:_imageView];
    _line = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_imageView.frame)+5, CGRectGetMinY(_imageView.frame)+5, CGRectGetWidth(_imageView.frame), 3)];
    _line.image = [UIImage imageNamed:@"qrcode_scan_line"];
    [self.view addSubview:_line];
}
 
//初始化扫描配置
- (void)scanSetup{
    
    self.preview.frame = self.view.bounds;
    self.preview.videoGravity = AVLayerVideoGravityResize;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode]];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    [self.session startRunning];
    
}
 
- (void)viewDidDisappear:(BOOL)animated {
    [self.session stopRunning];
    [_timer setFireDate:[NSDate distantFuture]];
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if ([metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        if ([metadataObject isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            NSString *stringValue = [metadataObject stringValue];
            if (stringValue != nil) {
                [self.session stopRunning];
                NSLog(@"%@",stringValue);
                [TargetEngine controller:nil pushToController:PushTargetAddNewEquipment WithTargetId:stringValue];
            }else{
                [_kHUDManager showMsgInView:nil withTitle:@"无法识别，请重试" isSuccess:YES];
            }
        }
    }
}
 
- (void)addTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.008 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
}
//控制扫描线上下滚动
- (void)timerMethod{
    if (upOrDown == NO) {
        num ++;
        _line.frame = CGRectMake(CGRectGetMinX(_imageView.frame)+5, CGRectGetMinY(_imageView.frame)+5+num, CGRectGetWidth(_imageView.frame)-10, 3);
        if (num == (int)(CGRectGetHeight(_imageView.frame)-10)) {
            upOrDown = YES;
        }
    }
    else{
        num --;
        _line.frame = CGRectMake(CGRectGetMinX(_imageView.frame)+5, CGRectGetMinY(_imageView.frame)+5+num, CGRectGetWidth(_imageView.frame)-10, 3);
        if (num == 0) {
            upOrDown = NO;
        }
    }
}
//暂定扫描
- (void)stopScan{
    [self.session stopRunning];
    [_timer setFireDate:[NSDate distantFuture]];
    _line.hidden = YES;
}
- (void)starScan{
    [self.session startRunning];
    [_timer setFireDate:[NSDate distantPast]];
    _line.hidden = NO;
}
 
@end


