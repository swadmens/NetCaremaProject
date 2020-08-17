//
//  VideoUpLoadViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/4.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "VideoUpLoadViewController.h"
#import "StartRecordVideoController.h"
#import "TCNavigationController.h"
#import "RIButtonItem.h"
#import "RACDelegateProxy.h"
#import "AFHTTPSessionManager.h"
#import "RequestSence.h"

#import "MovEncodeToMpegTool.h"
#import <TZImagePickerController.h>


@interface VideoUpLoadViewController ()<UITextFieldDelegate,UITextViewDelegate,StartRecordVideoDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic,strong) UITextField *titleTextField;

@property (nonatomic,strong) UITextView *describeTextView;
@property (nonatomic,strong) NSString *msg_content;//文件描述
@property (nonatomic,strong) UIButton *addVideoBtn;
@property (nonatomic,strong) NSData *fileData;

@property (nonatomic,strong) NSURL *fileUrl;


@property (nonatomic,strong) NSString *fileName;//文件名称
@property (nonatomic,assign) BOOL isAddVideo;//是否添加了视频

@end

@implementation VideoUpLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布视频";
    self.view.backgroundColor = kColorBackgroundColor;
    
    //上传按钮
    UIButton *upLoadBtn = [UIButton new];
    [upLoadBtn setBackgroundImage:UIImageWithFileName(@"demand_upload_image") forState:UIControlStateNormal];
    [upLoadBtn setTitle:@"上传" forState:UIControlStateNormal];
    [upLoadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    upLoadBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [upLoadBtn addTarget:self action:@selector(upLoadButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *righItem = [[UIBarButtonItem alloc]initWithCustomView:upLoadBtn];
    self.navigationItem.rightBarButtonItem = righItem;
    
    
    [self creadVideoUI];
    
}
//创建UI
-(void)creadVideoUI
{
    UIView *titleView = [UIView new];
    titleView.backgroundColor = [UIColor whiteColor];
    titleView.clipsToBounds = YES;
    titleView.layer.cornerRadius = 10;
    [self.view addSubview:titleView];
    [titleView alignTop:@"10" leading:@"15" bottom:nil trailing:@"15" toView:self.view];
    [titleView addHeight:48];
    
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"标题";
    nameLabel.textColor = kColorMainTextColor;
    nameLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [nameLabel sizeToFit];
    [titleView addSubview:nameLabel];
    [nameLabel yCenterToView:titleView];
    [nameLabel leftToView:titleView withSpace:20];
    
    _titleTextField = [UITextField new];
    _titleTextField.delegate = self;
    _titleTextField.font = [UIFont customFontWithSize:kFontSizeTwelve];
    _titleTextField.placeholder = @"请输入标题";
    _titleTextField.textColor = kColorMainTextColor;
    [titleView addSubview:_titleTextField];
    [_titleTextField yCenterToView:titleView];
    [_titleTextField leftToView:nameLabel withSpace:12];
    [_titleTextField addWidth:kScreenWidth-90];
    
    
    UIView *describeView = [UIView new];
    describeView.backgroundColor = [UIColor whiteColor];
    describeView.clipsToBounds = YES;
    describeView.layer.cornerRadius = 10;
    [self.view addSubview:describeView];
    [describeView alignTop:@"68" leading:@"15" bottom:nil trailing:@"15" toView:self.view];
    [describeView addHeight:230];
    
    
    UILabel *desNameLabel = [UILabel new];
    desNameLabel.text = @"描述";
    desNameLabel.textColor = kColorMainTextColor;
    desNameLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [desNameLabel sizeToFit];
    [describeView addSubview:desNameLabel];
    [desNameLabel topToView:describeView withSpace:18];
    [desNameLabel leftToView:describeView withSpace:20];
    
    _describeTextView = [UITextView new];
//    _describeTextView.backgroundColor = [UIColor redColor];
    _describeTextView.delegate = self;
    _describeTextView.font = [UIFont customFontWithSize:kFontSizeTwelve];
    _describeTextView.text = @"请输入描述内容";
    _describeTextView.textColor = kColorThirdTextColor;
    [describeView addSubview:_describeTextView];
    [_describeTextView topToView:describeView withSpace:11];
    [_describeTextView leftToView:desNameLabel withSpace:12];
    [_describeTextView addWidth:kScreenWidth-100];
    [_describeTextView addHeight:100];
    
    
    
    _addVideoBtn = [UIButton new];
    [_addVideoBtn setImage:UIImageWithFileName(@"upload_add_image") forState:UIControlStateNormal];
    _addVideoBtn.clipsToBounds = YES;
    _addVideoBtn.layer.cornerRadius = 10;
    [_addVideoBtn setBGColor:UIColorFromRGB(0xe8e8e8, 1) forState:UIControlStateNormal];
    [describeView addSubview:_addVideoBtn];
    [_addVideoBtn bottomToView:describeView withSpace:20];
    [_addVideoBtn leftToView:describeView withSpace:20];
    [_addVideoBtn addWidth:70];
    [_addVideoBtn addHeight:70];
    [_addVideoBtn addTarget:self action:@selector(addVedioClick) forControlEvents:UIControlEventTouchUpInside];
    
}

//上传视频
-(void)upLoadButtonClick
{
    [self.view endEditing:YES];
    
    if (![WWPublicMethod isStringEmptyText:self.fileName]) {
        [_kHUDManager showMsgInView:nil withTitle:@"视频名称不能为空" isSuccess:YES];
        return;
    }
    if (!_isAddVideo) {
        [_kHUDManager showMsgInView:nil withTitle:@"请添加一个您要上传的视频！" isSuccess:YES];
        return;
    }
    
    NSString *string = [NSString stringWithFormat:@"%@.mp4",self.fileName];
    [self getUploadVideoAddress:self.fileData withFileName:string];
//    [self sendImageWithImage:string];
}
#pragma mark - UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.fileName = textField.text;
}
#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"请输入描述内容";
        textView.textColor = kColorThirdTextColor;
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"请输入描述内容"]){
        textView.text = @"";
        textView.textColor = kColorMainTextColor;
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.markedTextRange == nil) {
        self.msg_content = [NSString stringWithFormat:@"%@",textView.text];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""] && range.length > 0) {
        //删除字符肯定是安全的
        return YES;
    }else {
        if (textView.text.length - range.length + text.length > 100) {
            return NO;
        }else {
            return YES;
        }
    }
}

//选择本地视频上传
-(void)addVedioClick
{
    [self chooseLocalVideo];
}

- (void)recordVideoNormalPath:(NSString *)path
{
//    NSError *err = nil;
//    NSData* data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path] options:NSDataReadingMappedIfSafe error:&err];
//
//    self.fileData = data;
//    self.isAddVideo = YES;
//    self.fileUrl = [NSURL fileURLWithPath:path];

}
-(void)recordVideoTakeHomePath:(NSString *)path withImage:(UIImage *)image
{

    DLog(@"path ==  %@",path);
    [[GCDQueue mainQueue] queueBlock:^{
        [self.addVideoBtn setImage:image forState:UIControlStateNormal];
    }];

    NSError *err = nil;
    NSData* data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path] options:NSDataReadingMappedIfSafe error:&err];

    self.fileData = data;
    self.isAddVideo = YES;
    self.fileUrl = [NSURL fileURLWithPath:path];

}


//选择本地视频
-(void)chooseLocalVideo
{
    //创建AlertController对象 preferredStyle可以设置是AlertView样式或者ActionSheet样式
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //创建取消按钮
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action){
        [[GCDQueue mainQueue] queueBlock:^{

            [self shootingVideo];
        }];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chosedVideo];
    }];
    
    //添加按钮
    [alertC addAction:action1];
    [alertC addAction:action2];
    [alertC addAction:action3];
    //显示
    [self presentViewController:alertC animated:YES completion:nil];
}
-(void)shootingVideo
{
    StartRecordVideoController *videoRecordVC = [[StartRecordVideoController alloc] init];
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:videoRecordVC];
    videoRecordVC.delegate = self;
    nav.modalPresentationStyle = 0;
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)chosedVideo
{
    //MaxImagesCount  可以选着的最大条目数
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:2 delegate:self];
    
    // 是否显示可选原图按钮
    imagePicker.allowPickingOriginalPhoto = NO;
    // 是否允许显示视频
    imagePicker.allowPickingVideo = YES;
    // 是否允许显示图片
    imagePicker.allowPickingImage = NO;
    // 持续时间 限制
    imagePicker.videoMaximumDuration = 5;
    // 设置 模态弹出模式。 iOS 13默认非全屏
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    // 这是一个navigation 只能present
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

// 选择视频的回调
-(void)imagePickerController:(TZImagePickerController *)picker
       didFinishPickingVideo:(UIImage *)coverImage
                sourceAssets:(PHAsset *)asset{
    
    [_kHUDManager showActivityInView:nil withTitle:@"处理视频中..."];
    
//    //不转码，直接使用
//    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPresetLowQuality success:^(NSString *outputPath) {
//        NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
//        [_kHUDManager hideAfter:0.1 onHide:nil];
//
//        // Export completed, send video here, send by outputPath or NSData
//        // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
//        NSData *data = [NSData dataWithContentsOfFile:outputPath];
//        self.fileData = data;
//        [[GCDQueue mainQueue] queueBlock:^{
//            self.isAddVideo = YES;
//            [self.addVideoBtn setImage:[self getImage:outputPath] forState:UIControlStateNormal];
//        }];
//
//    } failure:^(NSString *errorMessage, NSError *error) {
//        [_kHUDManager hideAfter:0.1 onHide:nil];
//        NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
//    }];
//
//    return;

    DLog(@"--------- 视频编码 ----------- 开始 ----------");
    [MovEncodeToMpegTool convertMovToMp4FromPHAsset:asset
                      andAVAssetExportPresetQuality:ExportPresetMediumQuality
                  andMovEncodeToMpegToolResultBlock:^(NSURL *mp4FileUrl, NSData *mp4Data, NSError *error) {
        DLog(@"--------- 视频编码 ----------- 结束 ----------\n{\n  %@,\n   %ld,\n  %@\n}",mp4FileUrl,mp4Data.length,error.localizedDescription);
        [_kHUDManager hideAfter:0.1 onHide:nil];

        self.fileData = mp4Data;
        self.fileUrl = mp4FileUrl;
        
        [[GCDQueue mainQueue] queueBlock:^{
            self.isAddVideo = YES;
            [self.addVideoBtn setImage:coverImage forState:UIControlStateNormal];
        }];
    }];
}
- (void)chosedVideoOldMethod
{
    BOOL canuse = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    if (canuse == NO) {
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        RIButtonItem *item;
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            item = [RIButtonItem itemWithLabel:@"去设置" action:^{
                [[UIApplication sharedApplication] openURL:url options:[NSDictionary new] completionHandler:nil];
            }];
        }
        [[TCNewAlertView shareInstance] showAlert:@"" message:@"您的设备不支持拍摄或您设置了拍摄权限" cancelTitle:@"知道了" viewController:self confirm:^(NSInteger buttonTag) {
            
        } buttonTitles:nil, nil];
        return;
    }
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    picker.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];//设置媒体类型为public.movie
    picker.allowsEditing = YES;
//    picker.delegate = self;
    [[picker rac_imageSelectedSignal] subscribeNext:^(id x) {
                
        NSString *videoPath = [[x objectForKey:UIImagePickerControllerMediaURL] path];
        NSData *data = [NSData dataWithContentsOfFile:videoPath];
        self.fileUrl = [x objectForKey:UIImagePickerControllerMediaURL];
        

        [picker dismissViewControllerAnimated:YES completion:^{
            self.fileData = data;
            self.isAddVideo = YES;
            [self.addVideoBtn setImage:[self getImage:videoPath] forState:UIControlStateNormal];
        }];
        
    }];
    
    [[picker.rac_delegateProxy signalForSelector:@selector(imagePickerControllerDidCancel:)] subscribeNext:^(id x) {
        //该block调用时候：当delegate要执行imagePickerControllerDidCancel
        [picker dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:picker animated:YES completion:nil];
    
}
//上传视频
-(void)getUploadVideoAddress:(NSData*)value withFileName:(NSString*)fileName
{
    [_kHUDManager showActivityInView:nil withTitle:@"正在上传..."];
    __unsafe_unretained typeof(self) weak_self = self;

    NSString *url = [NSString stringWithFormat:@"http://39.108.208.122:5080/LiveApp/rest/v2/vods/create?name=%@",fileName];
    NSString  *newUrlString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//链接含有中文转码

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"multipart/form-data",nil];

    // 设置请求头
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
//@{@"accept":@"video/*"}
    NSURLSessionDataTask *task = [manager POST:newUrlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        [formData appendPartWithFileData:value name:@"file" fileName:fileName mimeType:@"video/mp4"];

    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [_kHUDManager hideAfter:0.1 onHide:nil];

        DLog(@"responseObject ==  %@",responseObject)
        
        BOOL success = [[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"success"]] boolValue];
        if (success) {
            [_kHUDManager showMsgInView:nil withTitle:@"上传完成" isSuccess:YES];
            [weak_self.navigationController popViewControllerAnimated:YES];
        }else{
            [_kHUDManager showMsgInView:nil withTitle:@"上传失败，请重试！" isSuccess:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        [_kHUDManager showMsgInView:nil withTitle:@"上传失败，请重试！" isSuccess:YES];

        DLog(@"error ==  %@",error.userInfo)

    }];

    [task resume];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
