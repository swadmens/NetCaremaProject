//
//  CarmeaVideosViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/2.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "CarmeaVideosViewController.h"
#import "WWCollectionView.h"
#import "CarmeaVideosViewCell.h"
#import "AFHTTPSessionManager.h"
#import "CarmeaVideosModel.h"
#import "HKVideoPlaybackController.h"
#import "DemandModel.h"
#import "LGXVerticalButton.h"
#import "DownloadListController.h"
#import <UIImageView+YYWebImage.h>

@interface CarmeaVideosViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    BOOL _isHadFirst; // 是否第一次加载了
}
@property (nonatomic, strong) WWCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger page;
//token刷新次数
@property(nonatomic,assign) NSInteger refreshtoken;

@property (nonatomic,strong) NSMutableDictionary *dicData;

@property (nonatomic, strong) NSMutableIndexSet* selectedIndexSet;

@property (nonatomic,strong) UIView *editView;

@property (nonatomic,strong) NSString *device_id;//具体设备id


@end

@implementation CarmeaVideosViewController

-(NSMutableDictionary*)dicData
{
    if (!_dicData) {
        _dicData = [NSMutableDictionary new];
    }
    return _dicData;
}
-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
#pragma mark - 延迟加载
- (WWCollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向
        flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //左右间距
        flowlayout.minimumInteritemSpacing = 10;
        //上下间距
        flowlayout.minimumLineSpacing = 10;
        
        _collectionView = [[WWCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        _collectionView.backgroundColor = kColorBackgroundColor;
        // 注册
        [_collectionView registerClass:[CarmeaVideosViewCell class] forCellWithReuseIdentifier:[CarmeaVideosViewCell getCellIDStr]];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.refreshEnable = YES;
        __unsafe_unretained typeof(self) weak_self = self;
        _collectionView.actionHandle = ^(WWCollectionViewState state){

            switch (state) {
                case WWCollectionViewStateRefreshing:
                {
                    [weak_self loadNewData];
                }
                    break;
//                case WWCollectionViewStateLoadingMore:
//                {
//                    [weak_self loadMoreData];
//                }
//                    break;
                default:
                    break;
            }
        };
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorBackgroundColor;
    [self creadUI];

    [self.view addSubview:self.collectionView];
    [self.collectionView alignTop:@"40" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];

    self.selectedIndexSet = [NSMutableIndexSet new];
    
    
    self.editView = [UIView new];
    [self.editView addTopLineByColor:kColorLineColor];
    self.editView.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.editView];
    self.editView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 48);
    
    LGXVerticalButton *deleteBtn = [LGXVerticalButton new];
    [deleteBtn setImage:UIImageWithFileName(@"video_delete_image") forState:UIControlStateNormal];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:kColorMainTextColor forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEleven];
    [self.editView addSubview:deleteBtn];
    [deleteBtn alignTop:@"0" leading:@"0" bottom:@"0" trailing:nil toView:self.editView];
    [deleteBtn addWidth:kScreenWidth/2];
    [deleteBtn addTarget:self action:@selector(deleteVideoClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    LGXVerticalButton *downBtn = [LGXVerticalButton new];
    [downBtn setBGColor:kColorMainColor forState:UIControlStateNormal];
    [downBtn setImage:UIImageWithFileName(@"demand_download_image") forState:UIControlStateNormal];
    [downBtn setTitle:@"下载" forState:UIControlStateNormal];
    [downBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    downBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEleven];
    [self.editView addSubview:downBtn];
    [downBtn alignTop:@"0" leading:nil bottom:@"0" trailing:@"0" toView:self.editView];
    [downBtn addWidth:kScreenWidth/2];
    [downBtn addTarget:self action:@selector(downVideoClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takeGoHomeNotica:) name:@"editStates" object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSDictionary *data = [NSDictionary dictionaryWithDictionary:[WWPublicMethod objectTransFromJson:self.equiment_id]];
    [self.dicData addEntriesFromDictionary:data];
    
    NSString *ClientId = [self.dicData objectForKey:@"ClientId"];
    NSString *DeviceId = [self.dicData objectForKey:@"DeviceId"];
    NSString *CameraId = [self.dicData objectForKey:@"CameraId"];
    
    ClientId = [WWPublicMethod isStringEmptyText:ClientId]?ClientId:@"";
    DeviceId = [WWPublicMethod isStringEmptyText:DeviceId]?DeviceId:@"";
    CameraId = [WWPublicMethod isStringEmptyText:CameraId]?CameraId:@"";

    self.device_id = [NSString stringWithFormat:@"%@%@%@",ClientId,DeviceId,CameraId];
    
    [self loadNewData];
}
- (void)takeGoHomeNotica:(NSNotification *)notification
{
    self.isEdit = [[NSString stringWithFormat:@"%@",notification.userInfo[@"edit"]] boolValue];

    if (!self.isEdit) {
        [self exitTheEditStates];
    }else{
        [self enterTheEditStates];
    }

    [_collectionView reloadData];
}
//创建UI
-(void)creadUI
{
    UILabel *topLeftLabel = [UILabel new];
    topLeftLabel.backgroundColor = kColorMainColor;
    [self.view addSubview:topLeftLabel];
    [topLeftLabel leftToView:self.view withSpace:15];
    [topLeftLabel topToView:self.view withSpace:18];
    [topLeftLabel addWidth:1.5];
    [topLeftLabel addHeight:10.5];
  
  
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"所有录像";
    titleLabel.textColor = kColorSecondTextColor;
    titleLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [titleLabel sizeToFit];
    [self.view addSubview:titleLabel];
    [titleLabel yCenterToView:topLeftLabel];
    [titleLabel leftToView:topLeftLabel withSpace:6];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CarmeaVideosViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CarmeaVideosViewCell getCellIDStr] forIndexPath:indexPath];

    CarmeaVideosModel *model=[self.dataArray objectAtIndex:indexPath.row];
    [cell makeCellData:model];

    cell.isEdit = self.isEdit;

    
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}
//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = kScreenWidth/2-21;
    return CGSizeMake(width, width*0.85);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CarmeaVideosModel *model=[self.dataArray objectAtIndex:indexPath.row];

    if (self.isEdit) {
        [self.selectedIndexSet addIndex:indexPath.item];
    }else{       
        NSDictionary *dic = @{@"name":model.video_name,
                              @"snapUrl":model.snap,
                              @"videoUrl":model.hls,
                              @"createAt":model.time,
                             };
       
        DemandModel *models = [DemandModel makeModelData:dic];
        HKVideoPlaybackController *vc = [HKVideoPlaybackController new];
        vc.model = models;
        vc.allDataArray = [NSMutableArray arrayWithArray:self.dataArray];
        vc.indexInteger = indexPath.row;
        vc.isRecordFile = YES;
        vc.isLiving = NO;
        vc.carmeaModel = model;
        vc.device_id = self.device_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedIndexSet removeIndex:indexPath.item];
}
//获取数据
- (void)loadNewData
{
    self.page = 1;
    [self loadData];
}
- (void)loadMoreData
{
    [self loadData];
}
-(void)loadData
{
    [self startLoadDataRequest];
}
- (void)startLoadDataRequest
{
    [_kHUDManager showActivityInView:nil withTitle:nil];
    
    NSString *start = [NSString stringWithFormat:@"%ld",(self.page - 1)*10];

    NSDictionary *finalParams = @{
                                  @"id":self.device_id,
                                  @"day":@"all",
                                  @"start":start,
                                  @"limit":@"10",
                                  };
        
    //提交数据
    NSString *url = @"http://ncore.iot/service/video/liveqing/record/query_records";
    
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
            
            self.refreshtoken++;
            if (self.refreshtoken > 1) {
                return ;
            }
            NSString *unauthorized = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            int statusCode = [[responseObject objectForKey:@"code"] intValue];
            if ([unauthorized containsString:@"500"] && statusCode == 401) {
                [WWPublicMethod refreshToken:^(id obj) {
                    [self loadNewData];
                }];
            }
            return ;
        }
        DLog(@"responseObject  ==  %@",responseObject);
        [weak_self handleObject:responseObject];
    }];
    [task resume];
}
- (void)failedOperation
{
    _isHadFirst = YES;
    [_kHUDManager hideAfter:0.1 onHide:nil];
    [_kHUDManager showMsgInView:nil withTitle:@"请求失败" isSuccess:NO];
    self.collectionView.loadingMoreEnable = NO;
    [self.collectionView stopLoading];
    [self changeNoDataViewHiddenStatus];
}
- (void)handleObject:(id)obj
{
    _isHadFirst = YES;
    [_kHUDManager hideAfter:0.1 onHide:nil];
    __unsafe_unretained typeof(self) weak_self = self;
    [[GCDQueue globalQueue] queueBlock:^{
        NSDictionary *data = [obj objectForKey:@"data"];
        NSArray *months = [data objectForKey:@"months"];
        
        NSMutableArray *tempArray = [NSMutableArray array];

        [months enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *keys = obj;
            NSDictionary *mothsDic = [data objectForKey:keys];
            NSArray *days = [mothsDic objectForKey:@"days"];
            NSMutableArray *daysMutArray = [NSMutableArray new];
            [days enumerateObjectsUsingBlock:^(id  _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                NSString *dayKeys = obj2;
                NSArray *allData = [mothsDic objectForKey:dayKeys];
                [daysMutArray addObjectsFromArray:allData];
            }];
            
            [tempArray addObjectsFromArray:daysMutArray];
        }];
        
        if (weak_self.page == 1) {
            [weak_self.dataArray removeAllObjects];
        }
        NSMutableArray *modelArray = [NSMutableArray new];
        
        
        [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            
            NSString *originalSnap = [dic objectForKey:@"snap"];
            NSString *start_time = [dic objectForKey:@"start_time"];

            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            NSString *startTime = [mutDic objectForKey:@"start_time"];
            NSString *snap = [NSString stringWithFormat:@"http://ncore.iot/service/video/liveqing/record/getsnap?id=%@&period=%@",self.device_id,startTime];
            if (![WWPublicMethod isStringEmptyText:originalSnap]) {
                [mutDic setValue:snap forKey:@"snap"];
                [self getRecordCoverPhoto:start_time withData:idx];
            }
            CarmeaVideosModel *model = [CarmeaVideosModel makeModelData:mutDic];
            [modelArray addObject:model];
        }];
        [weak_self.dataArray addObjectsFromArray:modelArray];

        [[GCDQueue mainQueue] queueBlock:^{

            [weak_self.collectionView reloadData];
            if (tempArray.count >0) {
                weak_self.page++;
                weak_self.collectionView.loadingMoreEnable = YES;
            } else {
                weak_self.collectionView.loadingMoreEnable = NO;
            }
            [weak_self.collectionView stopLoading];
            [weak_self changeNoDataViewHiddenStatus];
        }];
    }];
}
- (void)changeNoDataViewHiddenStatus
{
    if (_isHadFirst == NO) {
        return ;
    }
    
    NSInteger count = self.dataArray.count;
    if (count == 0) {
        self.collectionView.hidden = YES;
//        self.noDataView.hidden = NO;
    } else {
        self.collectionView.hidden = NO;
//        self.noDataView.hidden = YES;
    }
    
}

//进入编辑状态
-(void)enterTheEditStates
{
    self.isEdit = YES;
    [_collectionView reloadData];

    if (self.editChangeState) {
           self.editChangeState(YES);
       }
    
    if (self.editView == nil) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.editView.transform = CGAffineTransformMakeTranslation(0, -48);
    }];
    
   
    
}
//退出编辑状态
-(void)exitTheEditStates
{
    self.isEdit = NO;
    [self.selectedIndexSet removeAllIndexes];
    [_collectionView reloadData];
    
    if (self.editChangeState) {
        self.editChangeState(NO);
    }

    if (self.editView == nil) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.editView.transform = CGAffineTransformIdentity;
    }];
    
   
}
//删除视频
-(void)deleteVideoClick
{
    [[TCNewAlertView shareInstance] showAlert:nil message:@"确认删除选择的视频吗？" cancelTitle:@"取消" viewController:self confirm:^(NSInteger buttonTag) {
        if (buttonTag == 0 ) {
            [self.selectedIndexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                CarmeaVideosModel *model = [self.dataArray objectAtIndex:idx];
                [self deleteNumbersVideo:model.start_time withInteger:idx];
            }];
        }
    } buttonTitles:@"确定", nil];
}
-(void)deleteNumbersVideo:(NSString*)startime withInteger:(NSInteger)integer
{
    NSDictionary *finalParams = @{
                                      @"id":self.device_id,
                                      @"period": startime,
                                      };
    //提交数据
    NSString *url = @"http://ncore.iot/service/video/liveqing/record/remove";
        
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
//        [self exitTheEditStates];
//        NSIndexPath *path = [NSIndexPath indexPathForItem:integer inSection:0];
//        [self.collectionView deleteItemsAtIndexPaths:@[path]];
        
        [self.dataArray removeObjectAtIndex:integer];
        [self.selectedIndexSet removeIndex:integer];
        [self.collectionView reloadData];
        
    }];
    [task resume];
}




//下载视频
-(void)downVideoClick
{
    NSMutableArray *tempArray = [NSMutableArray new];
    [self.selectedIndexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        CarmeaVideosModel *model = [self.dataArray objectAtIndex:idx];
//        [tempArray addObject:model.start_time];
        [tempArray addObject:model];
    }];
    
    DownloadListController *dvc = [DownloadListController new];
    dvc.dataArray = tempArray;
    dvc.downLoad_id = self.device_id;
    dvc.isRecord = YES;
    [self.navigationController pushViewController:dvc animated:YES];
    
    [self exitTheEditStates];

}

//获取录像封面快照
-(void)getRecordCoverPhoto:(NSString*)period withData:(NSInteger)indexInteger
{
    NSString *url = [NSString stringWithFormat:@"http://ncore.iot/service/video/liveqing/record/getsnap?forUrl=true&id=%@&&period=%@",self.device_id,period];
    
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
    CarmeaVideosModel *model = [self.dataArray objectAtIndex:indexInteger];
    model.snap = [NSString stringWithFormat:@"%@",[obj objectForKey:@"url"]];
    [self.dataArray replaceObjectAtIndex:indexInteger withObject:model];
    [self.collectionView reloadData];
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
