//
//  MessageNoticesDealController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/30.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "MessageNoticesDealController.h"
#import "WWTableView.h"
#import "WWTableViewCell.h"

@interface MessageNoticesDealCell : WWTableViewCell

@end

@interface MessageNoticesDealController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) WWTableView *tableView;

@end

@implementation MessageNoticesDealController

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
    [self.tableView registerClass:[MessageNoticesDealCell class] forCellReuseIdentifier:[MessageNoticesDealCell getCellIDStr]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通知";
    self.view.backgroundColor = kColorBackgroundColor;
    
    [self setupTableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MessageNoticesDealCell *cell = [tableView dequeueReusableCellWithIdentifier:[MessageNoticesDealCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    return cell;
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




@implementation MessageNoticesDealCell

-(void)dosetup
{
    [super dosetup];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"报警消息提醒";
    titleLabel.textColor = kColorMainTextColor;
    titleLabel.font = [UIFont customFontWithSize:kFontSizeFifty];
    [self.contentView addSubview:titleLabel];
    [titleLabel topToView:self.contentView withSpace:15];
    [titleLabel leftToView:self.contentView withSpace:15];
    [titleLabel bottomToView:self.contentView withSpace:15];
    
    
    UISwitch *switchView = [UISwitch new];
    switchView.on = YES;
//    switchView.tintColor = [UIColor redColor];
    switchView.onTintColor = UIColorFromRGB(0x009CEA, 1);
//    switchView.thumbTintColor = [UIColor blueColor];
//    switchView.backgroundColor = [UIColor redColor];
    [switchView addTarget:self action:@selector(valueChanged:) forControlEvents:(UIControlEventValueChanged)];
    [self.contentView addSubview:switchView];
    [switchView yCenterToView:self.contentView];
    [switchView rightToView:self.contentView withSpace:15];

    
}
-(void)valueChanged:(UISwitch*)mySwitch
{
    [_kHUDManager showMsgInView:nil withTitle:mySwitch.on?@"1":@"0" isSuccess:YES];
}

@end
