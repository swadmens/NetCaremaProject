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

@interface ChannelDetailCell : WWTableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UISwitch *switchView;
@property (nonatomic,strong) UIImageView *rightImageView;



@end

@interface ChannelDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

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
    [self.tableView registerClass:[ChannelDetailCell class] forCellReuseIdentifier:[ChannelDetailCell getCellIDStr]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通道详情";
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
      
       
    NSArray *arr = @[@"866262045665618",@"通知",@"设备音频采集",@"设备分享",@"更多设置"];
       
    [self.dataArray addObjectsFromArray:arr];
       
    
    [self setupTableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ChannelDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[ChannelDetailCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lineHidden = NO;

    NSString *value = [self.dataArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = value;
    
    if (indexPath.row == 0) {
        cell.detailLabel.hidden = YES;
        cell.switchView.hidden = YES;
        cell.rightImageView.hidden = NO;
    }else if (indexPath.row == 1){
        cell.detailLabel.hidden = YES;
        cell.switchView.hidden = YES;
        cell.rightImageView.hidden = NO;
    }else if (indexPath.row == 2){
        cell.detailLabel.hidden = YES;
        cell.switchView.hidden = NO;
        cell.rightImageView.hidden = YES;
    }else if (indexPath.row == 3){
        cell.detailLabel.hidden = NO;
        cell.switchView.hidden = YES;
        cell.rightImageView.hidden = NO;
    }else{
        cell.detailLabel.hidden = YES;
        cell.switchView.hidden = YES;
        cell.rightImageView.hidden = NO;
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        //更多设置
        [TargetEngine controller:self pushToController:PushTargetChannelMoreSystem WithTargetId:nil];
    }else if (indexPath.row == 0){
        [TargetEngine controller:self pushToController:PushTargetEquimentBasicInfo WithTargetId:nil];
    }else if (indexPath.row == 1){
        //通知
        [TargetEngine controller:nil pushToController:PushTargetMessageNoticesDeal WithTargetId:nil];
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

@implementation ChannelDetailCell

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
    _detailLabel.text = @"无";
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

