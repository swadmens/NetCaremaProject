//
//  MyEquipmentsViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/2/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "MyEquipmentsViewController.h"
#import "WWTableView.h"
#import "MyEquipmentsCell.h"
#import "RequestSence.h"
#import "MyEquipmentsModel.h"
#import "AFHTTPSessionManager.h"

@interface MyEquipmentsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isHadFirst; // 是否第一次加载了
}
@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger page;

/// 没有内容
@property (nonatomic, strong) UIView *noDataView;
//token刷新次数
@property(nonatomic,assign) NSInteger refreshtoken;

@property (nonatomic,assign) BOOL isLogion;//是否登录


@end

@implementation MyEquipmentsViewController
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
    [self.tableView alignTop:@"10" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[MyEquipmentsCell class] forCellReuseIdentifier:[MyEquipmentsCell getCellIDStr]];
    self.tableView.refreshEnable = YES;
    self.tableView.loadingMoreEnable = NO;
    
//    [self.tableView setEditing:YES animated:YES];//进入编辑状态

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
    self.noDataView = [self setupnoDataContentViewWithTitle:nil andImageNamed:@"empty_message_image" andTop:@"60"];
    self.noDataView.backgroundColor = kColorBackgroundColor;
    // label
    UILabel *tipLabel = [self getNoDataTipLabel];
    
    UIButton *againBtn = [UIButton new];
    [againBtn setTitle:@"暂无数据，轻触重试" forState:UIControlStateNormal];
    [againBtn setTitleColor:kColorMainTextColor forState:UIControlStateNormal];
    againBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [againBtn addTarget:self action:@selector(againLoadDataBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.noDataView addSubview:againBtn];
    [againBtn xCenterToView:self.noDataView];
    [againBtn topToView:tipLabel withSpace:-8];
}
-(void)againLoadDataBtn
{
    [self loadNewData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorBackgroundColor;

    self.title = @"我的设备";
    
    [self setupNoDataView];
    [self setupTableView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadNewData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyEquipmentsCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyEquipmentsCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MyEquipmentsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell makeCellData:model];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    IndexDataModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
//    NSString *url = [NSString stringWithFormat:@"https://leo.quarkioe.com/apps/androidapp/#/device/%@/dashboard/%@",model.childId,model.wechat[0]];
    MyEquipmentsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    
    NSDictionary *dic = @{
                          @"id":model.equipment_id,
                          @"name":model.equipment_name,
                          @"c8y_Notes":model.c8y_Notes,
                          @"CameraId":model.CameraId,
                          @"Channel":model.equipment_Channel,
                          @"ClientId":model.ClientId,
                          @"DeviceId":model.DeviceId,
                          @"owner":model.owner,
                          @"lastUpdated":model.lastUpdated,
                          @"responseInterval":model.responseInterval,
                         };
    NSString *pushId = [WWPublicMethod jsonTransFromObject:dic];

    [TargetEngine controller:self pushToController:PushTargetEquipmentInformation WithTargetId:pushId];

}
#pragma mark 选择编辑模式，添加模式很少用,默认是删除
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    // 取出要拖动的模型数据
    MyEquipmentsModel *model = [self.dataArray objectAtIndex:sourceIndexPath.row];
       //删除之前行的数据
    [self.dataArray removeObject:model];
       // 插入数据到新的位置
    [self.dataArray insertObject:model atIndex:destinationIndexPath.row];

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
    
    NSString *url = [NSString stringWithFormat:@"http://ncore.iot/inventory/managedObjects/%@/childAssets?pageSize=100&currentPage=%ld",self.equipment_id,(long)self.page];
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
        
         [weak_self handleObject:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"error: %@", error);
        [self failedOperation];
        self.refreshtoken++;
        if (self.refreshtoken > 1) {
            return ;
        }
        NSString *unauthorized = [error.userInfo objectForKey:@"NSLocalizedDescription"];
//        int statusCode = [[task.response objectForKey:@"code"] intValue];
        if ([unauthorized containsString:@"500"]) {
            [WWPublicMethod refreshToken:^(id obj) {
                [self loadNewData];
            }];
        }

    }];
        
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
        NSArray *data = [obj objectForKey:@"references"];
        NSMutableArray *tempArray = [NSMutableArray array];

        if (weak_self.page == 1) {
            [weak_self.dataArray removeAllObjects];
        }

        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            MyEquipmentsModel *model = [MyEquipmentsModel makeModelData:dic];
            [tempArray addObject:model];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
