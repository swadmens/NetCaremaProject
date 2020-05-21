//
//  EquipmentOfflineController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "EquipmentOfflineController.h"
#import "WWTableView.h"
#import "WWTableViewCell.h"
#import "RequestSence.h"

@interface EquipmentOfflineCell : WWTableViewCell

@property (nonatomic,strong) UILabel *titleLabel;

@end



@interface EquipmentOfflineController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation EquipmentOfflineController
-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)setupTableView
{
    
    UILabel *title = [UILabel new];
    title.text = @"当设备离线时，你可依次排查一下情况：";
    title.textColor = kColorMainTextColor;
    title.font = [UIFont customBoldFontWithSize:kFontSizeFifty];
    [self.view addSubview:title];
    [title topToView:self.view withSpace:15];
    [title leftToView:self.view withSpace:15];
    
    UILabel *lineLabel = [UILabel new];
    lineLabel.backgroundColor = kColorLineColor;
    [self.view addSubview:lineLabel];
    [lineLabel alignTop:@"50" leading:@"15" bottom:nil trailing:@"15" toView:self.view];
    [lineLabel addHeight:0.5];
    
    self.tableView = [[WWTableView alloc] init];
    self.tableView.backgroundColor = kColorBackgroundColor;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    [self.tableView alignTop:@"58" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[EquipmentOfflineCell class] forCellReuseIdentifier:[EquipmentOfflineCell getCellIDStr]];

}
-(void)addGroupClick
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设备离线";
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    
    NSArray *content = @[@"设备电源是否正常供电；",@"无线连接情况下WiFi账号密码是否被修改，如修改请重新配置网络；", @"有线连接情况下，网线是否正确插入；",@"设备连接的路由器是否正常工作；",@"如未能查明原因，可尝试reset设备，并重新添加设备。"];
    [self.dataArray addObjectsFromArray:content];
    

    [self setupTableView];
    
    
    UIButton *rightBtn = [UIButton new];
    [rightBtn setImage:UIImageWithFileName(@"help_refresh_image") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(right_clicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
}
-(void)right_clicked
{
    //刷新数据
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EquipmentOfflineCell *cell = [tableView dequeueReusableCellWithIdentifier:[EquipmentOfflineCell getCellIDStr] forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)startLoadDataRequest
{
    [_kHUDManager showActivityInView:nil withTitle:nil];
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
//    sence.pathURL = [NSString stringWithFormat:@"inventory/managedObjects?pageSize=100&fragmentType=quark_IsCameraManageDevice&currentPage=%ld",(long)self.page];;
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
    [_kHUDManager hideAfter:0.1 onHide:nil];
    [_kHUDManager showMsgInView:nil withTitle:@"请求失败" isSuccess:NO];
    self.tableView.loadingMoreEnable = NO;
    [self.tableView stopLoading];
}
- (void)handleObject:(id)obj
{
    [_kHUDManager hideAfter:0.1 onHide:nil];
    __unsafe_unretained typeof(self) weak_self = self;
    [[GCDQueue globalQueue] queueBlock:^{
        NSArray *data = [obj objectForKey:@"managedObjects"];
        NSMutableArray *tempArray = [NSMutableArray array];

        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
//            IndexDataModel *model = [IndexDataModel makeModelData:dic];
//            [tempArray addObject:model];
        }];
        [weak_self.dataArray addObjectsFromArray:tempArray];
        
        
        [[GCDQueue mainQueue] queueBlock:^{
            
            [weak_self.tableView reloadData];
            if (tempArray.count >0) {
                weak_self.tableView.loadingMoreEnable = YES;
            } else {
                weak_self.tableView.loadingMoreEnable = NO;
            }
            [weak_self.tableView stopLoading];
        }];
    }];
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



@implementation EquipmentOfflineCell

-(void)dosetup
{
    [super dosetup];
    self.contentView.backgroundColor = kColorBackgroundColor;
    
    UILabel *dianLabel = [UILabel new];
    dianLabel.clipsToBounds = YES;
    dianLabel.layer.cornerRadius = 1.5;
    dianLabel.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:dianLabel];
    [dianLabel leftToView:self.contentView withSpace:17];
    [dianLabel topToView:self.contentView withSpace:16];
    [dianLabel addWidth:3];
    [dianLabel addHeight:3];
    
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = kColorMainTextColor;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel topToView:self.contentView withSpace:8];
    [_titleLabel leftToView:self.contentView withSpace:33];
    [_titleLabel bottomToView:self.contentView withSpace:8];
    [_titleLabel addWidth:kScreenWidth-50];
    
}


@end
