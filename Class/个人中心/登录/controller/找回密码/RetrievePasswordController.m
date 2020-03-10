//
//  RetrievePasswordController.m
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/21.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "RetrievePasswordController.h"
//#import "LoginChooseCountriesCell.h"
#import "RetrievePasswordCell.h"
//#import "CountryAreaCodeController.h"
//#import "LGXThirdEngine.h"
#import "LGXSMSEngine.h"
#import "WWTableView.h"
#import "RequestSence.h"
#import "LoginButtonCell.h"
#import "ResetPwdSence.h"


@interface RetrievePasswordController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,strong) ResetPwdSence *resetSence;

@property (nonatomic,strong) NSString *phoneNum;
@property (nonatomic,strong) NSString *sendCode;
@property (nonatomic,strong) NSString *codeNum;//验证码
@property (nonatomic,strong) NSString *password;//密码
@property (nonatomic,strong) NSString *token;


@end

@implementation RetrievePasswordController

-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


-(void)setupTableView
{
    self.tableView = [[WWTableView alloc] init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView alignTop:@"60" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[RetrievePasswordCell class] forCellReuseIdentifier:[RetrievePasswordCell getCellIDStr]];
    [self.tableView registerClass:[LoginButtonCell class] forCellReuseIdentifier:[LoginButtonCell getCellIDStr]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"忘记密码";
    self.view.backgroundColor = [UIColor whiteColor];
   
    NSArray *array = @[@{@"icon":@"login_name_image",@"title":@"请输入手机号"},@{@"icon":@"password_code_image",@"title":@"请输入验证码"},@{@"icon":@"login_key_image",@"title":@"请重设密码"}];
    [self.dataArray addObjectsFromArray:array];
    
    
    
    [self setupTableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 3){
        LoginButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:[LoginButtonCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell makeCellData:@"完成"];
        [cell setLoginButtonClick:^{
            //找回密码
            [self firstChenckYanZhengMa];
        }];

        return cell;

    }else{
        RetrievePasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:[RetrievePasswordCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
        [cell makeCellData:dic withTag:indexPath.row withStyle:self.sendCode];

        cell.textFieldText = ^(NSString *text) {
            if(indexPath.row == 0){
                self.phoneNum = text;
            }else if(indexPath.row == 1){
                self.codeNum = text;
            }else{
                self.password = text;
            }
        };
        cell.sendCodeButton = ^{
            //发送验证码
            [self action_getVers];
        };
        return cell;
    }

}

#pragma mark - 获取验证码
/// 获取验证码
- (void)getVerificationCodeWithPhone:(NSString *)phoneNumber result:(SMSFinishedResultHandler)result
{
    [self.view endEditing:YES];
    
    NSString *theString = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([WWPublicMethod isNumberString:theString] == NO) { // 不是电话号码
        [_kHUDManager showMsgInView:nil withTitle:@"手机号码有误" isSuccess:NO];

        if (result) {
            result(NO);
        }
        return;
    }
    [_kHUDManager showActivityInView:nil withTitle:NSLocalizedString(@"obtaining", nil)];

    RequestSence *sence = [[RequestSence alloc] init];
    sence.pathURL = @"phonecode";

    NSMutableDictionary *parDic=[NSMutableDictionary dictionaryWithDictionary:[MyMD5 updataDic:phoneNumber]];
    [parDic setObject:@"lpwd" forKey:@"type"];

    sence.params = parDic;

    sence.successBlock = ^(id obj) {
        [_kHUDManager showSuccessInView:nil withTitle:[obj objectForKey:@"msg"] hideAfter:_kHUDDefaultHideTime onHide:nil];
        if (result) {
            result(YES);
        }
    };
    sence.errorBlock = ^(NSError *error){
        id obj = error.userInfo;
        [_kHUDManager showMsgInView:nil withTitle:[obj objectForKey:@"msg"] isSuccess:NO];
    };
    [sence sendRequest];

}
- (void)action_getVers
{
    self.sendCode = @"startSendCode";
    [self.tableView reloadData];
   
    return;
    
    [self getVerificationCodeWithPhone:self.phoneNum result:^(BOOL success) {
        if (success) {
            //开始获取验证码，并显示倒计时，在cell内进行
            self.sendCode = @"startSendCode";
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - 提交之前先检查验证码
- (void)firstChenckYanZhengMa
{
    if ([self checkWithUName:self.phoneNum andYanzheng:self.codeNum andPassword:self.password] == NO) {
        return;
    }

    RequestSence *sence = [[RequestSence alloc] init];
    sence.pathURL = @"phonecode/check";
    sence.params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                   @"phone":self.phoneNum,
                                                                   @"code" :self.codeNum,
                                                                   @"type" :@"lpwd",
                                                                   }];
    sence.successBlock = ^(id obj) {
        [_kHUDManager showSuccessInView:nil withTitle:[obj objectForKey:@"msg"] hideAfter:_kHUDDefaultHideTime onHide:nil];

        NSDictionary *dicObj=(NSDictionary*)[obj objectForKey:@"data"];

        self.token=[NSString stringWithFormat:@"%@",[dicObj objectForKey:@"token"]];
        [self resetPasswordWithUName:self.phoneNum pwd:self.password];

    };
    sence.errorBlock = ^(NSError *error){
        NSString *msg=[error.userInfo objectForKey:@"msg"];
        [_kHUDManager showMsgInView:nil withTitle:msg isSuccess:YES];
    };

    [sence sendRequest];

}
#pragma mark - 输入检测
- (BOOL)checkWithUName:(NSString *)uname andYanzheng:(NSString *)code andPassword:(NSString*)password
{
    if ([WWPublicMethod isStringEmptyText:uname] == NO) {
        [_kHUDManager showMsgInView:nil withTitle:NSLocalizedString(@"phoneNumError", nil) isSuccess:NO];
        
        return NO;
    }
    
    if ([WWPublicMethod isStringEmptyText:code] == NO) {
        [_kHUDManager showMsgInView:nil withTitle:NSLocalizedString(@"fillCode", nil) isSuccess:NO];
        return NO;
    }
    
    if ([WWPublicMethod isStringEmptyText:password] == NO || password.length < 6) { // 密码要求6位
        [_kHUDManager showMsgInView:nil withTitle:NSLocalizedString(@"keyLastSix", nil) isSuccess:NO];
        return NO;
    }
    
    return YES;
}



#pragma mark - 重置密码
- (void)resetPasswordWithUName:(NSString *)uname pwd:(NSString *)upwd
{
    [_kHUDManager showActivityInView:nil withTitle:NSLocalizedString(@"submission", nil)];
    self.resetSence.phone = uname;
    self.resetSence.token = self.token;
    self.resetSence.password = upwd;
    
    [self.resetSence sendRequest];
}

- (ResetPwdSence *)resetSence
{
    if (!_resetSence) {
        _resetSence = [[ResetPwdSence alloc] init];
        __unsafe_unretained typeof(self) weak_self = self;
        _resetSence.successBlock = ^(id obj) {
            [weak_self successedToReset:obj];
        };
        _resetSence.errorBlock = ^(NSError *error) {
            [weak_self errorToReset:error];
        };
    }
    return _resetSence;
}
- (void)successedToReset:(id)obj
{
    // 记录登录帐号
    _kUserModel.loginAcount = self.phoneNum;
    [_kHUDManager showMsgInView:nil withTitle:[obj objectForKey:@"msg"] isSuccess:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
- (void)errorToReset:(NSError *)error
{
    NSString *msg = [error.userInfo objectForKey:@"msg"];
    if (msg) {
        [_kHUDManager showMsgInView:nil withTitle:msg isSuccess:NO];
    } else {
        [_kHUDManager showFailedInView:nil withTitle:@"请求失败" hideAfter:_kHUDDefaultHideTime onHide:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
