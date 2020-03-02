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
@interface MyEquipmentsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isHadFirst; // 是否第一次加载了
}
@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger page;

/// 没有内容
@property (nonatomic, strong) UIView *noDataView;

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
//    self.tableView.refreshEnable = YES;
//    self.tableView.loadingMoreEnable = NO;
//    __unsafe_unretained typeof(self) weak_self = self;
//    self.tableView.actionHandle = ^(WWScrollingState state){
//        switch (state) {
//            case WWScrollingStateRefreshing:
//            {
////                [weak_self loadNewData];
//            }
//                break;
////            case WWScrollingStateLoadingMore:
////            {
////                [weak_self loadMoreData];
////            }
////                break;
//            default:
//                break;
//        }
//    };
}
- (void)setupNoDataView
{
    self.noDataView = [self setupnoDataContentViewWithTitle:nil andImageNamed:@"empty_message_image" andTop:@"60"];
    self.noDataView.backgroundColor = [UIColor whiteColor];
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
//    [self loadNewData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorBackgroundColor;

    self.title = @"我的设备";
    
    [self setupNoDataView];
    [self setupTableView];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.dataArray.count;
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyEquipmentsCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyEquipmentsCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    IndexDataModel *model = [self.dataArray objectAtIndex:indexPath.row];
//    [cell makeCellData:model];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    IndexDataModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
//    NSString *url = [NSString stringWithFormat:@"https://leo.quarkioe.com/apps/androidapp/#/device/%@/dashboard/%@",model.childId,model.wechat[0]];
    [TargetEngine controller:self pushToController:PushTargetEquipmentInformation WithTargetId:nil];

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
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathURL = @"inventory/managedObjects?nocache=2777024045122203&pageSize=2000&query=$filter%3D(type+eq+%27qk_project%27)+$orderby%3DcreationTime+desc&withTotalPages=true";
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
            MyEquipmentsModel *model = [MyEquipmentsModel makeModelData:dic];
            [tempArray addObject:model];
        }];
        [weak_self.dataArray addObjectsFromArray:tempArray];
        
        
        [[GCDQueue mainQueue] queueBlock:^{
            
            if (tempArray.count == 0) {
                [_kHUDManager showMsgInView:nil withTitle:[obj objectForKey:@"msg"] isSuccess:YES];
            }
            [weak_self.tableView reloadData];
            if (tempArray.count >0) {
                weak_self.page++;
//                weak_self.tableView.loadingMoreEnable = YES;
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
