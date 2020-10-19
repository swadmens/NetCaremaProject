//
//  ChannelDetailController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/30.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "ChannelDetailController.h"
#import "WWTableView.h"
#import "WWTableViewCell.h"
#import "RequestSence.h"
#import "SingleEquipmentModel.h"
#import "LivingModel.h"
#import "ChannelDetailFirstCell.h"
#import "ChannelDetailCell.h"
#import "ChannelDetailImageCell.h"
#import "EquipmentAbilityModel.h"


@interface ChannelDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,strong) SingleEquipmentModel *model;
@property (nonatomic,strong) EquipmentAbilityModel *abModel;

@end

@implementation ChannelDetailController
-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)setupTableView
{
    self.tableView = [[WWTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = kColorBackgroundColor;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    [self.tableView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ChannelDetailFirstCell class] forCellReuseIdentifier:[ChannelDetailFirstCell getCellIDStr]];
    [self.tableView registerClass:[ChannelDetailImageCell class] forCellReuseIdentifier:[ChannelDetailImageCell getCellIDStr]];
    [self.tableView registerClass:[ChannelDetailCell class] forCellReuseIdentifier:[ChannelDetailCell getCellIDStr]];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通道详情";
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
 
    [self getEquimentAbility];
    [self setupTableView];
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
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];

    if (indexPath.row == 0) {
        ChannelDetailFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:[ChannelDetailFirstCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lineHidden = NO;

        [cell makeCellData:dic];
        
        return cell;
    }else if (indexPath.row == 1) {
        ChannelDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:[ChannelDetailImageCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lineHidden = NO;

        [cell makeCellData:dic];
        
        return cell;
    }else{
        ChannelDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[ChannelDetailCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lineHidden = NO;

        [cell makeCellData:indexPath.row withData:dic];
        
        cell.switchChange = ^(BOOL switchOn) {
            [self getSwitchChange:switchOn withType:[dic objectForKey:@"type"]];
        };
        
        
        return cell;
    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        [TargetEngine controller:self pushToController:PushTargetEquimentBasicInfo WithTargetId:self.model.equipment_id];
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor whiteColor];

    return headerView;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = kColorBackgroundColor;
    
    
    UIButton *deleteBtn = [UIButton new];
    deleteBtn.clipsToBounds = YES;
    deleteBtn.layer.cornerRadius = 3;
    [deleteBtn setBGColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteBtn setTitle:@"删除设备" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:UIColorFromRGB(0xFD1616, 1) forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeFifty];
    [deleteBtn addTarget:self action:@selector(deleteCarmeraClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:deleteBtn];
    [deleteBtn leftToView:footerView withSpace:16];
    [deleteBtn yCenterToView:footerView];
    [deleteBtn addHeight:37];
    [deleteBtn addWidth:kScreenWidth/2-32];
    
    UIButton *restartBtn = [UIButton new];
    restartBtn.clipsToBounds = YES;
    restartBtn.layer.cornerRadius = 3;
    [restartBtn setBGColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [restartBtn setTitle:@"重启设备" forState:UIControlStateNormal];
    [restartBtn setTitleColor:kColorMainColor forState:UIControlStateNormal];
    restartBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeFifty];
    [restartBtn addTarget:self action:@selector(restartEquipmentClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:restartBtn];
    [restartBtn rightToView:footerView withSpace:16];
    [restartBtn yCenterToView:footerView];
    [restartBtn addHeight:37];
    [restartBtn addWidth:kScreenWidth/2-32];
    
    
    return footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 74;
}

-(void)deleteCarmeraClick
{
    [[TCNewAlertView shareInstance] showAlert:nil message:@"确认删除设备吗？" cancelTitle:@"取消" viewController:self confirm:^(NSInteger buttonTag) {
        
        if (buttonTag == 0) {
            [_kHUDManager showMsgInView:nil withTitle:@"删除了设备" isSuccess:YES];
        }
    } buttonTitles:@"确定", nil];
}
-(void)restartEquipmentClick
{
    [[TCNewAlertView shareInstance] showAlert:nil message:@"确认重启设备吗？" cancelTitle:@"取消" viewController:self confirm:^(NSInteger buttonTag) {
        
        if (buttonTag == 0) {
            [_kHUDManager showMsgInView:nil withTitle:@"重启了设备" isSuccess:YES];
        }
    } buttonTitles:@"确定", nil];
}
//获取设备能力集
-(void)getEquimentAbility
{
    NSString *url = [NSString stringWithFormat:@"service/cameraManagement/camera/device/getability/%@/%@",self.lvModel.system_Source,self.lvModel.deviceId];
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"obj ==  %@",obj)
        
        [[GCDQueue mainQueue] queueBlock:^{
            weak_self.abModel = [EquipmentAbilityModel makeModelData:obj];
            [weak_self getSingelEquimentInfo];
        }];
        
    };
    sence.errorBlock = ^(NSError *error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"error: %@", error);
    };
    [sence sendRequest];
}



//获取设备详情
-(void)getSingelEquimentInfo
{
    [_kHUDManager showActivityInView:nil withTitle:nil];
    NSString *url = [NSString stringWithFormat:@"inventory/managedObjects/%@",self.lvModel.deviceId];
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"obj ==  %@",obj)
        
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:obj];
        weak_self.model = [SingleEquipmentModel makeModelData:dic];
        
        NSArray *arr = @[@{@"name":weak_self.model.name,@"value":@""},
                         @{@"name":@"封面",@"value":self.lvModel.snap},
                         @{@"name":@"报警消息提醒",@"value":@(YES),@"showSwitch":@(YES),@"type":@"alarm"},
                         @{@"name":@"设备音频采集",@"value":@(YES),@"showSwitch":@(YES),@"type":@"audio"},
                         @{@"name":@"音视频加密",@"value":@(YES),@"showSwitch":@(YES),@"type":@"encryption"},
                         @{@"name":@"云端录像",@"value":@(self.model.cloudRecordStatus),@"showSwitch":@(YES),@"type":@"cloud"},
                         @{@"name":@"设备分享",@"detail":@"无",@"showSwitch":@(NO)},
                         @{@"name":@"设备程序版本",@"detail":@"v1.0",@"showSwitch":@(NO)},
                         @{@"name":@"通道名称",@"detail":self.model.channel,@"showSwitch":@(NO)}];
        [weak_self.dataArray addObjectsFromArray:arr];
 
        
        [[GCDQueue mainQueue] queueBlock:^{
            
            if (!weak_self.abModel.cloudStorage) {
                [weak_self.dataArray removeObjectAtIndex:4];
            }
            [weak_self.tableView reloadData];
        }];
        
    };
    sence.errorBlock = ^(NSError *error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"error: %@", error);
    };
    [sence sendRequest];
}

//开关操作
-(void)getSwitchChange:(BOOL)swichOn withType:(NSString*)type
{
    NSString *shared;
    NSString *url;
    
    if ([type isEqualToString:@"alarm"]) {
        //报警消息提醒
        shared = swichOn?@"true":@"false";
        url = [NSString stringWithFormat:@"service/video/livegbs/api/v1/device/setchannelshared?serial=%@&code=%@&shared=%@",self.model.system_Source,self.model.equipment_id,shared];
        
    }else if ([type isEqualToString:@"audio"]){
        //音频采集
        shared = swichOn?@"true":@"false";
        url = [NSString stringWithFormat:@"service/video/livegbs/api/v1/device/setchannelshared?serial=%@&code=%@&shared=%@",self.model.system_Source,self.model.equipment_id,shared];
    }else{
        //云端录像
        shared = swichOn?@"on":@"off";
        url = [NSString stringWithFormat:@"service/cameraManagement/camera/record/setcloudrecord?systemSource=%@&id=%@&command=%@",self.model.system_Source,self.model.equipment_id,shared];
    }

    
    [_kHUDManager showActivityInView:nil withTitle:nil];
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
//    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"Received: %@", obj);
    };
    sence.errorBlock = ^(NSError *error) {
        // 请求失败
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"error: %@", error);
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

