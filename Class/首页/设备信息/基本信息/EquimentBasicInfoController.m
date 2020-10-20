//
//  EquimentBasicInfoController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/2.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "EquimentBasicInfoController.h"
#import "WWTableView.h"
#import "ConfigurationFileCell.h"
#import "ConnectionMonitoringCell.h"
#import "AddCarmeraAddressController.h"
#import "RequestSence.h"
#import "MyEquipmentsModel.h"


@interface EquimentBasicInfoController ()<UITableViewDelegate,UITableViewDataSource,AddCarmeraAddressDelegate>

@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *c8y_Notes;


@property (nonatomic,assign)BOOL isSave;

@end

@implementation EquimentBasicInfoController

- (void)setupTableView
{
    self.tableView = [[WWTableView alloc] init];
    self.tableView.backgroundColor = kColorBackgroundColor;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    [self.tableView alignTop:@"10" leading:@"0" bottom:@"10" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ConfigurationFileCell class] forCellReuseIdentifier:[ConfigurationFileCell getCellIDStr]];
    [self.tableView registerClass:[ConnectionMonitoringCell class] forCellReuseIdentifier:[ConnectionMonitoringCell getCellIDStr]];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的设备";
    self.view.backgroundColor = kColorBackgroundColor;

    
    self.name = self.model.equipment_name;
    self.c8y_Notes = self.model.c8y_Notes;
    
    [self.tableView reloadData];
    
    [self setupTableView];
    self.isSave = NO;
    
    
    //右上角按钮
    UIButton *rightBtn = [UIButton new];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font=[UIFont customFontWithSize:kFontSizeFourteen];
    [rightBtn.titleLabel setTextAlignment: NSTextAlignmentRight];
//    rightBtn.frame = CGRectMake(0, 0, 65, 40);
    [rightBtn addTarget:self action:@selector(right_clicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:rightItem];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isSave) {
        return;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ConfigurationFileCell *cell = [tableView dequeueReusableCellWithIdentifier:[ConfigurationFileCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell makeCellData:self.model];
        
        cell.textFieldName = ^(NSString * _Nonnull text) {
            self.name = text;
        };
        cell.textFieldAnnotation = ^(NSString * _Nonnull text) {
            self.c8y_Notes = text;
        };
        cell.addAddressClick = ^{
            [self.view endEditing:YES];
            AddCarmeraAddressController *vc = [AddCarmeraAddressController new];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        };
       return cell;
        
    }else{
        
        ConnectionMonitoringCell *cell = [tableView dequeueReusableCellWithIdentifier:[ConnectionMonitoringCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell makeCellData:self.model];
        
       return cell;
    }
    
}

-(void)right_clicked
{
    //上传保存
    [self upLoadInfo];
}

-(void)upLoadInfo
{
    if (![WWPublicMethod isStringEmptyText:self.name]) {
        [_kHUDManager showMsgInView:nil withTitle:@"名称不能为空" isSuccess:YES];
        return;
    }
    
    if (![WWPublicMethod isStringEmptyText:self.c8y_Notes]) {
        [_kHUDManager showMsgInView:nil withTitle:@"注释不能为空" isSuccess:YES];
        return;
    }
    
    
    NSDictionary *finalParams = @{
                                  @"name":self.name,
                                  @"c8y_Notes": self.c8y_Notes,
                                  };
        
    //提交数据
//    NSString *url = [NSString stringWithFormat:@"inventory/managedObjects/%@",[self.dicData objectForKey:@"serial"]];
    NSString *url = [NSString stringWithFormat:@"service/video/livegbs/api/v1/device/setinfo?system_Source=%@&name=%@&deviceId=%@",self.model.system_Source,self.name,self.model.equipment_id];

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:finalParams
                                                       options:0
                                                         error:nil];
    
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
//    sence.body = jsonData;
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"Received: %@", obj);
        [_kHUDManager showMsgInView:nil withTitle:@"保存成功" isSuccess:YES];
        weak_self.isSave = YES;

    };
    sence.errorBlock = ^(NSError *error) {

        [_kHUDManager hideAfter:0.1 onHide:nil];
        // 请求失败
        DLog(@"error  ==  %@",error.userInfo);
        [_kHUDManager showMsgInView:nil withTitle:@"上传失败，请重试！" isSuccess:YES];
    };
    [sence sendRequest];
}

#pragma AddCarmeraAddressDelegate
-(void)addNewAddress:(NSString *)address
{
    self.model.address = address;
    [self.tableView reloadData];
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
