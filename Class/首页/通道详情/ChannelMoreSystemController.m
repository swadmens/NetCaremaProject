//
//  ChannelMoreSystemController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/10/20.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "ChannelMoreSystemController.h"
#import "MyEquipmentsModel.h"
#import "WWTableView.h"
#import "WWTableViewCell.h"
#import "RequestSence.h"

@interface ChannelMoreSystemController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) WWTableView *tableView;

@end

@interface ChannelMoreSystemCell : WWTableViewCell

@property (nonatomic,strong) UILabel *nameLabel;

@end


@implementation ChannelMoreSystemController
- (void)setupTableView
{
    self.tableView = [[WWTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = kColorBackgroundColor;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 50;
    [self.tableView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ChannelMoreSystemCell class] forCellReuseIdentifier:[ChannelMoreSystemCell getCellIDStr]];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"更多设置";
    [self setupTableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ChannelMoreSystemCell *cell = [tableView dequeueReusableCellWithIdentifier:[ChannelMoreSystemCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lineHidden = NO;

    NSArray *arr = @[@"重启设备",@"删除设备"];
    cell.nameLabel.text = [arr objectAtIndex:indexPath.row];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [[TCNewAlertView shareInstance] showAlert:nil message:@"确认重启设备吗？" cancelTitle:@"取消" viewController:self confirm:^(NSInteger buttonTag) {
            
            if (buttonTag == 0) {
                [_kHUDManager showMsgInView:nil withTitle:@"重启了设备" isSuccess:YES];
            }
        } buttonTitles:@"确定", nil];
    }else{
        [[TCNewAlertView shareInstance] showAlert:nil message:@"确认删除设备吗？" cancelTitle:@"取消" viewController:self confirm:^(NSInteger buttonTag) {
            
            if (buttonTag == 0) {
                [_kHUDManager showMsgInView:nil withTitle:@"删除了设备" isSuccess:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        } buttonTitles:@"确定", nil];
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

@implementation ChannelMoreSystemCell

-(void)dosetup
{
    [super dosetup];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.textColor = UIColorFromRGB(0xFD1616, 1);
    self.nameLabel.font = [UIFont customFontWithSize:kFontSizeFifty];
    [self.nameLabel sizeToFit];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel xCenterToView:self.contentView];
    [self.nameLabel yCenterToView:self.contentView];
    
}

@end
