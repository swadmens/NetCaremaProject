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

@interface EquimentBasicInfoController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation EquimentBasicInfoController
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
    [self.tableView registerClass:[ConfigurationFileCell class] forCellReuseIdentifier:[ConfigurationFileCell getCellIDStr]];
    [self.tableView registerClass:[ConnectionMonitoringCell class] forCellReuseIdentifier:[ConnectionMonitoringCell getCellIDStr]];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTableView];
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

       return cell;
    }else{
        ConnectionMonitoringCell *cell = [tableView dequeueReusableCellWithIdentifier:[ConnectionMonitoringCell getCellIDStr] forIndexPath:indexPath];
       cell.selectionStyle = UITableViewCellSelectionStyleNone;

       return cell;
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
