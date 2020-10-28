//
//  AreaSetupViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/10/26.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "AreaSetupViewController.h"
#import "WWTableView.h"
#import "AreaSetupViewCell.h"
#import "RequestSence.h"
#import "AreaSetupModel.h"
#import "AddNewAreaViewController.h"

@interface AreaSetupViewController ()<UITableViewDelegate,UITableViewDataSource,AddNewAreaSuccessDelegate>
{
    BOOL _isHadFirst; // 是否第一次加载了
}
@property (nonatomic, strong) WWTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger page;
/// 没有内容
@property (nonatomic, strong) UIView *noDataView;

@end

@implementation AreaSetupViewController
-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)setupNoDataView
{
    self.noDataView = [self setupnoDataContentViewWithTitle:@"暂无区域信息" andImageNamed:@"device_empty_backimage" andTop:@"60"];
}
- (void)setupTableView
{
    self.tableView = [WWTableView new];
    self.tableView.backgroundColor = kColorBackgroundColor;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 65;
    [self.view addSubview:self.tableView];
    [self.tableView alignTop:@"10" leading:@"0" bottom:@"58" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AreaSetupViewCell class] forCellReuseIdentifier:[AreaSetupViewCell getCellIDStr]];
    self.tableView.refreshEnable = YES;
//    self.tableView.loadingMoreEnable = NO;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"区域设置";
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.view.backgroundColor = kColorBackgroundColor;

    [self setupNoDataView];
    [self setupTableView];
    [self loadNewData];

    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView alignTop:nil leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    [bottomView addHeight:58];
    
    
    UIButton *addBtn = [UIButton new];
    addBtn.clipsToBounds = YES;
    addBtn.layer.cornerRadius = 19;
    [addBtn setTitle:@"添加区域" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:UIImageWithFileName(@"button_back_image") forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [addBtn addTarget:self action:@selector(addAreaButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addBtn];
    [addBtn centerToView:bottomView];
    [addBtn addWidth:kScreenWidth-30];
    [addBtn addHeight:38];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
//添加区域
-(void)addAreaButtonClick
{
    AddNewAreaViewController *avc = [AddNewAreaViewController new];
    avc.delegate = self;
    [self.navigationController pushViewController:avc animated:YES];
}
-(void)uploadAreaSuccess
{
    [self loadNewData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AreaSetupModel *model = [self.dataArray objectAtIndex:indexPath.row];

    AreaSetupViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[AreaSetupViewCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lineHidden = NO;
    
    [cell makeCellData:model];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AreaSetupModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    AddNewAreaViewController *avc = [AddNewAreaViewController new];
    avc.model = model;
    avc.delegate = self;
    [self.navigationController pushViewController:avc animated:YES];
    
}
#pragma mark ---- 侧滑删除
// 点击了“左滑出现的Delete按钮”会调用这个方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deleteAreaDataIndexPath:indexPath];
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

// 修改Delete按钮文字为“删除”
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
      return NO;
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
    
    NSString *url = [NSString stringWithFormat:@"inventory/managedObjects?type=UserLocationConfig&pageSize=100&currentPage=%ld",(long)self.page];

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
            AreaSetupModel *model = [AreaSetupModel makeModelData:dic];
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
//删除区域
-(void)deleteAreaDataIndexPath:(NSIndexPath*)indexPath
{
    AreaSetupModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    NSString *url = [NSString stringWithFormat:@"service/cameraManagement/camera/area/%@",model.area_id];
    
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"DELETE";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
    sence.successBlock = ^(id obj) {
//        [_kHUDManager showMsgInView:nil withTitle:@"" isSuccess:YES];
        DLog(@"Received: %@", obj);
        [[GCDQueue mainQueue] queueBlock:^{
            //删除数据
            [self.dataArray removeObjectAtIndex:indexPath.row];
            // 刷新
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }];

    };
    sence.errorBlock = ^(NSError *error) {
        DLog(@"error  ==  %@",error.userInfo);
        [_kHUDManager showMsgInView:nil withTitle:@"删除未完成！" isSuccess:YES];
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
