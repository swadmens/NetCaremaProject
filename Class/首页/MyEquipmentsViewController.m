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
#import "LivingModel.h"

@interface MyEquipmentsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) WWTableView *tableView;

@end

@implementation MyEquipmentsViewController
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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorBackgroundColor;

    self.title = @"我的设备";
    [self setupTableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyEquipmentsCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyEquipmentsCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    LivingModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell makeCellData:model];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LivingModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
//    NSDictionary *dic = @{
//                          @"id":model.equipment_id,
//                          @"name":model.equipment_name,
//                          @"c8y_Notes":model.c8y_Notes,
//                          @"CameraId":model.CameraId,
//                          @"Channel":model.equipment_Channel,
//                          @"ClientId":model.ClientId,
//                          @"DeviceId":model.DeviceId,
//                          @"owner":model.owner,
//                          @"lastUpdated":model.lastUpdated,
//                          @"responseInterval":model.responseInterval,
//                         };
//    NSString *pushId = [WWPublicMethod jsonTransFromObject:dic];
//
//    [TargetEngine controller:self pushToController:PushTargetEquipmentInformation WithTargetId:pushId];
    
    [self.delegate selectCarmeraModel:model];
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
