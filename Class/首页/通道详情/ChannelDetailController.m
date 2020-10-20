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
#import "LivingModel.h"
#import "ChannelDetailFirstCell.h"
#import "ChannelDetailCell.h"
#import "ChannelDetailImageCell.h"
#import "EquipmentAbilityModel.h"
#import "MyEquipmentsModel.h"
#import "EquimentBasicInfoController.h"
#import "ChannelMoreSystemController.h"

@interface ChannelDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

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
    self.tableView = [[WWTableView alloc] init];
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
    self.title = @"设备详情";
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
 
    [self getEquimentAbility];
    [self setupTableView];
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
//        [TargetEngine controller:self pushToController:PushTargetEquimentBasicInfo WithTargetId:self.model.equipment_id];
        EquimentBasicInfoController *infoVc = [EquimentBasicInfoController new];
        infoVc.model = self.eqModel;
        [self.navigationController pushViewController:infoVc animated:YES];
    }else if (indexPath.row == self.dataArray.count - 1){
        ChannelMoreSystemController *svc = [ChannelMoreSystemController new];
        svc.eqModel = self.eqModel;
        [self.navigationController pushViewController:svc animated:YES];
    }
}

//获取设备能力集
-(void)getEquimentAbility
{
    NSString *url = [NSString stringWithFormat:@"service/cameraManagement/camera/device/getability/%@/%@",self.eqModel.system_Source,self.eqModel.equipment_id];
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"obj ==  %@",obj)
        weak_self.abModel = [EquipmentAbilityModel makeModelData:obj];

        NSArray *arr = @[@{@"name":weak_self.eqModel.equipment_name,@"value":@""},
                         @{@"name":@"封面",@"value":self.eqModel.model.snap},
                         @{@"name":@"通道名称",@"detail":self.eqModel.channel,@"showSwitch":@(NO),@"right":@(NO)},
                         @{@"name":@"报警消息提醒",@"value":@(YES),@"showSwitch":@(YES),@"type":@"alarm",@"right":@(NO)},
                         @{@"name":@"设备音频采集",@"value":@(YES),@"showSwitch":@(YES),@"type":@"audio",@"right":@(NO)},
                         @{@"name":@"音视频加密",@"value":@(YES),@"showSwitch":@(YES),@"type":@"encryption",@"right":@(NO)},
                         @{@"name":@"云端录像",@"value":@(self.eqModel.cloudRecordStatus),@"showSwitch":@(YES),@"type":@"cloud",@"right":@(NO)},
                         @{@"name":@"设备分享",@"detail":@"",@"showSwitch":@(NO),@"right":@(YES)},
                         @{@"name":@"设备程序版本",@"detail":@"v1.0",@"showSwitch":@(NO),@"right":@(NO)},
                         @{@"name":@"更多设置",@"detail":@"",@"showSwitch":@(NO),@"right":@(YES)}];
        
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
        url = [NSString stringWithFormat:@"service/video/livegbs/api/v1/device/setchannelshared?serial=%@&code=%@&shared=%@",self.eqModel.system_Source,self.eqModel.equipment_id,shared];
        
    }else if ([type isEqualToString:@"audio"]){
        //音频采集
        shared = swichOn?@"true":@"false";
        url = [NSString stringWithFormat:@"service/video/livegbs/api/v1/device/setchannelshared?serial=%@&code=%@&shared=%@",self.eqModel.system_Source,self.eqModel.equipment_id,shared];
    }else{
        //云端录像
        shared = swichOn?@"on":@"off";
        url = [NSString stringWithFormat:@"service/cameraManagement/camera/record/setcloudrecord?systemSource=%@&id=%@&command=%@",self.eqModel.system_Source,self.eqModel.equipment_id,shared];
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

