//
//  MineViewController.m
//  YanGang
//
//  Created by 汪伟 on 2018/11/7.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "MineViewController.h"
#import "WWTableView.h"
#import "MineTableViewCell.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isHadFirst; // 是否第一次加载了
}
@property (nonatomic, strong) WWTableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UILabel *user_name;
@property (nonatomic,strong) UILabel *user_phone;

@end

@implementation MineViewController
-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationItem.leftBarButtonItem=nil;
    self.FDPrefersNavigationBarHidden = YES;
    
    NSArray *arr = @[@{@"icon":@"mine_system_image",@"title":@"用户设置",@"describe":@""},
                     @{@"icon":@"mine_download_image",@"title":@"我的下载",@"describe":@""},
//                     @{@"icon":@"mine_download_image",@"title":@"我的消息",@"describe":@""},
    ];
    [self.dataArray addObjectsFromArray:arr];
        
    [self creadTopView];
}

-(void)creadTopView
{
    UIImageView *topImageView = [UIImageView new];
    topImageView.image = UIImageWithFileName(@"mine_top_backimage");
    [self.view addSubview:topImageView];
    [topImageView alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:self.view];
    [topImageView addHeight:130];
    
    UILabel *titleLabel = [UILabel new];
    [titleLabel sizeToFit];
    titleLabel.text = @"个人中心";
    titleLabel.textColor = UIColorFromRGB(0xfefefe, 1);
    titleLabel.font = [UIFont customFontWithSize:kFontSizeSixteen];
    [topImageView addSubview:titleLabel];
    [titleLabel xCenterToView:topImageView];
    [titleLabel topToView:topImageView withSpace:34];
    
    
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.layer.shadowColor = UIColorFromRGB(0x000000, 0.1).CGColor;
    cardView.layer.shadowOffset = CGSizeMake(0,3);
    cardView.layer.shadowOpacity = 1;
    cardView.layer.shadowRadius = 5;
    cardView.layer.cornerRadius = 10;
    [self.view addSubview:cardView];
    [cardView alignTop:@"80" leading:@"15" bottom:nil trailing:@"15" toView:self.view];
    [cardView addHeight:98.5];
    
    
    UIImageView *headerImage = [UIImageView new];
    headerImage.image = UIImageWithFileName(@"mine_header_image");
    [cardView addSubview:headerImage];
    [headerImage yCenterToView:cardView];
    [headerImage leftToView:cardView withSpace:15];
    
    
    _user_name = [UILabel new];
    _user_name.textColor = kColorMainTextColor;
    _user_name.font = [UIFont customFontWithSize:kFontSizeEighTeen];
    [_user_name sizeToFit];
    [cardView addSubview:_user_name];
    [_user_name leftToView:headerImage withSpace:10];
    [_user_name addCenterY:-12 toView:cardView];
    
    
    _user_phone = [UILabel new];
    _user_phone.textColor = kColorThirdTextColor;
    _user_phone.font = [UIFont customFontWithSize:kFontSizeTwelve];
    [_user_phone sizeToFit];
    [cardView addSubview:_user_phone];
    [_user_phone leftToView:headerImage withSpace:10];
    [_user_phone addCenterY:12 toView:cardView];
    
    
    @weakify(self);
    /// 用户名变化监听
    [RACObserve(_kUserModel.userInfo, user_name) subscribeNext:^(id x) {
        @strongify(self);
        self.user_name.text = x;
    }];
    /// 手机号变化监听
    [RACObserve(_kUserModel.userInfo, user_phone) subscribeNext:^(id x) {
        @strongify(self);
        NSString *phone = x;
        if ([phone containsString:@"+86"]) {
            self.user_phone.text = [phone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        }else{
            self.user_phone.text = phone;
        }
    }];
    

    self.tableView = [WWTableView new];
    self.tableView.backgroundColor = kColorBackgroundColor;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 88;
    [self.view addSubview:self.tableView];
    [self.tableView topToView:cardView withSpace:15];
    [self.tableView bottomToView:self.view];
    [self.tableView leftToView:self.view];
    [self.tableView addWidth:kScreenWidth];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[MineTableViewCell class] forCellReuseIdentifier:[MineTableViewCell getCellIDStr]];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MineTableViewCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    [cell makeCellData:dic];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        //个人信息
        [TargetEngine controller:self pushToController:PushTargetPersonInfoView WithTargetId:nil];

    }else if (indexPath.row == 1){
        //下载列表
        [TargetEngine controller:self pushToController:PushTargetDownloadList WithTargetId:nil];
    }else{
        //我的消息
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
