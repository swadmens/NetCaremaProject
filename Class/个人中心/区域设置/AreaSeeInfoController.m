//
//  AreaSeeInfoController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/10/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "AreaSeeInfoController.h"
#import "WWTableView.h"
#import "AddNewAreaTextFieldCell.h"
#import "RequestSence.h"

@interface AreaSeeInfoController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) WWTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation AreaSeeInfoController
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
    self.tableView.backgroundColor = kColorBackgroundColor;
    self.tableView.rowHeight = 50;
    [self.view addSubview:self.tableView];
    [self.tableView alignTop:@"10" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AddNewAreaTextFieldCell class] forCellReuseIdentifier:[AddNewAreaTextFieldCell getCellIDStr]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"区域详情";
    self.view.backgroundColor = kColorBackgroundColor;
    
    NSDictionary *dic = [WWPublicMethod objectTransFromJson:self.area_id];
    
    
    NSArray *Arr = @[
                     @{@"title":@"位置分类",@"detail":[dic objectForKey:@"name"]},
                     @{@"title":@"分类别名",@"detail":[dic objectForKey:@"nameEn"]},
                     @{@"title":@"位置信息",@"detail":[dic objectForKey:@"locationDetail"]},
                     @{@"title":@"位置别名",@"detail":[dic objectForKey:@"shortName"]}];
    [self.dataArray addObjectsFromArray:Arr];
    
    [self setupTableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    
//    if (indexPath.row == 0) {
//        AddNewAreaChooseCarmeraCell *cell = [tableView dequeueReusableCellWithIdentifier:[AddNewAreaChooseCarmeraCell getCellIDStr] forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        [cell makeCellData:dic];
//
//        return cell;
//    }else{
    AddNewAreaTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:[AddNewAreaTextFieldCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell makeCellData:dic withEdit:NO];
    
    return cell;
//    }
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
