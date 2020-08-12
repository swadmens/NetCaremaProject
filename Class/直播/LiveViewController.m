//
//  LiveViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/2/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "LiveViewController.h"
#import "WWCollectionView.h"
#import "LiveViewCollectionViewCell.h"
#import "ChooseAreaView.h"
#import "LivingModel.h"
#import "HKVideoPlaybackController.h"
#import "SuperPlayerViewController.h"
#import "DemandModel.h"
#import "RequestSence.h"
#import "MyEquipmentsModel.h"


@interface LiveViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    BOOL _isHadFirst; // 是否第一次加载了
}
@property (nonatomic,strong) UIButton *chooseBtn;

@property (nonatomic, strong) WWCollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger page;
/// 没有内容
@property (nonatomic, strong) UIView *noDataView;
//token刷新次数
@property(nonatomic,assign) NSInteger refreshtoken;

@property (nonatomic,strong) ChooseAreaView *areaView;
@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,assign) BOOL isLiving;//是否直播中


@end

@implementation LiveViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
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
        
        CGFloat width = kScreenWidth/2-20;
        flowlayout.itemSize = CGSizeMake(width, width*0.6);
        
        _collectionView = [[WWCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        _collectionView.backgroundColor = kColorBackgroundColor;
        // 注册
        [_collectionView registerClass:[LiveViewCollectionViewCell class] forCellWithReuseIdentifier:[LiveViewCollectionViewCell getCellIDStr]];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.refreshEnable = YES;
        __unsafe_unretained typeof(self) weak_self = self;
        _collectionView.actionHandle = ^(WWCollectionViewState state){

            switch (state) {
                case WWCollectionViewStateRefreshing:
                {
                    [weak_self loadNewData];
                }
                    break;
                case WWCollectionViewStateLoadingMore:
                {
                    [weak_self loadMoreData];
                }
                    break;
                default:
                    break;
            }
        };
    }
    return _collectionView;
}
- (void)setupNoDataView
{
    self.noDataView = [self setupnoDataContentViewWithTitle:@"暂无直播" andImageNamed:@"device_empty_backimage" andTop:@"60"];
}
-(void)againLoadDataBtn
{
    [self loadNewData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"直播";
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationItem.leftBarButtonItem=nil;
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;

    
    [self.view addSubview:self.collectionView];
    [self.collectionView alignTop:@"45" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    
    
    _areaView = [ChooseAreaView new];
    _areaView.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, 350);
    [[UIApplication sharedApplication].keyWindow addSubview:_areaView];
    __weak __typeof(self)weakSelf = self;
    _areaView.chooseArea = ^(NSString * _Nonnull area_id) {
        DLog(@"选择的是  ==   %@",area_id);
        [weakSelf chooseAreaClick];
    };
    
    _coverView = [UIView new];
    _coverView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight-450);
    _coverView.backgroundColor = UIColorFromRGB(0x000000, 0.7);
    [[UIApplication sharedApplication].keyWindow addSubview:_coverView];

    [self creadLivingUI];
    [self setupNoDataView];
    [self loadNewData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if (self.dataArray.count == 0) {
//        [self loadNewData];
//    }
}
//创建UI
-(void)creadLivingUI
{
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:self.view];
    [topView addHeight:35];
    
    
    _chooseBtn = [UIButton new];
    [_chooseBtn setTitle:@"选择区域" forState:UIControlStateNormal];
    [_chooseBtn setTitleColor:kColorMainTextColor forState:UIControlStateNormal];
    [_chooseBtn setTitleColor:kColorMainColor forState:UIControlStateSelected];
    [_chooseBtn setImage:UIImageWithFileName(@"choose_area_down_image") forState:UIControlStateNormal];
    [_chooseBtn setImage:UIImageWithFileName(@"choose_area_up_image") forState:UIControlStateSelected];
    _chooseBtn.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
//    下面是设置图片跟文字的间距：
    CGFloat margin = (60 - CGRectGetWidth(_chooseBtn.imageView.frame) - CGRectGetWidth(_chooseBtn.titleLabel.frame)) *0.5;
    CGFloat marginGay = 22;
    _chooseBtn.imageEdgeInsets = UIEdgeInsetsMake(0, marginGay, 0, margin - marginGay);
    _chooseBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    [topView addSubview:_chooseBtn];
    [_chooseBtn centerToView:topView];
    [_chooseBtn addTarget:self action:@selector(chooseAreaClick) forControlEvents:UIControlEventTouchUpInside];
    
}
//选择区域
-(void)chooseAreaClick
{
    _chooseBtn.selected = !_chooseBtn.selected;
    __weak __typeof(self)weakself = self;
    
    if (_chooseBtn.selected) {
       
        [UIView animateWithDuration:0.35 animations:^{
            weakself.areaView.transform = CGAffineTransformMakeTranslation(0, kScreenHeight+100);
            weakself.coverView.transform = CGAffineTransformMakeTranslation(0, -kScreenHeight+450);
        }];
    }else{
        [UIView animateWithDuration:0.35 animations:^{
            weakself.areaView.transform = CGAffineTransformIdentity;
            weakself.coverView.transform = CGAffineTransformIdentity;
        }];
    }
    
}

#pragma mark -- collectionDelegate
//定义展示的Section的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LiveViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[LiveViewCollectionViewCell getCellIDStr] forIndexPath:indexPath];
    LivingModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell makeCellData:model];
    
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LivingModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if ([WWPublicMethod isStringEmptyText:model.RTMP]) {
        //live直播
        SuperPlayerViewController *vc = [SuperPlayerViewController new];
        vc.hidesBottomBarWhenPushed = YES;
//        vc.allDataArray = [NSArray arrayWithArray:self.dataArray];
        vc.allDataArray = [NSArray arrayWithObjects:model, nil];
        vc.isLiving = YES;
        vc.title_value = model.ChannelName;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else{
        [_kHUDManager showMsgInView:nil withTitle:@"当前设备已离线" isSuccess:YES];
        return;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}
- (void)loadNewData
{
    self.page = 1;
    [self startLoadDataRequest];
}
- (void)loadMoreData
{
    [self startLoadDataRequest];
}
- (void)startLoadDataRequest
{
    [_kHUDManager showActivityInView:nil withTitle:nil];
        
    NSString *start = [NSString stringWithFormat:@"%ld",(self.page - 1)*10];
       
    NSDictionary *finalParams = @{
                                 @"start":start,
                                 @"limit":@"10",
                                 };
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:finalParams
                                                      options:0
                                                        error:nil];
    
    NSString *url = [NSString stringWithFormat:@"inventory/managedObjects?pageSize=100&fragmentType=quark_GBSCameraDevice&currentPage=%ld",(long)self.page];
//    service/video/liveqing/live/list
    
    
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
//    sence.body = jsonData;
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        DLog(@"Received: %@", obj);
        [weak_self handleObject:obj];
    };
    sence.errorBlock = ^(NSError *error) {
        // 请求失败
        DLog(@"error  ==  %@",error.userInfo);
        [weak_self failedOperation];
    };
    [sence sendRequest];
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
//    [_kHUDManager hideAfter:0.1 onHide:nil];
    __unsafe_unretained typeof(self) weak_self = self;
    [[GCDQueue globalQueue] queueBlock:^{
//        NSArray *data = [obj objectForKey:@"references"];
//        NSDictionary *data = [obj objectForKey:@"data"];
//        NSArray *rows= [data objectForKey:@"rows"];
//        NSMutableArray *tempArray = [NSMutableArray array];
//
//        [rows enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSDictionary *dic = obj;
//            LivingModel *model = [LivingModel makeModelData:dic];
//            //只展示正在直播的设备
//            if ([WWPublicMethod isStringEmptyText:model.RTMP]) {
//                [tempArray addObject:model];
//            }
//        }];
//        [weak_self.dataArray addObjectsFromArray:tempArray];
//
//        //获取直播封面
//        [weak_self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            LivingModel *model = obj;
//            if (![WWPublicMethod isStringEmptyText:model.SnapURL]) {
//                [weak_self getLivingCoverPhoto:model.DeviceID withIndex:idx];
//            }
//        }];
        
        NSArray *data = [obj objectForKey:@"managedObjects"];
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:data.count];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            NSDictionary *quark_GBSCameraDevice = [dic objectForKey:@"quark_GBSCameraDevice"];
            NSString *deviceID = [quark_GBSCameraDevice objectForKey:@"id"];
//            MyEquipmentsModel *model = [MyEquipmentsModel makeModelData:dic];
            [weak_self getLivingData:deviceID];
        }];
        

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
        self.noDataView.hidden = NO;
    } else {
        self.collectionView.hidden = NO;
        self.noDataView.hidden = YES;
    }
    
}

//获取直播快照
-(void)getLivingCoverPhoto:(NSString*)live_id withIndex:(NSInteger)indexPath
{
    NSString *url = [NSString stringWithFormat:@"service/video/liveqing/snap/current?id=%@",live_id];
    
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"Received: %@", obj);

         [weak_self dealWithCoverPhoto:obj withIndex:indexPath];
    };

    sence.errorBlock = ^(NSError *error) {

        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"error: %@", error);
    };
    [sence sendRequest];
}

-(void)dealWithCoverPhoto:(id)obj withIndex:(NSInteger)indexPath
{
    if (obj == nil) {
        return;
    }
    
//    NSDictionary *data = [obj objectForKey:@"data"];
//    LivingModel *model = [self.dataArray objectAtIndex:indexPath];
//    model.SnapURL = [NSString stringWithFormat:@"%@",[data objectForKey:model.DeviceID]];
//    [self.dataArray replaceObjectAtIndex:indexPath withObject:model];
//    [self.collectionView reloadData];
}

//获取直播数据
-(void)getLivingData:(NSString*)serial
{
     NSString *url = [NSString stringWithFormat:@"service/video/livegbs/api/v1/stream/list?serial=%@",serial];
    //    service/video/liveqing/live/list
        
        
        RequestSence *sence = [[RequestSence alloc] init];
        sence.requestMethod = @"GET";
        sence.pathHeader = @"application/json";
    //    sence.body = jsonData;
        sence.pathURL = url;
        __unsafe_unretained typeof(self) weak_self = self;
        sence.successBlock = ^(id obj) {
            DLog(@"Received: %@", obj);
            [weak_self handleLivingObject:obj];
        };
        sence.errorBlock = ^(NSError *error) {

            [_kHUDManager hideAfter:0.1 onHide:nil];
            // 请求失败
            DLog(@"error  ==  %@",error.userInfo);
//            [weak_self failedOperation];
        };
        [sence sendRequest];
}
-(void)handleLivingObject:(id)obj
{
    [_kHUDManager hideAfter:0.1 onHide:nil];
    __unsafe_unretained typeof(self) weak_self = self;
    [[GCDQueue globalQueue] queueBlock:^{
        
//        if (weak_self.page == 1) {
//            [weak_self.dataArray removeAllObjects];
//        }
        
        NSArray *data= [obj objectForKey:@"Streams"];
        NSMutableArray *tempArray = [NSMutableArray array];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            LivingModel *model = [LivingModel makeModelData:dic];
            [tempArray addObject:model];
        }];
        [self.dataArray addObjectsFromArray:tempArray];

        [[GCDQueue mainQueue] queueBlock:^{
            [weak_self.collectionView reloadData];
            [weak_self changeNoDataViewHiddenStatus];
        }];

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
