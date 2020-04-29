//
//  LocalVideoViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/29.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "LocalVideoViewController.h"
#import "WWTableView.h"
#import "LocalVideoCell.h"
#import "RequestSence.h"

@interface LocalVideoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isHadFirst; // 是否第一次加载了
}
@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger page;
/// 没有内容
@property (nonatomic, strong) UIView *noDataView;

@end

@implementation LocalVideoViewController
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
    [self.tableView registerClass:[LocalVideoCell class] forCellReuseIdentifier:[LocalVideoCell getCellIDStr]];
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
-(void)addGroupClick
{
    [TargetEngine controller:nil pushToController:PushTargetAddNewGroup WithTargetId:nil];
}
- (void)setupNoDataView
{
    self.noDataView = [self setupnoDataContentViewWithTitle:nil andImageNamed:@"empty_message_image" andTop:@"90"];
    self.noDataView.backgroundColor = kColorBackgroundColor;
    // label
    UILabel *tipLabel = [self getNoDataTipLabel];
    
    UIButton *againBtn = [UIButton new];
    [againBtn setTitle:@"暂无分组，轻触重试" forState:UIControlStateNormal];
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
    self.title = @"本地录像";
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
   
    [self setupTableView];
    
    
//
    //右上角按钮
    UIButton *rightBtn = [UIButton new];
    [rightBtn setImage:UIImageWithFileName(@"local_right_image") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(right_clicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    
    
}
-(void)right_clicked
{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LocalVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:[LocalVideoCell getCellIDStr] forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//        IndexDataModel *model = [self.dataArray objectAtIndex:indexPath.row];
//        [cell makeCellData:model];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
//            IndexDataModel *model = [IndexDataModel makeModelData:dic];
//            [tempArray addObject:model];
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
