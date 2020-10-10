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
#import "SuperPlayerViewController.h"
#import "RequestSence.h"
#import "MyEquipmentsModel.h"
#import "IndexDataModel.h"


@interface LiveViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    BOOL _isHadFirst; // 是否第一次加载了
}
@property (nonatomic,strong) UIButton *chooseBtn;

@property (nonatomic, strong) WWCollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *dataModelArray;
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
- (NSMutableArray *)dataModelArray
{
    if (!_dataModelArray) {
        _dataModelArray = [NSMutableArray array];
    }
    return _dataModelArray;
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
    return self.dataModelArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LiveViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[LiveViewCollectionViewCell getCellIDStr] forIndexPath:indexPath];
    MyEquipmentsModel *model = [self.dataModelArray objectAtIndex:indexPath.row];
    [cell makeCellData:model];
    
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyEquipmentsModel *model = [self.dataModelArray objectAtIndex:indexPath.row];
    if (model.model.online) {
        //live直播
        SuperPlayerViewController *vc = [SuperPlayerViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        vc.allDataArray = [NSArray arrayWithObjects:model, nil];
        vc.isLiving = YES;
        vc.isDemandFile = NO;
        vc.title_value = model.model.name;
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
    
    NSString *url = [NSString stringWithFormat:@"inventory/managedObjects?type=camera_Root&fragmentType=camera_Device&pageSize=100&currentPage=%ld",(long)self.page];

    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/vnd.com.nsn.cumulocity.managedobjectcollection+json";
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
       
        DLog(@"Index ==  Received: %@", obj);
        [weak_self handleObject:obj];
    };
    sence.errorBlock = ^(NSError *error) {
        
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
    __unsafe_unretained typeof(self) weak_self = self;
    [_kHUDManager hideAfter:0.1 onHide:nil];
    [[GCDQueue globalQueue] queueBlock:^{
        NSArray *data = [obj objectForKey:@"managedObjects"];
        NSMutableArray *tempArray = [NSMutableArray array];

        if (weak_self.page == 1) {
            [weak_self.dataArray removeAllObjects];
            [self.dataModelArray removeAllObjects];
        }

        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            IndexDataModel *model = [IndexDataModel makeModelData:dic];
            [tempArray addObject:model];
            [weak_self getDeviceInfo:model.equipment_id withIndex:idx];
        }];
        [weak_self.dataArray addObjectsFromArray:tempArray];
        
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

//获取设备信息
-(void)getDeviceInfo:(NSString*)device_id withIndex:(NSInteger)index
{
    NSString *url = [NSString stringWithFormat:@"inventory/managedObjects/%@/childDevices?pageSize=100&currentPage=1",device_id];
//    NSString *url = [NSString stringWithFormat:@"inventory/managedObjects/%@/childDevices?pageSize=100&currentPage=1",device_id];

    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        DLog(@"Received: %@", obj);
         [weak_self handleDeviceInfoObject:obj withIndex:index];
    };
    sence.errorBlock = ^(NSError *error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"error: %@", error);
    };
    [sence sendRequest];
}
- (void)handleDeviceInfoObject:(id)obj withIndex:(NSInteger)index
{
    _isHadFirst = YES;
    __unsafe_unretained typeof(self) weak_self = self;
    [[GCDQueue globalQueue] queueBlock:^{
        NSArray *data = [obj objectForKey:@"references"];
        NSMutableArray *tempArray = [NSMutableArray array];

        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            MyEquipmentsModel *model = [MyEquipmentsModel makeModelData:dic];
            [weak_self getDeviceLivingData:model withIndex:index withEquimentIndex:idx];
            [tempArray addObject:model];
        }];

        IndexDataModel *model = [self.dataArray objectAtIndex:index];
        model.childDevices_info = [NSMutableArray arrayWithArray:tempArray];
        [self.dataArray replaceObjectAtIndex:index withObject:model];

        [[GCDQueue mainQueue] queueBlock:^{
            [weak_self.collectionView reloadData];
        }];
    }];
}
//获取直播数据
-(void)getDeviceLivingData:(MyEquipmentsModel*)meModel withIndex:(NSInteger)index withEquimentIndex:(NSInteger)equiIndex
{
    NSString *url = [NSString stringWithFormat:@"service/cameraManagement/camera/live/infos?systemSource=%@&id=%@",meModel.system_Source,meModel.equipment_id];
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"Received: %@", obj);
        [weak_self handleDeviceLivingObject:obj withModel:meModel withIndex:index withEquimentIndex:equiIndex];
    };
    sence.errorBlock = ^(NSError *error) {

        [_kHUDManager hideAfter:0.1 onHide:nil];
        // 请求失败
        DLog(@"error  ==  %@",error.userInfo);
    };
    [sence sendRequest];
}

- (void)handleDeviceLivingObject:(id)obj withModel:(MyEquipmentsModel*)meModel withIndex:(NSInteger)index withEquimentIndex:(NSInteger)equiIndex
{
    [_kHUDManager hideAfter:0.1 onHide:nil];
    __unsafe_unretained typeof(self) weak_self = self;
    [[GCDQueue globalQueue] queueBlock:^{

        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:obj];
        [dic setObject:meModel.createdAt forKey:@"createdAt"];
        [dic setObject:meModel.equipment_name forKey:@"name"];
        [dic setObject:meModel.equipment_id forKey:@"deviceId"];
        [dic setObject:meModel.system_Source forKey:@"system_Source"];
        [dic setObject:meModel.presets forKey:@"presets"];
        LivingModel *lvModel = [LivingModel makeModelData:dic];
        
        IndexDataModel *model = [self.dataArray objectAtIndex:index];
        MyEquipmentsModel *eModel = [model.childDevices_info objectAtIndex:equiIndex];
        eModel.model = lvModel;
        [model.childDevices_info replaceObjectAtIndex:equiIndex withObject:eModel];
        [self.dataArray replaceObjectAtIndex:index withObject:model];
        
        [[GCDQueue mainQueue] queueBlock:^{
            [self.dataModelArray removeAllObjects];
            [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                IndexDataModel *indexModel = obj;
                [self.dataModelArray addObjectsFromArray:indexModel.childDevices_info];
            }];
            [weak_self.collectionView reloadData];
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
