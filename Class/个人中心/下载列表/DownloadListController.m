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
#import "AFHTTPSessionManager.h"
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

@interface DownloadListController ()<UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate>
{
    BOOL _isHadFirst; // 是否第一次加载了
}
@property (nonatomic, strong) WWTableView *tableView;
@property (nonatomic,strong) NSMutableArray *showDataArray;
@property (nonatomic, strong) NSMutableDictionary *cellDic;
/// 没有内容
@property (nonatomic, strong) UIView *noDataView;

@property (nonatomic,strong) NSMutableArray *lengthArray;

@property(nonatomic,strong)NSURLSessionDownloadTask*downloadTask;

///视频播放和下载用的url
@property (nonatomic,strong) NSString *url;


@property (nonatomic,strong) NSMutableArray *originalData;

@property (nonatomic,assign) BOOL isRecord;//是否是录像文件

@end

@implementation DownloadListController
-(NSMutableArray*)showDataArray
{
    if (!_showDataArray) {
        _showDataArray = [NSMutableArray array];
    }
    return _showDataArray;
}
-(NSMutableArray*)originalData
{
    if (!_originalData) {
        _originalData = [NSMutableArray array];
    }
    return _originalData;
}
-(NSMutableArray*)lengthArray
{
    if (!_lengthArray) {
        _lengthArray = [NSMutableArray array];
    }
    return _lengthArray;
}
- (void)setupNoDataView
{
    self.noDataView = [self setupnoDataContentViewWithTitle:nil andImageNamed:@"empty_message_image" andTop:@"60"];
    self.noDataView.backgroundColor = kColorBackgroundColor;
    // label
    UILabel *tipLabel = [self getNoDataTipLabel];
    
    UIButton *againBtn = [UIButton new];
    [againBtn setTitle:@"暂无数据" forState:UIControlStateNormal];
    [againBtn setTitleColor:kColorMainTextColor forState:UIControlStateNormal];
    againBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [self.noDataView addSubview:againBtn];
    [againBtn xCenterToView:self.noDataView];
    [againBtn topToView:tipLabel withSpace:-8];
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
    [self dealWithOrigineData];
    [self setupTableView];
    
    
    //查看本地相册中的视频
//    [self getLocationInfo];
    
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
    
}

//右上角按钮点击
-(void)right_clicked
{
    [[TCNewAlertView shareInstance] showAlert:nil message:@"确认清空下载列表吗？" cancelTitle:@"取消" viewController:self confirm:^(NSInteger buttonTag) {
        if (buttonTag == 0) {
            [self.showDataArray removeAllObjects];
            [self.originalData removeAllObjects];
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
    
    //缓存信息,如果是已缓存的更新缓存，如果不是就新增
    [self.showDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[CLVoiceApplyAddressModel class]]) {
            NSDictionary *dic = [self.originalData objectAtIndex:idx];
            CLVoiceApplyAddressModel *model = [CLVoiceApplyAddressModel AddressModelWithDict:dic];
            [CLInvoiceApplyAddressModelTool updateInfoAtIndex:idx withInfo:model];
        }else{
            NSDictionary *dic = [self.originalData objectAtIndex:idx];
            CLVoiceApplyAddressModel *model = [CLVoiceApplyAddressModel AddressModelWithDict:dic];
            [CLInvoiceApplyAddressModelTool addInfo:model];
        }
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    id objt = [self.showDataArray objectAtIndex:indexPath.row];

    if ([objt isKindOfClass:[CarmeaVideosModel class]]) {
        [cell makeCellData:objt];
        NSDictionary *dic = [self.originalData objectAtIndex:indexPath.row];;
        cell.url = [dic objectForKey:@"url"];
        
    }else if ([objt isKindOfClass:[CLVoiceApplyAddressModel class]]){
        CLVoiceApplyAddressModel *models = objt;
        cell.url = models.url;
        [cell makeCellCacheData:models];
    }else{
        cell.url = self.url;
        [cell makeCellDemandData:objt];
    }
    NSMutableDictionary *temp = [self.originalData objectAtIndex:indexPath.row];
    cell.downlaodProgress = ^(NSString * _Nonnull value, NSString * _Nonnull writeBytes) {
        [temp setValue:value forKey:@"progress"];
        [temp setValue:writeBytes forKey:@"writeBytes"];
    };
    
    cell.localizedFilePath = ^(NSString * _Nonnull value) {
        [temp setValue:value forKey:@"file_path"];
    };
    
    [self.originalData replaceObjectAtIndex:indexPath.row withObject:temp];

    return cell;
}
#pragma mark ---- 侧滑删除
// 点击了“左滑出现的Delete按钮”会调用这个方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    //删除缓存
    id obj = [self.showDataArray objectAtIndex:indexPath.row];
     if ([obj isKindOfClass:[CLVoiceApplyAddressModel class]]) {
//         NSInteger idx = [self.showDataArray indexOfObject:obj];
         [CLInvoiceApplyAddressModelTool removeInfoAtIndex:indexPath.row - self.dataArray.count];
     }
    
    
    // 删除模型
    [self.originalData removeObjectAtIndex:indexPath.row];
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

- (void)startLoadDataRequest:(NSString*)start_time withInteger:(NSInteger)idx
{
    [_kHUDManager showActivityInView:nil withTitle:nil];
    
    NSString *urlString;
    if (_isRecord) {
        //如果是录像文件
        urlString = [NSString stringWithFormat:@"http://192.168.6.120:10102/outer/liveqing/record/download/%@/%@",self.downLoad_id,start_time];
    }else{
        urlString = [NSString stringWithFormat:@"http://192.168.6.120:10102/outer/liveqing/vod/download/%@",start_time];
    }

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //配置用户名 密码
    NSString *str1 = [NSString stringWithFormat:@"%@/%@:%@",_kUserModel.userInfo.tenant_name,_kUserModel.userInfo.user_name,_kUserModel.userInfo.password];
    //进行加密  [str base64EncodedString]使用开源Base64.h分类文件加密
    NSString *str2 = [NSString stringWithFormat:@"Basic %@",[WWPublicMethod encodeBase64:str1]];
    // 设置Authorization的方法设置header
    [manager.requestSerializer setValue:str2 forHTTPHeaderField:@"Authorization"];
    
    __unsafe_unretained typeof(self) weak_self = self;

    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        DLog(@"Received: %@", responseObject);
        DLog(@"Received HTTP %ld", (long)httpResponse.statusCode);
        NSMutableDictionary *temp = [self.originalData objectAtIndex:idx];
        NSString *downUrl = [responseObject objectForKey:@"url"];
         if (!weak_self.isRecord) {
             //点播文件
             self.url = downUrl;
             [temp setValue:downUrl forKey:@"url"];
         }else{
             //录像文件
             [temp setValue:downUrl forKey:@"url"];
         }
        [self.originalData replaceObjectAtIndex:idx withObject:temp];
  
        [self.tableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"error: %@", error);
        
    }];
        
}

//获取本地相册视频信息
-(void)getLocationInfo
{
    PHFetchOptions *options = [PHFetchOptions new];
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:options];
    NSMutableArray *sourceArray = [NSMutableArray arrayWithCapacity:result.count];
    for (PHAsset *assets in result) {
        NSArray *assetResources = [PHAssetResource assetResourcesForAsset:assets];
        PHAssetResource *assetRes = [assetResources firstObject];
        NSLog(@"originalFilename %@", assetRes.originalFilename);
        NSLog(@"uniformTypeIdentifier %@", assetRes.uniformTypeIdentifier);
        NSLog(@"assetLocalIdentifier %@", assetRes.assetLocalIdentifier);
        [sourceArray addObject:assetRes];
    }
    DLog(@"sourceArray == %@",sourceArray);

}

//处理原始数据
-(void)dealWithOrigineData
{
    if (self.dataArray.count == 0) {
        
        //读取缓存数据
        NSArray *temp = CLInvoiceApplyAddressModelTool.allAddressInfo;
        [self.showDataArray addObjectsFromArray:temp];
        NSArray *dataArr = [CLVoiceApplyAddressModel mj_keyValuesArrayWithObjectArray:temp];
        [self.originalData addObjectsFromArray:dataArr];
        DLog(@"self.originalData  ==  %@",self.originalData);
           
    }else{
        
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
                self.isRecord = YES;
                [self startLoadDataRequest:model.start_time withInteger:idx];
            }else{
                
                DemandModel *model = obj;
                
                [tempDic setValue:model.snapUrl forKey:@"snap"];//封面图片URL
                [tempDic setValue:model.createAt forKey:@"time"];//视频时间
                [tempDic setValue:model.time forKey:@"start_time"];//视频时间
                [tempDic setValue:model.video_name forKey:@"name"];//视频名称
                [tempDic setValue:model.duration forKey:@"duration"];//视频时长
                [tempDic setValue:model.hls forKey:@"hls"];//视频播放地址
                
                //点播文件下载
                self.isRecord = NO;
                [self startLoadDataRequest:model.video_id withInteger:idx];
            }
            [self.originalData addObject:tempDic];
        }];
        
        [self.showDataArray addObjectsFromArray:self.dataArray];

        
        //读取缓存数据
       
        NSArray *temp = CLInvoiceApplyAddressModelTool.allAddressInfo;
        if (temp.count == 0) {
            return ;
        }
        
        NSMutableArray *tempName = [NSMutableArray array];
        [temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CLVoiceApplyAddressModel *model = obj;
            [self.originalData enumerateObjectsUsingBlock:^(id  _Nonnull objs, NSUInteger idxs, BOOL * _Nonnull stops) {
                NSDictionary *dic = objs;
                if ([model.time isEqualToString:[dic objectForKey:@"time"]]) {
                    [tempName addObject:model.name];
                    [self.originalData removeObject:dic];
                    [self.showDataArray removeObjectAtIndex:idxs];
                }
            }];
        }];
        
        if (tempName.count > 0) {
            NSString *mes = [NSString stringWithFormat:@"任务“%@”已存在",[tempName componentsJoinedByString:@"，"]];
            [[TCNewAlertView shareInstance] showAlert:nil message:mes cancelTitle:nil viewController:self confirm:^(NSInteger buttonTag) {
                       
//                if (buttonTag == 0) {
//
//                }else{
//
//                }
                
            } buttonTitles:@"好的", nil];
        }
        
        [self.showDataArray addObjectsFromArray:temp];
        
        NSArray *dataArr = [CLVoiceApplyAddressModel mj_keyValuesArrayWithObjectArray:temp];
        [self.originalData addObjectsFromArray:dataArr];
        DLog(@"self.originalData  ==  %@",self.originalData);
    }
    
    [self changeNoDataViewHiddenStatus];
}
- (void)changeNoDataViewHiddenStatus
{
    NSInteger count = self.originalData.count;
    if (count == 0) {
        self.tableView.hidden = YES;
        self.noDataView.hidden = NO;
    } else {
        self.tableView.hidden = NO;
        self.noDataView.hidden = YES;
    }
    
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
