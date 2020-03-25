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
#import "CarmeaVideosViewCell.h"
#import "AFHTTPSessionManager.h"
#import "DemandModel.h"

@interface DemandViewController ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    BOOL _isHadFirst; // 是否第一次加载了
}

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UISearchBar *searchButton;
@property(nonatomic,assign) NSInteger page;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *searchDataSource;/**<搜索结果数据源*/


@property (nonatomic, strong) WWCollectionView *collectionUpView;
@property(nonatomic,strong) NSMutableArray *titleDataArray;
@property (nonatomic, strong) NSMutableDictionary *cellDic;

@property (nonatomic, strong) WWCollectionView *collectionView;

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
- (void)setupViews
{
    /// 顶部搜索的
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = kColorBackSecondColor;
    self.contentView.frame = CGRectMake(0, 0, kScreenWidth, 80);
    [self.view addSubview:self.contentView];
//    self.navigationItem.titleView = self.contentView;
    
    
   
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
    //    searchField1.placeholder = NSLocalizedString(@"searching", nil);
    [self.searchButton setTintColor:kColorMainViceTextColor];
    [self.contentView addSubview:self.searchButton];
    UIImage *image=[UIImage imageWithColor:[UIColor whiteColor]];
    UIImage *searchBGImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 30.0, 0.0, 40.0) resizingMode:UIImageResizingModeStretch];
    [self.searchButton setBackgroundImage:searchBGImage];
//    self.searchButton.frame=CGRectMake(78, 8, kScreenWidth-160, 25);
    [self.searchButton addCenterY:10 toView:self.contentView];
    [self.searchButton leftToView:self.contentView withSpace:78];
    [self.searchButton addWidth:kScreenWidth-160];
    [self.searchButton addHeight:25];
    
    
    //编辑按钮
    UIButton *editBtn = [UIButton new];
    [editBtn setImage:UIImageWithFileName(@"demand_edit_image") forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:editBtn];
    [editBtn addCenterY:10 toView:self.contentView];
    [editBtn leftToView:self.contentView withSpace:5];
    [editBtn addWidth:30];
    [editBtn addHeight:30];

    //下载按钮
    UIButton *downLoadBtn = [UIButton new];
    [downLoadBtn setImage:UIImageWithFileName(@"demand_download_image") forState:UIControlStateNormal];
    [downLoadBtn addTarget:self action:@selector(downLoadButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:downLoadBtn];
    [downLoadBtn yCenterToView:editBtn];
    [downLoadBtn leftToView:editBtn withSpace:3];
    [downLoadBtn addWidth:30];
    [downLoadBtn addHeight:30];

    
    //上传按钮
    UIButton *upLoadBtn = [UIButton new];
    [upLoadBtn setBackgroundImage:UIImageWithFileName(@"demand_upload_image") forState:UIControlStateNormal];
    [upLoadBtn setTitle:@"上传" forState:UIControlStateNormal];
    [upLoadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    upLoadBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    [upLoadBtn addTarget:self action:@selector(upLoadButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:upLoadBtn];
    [upLoadBtn yCenterToView:editBtn];
    [upLoadBtn rightToView:self.contentView withSpace:15];
    
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
    [TargetEngine controller:self pushToController:PushTargetVideoUpLoad WithTargetId:nil];
}
- (WWCollectionView *)collectionUpView
{
    if (!_collectionUpView) {
        
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向
        flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //左右间距
//        flowlayout.minimumInteritemSpacing = 20;
//        //上下间距
//        flowlayout.minimumLineSpacing = 0.1;
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
        //左右间距
        flowlayout.minimumInteritemSpacing = 10;
        //上下间距
        flowlayout.minimumLineSpacing = 10;
        
        CGFloat width = kScreenWidth/2-21;
        flowlayout.itemSize = CGSizeMake(width, width*0.85);
        
        _collectionView = [[WWCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        _collectionView.backgroundColor = kColorBackgroundColor;
        // 注册
        [_collectionView registerClass:[CarmeaVideosViewCell class] forCellWithReuseIdentifier:[CarmeaVideosViewCell getCellIDStr]];
        
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
//    self.title = @"点播";
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationItem.leftBarButtonItem=nil;
    self.FDPrefersNavigationBarHidden = YES;
    
    NSArray *titleArr =  @[@{@"title":@"全部",@"select":@(YES)},@{@"title":@"多清晰度视频",@"select":@(NO)},@{@"title":@"点播视频111",@"select":@(NO)},@{@"title":@"点播视频222",@"select":@(NO)},@{@"title":@"点播视频333",@"select":@(NO)},@{@"title":@"点播视频444",@"select":@(NO)},];
    [self.titleDataArray addObjectsFromArray:titleArr];
    
    
    [self.view addSubview:self.collectionUpView];
    [self.collectionUpView alignTop:@"85" leading:@"0" bottom:nil trailing:@"0" toView:self.view];
    [self.collectionUpView addHeight:35];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView alignTop:@"130" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    
    [self setupViews];
    [self loadNewData];
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
        
//        __unsafe_unretained typeof(self) weak_self = self;
//
//        // 每次先从字典中根据IndexPath取出唯一标识符
//        NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
//        // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
//        if (identifier == nil) {
//           identifier = [NSString stringWithFormat:@"%@%@", [DemandTitleCollectionCell getCellIDStr], [NSString stringWithFormat:@"%@", indexPath]];
//           [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
//           // 注册Cell
//           [self.collectionUpView registerClass:[DemandTitleCollectionCell class] forCellWithReuseIdentifier:identifier];
//        }
//        DemandTitleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        DemandTitleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[DemandTitleCollectionCell getCellIDStr] forIndexPath:indexPath];

        NSDictionary *title = [self.titleDataArray objectAtIndex:indexPath.row];
        [cell makeCellData:title];
        
        //设置首个默认选中
        [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];

        return cell;
    }else{
         CarmeaVideosViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CarmeaVideosViewCell getCellIDStr] forIndexPath:indexPath];
        DemandModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [cell makeCellData:model];
       
        
        return cell;
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.collectionView]) {
        if (indexPath.row == 0) {
            [TargetEngine controller:self pushToController:PushTargetDHVideoPlayback WithTargetId:@"1"];
        }else{
            [TargetEngine controller:self pushToController:PushTargetHKVideoPlayback WithTargetId:@"1"];
        }
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    if ([collectionView isEqual:self.collectionUpView]) {
           return UIEdgeInsetsMake(0, 8, 0, 8);
       }else{
           return UIEdgeInsetsMake(0, 15, 0, 15);
       }
    
    
}
//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if ([collectionView isEqual:self.collectionUpView]) {
        return 0.1;
    }else{
        return 10;
    }
}
//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if ([collectionView isEqual:self.collectionUpView]) {
        return 0.1;
    }else{
        return 5;
    }
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([collectionView isEqual:self.collectionView]) {
//        CGFloat width = kScreenWidth/2-21;
//        return CGSizeMake(width, width*0.8);
//    }else{
//        return CGSizeZero;
//    }
//
//}
#pragma mark - UIScrollViewDelegate
////预计出大概位置，经过精确定位获得准备位置
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
//    targetContentOffset->x = targetOffset.x;
//    targetContentOffset->y = targetOffset.y;
//}
////计算落在哪个item上
//- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
//{
//    CGFloat item_width = 70;
//
//    CGFloat pageSize = 15 + item_width;
//    //四舍五入
//    NSInteger page = roundf(offset.x / pageSize);
//    CGFloat targetX = pageSize * page;
//
//    return CGPointMake(targetX, offset.y);
//}

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

    NSString *url = @"http://192.168.6.120:10102/outer/liveqing/vod/list";
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

    __unsafe_unretained typeof(self) weak_self = self;
    
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        DLog(@"Received: %@", responseObject);
        DLog(@"Received HTTP %ld", (long)httpResponse.statusCode);
        
         [weak_self handleObject:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"error: %@", error);
    }];
    
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
//        NSArray *data = [obj objectForKey:@"references"];
        NSDictionary *data = [obj objectForKey:@"data"];
        NSArray *rows= [data objectForKey:@"rows"];
        NSMutableArray *tempArray = [NSMutableArray array];

        if (weak_self.page == 1) {
            [weak_self.dataArray removeAllObjects];
        }

        [rows enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            DemandModel *model = [DemandModel makeModelData:dic];
            [tempArray addObject:model];
        }];
        [weak_self.dataArray addObjectsFromArray:tempArray];

        [[GCDQueue mainQueue] queueBlock:^{

            if (tempArray.count == 0) {
                [_kHUDManager showMsgInView:nil withTitle:[obj objectForKey:@"msg"] isSuccess:YES];
            }
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

/*
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
