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

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>


static NSString *const _kdownloadListKey = @"download_video_list";

@interface DownloadListController ()<UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate>
{
    BOOL _isHadFirst; // 是否第一次加载了
}
@property (nonatomic, strong) WWTableView *tableView;

@property (nonatomic,strong) NSMutableArray *lengthArray;

@property(nonatomic,strong)NSURLSessionDownloadTask*downloadTask;

///视频播放和下载用的url
@property (nonatomic,strong) NSString *url;


@property (nonatomic,strong) NSMutableArray *originalData;

@property (nonatomic,assign) BOOL isRecord;//是否是录像文件

@end

@implementation DownloadListController
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
            [tempDic setValue:model.start_time forKey:@"start_time"];//视频时间
            //录像文件下载
            self.isRecord = YES;
            [self startLoadDataRequest:model.start_time withInteger:idx];
        }else{
            
            DemandModel *model = obj;
            
            [tempDic setValue:model.snapUrl forKey:@"snap"];//封面图片URL
            [tempDic setValue:model.time forKey:@"time"];//视频时间
            [tempDic setValue:model.start_time forKey:@"start_time"];//视频时间
            [tempDic setValue:model.video_name forKey:@"name"];//视频名称
            [tempDic setValue:model.duration forKey:@"duration"];//视频时长
            [tempDic setValue:model.hls forKey:@"hls"];//视频播放地址
            [tempDic setValue:model.start_time forKey:@"start_time"];//视频时间
            
            //点播文件下载
            self.isRecord = NO;
            [self startLoadDataRequest:model.video_id withInteger:0];
        }
        [self.originalData addObject:tempDic];
    }];
    

    [self setupTableView];
    
    
    //查看本地相册中的视频
//    [self getLocationInfo];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DownloadListCell *cell = [tableView dequeueReusableCellWithIdentifier:[DownloadListCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    id objt = [self.dataArray objectAtIndex:indexPath.row];
    if ([objt isKindOfClass:[CarmeaVideosModel class]]) {
        [cell makeCellData:objt];
        NSDictionary *dic = [self.originalData objectAtIndex:indexPath.row];;
        cell.url = [dic objectForKey:@"url"];
        
    }else{
        cell.url = self.url;
        [cell makeCellDemandData:objt];
    }
      
    return cell;
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
        NSString *downUrl = [responseObject objectForKey:@"url"];
         if (!weak_self.isRecord) {
             //点播文件
             self.url = downUrl;
         }else{
             NSMutableDictionary *temp = [self.originalData objectAtIndex:idx];
             [temp setValue:downUrl forKey:@"url"];
         }
  
        [self.tableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"error: %@", error);
        
    }];
        
}


//保存数据
- (void)save
{
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:NO error:nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:data forKey:_kUserInfoModelKey];
    [user synchronize];
    
}

//读取数据
- (void)read
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSData *data = [user objectForKey:_kUserInfoModelKey];
//    UserInfoModel *uInfo = [NSKeyedUnarchiver unarchivedObjectOfClass:self fromData:data error:nil];
    
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
