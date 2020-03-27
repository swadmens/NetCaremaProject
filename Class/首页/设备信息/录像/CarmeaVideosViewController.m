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

@interface CarmeaVideosViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    BOOL _isHadFirst; // 是否第一次加载了
}
@property (nonatomic, strong) WWCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger page;

@property (nonatomic,strong) NSMutableDictionary *dicData;



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
//                    [weak_self loadMoreData];
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
    self.view.backgroundColor = kColorBackgroundColor;
    [self creadUI];

    [self.view addSubview:self.collectionView];
    [self.collectionView alignTop:@"40" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];

    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takeGoHomeNotica:) name:@"editStates" object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSDictionary *data = [NSDictionary dictionaryWithDictionary:[WWPublicMethod objectTransFromJson:self.equiment_id]];
    [self.dicData addEntriesFromDictionary:data];
    [self loadNewData];
}
- (void)takeGoHomeNotica:(NSNotification *)notification
{
    self.isEdit = [[NSString stringWithFormat:@"%@",notification.userInfo[@"edit"]] boolValue];

    if (!self.isEdit) {
        [self.dataArray removeAllObjects];
        NSArray *dataArr = @[@{@"choose":@(NO)},@{@"choose":@(NO)},@{@"choose":@(NO)},@{@"choose":@(NO)},];
        [self.dataArray addObjectsFromArray:dataArr];
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
    cell.isChoosed = model.isChoose;

    
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
    if (self.isEdit) {
        CarmeaVideosViewCell *cell = (CarmeaVideosViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
        cell.isChoosed = [[dic objectForKey:@"choose"] boolValue];
        NSDictionary *lDic = @{@"choose":@(![[dic objectForKey:@"choose"] boolValue])};
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:lDic];
    }else{
        if (indexPath.row == 0) {
               [TargetEngine controller:self pushToController:PushTargetDHVideoPlayback WithTargetId:@"1"];
           }else{
               [TargetEngine controller:self pushToController:PushTargetHKVideoPlayback WithTargetId:@"1"];
           }
    }
    
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
    
    NSString *ClientId = [self.dicData objectForKey:@"ClientId"];
    NSString *DeviceId = [self.dicData objectForKey:@"DeviceId"];
    NSString *CameraId = [self.dicData objectForKey:@"CameraId"];
    
    ClientId = [WWPublicMethod isStringEmptyText:ClientId]?ClientId:@"";
    DeviceId = [WWPublicMethod isStringEmptyText:DeviceId]?DeviceId:@"";
    CameraId = [WWPublicMethod isStringEmptyText:CameraId]?CameraId:@"";

    NSString *ids = [NSString stringWithFormat:@"%@%@%@",ClientId,DeviceId,CameraId];
    
    NSDictionary *finalParams = @{
                                  @"id":ids,
                                  @"day":@"all",
                                  };
        
    //提交数据
    NSString *url = @"http://192.168.6.120:10102/outer/liveqing/record/query_records";
    
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
            [_kHUDManager showMsgInView:nil withTitle:@"上传失败，请重试！" isSuccess:YES];
            [weak_self failedOperation];
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
//        NSArray *data = [obj objectForKey:@"references"];
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
            
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [mutDic setValue:@(NO) forKey:@"choose"];
            
            CarmeaVideosModel *model = [CarmeaVideosModel makeModelData:mutDic];
            [modelArray addObject:model];
            
        }];
        [weak_self.dataArray addObjectsFromArray:modelArray];

        [[GCDQueue mainQueue] queueBlock:^{

            if (modelArray.count == 0) {
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
