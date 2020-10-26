//
//  DemandViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/2/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "DemandViewController.h"
#import "WWCollectionView.h"
#import "DemandTitleCollectionCell.h"
#import "DemandViewCell.h"
#import "AFHTTPSessionManager.h"
#import "DemandModel.h"
#import "SuperPlayerViewController.h"
#import "RequestSence.h"
#import "CarmeaVideosModel.h"
#import "VideoUpLoadViewController.h"

@interface DemandViewController ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,VideoUpLoadSuccessDelegate,SuperPlayerDelegate>
{
    BOOL _isHadFirst; // 是否第一次加载了
}

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UISearchBar *searchButton;
@property(nonatomic,assign) NSInteger page;

/// 没有内容
@property (nonatomic, strong) UIView *noDataView;

//token刷新次数
@property(nonatomic,assign) NSInteger refreshtoken;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *searchDataSource;/**<搜索结果数据源*/
@property (nonatomic,strong) NSString *searchValue;
@property (nonatomic,assign) BOOL isClickSearch;//是否点击了搜索


@property (nonatomic, strong) WWCollectionView *collectionUpView;
@property(nonatomic,strong) NSMutableArray *titleDataArray;
@property (nonatomic, strong) NSMutableDictionary *cellDic;

@property (nonatomic, strong) WWCollectionView *collectionView;

@property (nonatomic,strong) NSString *folder;//子目录
@property (nonatomic,assign) BOOL isClick;//是否点击过
@property (nonatomic,assign) NSIndexPath *selectPath;

@end

@implementation DemandViewController
- (UISearchBar *)searchButton
{
    if (!_searchButton) {
        _searchButton = [UISearchBar new];
    }
    return _searchButton;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray*)searchDataSource
{
    if (!_searchDataSource) {
        _searchDataSource = [NSMutableArray array];
    }
    return _searchDataSource;
}
- (NSMutableArray *)titleDataArray
{
    if (!_titleDataArray) {
        _titleDataArray = [NSMutableArray array];
    }
    return _titleDataArray;
}
- (void)setupNoDataView
{
    self.noDataView = [self setupnoDataContentViewWithTitle:@"暂无点播文件" andImageNamed:@"device_empty_backimage" andTop:@"60"];
}
-(void)againLoadDataBtn
{
    [self loadNewData];
}
- (void)setupViews
{
    /// 顶部搜索的
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.frame = CGRectMake(0, 0, kScreenWidth, 64);
//    [self.view addSubview:self.contentView];
    self.navigationItem.titleView = self.contentView;

    
    self.searchButton = [UISearchBar new];
    self.searchButton.placeholder = @"搜索";
    self.searchButton.barStyle = UISearchBarStyleMinimal;
    self.searchButton.delegate = self;
    self.searchButton.clipsToBounds = YES;
    self.searchButton.layer.cornerRadius = 12.5;
     UITextField *searchField1;
       if ([[[UIDevice currentDevice]systemVersion] floatValue] >=     13.0) {
           searchField1 = self.searchButton.searchTextField;
       }else{
           searchField1 = [self.searchButton valueForKey:@"_searchField"];
       }
    searchField1.backgroundColor = [UIColor whiteColor];
    searchField1.textColor = kColorMainTextColor;
    searchField1.font=[UIFont customFontWithSize:kFontSizeFourteen];
    searchField1.layer.cornerRadius=12.5;
    searchField1.layer.masksToBounds=YES;
    NSMutableAttributedString *arrStr = [[NSMutableAttributedString alloc]initWithString:searchField1.placeholder attributes:@{NSForegroundColorAttributeName:kColorMainViceTextColor,NSFontAttributeName:[UIFont customFontWithSize:kFontSizeFourteen]}];
    searchField1.attributedPlaceholder = arrStr;
    [self.searchButton setTintColor:kColorMainViceTextColor];
    [self.contentView addSubview:self.searchButton];
    UIImage *image=[UIImage imageWithColor:[UIColor whiteColor]];
    UIImage *searchBGImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 30.0, 0.0, 40.0) resizingMode:UIImageResizingModeStretch];
    [self.searchButton setBackgroundImage:searchBGImage];
    self.searchButton.frame = CGRectMake(28, 10, kScreenWidth-110, 25);

    
//    //编辑按钮
//    UIButton *editBtn = [UIButton new];
//    editBtn.hidden = YES;
//    [editBtn setImage:UIImageWithFileName(@"demand_edit_image") forState:UIControlStateNormal];
//    [editBtn addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:editBtn];
//    [editBtn addCenterY:10 toView:self.contentView];
//    [editBtn leftToView:self.contentView withSpace:5];
//    [editBtn addWidth:30];
//    [editBtn addHeight:30];
//
//    //下载按钮
//    UIButton *downLoadBtn = [UIButton new];
//    downLoadBtn.hidden = YES;
//    [downLoadBtn setImage:UIImageWithFileName(@"demand_download_image") forState:UIControlStateNormal];
//    [downLoadBtn addTarget:self action:@selector(downLoadButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:downLoadBtn];
//    [downLoadBtn yCenterToView:editBtn];
//    [downLoadBtn leftToView:editBtn withSpace:3];
//    [downLoadBtn addWidth:30];
//    [downLoadBtn addHeight:30];
//
//
//    //上传按钮
//    UIButton *upLoadBtn = [UIButton new];
//    [upLoadBtn setBackgroundImage:UIImageWithFileName(@"demand_upload_image") forState:UIControlStateNormal];
//    [upLoadBtn setTitle:@"上传" forState:UIControlStateNormal];
//    [upLoadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    upLoadBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
//    [upLoadBtn addTarget:self action:@selector(upLoadButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:upLoadBtn];
//    [upLoadBtn yCenterToView:self.searchButton];
//    [upLoadBtn rightToView:self.contentView withSpace:15];
    
}
//编辑
-(void)editButtonClick
{
    DLog(@"编辑");
}
//下载
-(void)downLoadButtonClick
{
    DLog(@"下载");
}
//上传
-(void)upLoadButtonClick
{
    VideoUpLoadViewController *upvc = [VideoUpLoadViewController new];
    upvc.delegate = self;
    upvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:upvc animated:YES];
    upvc.hidesBottomBarWhenPushed = NO;
}
-(void)uploadVideoSuccess
{
    [self loadNewData];
}
- (WWCollectionView *)collectionUpView
{
    if (!_collectionUpView) {
        
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向
        flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //item大小
        flowlayout.estimatedItemSize = CGSizeMake(70, 35);
        _collectionUpView = [[WWCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        // 注册
        [_collectionUpView registerClass:[DemandTitleCollectionCell class] forCellWithReuseIdentifier:[DemandTitleCollectionCell getCellIDStr]];
        _collectionUpView.backgroundColor = [UIColor whiteColor];
        _collectionUpView.showsHorizontalScrollIndicator = NO;
        _collectionUpView.delegate = self;
        _collectionUpView.dataSource = self;
    
    }
    return _collectionUpView;
}
- (WWCollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向
        flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
     
        //item大小
//        CGFloat width = kScreenWidth/2-21;
//        flowlayout.itemSize = CGSizeMake(width, width*0.85);
        flowlayout.itemSize = CGSizeMake(kScreenWidth-0.2, 100);
        
        
        _collectionView = [[WWCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        _collectionView.backgroundColor = kColorBackgroundColor;
        // 注册
        [_collectionView registerClass:[DemandViewCell class] forCellWithReuseIdentifier:[DemandViewCell getCellIDStr]];
        
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationItem.leftBarButtonItem = nil;

    
//    [self.view addSubview:self.collectionUpView];
//    [self.collectionUpView alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:self.view];
//    [self.collectionUpView addHeight:35];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView alignTop:@"15" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    
    self.folder = @" ";
    self.isClick = NO;
    self.searchValue = @"";
    [self setupNoDataView];
    [self setupViews];
    [self getSubcatalogList];
    [self loadNewData];

    
    //右上角
    UIButton *upLoadBtn = [UIButton new];
    [upLoadBtn setBackgroundImage:UIImageWithFileName(@"demand_upload_image") forState:UIControlStateNormal];
    [upLoadBtn setTitle:@"上传" forState:UIControlStateNormal];
    [upLoadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    upLoadBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    [upLoadBtn addTarget:self action:@selector(upLoadButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:upLoadBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

#pragma mark -- collectionDelegate
//定义展示的Section的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:self.collectionUpView]) {
        return self.titleDataArray.count;
    }else{
        return self.dataArray.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.collectionUpView]) {
        
        // 每次先从字典中根据IndexPath取出唯一标识符
        NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
        if (identifier == nil) {
           identifier = [NSString stringWithFormat:@"%@%@", [DemandTitleCollectionCell getCellIDStr], [NSString stringWithFormat:@"%@", indexPath]];
           [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
           // 注册Cell
           [self.collectionUpView registerClass:[DemandTitleCollectionCell class] forCellWithReuseIdentifier:identifier];
        }
        DemandTitleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        DemandSubcatalogModel *model = [self.titleDataArray objectAtIndex:indexPath.row];
        [cell makeCellData:model];
        
        if (!self.isClick) {
            //设置首个默认选中
            [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        }
        return cell;
    }else{
         
        DemandViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[DemandViewCell getCellIDStr] forIndexPath:indexPath];
        DemandModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [cell makeCellData:model];
       
        return cell;
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if ([collectionView isEqual:self.collectionView]) {
        DemandModel *model = [self.dataArray objectAtIndex:indexPath.row];
        self.selectPath = indexPath;
        
        SuperPlayerViewController *vc = [SuperPlayerViewController new];
        vc.delegate = self;
        [vc makeViewDemandData:model];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else{
        DemandSubcatalogModel *model = [self.titleDataArray objectAtIndex:indexPath.row];
        self.folder = model.folder;
        self.isClick = YES;
        [self loadNewData];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if ([collectionView isEqual:self.collectionUpView]) {
           return UIEdgeInsetsMake(0, 0, 0, 0);
       }else{
           return UIEdgeInsetsMake(0, 0, 0, 0);
       }
    
}
//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if ([collectionView isEqual:self.collectionUpView]) {
        return 0.1;
    }else{
        return 10;
    }
}
//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if ([collectionView isEqual:self.collectionUpView]) {
        return 0.1;
    }else{
        return 0.1;
    }
}
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
    
//    NSString *start = [NSString stringWithFormat:@"%ld",(self.page - 1)*10];
//
//    NSDictionary *finalParams = @{
//                                  @"start":start,
//                                  @"limit":@"10",
//                                  };
//
//    NSMutableDictionary *mutData = [NSMutableDictionary dictionaryWithDictionary:finalParams];
//    if ([WWPublicMethod isStringEmptyText:self.folder]) {
//        [mutData setValue:self.folder forKey:@"folder"];
//    }
//
//    if ([WWPublicMethod isStringEmptyText:self.searchValue]) {
//        [mutData setValue:self.searchValue forKey:@"q"];
//    }
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutData options:0 error:nil];
    
//    /inventory/managedObjects?query=$filter=type+eq+vod+and+has(camera_Vod)+and+(name+eq+xxx*+or+description+eq+xx*+or+title+eq+xx*) &pageSize=100&currentPage=1
    
    NSString *url = [NSString stringWithFormat:@"/inventory/managedObjects?query=$filter=type+eq+vod+and+has(camera_Vod)%@&pageSize=100&currentPage=%ld",self.searchValue,(long)self.page];

    
    //提交数据
//    NSString *url = [NSString stringWithFormat:@"/inventory/managedObjects?query=$filter=type+eq+vod+and+has(camera_Vod)&pageSize=10&currentPage=%ld%@",(long)self.page,self.searchValue];
    NSString *newUrlString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//链接含有中文转码

    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
//    sence.body = jsonData;
    sence.pathURL = newUrlString;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"Received: %@", obj);
        [weak_self handleObject:obj];
    };
    sence.errorBlock = ^(NSError *error) {

        [_kHUDManager hideAfter:0.1 onHide:nil];
        // 请求失败
        DLog(@"error  ==  %@",error.userInfo);
        [weak_self failedOperation];
    };
    [sence sendRequest];

    return;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"application/vnd.com.nsn.cumulocity.managedobject+json",@"multipart/form-data", nil];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    
    // 设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:_kUserModel.userInfo.Authorization forHTTPHeaderField:@"Authorization"];
    
    // 设置body
//    [request setHTTPBody:jsonData];
//    __unsafe_unretained typeof(self) weak_self = self;

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
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;

        DLog(@"Received: %@", responseObject);
        DLog(@"Received HTTP %ld", (long)httpResponse.statusCode);

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
        NSArray *data = [obj objectForKey:@"managedObjects"];
//        NSDictionary *data = [obj objectForKey:@"data"];
//        NSArray *rows= [data objectForKey:@"rows"];
        NSMutableArray *tempArray = [NSMutableArray array];

        if (weak_self.page == 1) {
            [weak_self.dataArray removeAllObjects];
        }

        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            DemandModel *model = [DemandModel makeModelData:dic];
            [tempArray addObject:model];
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

//获取子目录
-(void)getSubcatalogList
{
    
    NSArray *rows= @[@{@"createAt":@"2020-03-16 23:34:12",
                       @"desc":@"",
                       @"folder":@"",
                       @"id":@"",
                       @"name":@"全部",
                       @"realPath":@"",
                       @"sort":@"1",
                       @"updateAt":@"2020-03-16 23:34:12",
                     },
                    @{@"createAt":@"2020-03-16 23:34:12",
                      @"desc":@"",
                      @"folder":@"other",
                      @"id":@"",
                      @"name":@"其它",
                      @"realPath":@"",
                      @"sort":@"1",
                      @"updateAt":@"2020-03-16 23:34:12",
                      }];
    NSMutableArray *tempArray = [NSMutableArray array];
    [rows enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = obj;
        DemandSubcatalogModel *model = [DemandSubcatalogModel makeModelData:dic];
        [tempArray addObject:model];
    }];
    [self.titleDataArray addObjectsFromArray:tempArray];
    
    [[GCDQueue mainQueue] queueBlock:^{
        [self.collectionUpView reloadData];
    }];
    
    return;
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = @"service/video/liveqing/vod/subcataloglist";
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"Received: %@", obj);
        
        [weak_self handleSubcatalogObject:obj];
        
    };
    sence.errorBlock = ^(NSError *error) {

        [_kHUDManager hideAfter:0.1 onHide:nil];
        // 请求失败
        DLog(@"error  ==  %@",error.userInfo);
        NSArray *rows= @[@{@"createAt":@"2020-03-16 23:34:12",
                           @"desc":@"",
                           @"folder":@"",
                           @"id":@"",
                           @"name":@"全部",
                           @"realPath":@"",
                           @"sort":@"1",
                           @"updateAt":@"2020-03-16 23:34:12",
                         },
                        @{@"createAt":@"2020-03-16 23:34:12",
                          @"desc":@"",
                          @"folder":@"other",
                          @"id":@"",
                          @"name":@"其它",
                          @"realPath":@"",
                          @"sort":@"1",
                          @"updateAt":@"2020-03-16 23:34:12",
                          }];
        NSMutableArray *tempArray = [NSMutableArray array];
        [rows enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            DemandSubcatalogModel *model = [DemandSubcatalogModel makeModelData:dic];
            [tempArray addObject:model];
        }];
        [weak_self.titleDataArray addObjectsFromArray:tempArray];
        
        [[GCDQueue mainQueue] queueBlock:^{
            [weak_self.collectionUpView reloadData];
        }];
    };
    [sence sendRequest];
}
- (void)handleSubcatalogObject:(id)obj
{
    _isHadFirst = YES;
    [_kHUDManager hideAfter:0.1 onHide:nil];
    __unsafe_unretained typeof(self) weak_self = self;
    [[GCDQueue globalQueue] queueBlock:^{
        NSDictionary *data = [obj objectForKey:@"data"];
        NSMutableArray *rows= [NSMutableArray arrayWithArray:[data objectForKey:@"rows"]];
        NSMutableArray *tempArray = [NSMutableArray array];
        
        NSDictionary *allDic = @{@"createAt":@"2020-03-16 23:34:12",
                                 @"desc":@"",
                                 @"folder":@"",
                                 @"id":@"",
                                 @"name":@"全部",
                                 @"realPath":@"",
                                 @"sort":@"1",
                                 @"updateAt":@"2020-03-16 23:34:12",
                                 };
        NSDictionary *otherDic = @{@"createAt":@"2020-03-16 23:34:12",
                                   @"desc":@"",
                                   @"folder":@"other",
                                   @"id":@"",
                                   @"name":@"其它",
                                   @"realPath":@"",
                                   @"sort":@"1",
                                   @"updateAt":@"2020-03-16 23:34:12",
                                   };
        [rows insertObject:allDic atIndex:0];
        [rows addObject:otherDic];
        
        [weak_self.titleDataArray removeAllObjects];
        
        [rows enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            DemandSubcatalogModel *model = [DemandSubcatalogModel makeModelData:dic];
            [tempArray addObject:model];
        }];
        [weak_self.titleDataArray addObjectsFromArray:tempArray];
        
        [[GCDQueue mainQueue] queueBlock:^{
            [weak_self.collectionUpView reloadData];
        }];
    }];
}

//搜索处理
#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.isClickSearch = NO;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (self.isClickSearch) {
        return;
    }
    self.isClickSearch = YES;
    if (searchBar.text.length == 0) {
           self.searchValue = @"";
       }else {
           self.searchValue = [NSString stringWithFormat:@"+and+(name+eq'*%@*'or+description+eq'*%@*'or+title+eq'*%@*')",searchBar.text,searchBar.text,searchBar.text];
       }
       [self loadNewData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchValue = @"";
    self.isClickSearch = NO;
    [self loadNewData];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (self.isClickSearch) {
        return;
    }
    self.isClickSearch = YES;
    if (searchBar.text.length == 0) {
           self.searchValue = @"";
    }else {
        self.searchValue = [NSString stringWithFormat:@"+and+(name+eq'*%@*'or+description+eq'*%@*'or+title+eq'*%@*')",searchBar.text,searchBar.text,searchBar.text];
    }
    [self loadNewData];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.isClickSearch = NO;
}
//删除点播文件后处理数据
#pragma mark - SuperPlayerDelegate
-(void)deleteDemandSuccess
{
    [self.dataArray removeObjectAtIndex:self.selectPath.row];
    [self.collectionView deleteItemsAtIndexPaths:@[self.selectPath]];
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
