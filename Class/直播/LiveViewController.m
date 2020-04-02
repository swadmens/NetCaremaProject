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
#import "AFHTTPSessionManager.h"
#import "LivingModel.h"


@interface LiveViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    BOOL _isHadFirst; // 是否第一次加载了
}
@property (nonatomic,strong) UIButton *chooseBtn;

@property (nonatomic, strong) WWCollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger page;

@property (nonatomic,strong) ChooseAreaView *areaView;
@property (nonatomic,strong) UIView *coverView;

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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"直播";
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationItem.leftBarButtonItem=nil;
    
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
    _coverView.hidden = YES;
    _coverView.frame = CGRectMake(0, 450, kScreenWidth, kScreenHeight-450);
    _coverView.backgroundColor = UIColorFromRGB(0x000000, 0.7);
    [[UIApplication sharedApplication].keyWindow addSubview:_coverView];

    
    
    
    [self creadLivingUI];
    [self loadNewData];
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
        _coverView.hidden = NO;
        _areaView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            weakself.areaView.frame = CGRectMake(0, 100, kScreenWidth, 350);
        }];
    }else{
        _coverView.hidden = YES;
        _areaView.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            weakself.areaView.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, 350);
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
    if (indexPath.row == 0) {
        [TargetEngine controller:self pushToController:PushTargetDHLiving WithTargetId:@"1"];
    }else{
        
        //live直播
        LivingModel *model = [self.dataArray objectAtIndex:indexPath.row];
        NSDictionary *dic = @{@"name":model.name,
                              @"RTMP":model.RTMP,
                              @"shared":model.shared,
                              @"sharedLink":model.sharedLink,
                              @"url":model.url,
        };
        NSString *pushId = [WWPublicMethod jsonTransFromObject:dic];
        [TargetEngine controller:self pushToController:PushTargetLiveLiving WithTargetId:pushId];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
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

    NSString *url = @"http://192.168.6.120:10102/outer/liveqing/live/list";
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
        NSString *unauthorized = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        int errorCode = [[error.userInfo objectForKey:@"code"] intValue];
        if (errorCode == 500 && [unauthorized containsString:@"401"]) {
            [WWPublicMethod refreshToken:nil];
        }
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
            LivingModel *model = [LivingModel makeModelData:dic];
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
