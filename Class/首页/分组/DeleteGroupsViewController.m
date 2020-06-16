//
//  DeleteGroupsViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/5/6.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "DeleteGroupsViewController.h"
#import "WWTableView.h"
#import "DeleteGroupsTableViewCell.h"
#import "RequestSence.h"

@interface DeleteGroupsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isHadFirst; // 是否第一次加载了
}
@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger page;
/// 没有内容
@property (nonatomic, strong) UIView *noDataView;

@property (nonatomic,strong) UILabel *groupNameLabel;

@property (nonatomic,assign) BOOL isClick;//是否点击过

@property (nonatomic, strong) NSMutableIndexSet *selectedIndexSet;

@end

@implementation DeleteGroupsViewController
-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableIndexSet*)selectedIndexSet
{
    if (!_selectedIndexSet) {
        _selectedIndexSet = [NSMutableIndexSet new];
    }
    return _selectedIndexSet;
}
- (void)setupTableView
{
    self.tableView = [[WWTableView alloc] init];
    self.tableView.backgroundColor = kColorBackgroundColor;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    [self.tableView alignTop:@"10" leading:@"0" bottom:@"58" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[DeleteGroupsTableViewCell class] forCellReuseIdentifier:[DeleteGroupsTableViewCell getCellIDStr]];

    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView alignTop:nil leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    [bottomView addHeight:58];
    
    
    UIButton *deleteBtn = [UIButton new];
    deleteBtn.clipsToBounds = YES;
    deleteBtn.layer.cornerRadius = 19;
    [deleteBtn setTitle:@"删除分组" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:UIImageWithFileName(@"button_back_image") forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [deleteBtn addTarget:self action:@selector(deleteGroupClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:deleteBtn];
    [deleteBtn centerToView:bottomView];
    [deleteBtn addWidth:kScreenWidth-30];
    [deleteBtn addHeight:38];
    
}
-(void)deleteGroupClick
{
    //删除分组
    if (self.selectedIndexSet.count == 0) {
        return;
    }
    
    [self.dataArray removeObjectsAtIndexes:self.selectedIndexSet];
    [self changeNoDataViewHiddenStatus];
    [self.selectedIndexSet removeAllIndexes];

    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DeleteGroupsTableViewCell *cell = (DeleteGroupsTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        cell.selectBtn.selected = NO;
    }];
    [self.tableView reloadData];
}
- (void)setupNoDataView
{
    self.noDataView = [self setupnoDataContentViewWithTitle:@"暂无分组" andImageNamed:@"device_empty_backimage" andTop:@"60"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"删除分组";
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    [self setupTableView];
    [self setupNoDataView];

    
    NSArray *arr = @[@{@"titles":@"111"},@{@"titles":@"222"},@{@"titles":@"333"},@{@"titles":@"444"},@{@"titles":@"555"},@{@"titles":@"666"},@{@"titles":@"777"},@{@"titles":@"888"}];
    [self.dataArray addObjectsFromArray:arr];
    
    
    //右上角按钮
    UIButton *rightBtn = [UIButton new];
    [rightBtn setImage:UIImageWithFileName(@"group_chooses_image") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(right_clicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
}
-(void)right_clicked
{
//    [self.tableView setEditing:YES animated:NO];
    
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        DeleteGroupsTableViewCell *cell = (DeleteGroupsTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        cell.selectBtn.selected = YES;
        [self.selectedIndexSet addIndex:idx];

    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DeleteGroupsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DeleteGroupsTableViewCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell makeCellData:model];

    
    return cell;
}
// 选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *model = [self.dataArray objectAtIndex:indexPath.row];
//    BOOL selected = [[model objectForKey:@"select"] boolValue];
//    if (selected) {
//        NSDictionary *dic = @{@"select":@(NO)};
//        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:dic];
//        [self.selectedIndexSet removeIndex:indexPath.item];
//    }else{
//        NSDictionary *dic = @{@"select":@(YES)};
//        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:dic];
//        [self.selectedIndexSet addIndex:indexPath.item];
//    }
//
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    
    DeleteGroupsTableViewCell *cell = (DeleteGroupsTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectBtn.selected = !cell.selectBtn.selected;
    if (cell.selectBtn.selected) {
        [self.selectedIndexSet addIndex:indexPath.item];
    }else{
        [self.selectedIndexSet removeIndex:indexPath.item];
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
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/vnd.com.nsn.cumulocity.managedobjectcollection+json";
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
