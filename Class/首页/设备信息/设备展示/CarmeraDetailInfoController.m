//
//  CarmeraDetailInfoController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/30.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "CarmeraDetailInfoController.h"
#import "WWTableView.h"
#import "WWTableViewCell.h"

@interface CarmeraDetailInfoCell : WWTableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UISwitch *switchView;
@property (nonatomic,strong) UIImageView *rightImageView;



@end



@interface CarmeraDetailInfoController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CarmeraDetailInfoController
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
    [self.tableView alignTop:@"10" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[CarmeraDetailInfoCell class] forCellReuseIdentifier:[CarmeraDetailInfoCell getCellIDStr]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"全部分组";
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
   
    
    NSArray *arr = @[@"866262045665618",@"设备程序版本",@"自定义音视频加密",@"更多设置"];
    
    [self.dataArray addObjectsFromArray:arr];
    
    
    
    
    [self setupTableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CarmeraDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[CarmeraDetailInfoCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lineHidden = NO;

    NSString *value = [self.dataArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = value;
    
    if (indexPath.row == 0) {
        cell.detailLabel.hidden = YES;
        cell.switchView.hidden = YES;
        cell.rightImageView.hidden = NO;
    }else if (indexPath.row == 1){
        cell.detailLabel.hidden = NO;
        cell.switchView.hidden = YES;
        cell.rightImageView.hidden = NO;
    }else if (indexPath.row == 2){
        cell.detailLabel.hidden = YES;
        cell.switchView.hidden = NO;
        cell.rightImageView.hidden = YES;
    }else{
        cell.detailLabel.hidden = YES;
        cell.switchView.hidden = YES;
        cell.rightImageView.hidden = NO;
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        [TargetEngine controller:self pushToController:PushTargetCarmeraMoreSystem WithTargetId:nil];
    }else if (indexPath.row == 0){
        [TargetEngine controller:self pushToController:PushTargetEquimentBasicInfo WithTargetId:nil];
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
    [deleteBtn xCenterToView:footerView];
    [deleteBtn yCenterToView:footerView];
    [deleteBtn addHeight:37];
    [deleteBtn addWidth:kScreenWidth-64];
    
    
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
    DLog(@"删除设备")
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


@implementation CarmeraDetailInfoCell

-(void)dosetup
{
    [super dosetup];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"测试的";
    _titleLabel.textColor = kColorMainTextColor;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeFifty];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel topToView:self.contentView withSpace:15];
    [_titleLabel leftToView:self.contentView withSpace:15];
    [_titleLabel bottomToView:self.contentView withSpace:15];
    
    
    _rightImageView = [UIImageView new];
    _rightImageView.image = UIImageWithFileName(@"mine_right_arrows");
    [self.contentView addSubview:_rightImageView];
    [_rightImageView yCenterToView:self.contentView];
    [_rightImageView rightToView:self.contentView withSpace:15];
    
    
    _detailLabel = [UILabel new];
    _detailLabel.text = @"V1.0";
    _detailLabel.textColor = kColorThirdTextColor;
    _detailLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [self.contentView addSubview:_detailLabel];
    [_detailLabel yCenterToView:_rightImageView];
    [_detailLabel rightToView:_rightImageView withSpace:10];
    
    
    _switchView = [UISwitch new];
    _switchView.on = YES;
//    _switchView.tintColor = [UIColor redColor];
    _switchView.onTintColor = UIColorFromRGB(0x009CEA, 1);
//    _switchView.thumbTintColor = [UIColor blueColor];
//    _switchView.backgroundColor = [UIColor redColor];
    [_switchView addTarget:self action:@selector(valueChanged:) forControlEvents:(UIControlEventValueChanged)];
    [self.contentView addSubview:_switchView];
    [_switchView yCenterToView:self.contentView];
    [_switchView rightToView:self.contentView withSpace:15];
    
    
    
}
-(void)valueChanged:(UISwitch*)mySwitch
{
    [_kHUDManager showMsgInView:nil withTitle:mySwitch.on?@"1":@"0" isSuccess:YES];
}




@end
