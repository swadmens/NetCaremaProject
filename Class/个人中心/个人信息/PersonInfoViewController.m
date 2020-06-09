//
//  PersonInfoViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/2/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "WWTableView.h"
#import "PersonInfoViewCell.h"
#import "LoginButtonCell.h"

@interface PersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) WWTableView *tableView;

@property (nonatomic,strong) NSArray *dataArray;

@property (strong, nonatomic)AVPlayer *myPlayer;//播放器
@property (strong, nonatomic)AVPlayerItem *item;//播放单元
@property (strong, nonatomic)AVPlayerLayer *playerLayer;//播放界面（layer）

@property (nonatomic, copy) void (^completionHandler)(NSString *value);


@end

@implementation PersonInfoViewController
- (void)setupTableView
{
    self.tableView = [WWTableView new];
    self.tableView.backgroundColor = kColorBackgroundColor;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 88;
    [self.view addSubview:self.tableView];
    [self.tableView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[PersonInfoViewCell class] forCellReuseIdentifier:[PersonInfoViewCell getCellIDStr]];
    [self.tableView registerClass:[LoginButtonCell class] forCellReuseIdentifier:[LoginButtonCell getCellIDStr]];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人信息";

    
    NSString *phone = [WWPublicMethod isStringEmptyText:_kUserModel.userInfo.user_phone]?_kUserModel.userInfo.user_phone:@"";
    if ([phone containsString:@"+86"]) {
        phone = [phone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    }
    
    NSArray *arr = @[@{@"title":@"昵称",@"describe":[WWPublicMethod isStringEmptyText:_kUserModel.userInfo.user_name]?_kUserModel.userInfo.user_name:@""},
                     @{@"title":@"手机号码",@"describe":phone},
                     @{@"title":@"邮箱",@"describe":[WWPublicMethod isStringEmptyText:_kUserModel.userInfo.email]?_kUserModel.userInfo.email:@""},
                     @{@"title":@"退出登录",@"describe":@"退出登录"},
                     ];
    self.dataArray = arr;
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

    if (indexPath.row == 3) {
        LoginButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:[LoginButtonCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *title = [dic objectForKey:@"title"];
        [cell makeCellData:title];
        
        cell.loginButtonClick = ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
            _kUserModel.isLogined = NO;
            [_kUserModel showLoginView];
        };
        
        return cell;
    }else{
        PersonInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PersonInfoViewCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lineHidden = NO;
        
        [cell makeCellData:dic];
        
        
        return cell;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [TargetEngine controller:nil pushToController:PushTargetMyFriendsView WithTargetId:nil];
    if (indexPath.row == 0) {
        //昵称
       
    }else if(indexPath.row == 1) {
        //手机号码
//        [TargetEngine controller:self pushToController:PushTargetAboutUsView WithTargetId:nil];
    }else if(indexPath.row == 2) {
        //邮箱
//        [TargetEngine controller:self pushToController:PushTargetAboutUsView WithTargetId:nil];
    }else{
        //更改密码
        

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
