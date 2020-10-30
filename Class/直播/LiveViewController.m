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
#import "AreaInfoModel.h"


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

@property (strong, nonatomic) NSMutableArray *dataAreaArray;

@property (nonatomic,strong) NSString *nameEn;//分类别名
@property (nonatomic,strong) NSString *shortName;//位置别名
@property (nonatomic,assign) BOOL selectArea;//是否选择了区域


@end

@implementation LiveViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)dataAreaArray
{
    if (!_dataAreaArray) {
        
        NSDictionary *dic = @{
            @"shortNames": @[@"全部"],
            @"areaType": @"全部"
        };
        AreaInfoModel *model = [AreaInfoModel makeModelData:dic];
        _dataAreaArray = [NSMutableArray arrayWithObject:model];
    }
    return _dataAreaArray;
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
    
    [self setupNoDataView];
    [self loadNewData];
    
    self.selectArea = NO;
    
    _areaView = [[ChooseAreaView alloc]initWithFrame:CGRectMake(0, 35, kScreenWidth, 350)];
    [self.view addSubview:_areaView];
    __weak __typeof(self)weakSelf = self;
    _areaView.chooseArea = ^(NSString * _Nonnull area_id) {
        DLog(@"选择的是  ==   %@",area_id);
        NSDictionary *areaDic = [WWPublicMethod objectTransFromJson:area_id];
        weakSelf.nameEn = [areaDic objectForKey:@"first"];
        weakSelf.shortName = [areaDic objectForKey:@"three"];
        [weakSelf qureyScreeningData];
    };
    self.areaView.transform = CGAffineTransformMakeTranslation(0, -450);

    
    _coverView = [UIView new];
    _coverView.userInteractionEnabled = YES;
    _coverView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight-448);
    _coverView.backgroundColor = UIColorFromRGB(0x000000, 0.7);
    [[UIApplication sharedApplication].keyWindow addSubview:_coverView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverViewClick:)];
    [_coverView addGestureRecognizer:tap];
    
    
    [self creadLivingUI];

    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
//创建顶部按钮
-(void)creadLivingUI
{
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:self.view];
    [topView addHeight:35];
    [topView addBottomLineByColor:kColorLineColor];
    
    
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
        
        [self getAreaLocationInfo];//获取筛选数据
               
        [UIView animateWithDuration:0.35 animations:^{
            weakself.areaView.transform = CGAffineTransformIdentity;
        }];

        [UIView animateWithDuration:0.1 animations:^{
            weakself.coverView.transform = CGAffineTransformMakeTranslation(0, -kScreenHeight+448);
        }];

    }else{
        [UIView animateWithDuration:0.35 animations:^{
            weakself.coverView.transform = CGAffineTransformIdentity;
            weakself.areaView.transform = CGAffineTransformMakeTranslation(0, -450);
        }];
    }
}
//确定筛选数据
-(void)qureyScreeningData
{
    [self chooseAreaClick];
    
    //点击了确定，开始筛选
    NSString *btnTitle;
    if ([self.shortName isEqualToString:@"全部"] || ![WWPublicMethod isStringEmptyText:self.shortName]) {
        self.selectArea = NO;
        btnTitle = @"选择区域";
    }else{
        self.selectArea = YES;
        btnTitle = [NSString stringWithFormat:@"%@/%@",self.nameEn,self.shortName];
    }
    [[GCDQueue mainQueue] queueBlock:^{
        [self.chooseBtn setTitle:btnTitle forState:UIControlStateNormal];
        [self loadNewData];
    }];
}
-(void)coverViewClick:(UITapGestureRecognizer*)tp
{
    [self chooseAreaClick];
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
    MyEquipmentsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell makeCellData:model];
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyEquipmentsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (model.online) {
        
//        [self.dataArray removeObjectAtIndex:indexPath.row];
//        [self.dataArray insertObject:model atIndex:0];
        
        //live直播
        SuperPlayerViewController *vc = [SuperPlayerViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [vc makeViewLiveData:[NSArray arrayWithObjects:model, nil] withTitle:model.model.name];
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
    
    NSString *url;
    if (self.selectArea) {
        url = [NSString stringWithFormat:@"inventory/managedObjects?query=$filter=type+eq+camera+and+has(camera_Device)+and+areaInfo.nameEn+eq+%@+and+areaInfo.shortName+eq+%@&pageSize=10&currentPage=%ld",self.nameEn,self.shortName,(long)self.page];
    }else{
        url = [NSString stringWithFormat:@"inventory/managedObjects?query=$filter=type+eq+camera+and+has(camera_Device)&pageSize=10&currentPage=%ld",(long)self.page];
    }
    
    NSString *newUrlString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//链接含有中文转码

    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
//    sence.pathHeader = @"application/vnd.com.nsn.cumulocity.managedobjectcollection+json";
    sence.pathHeader = @"application/json";
    sence.pathURL = newUrlString;
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
        }

        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;

            MyEquipmentsModel *model = [MyEquipmentsModel makeModelData:dic];
//            if (model.online) {
                [tempArray addObject:model];
                [weak_self getDeviceLivingData:model withEquimentIndex:tempArray.count-1];
//            }
            
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

//获取直播数据
-(void)getDeviceLivingData:(MyEquipmentsModel*)meModel withEquimentIndex:(NSInteger)index
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
        [weak_self handleDeviceLivingObject:obj withModel:meModel withEquimentIndex:index];
    };
    sence.errorBlock = ^(NSError *error) {

        [_kHUDManager hideAfter:0.1 onHide:nil];
        // 请求失败
        DLog(@"error  ==  %@",error.userInfo);
    };
    [sence sendRequest];
}

- (void)handleDeviceLivingObject:(id)obj withModel:(MyEquipmentsModel*)meModel withEquimentIndex:(NSInteger)index
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
        
        MyEquipmentsModel *eModel = [self.dataArray objectAtIndex:index];
        eModel.model = lvModel;
        [self.dataArray replaceObjectAtIndex:index withObject:eModel];
        
        [[GCDQueue mainQueue] queueBlock:^{
            [weak_self.collectionView reloadData];
        }];

    }];
}

//获取区域信息
-(void)getAreaLocationInfo
{
    NSString *url = @"inventory/managedObjects?type=UserLocationIndex";
    
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"Received: %@", obj);
        NSArray *managedObjects = [obj objectForKey:@"managedObjects"];
        NSDictionary *data = managedObjects.firstObject;
        NSArray *areas = [data objectForKey:@"areas"];
        NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:data.count+1];
        
        NSDictionary *dic = @{
            @"shortNames": @[@"全部"],
            @"areaType": @"全部"
        };
        AreaInfoModel *model = [AreaInfoModel makeModelData:dic];
        [tempArr addObject:model];
        
        [areas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            AreaInfoModel *model = [AreaInfoModel makeModelData:dic];
            [tempArr addObject:model];
        }];
//        [weak_self.dataAreaArray addObjectsFromArray:tempArr];
        
        [[GCDQueue mainQueue] queueBlock:^{
            [weak_self.areaView makeViewData:tempArr];
        }];
        
    };
    sence.errorBlock = ^(NSError *error) {

        [_kHUDManager hideAfter:0.1 onHide:nil];
        // 请求失败
        DLog(@"error  ==  %@",error.userInfo);
    };
    [sence sendRequest];
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
