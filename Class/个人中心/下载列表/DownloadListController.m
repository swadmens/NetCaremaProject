//
//  DownloadListController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/5.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "DownloadListController.h"
#import "WWTableView.h"
#import "DownloadListCell.h"
#import "DownLoadSence.h"
#import "RequestSence.h"
#import "CarmeaVideosModel.h"
#import "DemandModel.h"
#import <MJExtension.h>

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "CLVoiceApplyAddressModel.h"
#import "CLInvoiceApplyAddressModelTool.h"


static NSString *const _kdownloadListKey = @"download_video_list";

@interface DownloadListController ()<UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate,PLLongMediaTableViewCellDelegate>
{
    BOOL _isHadFirst; // 是否第一次加载了
}
@property (nonatomic, strong) WWTableView *tableView;
@property (nonatomic,strong) NSMutableArray *showDataArray;
@property (nonatomic, strong) NSMutableDictionary *cellDic;
/// 没有内容
@property (nonatomic, strong) UIView *noDataView;

@property(nonatomic,strong)NSURLSessionDownloadTask*downloadTask;

///视频播放和下载用的url
@property (nonatomic,strong) NSString *url;

@property (nonatomic, assign) BOOL isFullScreen;

@property (nonatomic,strong) NSMutableArray *localVideoArray;


@end

@implementation DownloadListController
-(NSMutableArray*)showDataArray
{
    if (!_showDataArray) {
        _showDataArray = [NSMutableArray array];
    }
    return _showDataArray;
}
-(NSMutableArray*)localVideoArray
{
    if (!_localVideoArray) {
        _localVideoArray = [NSMutableArray array];
    }
    return _localVideoArray;
}
- (void)setupNoDataView
{
    self.noDataView = [self setupnoDataContentViewWithTitle:@"暂无下载数据" andImageNamed:@"device_empty_backimage" andTop:@"60"];
//    // label
//    UILabel *tipLabel = [self getNoDataTipLabel];
//
//    UIButton *againBtn = [UIButton new];
//    [againBtn setTitle:@"暂无数据" forState:UIControlStateNormal];
//    [againBtn setTitleColor:kColorMainTextColor forState:UIControlStateNormal];
//    againBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
//    [self.noDataView addSubview:againBtn];
//    [againBtn xCenterToView:self.noDataView];
//    [againBtn topToView:tipLabel withSpace:-8];
}
-(void)setupTableView
{
    self.tableView = [WWTableView new];
    self.tableView.backgroundColor = kColorBackgroundColor;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 88;
    [self.view addSubview:self.tableView];
    [self.tableView alignTop:@"10" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[DownloadListCell class] forCellReuseIdentifier:[DownloadListCell getCellIDStr]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"下载列表";
    
    [self setupNoDataView];
    [self setupTableView];
    [self dealWithOrigineData];
    
    
    //右上角按钮
    UIButton *rightBtn = [UIButton new];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font=[UIFont customFontWithSize:kFontSizeFourteen];
    [rightBtn.titleLabel setTextAlignment: NSTextAlignmentRight];
    rightBtn.frame = CGRectMake(0, 0, 65, 40);
    [rightBtn addTarget:self action:@selector(right_clicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn setTitle:@"清空" forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takeGoHomeNotica:) name:@"saveDownloadList" object:nil];
    
    
    //获取本地相册所有视频信息
    [self getLoaclVideos:^(NSString *url, NSUInteger length) {
        NSMutableDictionary *dicts = [NSMutableDictionary dictionary];
        [dicts setObject:url forKey:@"url"];
        [dicts setObject:@(length) forKey:@"length"];
        [self.localVideoArray addObject:dicts];
    }];
    
}
- (void)takeGoHomeNotica:(NSNotification *)notification
{
    //更新缓存信息
    [self.showDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        CLVoiceApplyAddressModel *model = obj;
        [CLInvoiceApplyAddressModelTool updateInfoAtIndex:idx withInfo:model];
        
    }];
    
}
//右上角按钮点击
-(void)right_clicked
{
    [[TCNewAlertView shareInstance] showAlert:nil message:@"确认清空下载列表吗？" cancelTitle:@"取消" viewController:self confirm:^(NSInteger buttonTag) {
        if (buttonTag == 0) {
            [self.showDataArray removeAllObjects];
            [self changeNoDataViewHiddenStatus];
            //清空所以缓存
            [CLInvoiceApplyAddressModelTool removeAllInfo];
            [_kHUDManager showMsgInView:nil withTitle:@"操作完成" isSuccess:YES];
        }
    } buttonTitles:@"确认", nil];
   
}
//离开页面，保存缓存
-(void)action_goback
{
//    [_kHUDManager showActivityInView:nil withTitle:@"保存信息中..."];
    
    //更新缓存信息
    [self.showDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        CLVoiceApplyAddressModel *model = obj;
        [CLInvoiceApplyAddressModelTool updateInfoAtIndex:idx withInfo:model];
        
    }];
    
//    [_kHUDManager hideAfter:0.1 onHide:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.showDataArray.count;
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //不使用cell的复用
    // 每次先从字典中根据IndexPath取出唯一标识符
    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
    if (identifier == nil) {
       identifier = [NSString stringWithFormat:@"%@%@", [DownloadListCell getCellIDStr], [NSString stringWithFormat:@"%@", indexPath]];
       [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
       // 注册Cell
        [self.tableView registerClass:[DownloadListCell class] forCellReuseIdentifier:identifier];
    }
    
    DownloadListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    CLVoiceApplyAddressModel *model = [self.showDataArray objectAtIndex:indexPath.row];
    [cell makeCellData:model];
    cell.localVideoArr = self.localVideoArray;

    
    cell.downlaodProgress = ^(NSString * _Nonnull value, NSString * _Nonnull writeBytes) {
        model.progress = value;
        model.writeBytes = writeBytes;
    };
    
    cell.localizedFilePath = ^(NSString * _Nonnull value) {
        model.file_path = value;
    };
    
    [self.showDataArray replaceObjectAtIndex:indexPath.row withObject:model];
    //更新缓存
    [CLInvoiceApplyAddressModelTool updateInfoAtIndex:indexPath.row withInfo:model];

    return cell;
}
#pragma mark ---- 侧滑删除
// 点击了“左滑出现的Delete按钮”会调用这个方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除缓存
    [CLInvoiceApplyAddressModelTool removeInfoAtIndex:indexPath.row];
    // 删除模型
    [self.showDataArray removeObjectAtIndex:indexPath.row];
    // 刷新
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

// 修改Delete按钮文字为“删除”
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
      return NO;
}
- (void)tableViewCellEnterFullScreen:(DownloadListCell *)cell {
    self.isFullScreen = YES;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)tableViewCellExitFullScreen:(DownloadListCell *)cell {
    self.isFullScreen = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}


- (void)startLoadDataRequest:(NSString*)start_time withInteger:(NSInteger)idx
{
    [_kHUDManager showActivityInView:nil withTitle:nil];
    
    NSString *urlString;
    if (_isRecord) {
        //如果是录像文件
        urlString = [NSString stringWithFormat:@"service/video/liveqing/record/download/%@/%@",self.downLoad_id,start_time];
    }else{
        urlString = [NSString stringWithFormat:@"service/video/liveqing/vod/download/%@",start_time];
    }
    
    
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = urlString;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"Received: %@", obj);

         CLVoiceApplyAddressModel *model = [weak_self.showDataArray objectAtIndex:idx];
         model.url = [obj objectForKey:@"url"];
         [weak_self.showDataArray replaceObjectAtIndex:idx withObject:model];
         //更新缓存
         [CLInvoiceApplyAddressModelTool updateInfoAtIndex:idx withInfo:model];
         
         [weak_self.tableView reloadData];
    };

    sence.errorBlock = ^(NSError *error) {

        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"error: %@", error);
    };
    [sence sendRequest];
}

//处理原始数据
-(void)dealWithOrigineData
{
    if (self.dataArray.count == 0) {
        
        //读取缓存数据
        NSArray *temp = CLInvoiceApplyAddressModelTool.allAddressInfo;
        [self.showDataArray addObjectsFromArray:temp];
        
    }else{
        
        NSMutableArray *tempModelArr = [NSMutableArray array];

        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableDictionary *tempDic = [NSMutableDictionary new];
            
            if ([obj isKindOfClass:[CarmeaVideosModel class]]) {
                
                CarmeaVideosModel *model = obj;
                [tempDic setValue:model.snap forKey:@"snap"];//封面图片URL
                [tempDic setValue:model.time forKey:@"time"];//视频时间
                [tempDic setValue:model.start_time forKey:@"start_time"];//视频时间
                [tempDic setValue:model.video_name forKey:@"name"];//视频名称
                [tempDic setValue:model.duration forKey:@"duration"];//视频时长
                [tempDic setValue:model.hls forKey:@"hls"];//视频播放地址

                //录像文件下载
                [self startLoadDataRequest:model.start_time withInteger:idx];
            }else{
                
                DemandModel *model = obj;
                
                [tempDic setValue:model.snapUrl forKey:@"snap"];//封面图片URL
                [tempDic setValue:model.createAt forKey:@"time"];//视频时间
                [tempDic setValue:model.start_time forKey:@"start_time"];//视频时间
                [tempDic setValue:model.video_name forKey:@"name"];//视频名称
                [tempDic setValue:model.duration forKey:@"duration"];//视频时长
                [tempDic setValue:model.videoUrl forKey:@"hls"];//视频播放地址
                
                //点播文件下载
                [self startLoadDataRequest:model.video_id withInteger:idx];
            }
            
            CLVoiceApplyAddressModel *model = [CLVoiceApplyAddressModel AddressModelWithDict:tempDic];
            [tempModelArr addObject:model];
        }];
        
        [self.showDataArray addObjectsFromArray:tempModelArr];
        
        //读取缓存数据
        NSArray *temp = CLInvoiceApplyAddressModelTool.allAddressInfo;
        NSArray *temp_arr = [NSArray arrayWithArray:temp];
        if (temp.count > 0) {
            //判断下载任务是否存在
            NSMutableArray *tempName = [NSMutableArray array];
            [temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CLVoiceApplyAddressModel *model = obj;
                [self.showDataArray enumerateObjectsUsingBlock:^(id  _Nonnull objs, NSUInteger idxs, BOOL * _Nonnull stops) {
                    CLVoiceApplyAddressModel *models = objs;
                    if ([model.time isEqualToString:models.time]) {
                        [tempName addObject:model.name];
                        [self.showDataArray removeObjectAtIndex:idxs];
                    }
                }];
            }];
            
            //提示信息
            if (tempName.count > 0) {
                NSString *mes = [NSString stringWithFormat:@"任务“%@”已存在",[tempName componentsJoinedByString:@"，"]];
                [[TCNewAlertView shareInstance] showAlert:nil message:mes cancelTitle:nil viewController:self confirm:^(NSInteger buttonTag) {
            //              if (buttonTag == 0) {
            
    //                }else{
    //
    //                }
                } buttonTitles:@"好的", nil];
            }
            //新增缓存信息
            if (self.showDataArray.count > 0) {
                [self.showDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    CLVoiceApplyAddressModel *model = obj;
                    [CLInvoiceApplyAddressModelTool addInfo:model];
                }];
            }
            
            [self.showDataArray addObjectsFromArray:temp_arr];
        }else{
            
            //新增缓存信息
            if (self.showDataArray.count > 0) {
                [self.showDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    CLVoiceApplyAddressModel *model = obj;
                    [CLInvoiceApplyAddressModelTool addInfo:model];
                }];
            }
        }
    }
    
    [self changeNoDataViewHiddenStatus];
    [self.tableView reloadData];
}
- (void)changeNoDataViewHiddenStatus
{
    NSInteger count = self.showDataArray.count;
    if (count == 0) {
        self.tableView.hidden = YES;
        self.noDataView.hidden = NO;
    } else {
        self.tableView.hidden = NO;
        self.noDataView.hidden = YES;
    }
    
}

//获取本地相册的所有视频信息
//获取本地相册中的视频测试
-(void)getLoaclVideos:(void (^)(NSString *url,NSUInteger length))ChooseRelultBlock;
{
    // 这里创建一个数组, 用来存储所有的相册
    NSMutableArray *allAlbumArray = [NSMutableArray array];
    // 获得相机胶卷
    // PHAssetCollectionTypeSmartAlbum = 2,  智能相册，系统自己分配和归纳的
    // PHAssetCollectionSubtypeSmartAlbumUserLibrary = 209,  相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    // 相机胶卷相簿存储到数组
    [allAlbumArray addObject:cameraRoll];
    // 获得所有的自定义相簿
    // PHAssetCollectionTypeAlbum = 1,  相册，系统外的
    // PHAssetCollectionSubtypeAlbumRegular = 2, 在iPhone中自己创建的相册
    // assetCollections是一个集合, 存储自定义的相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
         // 相簿存储到数组
         [allAlbumArray addObject:assetCollection];
    }
    
    // 遍历本地相簿
    [allAlbumArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        PHAssetCollection *albumCollection = obj;
        PHFetchResult<PHAsset *> *albumAssets = [PHAsset fetchAssetsInAssetCollection:albumCollection options:nil];
        // 取出一个视频对象, 这里假设albumAssets集合有视频文件
        for (PHAsset *asset in albumAssets) {
            // mediaType文件类型
            // PHAssetMediaTypeUnknown = 0, 位置类型
            // PHAssetMediaTypeImage   = 1, 图片
            // PHAssetMediaTypeVideo   = 2, 视频
            // PHAssetMediaTypeAudio   = 3, 音频
            
            NSInteger fileType = asset.mediaType;
            // 区分文件类型, 取视频文件
            if (fileType == PHAssetMediaTypeVideo)
            {
                // 取出视频文件
                PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
                options.version = PHImageRequestOptionsVersionCurrent;
                options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
                [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                    // 获取信息 asset audioMix info
                    // 上传视频时用到data
                    AVURLAsset *urlAsset = (AVURLAsset *)asset;
                    NSString *url = [NSString stringWithFormat:@"%@",urlAsset.URL];
                    NSData *data = [NSData dataWithContentsOfURL:urlAsset.URL options:NSDataReadingMappedIfSafe error:nil];
                    ChooseRelultBlock(url,data.length);
                    
                }];
            }
            
        }
    }];
    
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
