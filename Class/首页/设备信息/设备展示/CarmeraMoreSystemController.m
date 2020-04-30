//
//  CarmeraMoreSystemController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/30.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "CarmeraMoreSystemController.h"
#import "WWTableView.h"
#import "WWTableViewCell.h"

@interface CarmeraMoreSystemCell : WWTableViewCell

@property (nonatomic,strong) UILabel *titleLabel;


@end

@interface CarmeraMoreSystemController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CarmeraMoreSystemController
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
    [self.tableView alignTop:@"10" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[CarmeraMoreSystemCell class] forCellReuseIdentifier:[CarmeraMoreSystemCell getCellIDStr]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"更多设置";
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
     [self setupTableView];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CarmeraMoreSystemCell *cell = [tableView dequeueReusableCellWithIdentifier:[CarmeraMoreSystemCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

   
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    [[TCNewAlertView shareInstance] showAlert:nil message:@"确认重启设备吗？" cancelTitle:@"取消" viewController:self confirm:^(NSInteger buttonTag) {
        
        if (buttonTag == 0) {
            [_kHUDManager showMsgInView:nil withTitle:@"重启了设备" isSuccess:YES];
        }
        
        
    } buttonTitles:@"确定", nil];
    

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


@implementation CarmeraMoreSystemCell

-(void)dosetup
{
    [super dosetup];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"确认重启设备";
    _titleLabel.textColor = kColorMainTextColor;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeFifty];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel topToView:self.contentView withSpace:15];
    [_titleLabel leftToView:self.contentView withSpace:15];
    [_titleLabel bottomToView:self.contentView withSpace:15];
    
}




@end
