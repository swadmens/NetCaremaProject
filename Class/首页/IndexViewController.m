//
//  IndexViewController.m
//  YanGang
//
//  Created by 汪伟 on 2018/11/7.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "IndexViewController.h"
#import "WWTableView.h"
#import "IndexTableViewCell.h"
#import "RequestSence.h"
#import "IndexDataModel.h"
#import "IndexTopView.h"
#import "SingleCarmeraCell.h"
#import "MoreCarmerasCell.h"
#import "IndexBottomView.h"
#import "ShowCarmerasViewController.h"
#import "MyEquipmentsModel.h"
#import "WMZDialog.h"
#import "QRScanCodeViewController.h"//二维码
#import "SuperPlayerViewController.h"
#import "AFHTTPSessionManager.h"

#import "LocalVideoViewController.h"


@interface IndexViewController ()<UITableViewDelegate,UITableViewDataSource,IndexTopDelegate,IndexBottomDelegate,showCarmeraDelegate,LocalVideoDelegate>
{
    BOOL _isHadFirst; // 是否第一次加载了
}
@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger page;

/// 没有内容
@property (nonatomic, strong) UIView *noDataView;
@property (nonatomic, strong) IndexBottomView *bottomView;
@property (nonatomic,strong) UIView *coverView;

@property (nonatomic,assign) BOOL isLogion;//是否登录
@property (nonatomic,strong) MyEquipmentsModel *selectModel;


@end

@implementation IndexViewController

-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)setupTableView
{
    self.tableView = [[WWTableView alloc] init];
    self.tableView.backgroundColor = kColorBackgroundColor;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    [self.tableView alignTop:@"110" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[IndexTableViewCell class] forCellReuseIdentifier:[IndexTableViewCell getCellIDStr]];
    [self.tableView registerClass:[SingleCarmeraCell class] forCellReuseIdentifier:[SingleCarmeraCell getCellIDStr]];
    [self.tableView registerClass:[MoreCarmerasCell class] forCellReuseIdentifier:[MoreCarmerasCell getCellIDStr]];

    
    self.tableView.refreshEnable = YES;
    self.tableView.loadingMoreEnable = NO;
    __unsafe_unretained typeof(self) weak_self = self;
    self.tableView.actionHandle = ^(WWScrollingState state){
        switch (state) {
            case WWScrollingStateRefreshing:
            {
                [weak_self loadNewData];
            }
                break;
            case WWScrollingStateLoadingMore:
            {
                [weak_self loadMoreData];
            }
                break;
            default:
                break;
        }
    };
}
- (void)setupNoDataView
{
    self.noDataView = [self setupnoDataContentViewWithTitle:@"网络出问题了，快去检查一下吧~" andImageNamed:@"index_empty_backimage" andTop:@"105"];
//    // label
//    UILabel *tipLabel = [self getNoDataTipLabel];
//
//    UIButton *againBtn = [UIButton new];
//    [againBtn setTitle:@"暂无数据，轻触重试" forState:UIControlStateNormal];
//    [againBtn setTitleColor:kColorThirdTextColor forState:UIControlStateNormal];
//    againBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
//    [againBtn addTarget:self action:@selector(againLoadDataBtn) forControlEvents:UIControlEventTouchUpInside];
//    [self.noDataView addSubview:againBtn];
//    [againBtn xCenterToView:self.noDataView];
//    [againBtn topToView:tipLabel withSpace:-8];
}
-(void)againLoadDataBtn
{
    [self loadNewData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationItem.leftBarButtonItem = nil;
    self.FDPrefersNavigationBarHidden = YES;
    
//    self.title = @"我的设备";
    
    IndexTopView *topView = [IndexTopView new];
    topView.delegate = self;
    topView.frame = CGRectMake(0, 0, kScreenWidth, 105);
    [self.view addSubview:topView];
    
     
    _coverView = [UIView new];
    _coverView.hidden = YES;
    _coverView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _coverView.backgroundColor = UIColorFromRGB(0x000000, 0.7);
    [[UIApplication sharedApplication].keyWindow addSubview:_coverView];
    
    
    _bottomView = [[IndexBottomView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 190)];
    _bottomView.delegate = self;
    [_coverView addSubview:_bottomView];
    

    
    @weakify(self);
       /// 登录变化监听
       [RACObserve(_kUserModel, isLogined) subscribeNext:^(id x) {
           @strongify(self);

           self.isLogion = [x boolValue];

           if (!self.isLogion) {
               [_kUserModel showLoginView];
           }else{
               [self setupNoDataView];
               [self setupTableView];
               [self loadNewData];
           }

       }];
        
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    IndexTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[IndexTableViewCell getCellIDStr] forIndexPath:indexPath];
    
    IndexDataModel *model = [self.dataArray objectAtIndex:indexPath.row];
   
    if (model.equipment_nums.count > 1) {
        MoreCarmerasCell *cell = [tableView dequeueReusableCellWithIdentifier:[MoreCarmerasCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell makeCellData:model];
        
        cell.moreDealClick = ^(NSInteger selectRow) {
            [self collectionSelect:indexPath.row];
            self.selectModel = [model.equipment_nums objectAtIndex:selectRow];
        };
        
        cell.rightBtnClick = ^{
            ShowCarmerasViewController *vc = [ShowCarmerasViewController new];
            vc.equipment_id = model.equipment_id;
            vc.delegate = self;
            vc.indexRow = indexPath.row;
            vc.dataArray = [NSMutableArray arrayWithArray:model.equipment_nums];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        };
        
        return cell;
        
    }else{
        SingleCarmeraCell *cell = [tableView dequeueReusableCellWithIdentifier:[SingleCarmeraCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell makeCellData:model];
        
        cell.moreClick = ^{
            [self collectionSelect:indexPath.row];
        };
        
        
        return cell;
    }  
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    IndexDataModel *model = [self.dataArray objectAtIndex:indexPath.row];
//    [TargetEngine controller:self pushToController:PushTargetMyEquipments WithTargetId:model.equipment_id];
    
    
//    if (indexPath.row > 0) {
        SuperPlayerViewController *vc = [SuperPlayerViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        vc.isLiving = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
//    }
    
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
    [_kHUDManager showActivityInView:self.view withTitle:nil];
    
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathURL = [NSString stringWithFormat:@"inventory/managedObjects?pageSize=100&fragmentType=quark_IsCameraManageDevice&currentPage=%ld",(long)self.page];;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {

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
    self.tableView.loadingMoreEnable = NO;
    [self.tableView stopLoading];
    [self changeNoDataViewHiddenStatus];
}
- (void)handleObject:(id)obj
{
    _isHadFirst = YES;
    [_kHUDManager hideAfter:0.1 onHide:nil];
    __unsafe_unretained typeof(self) weak_self = self;
    [[GCDQueue globalQueue] queueBlock:^{
        NSArray *data = [obj objectForKey:@"managedObjects"];
        NSMutableArray *tempArray = [NSMutableArray array];

        if (weak_self.page == 1) {
            [weak_self.dataArray removeAllObjects];
        }

        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            IndexDataModel *model = [IndexDataModel makeModelData:dic];
            [tempArray addObject:model];
            [weak_self getDeviceInfo:model.equipment_id withIndex:idx];
        }];
        [weak_self.dataArray addObjectsFromArray:tempArray];
        
        
        [[GCDQueue mainQueue] queueBlock:^{
            
            [weak_self.tableView reloadData];
            if (tempArray.count >0) {
                weak_self.page++;
                weak_self.tableView.loadingMoreEnable = YES;
            } else {
                weak_self.tableView.loadingMoreEnable = NO;
            }
            [weak_self.tableView stopLoading];
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
        self.tableView.hidden = YES;
        self.noDataView.hidden = NO;
    } else {
        self.tableView.hidden = NO;
        self.noDataView.hidden = YES;
    }
}

//获取设备信息
-(void)getDeviceInfo:(NSString*)device_id withIndex:(NSInteger)index
{
    NSString *url = [NSString stringWithFormat:@"http://ncore.iot/inventory/managedObjects/%@/childAssets?pageSize=100&currentPage=1",device_id];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //配置用户名 密码
    NSString *str1 = [NSString stringWithFormat:@"%@/%@:%@",_kUserModel.userInfo.tenant_name,_kUserModel.userInfo.user_name,_kUserModel.userInfo.password];
    //进行加密  [str base64EncodedString]使用开源Base64.h分类文件加密
    NSString *str2 = [NSString stringWithFormat:@"Basic %@",[WWPublicMethod encodeBase64:str1]];
    // 设置Authorization的方法设置header
    [manager.requestSerializer setValue:str2 forHTTPHeaderField:@"Authorization"];
    __unsafe_unretained typeof(self) weak_self = self;
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        DLog(@"Received: %@", responseObject);
        DLog(@"Received HTTP %ld", (long)httpResponse.statusCode);
        
         [weak_self handleDeviceInfoObject:responseObject withIndex:index];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"error: %@", error);
//        [self failedOperation];
    }];
        
}
- (void)handleDeviceInfoObject:(id)obj withIndex:(NSInteger)index
{
    _isHadFirst = YES;
    [_kHUDManager hideAfter:0.1 onHide:nil];
    __unsafe_unretained typeof(self) weak_self = self;
    [[GCDQueue globalQueue] queueBlock:^{
        NSArray *data = [obj objectForKey:@"references"];
        NSMutableArray *tempArray = [NSMutableArray array];

        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            MyEquipmentsModel *model = [MyEquipmentsModel makeModelData:dic];
            [tempArray addObject:model];
        }];
        
        IndexDataModel *model = [self.dataArray objectAtIndex:index];
        model.equipment_nums = tempArray;
        [self.dataArray replaceObjectAtIndex:index withObject:model];
        
        
        [[GCDQueue mainQueue] queueBlock:^{
            
            [weak_self.tableView reloadData];
        }];
    }];
}

#pragma IndexTopDelegate
-(void)collectionSelect:(NSInteger)index
{
    NSArray *arr = @[@{@"title":@"消息设置",@"image":@"index_message_image"},
                    @{@"title":@"全部录像",@"image":@"index_all_video_image"},
                    @{@"title":@"设备共享",@"image":@"index_equiment_shara_image"},
                    @{@"title":@"设备详情",@"image":@"index_channel_detail_image"}];
    NSArray *arr2 = @[@{@"title":@"全部录像",@"image":@"index_all_video_image"},
                    @{@"title":@"通道详情",@"image":@"index_channel_detail_image"}];
    
    NSString *ClientId = [WWPublicMethod isStringEmptyText:self.selectModel.ClientId]?self.selectModel.ClientId:@"";
    NSString *DeviceId = [WWPublicMethod isStringEmptyText:self.selectModel.DeviceId]?self.selectModel.DeviceId:@"";
    NSString *CameraId = [WWPublicMethod isStringEmptyText:self.selectModel.CameraId]?self.selectModel.CameraId:@"";
    
    NSString *device_id = [NSString stringWithFormat:@"%@%@%@",ClientId,DeviceId,CameraId];
    
    CGFloat height;
    if (index == 1) {
        [self.bottomView makeViewData:arr2 with:device_id];
        height = arr2.count * 35 + 50;
    }else{
        [self.bottomView makeViewData:arr with:device_id];
        height = arr.count * 35 + 50;
    }
    
   [UIView animateWithDuration:0.3 animations:^{
       self.bottomView.transform = CGAffineTransformMakeTranslation(0, -height);
       self.coverView.hidden = NO;
   }];
    
}
-(void)searchValue:(NSString *)value
{
    DLog(@"搜索  ==  %@",value);
}
-(void)navPopView:(NSInteger)value
{
    
    if (value == 0) {

        QRScanCodeViewController *qvc = [QRScanCodeViewController new];
        qvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:qvc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else{
        [TargetEngine controller:nil pushToController:PushTargetAllGroups WithTargetId:nil];
    }
}
-(void)allPlayerBtn
{
//    IndexDataModel *model = [self.dataArray objectAtIndex:0];
    
    SuperPlayerViewController *vc = [SuperPlayerViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.isLiving = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
#pragma IndexBottomDelegate
-(void)clickCancelBtn
{
    self.bottomView.transform = CGAffineTransformIdentity;
    self.coverView.hidden = YES;
}
-(void)clickAllVideos
{
    
    NSString *ClientId = [WWPublicMethod isStringEmptyText:self.selectModel.ClientId]?self.selectModel.ClientId:@"";
    NSString *DeviceId = [WWPublicMethod isStringEmptyText:self.selectModel.DeviceId]?self.selectModel.DeviceId:@"";
    NSString *CameraId = [WWPublicMethod isStringEmptyText:self.selectModel.CameraId]?self.selectModel.CameraId:@"";

    
    LocalVideoViewController *vc = [LocalVideoViewController new];
    vc.delegate = self;
    vc.hidesBottomBarWhenPushed = YES;
    vc.isFromIndex = YES;
    vc.device_id = [NSString stringWithFormat:@"%@%@%@",ClientId,DeviceId,CameraId];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
-(void)clickChannelDetails
{
    NSDictionary *dic = @{
                          @"id":self.selectModel.equipment_id,
                          @"name":self.selectModel.equipment_name,
                          @"c8y_Notes":self.selectModel.c8y_Notes,
                          @"CameraId":self.selectModel.CameraId,
                          @"Channel":self.selectModel.equipment_Channel,
                          @"ClientId":self.selectModel.ClientId,
                          @"DeviceId":self.selectModel.DeviceId,
                          @"owner":self.selectModel.owner,
                          @"lastUpdated":self.selectModel.lastUpdated,
                          @"responseInterval":self.selectModel.responseInterval,
                         };
    NSString *pushId = [WWPublicMethod jsonTransFromObject:dic];
    
    [TargetEngine controller:nil pushToController:PushTargetChannelDetail WithTargetId:pushId];

}
#pragma LocalVideoDelegate
-(void)selectRowData:(NSString *)value
{
    
}
#pragma showCarmeraDelegate
-(void)getNewArray:(NSArray *)array withIndex:(NSInteger)index
{
    IndexDataModel *model = [self.dataArray objectAtIndex:index];
    model.equipment_nums = array;
    [self.dataArray replaceObjectAtIndex:index withObject:model];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
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
