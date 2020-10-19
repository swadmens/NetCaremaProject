//
//  ShowCarmerasViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/29.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "ShowCarmerasViewController.h"
#import "WWTableView.h"
#import "ShowCarmerasTableViewCell.h"
#import "RequestSence.h"
#import "MyEquipmentsModel.h"
#import "ChannelDetailController.h"

@interface ShowCarmerasViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isHadFirst; // 是否第一次加载了
}
@property (nonatomic,strong) WWTableView *tableView;
@property(nonatomic,assign) NSInteger page;

/// 没有内容
@property (nonatomic, strong) UIView *noDataView;
//token刷新次数
@property(nonatomic,assign) NSInteger refreshtoken;

@property (nonatomic,strong) UIButton *rightBtn;
@end

@implementation ShowCarmerasViewController

- (void)setupTableView
{
    self.tableView = [[WWTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.clipsToBounds = YES;
    self.tableView.layer.cornerRadius = 5;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    [self.tableView alignTop:@"10" leading:@"15" bottom:@"10" trailing:@"15" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[ShowCarmerasTableViewCell class] forCellReuseIdentifier:[ShowCarmerasTableViewCell getCellIDStr]];
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
    self.noDataView = [self setupnoDataContentViewWithTitle:@"还没有设备，赶快去添加吧~" andImageNamed:@"device_empty_backimage" andTop:@"60"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorBackgroundColor;

    self.title = @"我的设备";
    
    [self setupNoDataView];
    [self setupTableView];
    [self changeNoDataViewHiddenStatus];
    
    
    //右上角按钮
    _rightBtn = [UIButton new];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightBtn.titleLabel.font=[UIFont customFontWithSize:kFontSizeFourteen];
    [_rightBtn.titleLabel setTextAlignment: NSTextAlignmentRight];
    _rightBtn.frame = CGRectMake(0, 0, 65, 40);
    [_rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_rightBtn setTitle:@"完成" forState:UIControlStateSelected];
    [_rightBtn addTarget:self action:@selector(right_clicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

-(void)right_clicked:(UIButton*)sender
{
    _rightBtn.selected = !_rightBtn.selected;
    [self.tableView setEditing:_rightBtn.selected animated:YES];//进入/退出编辑状态
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ShowCarmerasTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ShowCarmerasTableViewCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MyEquipmentsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell makeCellData:model];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyEquipmentsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    ChannelDetailController *cvc = [ChannelDetailController new];
    cvc.lvModel = model.model;
    [self.navigationController pushViewController:cvc animated:YES];
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
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
      return NO;
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
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImageView = [UIImageView new];
    iconImageView.image = UIImageWithFileName(@"all_mark_image");
    [headerView addSubview:iconImageView];
    [iconImageView yCenterToView:headerView];
    [iconImageView leftToView:headerView withSpace:15];
    

    UILabel *titleLabel = [UILabel new];
    titleLabel.text = [NSString stringWithFormat:@"摄像机(%lu)",(unsigned long)self.dataArray.count];
    titleLabel.textColor = kColorMainTextColor;
    titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [headerView addSubview:titleLabel];
    [titleLabel yCenterToView:headerView];
    [titleLabel leftToView:iconImageView withSpace:8];
    
    
    
    return headerView;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    
    return footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 42.5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
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
    
    NSString *url = [NSString stringWithFormat:@"inventory/managedObjects/%@/childDevices?pageSize=100&currentPage=%ld",self.equipment_id,(long)self.page];
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
-(void)action_goback
{
    [self.delegate getNewInfoArray:self.dataArray withIndex:self.indexRow];
    [self.navigationController popViewControllerAnimated:YES];
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
