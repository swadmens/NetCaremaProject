//
//  EquimentAlarmsController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/12/1.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "EquimentAlarmsController.h"
#import "WWTableView.h"
#import "RequestSence.h"
#import "EquimentAlarmsCell.h"
#import "EquimentAlarmsModel.h"


@interface EquimentAlarmsController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isHadFirst; // 是否第一次加载了
}
@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger page;

/// 没有内容
@property (nonatomic, strong) UIView *noDataView;

@end

@implementation EquimentAlarmsController
-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)setupTableView
{
    self.tableView = [WWTableView new];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    [self.tableView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[EquimentAlarmsCell class] forCellReuseIdentifier:[EquimentAlarmsCell getCellIDStr]];
    self.tableView.refreshEnable = YES;
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
    self.noDataView = [self setupnoDataContentViewWithTitle:@"暂无告警" andImageNamed:@"device_empty_backimage" andTop:@"60"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设备告警";
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;

    [self setupTableView];
    [self setupNoDataView];
    [self loadNewData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EquimentAlarmsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    EquimentAlarmsCell *cell = [tableView dequeueReusableCellWithIdentifier:[EquimentAlarmsCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lineHidden = NO;
   
    [cell makeCellData:model];
    
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
    
    //获取当前时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    
    NSString *url = [NSString stringWithFormat:@"alarm/alarms?status=%@&source=%@&dateFrom=%@&dateTo=%@&pageSize=10&currentPage=%ld",@"ACTIVE",self.deviceId,@"2020-11-11",@"2020-12-01",self.page];

    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"Received: %@", obj);

         [weak_self handleObject:obj];
    };

    sence.errorBlock = ^(NSError *error) {
  
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"error: %@", error);
        [self failedOperation];

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
        NSArray *data = [obj objectForKey:@"alarms"];
        NSMutableArray *tempArray = [NSMutableArray array];

        if (weak_self.page == 1) {
            [weak_self.dataArray removeAllObjects];
        }

        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            EquimentAlarmsModel *model = [EquimentAlarmsModel makeModelData:dic];
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
//    if (_isHadFirst == NO) {
//        return ;
//    }
    
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
