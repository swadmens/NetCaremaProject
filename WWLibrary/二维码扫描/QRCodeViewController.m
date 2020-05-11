//
//  QRCodeViewController.m
//  QRCode
//
//  Created by 王聪 on 16/5/22.
//  Copyright © 2016年 王聪. All rights reserved.
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface QRCodeViewController () <UITabBarDelegate,AVCaptureMetadataOutputObjectsDelegate>

// 显示扫描后的结果
@property (weak, nonatomic) IBOutlet UILabel *resultLab;

// 高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightCons;

// 扫描线
@property (weak, nonatomic) IBOutlet UIImageView *scanLineView;

// 扫描线的约束，这里很重要，动画效果主要是根据设置这个的值实现的
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanLineCons;

// 自定义ToolBar
@property (weak, nonatomic) IBOutlet UITabBar *customTabBar;

// 会话
@property (nonatomic, strong) AVCaptureSession *session;

// 输入设备
@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;

// 输出设备
@property (nonatomic, strong) AVCaptureMetadataOutput *output;

// 预览图层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

// 会话图层
@property (nonatomic, strong) CALayer *drawLayer;


// 扫描完成回调block
@property (copy, nonatomic) void (^completionBlock) (NSString *);

// 音频播放
@property (strong, nonatomic) AVAudioPlayer        *beepPlayer;

@property (nonatomic,assign) BOOL isTurnON;

@end

@implementation QRCodeViewController

#pragma mark - 懒加载
// 会话
- (AVCaptureSession *)session
{
    if (_session == nil) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}
// 拿到输入设备
- (AVCaptureDeviceInput *)deviceInput
{
    if (_deviceInput == nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        _deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
    }
    return _deviceInput;
}
// 拿到输出对象
- (AVCaptureMetadataOutput *)output
{
    if (_output == nil) {
        _output = [[AVCaptureMetadataOutput alloc] init];
    }
    return _output;
}
// 创建预览图层
- (AVCaptureVideoPreviewLayer *)previewLayer
{
    if (_previewLayer == nil) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        _previewLayer.frame = [UIScreen mainScreen].bounds;
    }
    return _previewLayer;
}
// 创建用于绘制边线的图层
- (CALayer *)drawLayer
{
    if (_drawLayer == nil) {
        _drawLayer = [[CALayer alloc] init];
        _drawLayer.frame = [UIScreen mainScreen].bounds;
    }
    return _drawLayer;
}

- (AVAudioPlayer *)beepPlayer
{
    if (_beepPlayer == nil) {
        NSString * wavPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"wav"];
        NSData* data = [[NSData alloc] initWithContentsOfFile:wavPath];
        _beepPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
    }
    return _beepPlayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

//    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    
    self.customTabBar.selectedItem = self.customTabBar.items[0];
    self.customTabBar.delegate = self;
    
    self.title = @"扫描二维码";
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;

    
    UIButton *rightBtn = [UIButton new];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font=[UIFont customFontWithSize:kFontSizeFourteen];
    [rightBtn.titleLabel setTextAlignment: NSTextAlignmentRight];
    rightBtn.frame = CGRectMake(0, 0, 65, 40);
    [rightBtn addTarget:self action:@selector(right_clicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn setTitle:@"设备ID添加" forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    
    
    _resultLab.text = @"  ";
    [_resultLab addWidth:kScreenWidth - 30];
    
    
//    [self setupTopBar];
    [self startAnimation];
    [self startScan];
}
-(void)right_clicked
{
    
}
- (void)setupTopBar
{
    CGFloat space=0;
    if (IS_IPHONEX) {
        space=22;
    }
    
    UIView*topView=[UIView new];
    topView.backgroundColor = UIColorFromRGB(0xf55b53, 0);
    [self.view addSubview:topView];
    [topView addHeight:64+space];
    [topView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    
    UIImage *aimage = UIImageWithFileName(@"icon_back_screen");
    CGFloat leftWidth = aimage.size.width;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:aimage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, leftWidth, 64.0);
    [button addTarget:self action:@selector(action_goback) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:button];
    [button leftToView:topView withSpace:12];
    [button bottomToView:topView withSpace:10];
    
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//
//    [self.tabBarController.tabBar setHidden:YES];
////    self.navigationController.navigationBarHidden=YES;
////
////    if (!_isPushIn) {
////        [self.navigationController popViewControllerAnimated:YES];
////    }else{
////       _isPushIn=NO;
////    }
//
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

#pragma mark - Managing the Block

- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString))completionBlock
{
    self.completionBlock = completionBlock;
    self.navigationController.navigationBarHidden=NO;
}

#pragma 扫描过程
- (void)startScan
{
    // 1.判断是否能够将输入添加到会话中
    if (![self.session canAddInput:self.deviceInput]) {
        return;
    }
    
    // 2.判断是否能够将输出添加到会话中
    if (![self.session canAddOutput:self.output]) {
        return;
    }
    
    // 3.将输入和输出都添加到会话中
    [self.session addInput:self.deviceInput];
    
    [self.session addOutput:self.output];
    
    // 4.设置输出能够解析的数据类型
    // 注意: 设置能够解析的数据类型, 一定要在输出对象添加到会员之后设置, 否则会报错
    self.output.metadataObjectTypes = self.output.availableMetadataObjectTypes;
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 如果想实现只扫描一张图片, 那么系统自带的二维码扫描是不支持的
    // 只能设置让二维码只有出现在某一块区域才去扫描
//    self.output.rectOfInterest = CGRectMake(0.0, 0.0, 1, 1);
    
    // 设置二维码区域参考http://www.tuicool.com/articles/6jUjmur
    [self.output setRectOfInterest : CGRectMake (( 160 )/ kScreenHeight ,(( kScreenWidth - 300 )/ 2 )/ kScreenWidth , 300 / kScreenHeight , 300 / kScreenWidth)];
    
    // 5.添加预览图层
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    // 添加绘制图层
    [self.previewLayer addSublayer:self.drawLayer];
    
    // 6.告诉session开始扫描
    [self.session startRunning];
}

- (void)stopScan
{
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }

    [self stopAnimation];
}


- (void)startAnimation
{
    // 让约束从顶部开始
    self.scanLineCons.constant = 0;
    [self.view layoutIfNeeded];
    // 设置动画指定的次数
    [UIView animateWithDuration:2.0 animations:^{
        // 1.修改约束
        self.scanLineCons.constant = self.containerHeightCons.constant;
        [UIView setAnimationRepeatCount:MAXFLOAT];
        // 2.强制更新界面
        [self.view layoutIfNeeded];
    }];
}

// 停止动画
- (void)stopAnimation
{
    [self.view.layer removeAllAnimations];
}

/**
 *  当从二维码中获取到信息时，就会调用下面的方法
 *
 *  @param captureOutput   输出对象
 *  @param metadataObjects 信息
 *  @param connection
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // 0.清空图层
    [self clearCorners];
    
    if (metadataObjects.count == 0 || metadataObjects == nil) {
        return;
    }
    
    
    // 1.获取扫描到的数据
    // 注意: 要使用stringValue

    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
//        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects lastObject];
        //判断回传的数据类型
//        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode] && [metadataObj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
        

            // 扫描结果
            NSString *result = [metadataObjects.lastObject stringValue];
            
            // 停止扫描
            [self stopScan];
            
            if (_completionBlock) {
                [self.beepPlayer play];
                _completionBlock(result);
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(reader:didScanResult:)]) {
                [self.delegate reader:self didScanResult:result];
            }
        
        [self pressBackButton];
            return;
//    }
    }

    
    // 2.获取扫描到的二维码的位置
    // 2.1转换坐标
    for (AVMetadataObject *object in metadataObjects) {
        // 2.1.1判断当前获取到的数据, 是否是机器可识别的类型
        if ([object isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            // 2.1.2将坐标转换界面可识别的坐标
            AVMetadataMachineReadableCodeObject *codeObject = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:object];
            // 2.1.3绘制图形
            [self drawCorners:codeObject];
        }
    }
}
- (void)pressBackButton {
    
    [UIView animateWithDuration:0.5 animations:^{
        UINavigationController *nvc = self.navigationController;
        if (nvc) {
            if (nvc.viewControllers.count == 1) {
                [nvc dismissViewControllerAnimated:YES completion:nil];
            } else {
                [nvc popViewControllerAnimated:NO];
            }
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
}


/**
 *  画出二维码的边框
 *
 *  @param codeObject 保存了坐标的对象
 */
- (void)drawCorners:(AVMetadataMachineReadableCodeObject *)codeObject
{
    if (codeObject.corners.count == 0) {
        return;
    }
    
    // 1.创建一个图层
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.lineWidth = 4;
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    
    // 2.创建路径
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGPoint point = CGPointZero;
    NSInteger index = 0;
    
    // 2.1移动到第一个点
    // 从corners数组中取出第0个元素, 将这个字典中的x/y赋值给point
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)codeObject.corners[index++], &point);
    [path moveToPoint:point];
    
    // 2.2移动到其它的点
    while (index < codeObject.corners.count) {
        CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)codeObject.corners[index++], &point);
        [path addLineToPoint:point];
    }
    // 2.3关闭路径
    [path closePath];
    
    // 2.4绘制路径
    layer.path = path.CGPath;
    
    // 3.将绘制好的图层添加到drawLayer上
    [self.drawLayer addSublayer:layer];
}

/**
 *  清除边线
 */
- (void)clearCorners
{
    if (self.drawLayer.sublayers == nil || self.drawLayer.sublayers.count == 0) {
        return;
    }
    
    for (CALayer *subLayer in self.drawLayer.sublayers) {
        [subLayer removeFromSuperlayer];
    }
}


/**
 *  选择tabBar时进行跳转
 *
 *  @param tabBar tabbar
 *  @param item   tabBar的item
 */
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 1) {
        self.containerHeightCons.constant = 300;
   
        DLog(@"打开闪光灯");
        
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
        
    } else {
    
//        self.containerHeightCons.constant = 150;
    
        DLog(@"打开系统相册");

    }
    
//    // 2.停止动画
//    [self.view.layer removeAllAnimations];
//    [self.scanLineView.layer removeAllAnimations];
//
//    // 3.重新开始动画
//    [self startAnimation];
}

- (void)action_goback
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.tabBarController.tabBar setHidden:NO];
}

@end
