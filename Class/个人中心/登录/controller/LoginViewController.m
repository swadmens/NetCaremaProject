//
//  LoginViewController.m
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/19.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "LoginViewController.h"
#import "LGXHorizontalButton.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPSessionManager.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UITextField *passwordTextField;

@property (nonatomic,strong) LGXHorizontalButton *rmButton;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.FDPrefersNavigationBarHidden=YES;
    
    
    UILabel *loginTitle = [UILabel new];
    loginTitle.text = @"登陆";
    loginTitle.textColor = kColorMainTextColor;
    loginTitle.font = [UIFont customFontWithSize:kFontSizeEighTeen];
    [self.view addSubview:loginTitle];
    [loginTitle xCenterToView:self.view];
    [loginTitle topToView:self.view withSpace:88];
    
    
    UIImageView *nameImageView = [UIImageView new];
    nameImageView.image = UIImageWithFileName(@"login_name_image");
    [self.view addSubview:nameImageView];
    [nameImageView topToView:loginTitle withSpace:88];
    [nameImageView leftToView:self.view withSpace:40];
    
    
    _nameTextField = [UITextField new];
    _nameTextField.placeholder = @"请输入账号";
    _nameTextField.textColor = kColorMainTextColor;
    _nameTextField.font = [UIFont customFontWithSize:kFontSizeFifty];
    _nameTextField.delegate = self;
    [self.view addSubview:_nameTextField];
    [_nameTextField yCenterToView:nameImageView];
    [_nameTextField leftToView:self.view withSpace:62];
    [_nameTextField addWidth:kScreenWidth-96];
    [_nameTextField addHeight:30];
    
    
    UILabel *nameLine = [UILabel new];
    nameLine.backgroundColor = UIColorFromRGB(0xe6e6e6, 1);
    [self.view addSubview:nameLine];
    [nameLine leftToView:self.view withSpace:36];
    [nameLine addWidth:kScreenWidth-72];
    [nameLine addHeight:1];
    [nameLine topToView:nameImageView withSpace:12.5];
    
    
    UIImageView *keyImageView = [UIImageView new];
    keyImageView.image = UIImageWithFileName(@"login_key_image");
    [self.view addSubview:keyImageView];
    [keyImageView topToView:nameLine withSpace:47.5];
    [keyImageView xCenterToView:nameImageView];
    
    
    _passwordTextField = [UITextField new];
    _passwordTextField.placeholder = @"请输入密码";
    _passwordTextField.textColor = kColorMainTextColor;
    _passwordTextField.font = [UIFont customFontWithSize:kFontSizeFifty];
    _passwordTextField.delegate = self;
    _passwordTextField.secureTextEntry = YES;
    [self.view addSubview:_passwordTextField];
    [_passwordTextField yCenterToView:keyImageView];
    [_passwordTextField xCenterToView:_nameTextField];
    [_passwordTextField addWidth:kScreenWidth-96];
    [_passwordTextField addHeight:30];
    
    
    UILabel *keyLine = [UILabel new];
    keyLine.backgroundColor = UIColorFromRGB(0xe6e6e6, 1);
    [self.view addSubview:keyLine];
    [keyLine leftToView:self.view withSpace:36];
    [keyLine addWidth:kScreenWidth-72];
    [keyLine addHeight:1];
    [keyLine topToView:keyImageView withSpace:12.5];
    
    
    UIButton *fgButton = [UIButton new];
    [fgButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [fgButton setTitleColor:UIColorFromRGB(0x808080, 1) forState:UIControlStateNormal];
    fgButton.titleLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    [fgButton addTarget:self action:@selector(forgetKeyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fgButton];
    [fgButton topToView:keyLine withSpace:6];
    [fgButton rightToView:self.view withSpace:45];
    [fgButton addWidth:50];
    [fgButton addHeight:30];
    
    
    //记住密码
    _rmButton = [LGXHorizontalButton new];
    [_rmButton setImage:UIImageWithFileName(@"rm_key_noselect") forState:UIControlStateNormal];
    [_rmButton setImage:UIImageWithFileName(@"rm_key_select") forState:UIControlStateSelected];
    [_rmButton setTitle:@"记住密码" forState:UIControlStateNormal];
    [_rmButton setTitleColor:UIColorFromRGB(0x808080, 1) forState:UIControlStateNormal];
    _rmButton.titleLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    [_rmButton addTarget:self action:@selector(rememberKeyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rmButton];
    [_rmButton topToView:keyLine withSpace:6];
    [_rmButton leftToView:self.view withSpace:40];
    [_rmButton addWidth:65];
    [_rmButton addHeight:30];
    
    
    
    
    //登陆按钮
    UIButton *loginButton = [UIButton new];
    [loginButton setBackgroundImage:UIImageWithFileName(@"login_backimage") forState:UIControlStateNormal];
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont customFontWithSize:kFontSizeEighTeen];
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    [loginButton xCenterToView:self.view];
    [loginButton topToView:keyLine withSpace:60];
    
    
  
}

-(void)forgetKeyButtonClick
{
    DLog(@"忘记密码");
    [TargetEngine controller:self pushToController:PushTargetRetrievePassword WithTargetId:nil];
}
//登陆按钮
-(void)loginButtonClick
{
    //登录检查
    if (![WWPublicMethod isStringEmptyText:_nameTextField.text]) {
        [_kHUDManager showMsgInView:nil withTitle:@"请输入账户" isSuccess:YES];
        return;
    }
    
    if (![WWPublicMethod isStringEmptyText:_passwordTextField.text]) {
        [_kHUDManager showMsgInView:nil withTitle:@"请输入密码" isSuccess:YES];
        return;
    }
    
    
    [_kHUDManager showActivityInView:nil withTitle:@"登录中..."];
    
    //http的get请求地址
    NSString *urlStr = @"http://ncore.iot/user/currentUser";

    NSURL *url = [NSURL URLWithString:urlStr];
    //自定义的request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //请求过期时间
    request.timeoutInterval = 10;
    //get请求
    request.HTTPMethod = @"GET";
    //配置用户名 密码
    NSString *str1 = [NSString stringWithFormat:@"%@/%@:%@",_kUserModel.userInfo.tenant_name,_nameTextField.text,_passwordTextField.text];
    //进行加密  [str base64EncodedString]使用开源Base64.h分类文件加密
    NSString *str2 = [NSString stringWithFormat:@"Basic %@",[WWPublicMethod encodeBase64:str1]];
    [request setValue:str2 forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/vnd.com.nsn.cumulocity.currentuser+json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/vnd.com.nsn.cumulocity.currentuser+json" forHTTPHeaderField:@"Accept"];

    AFHTTPRequestOperation *op=[[AFHTTPRequestOperation alloc]initWithRequest:request];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/vnd.com.nsn.cumulocity.currentuser+json",nil];
    //设置返回数据为json数据
    op.responseSerializer= [AFJSONResponseSerializer serializer];
    //发送网络请求
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"%@",responseObject);
        
//        [_kUserModel makeIm_accountWithData:responseObject];
        
        NSDictionary *uInfo = responseObject;
        
        _kUserModel.userInfo.email = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"email"]];
        _kUserModel.userInfo.firstName = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"firstName"]];
        _kUserModel.userInfo.lastPasswordChange = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"lastPasswordChange"]];
        _kUserModel.userInfo.user_self = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"self"]];
        _kUserModel.userInfo.shouldResetPassword = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"shouldResetPassword"]];
        _kUserModel.userInfo.user_id = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"id"]];
        _kUserModel.userInfo.user_name = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"userName"]];
        
        _kUserModel.userInfo.user_name = self.nameTextField.text;
        _kUserModel.userInfo.password = self.passwordTextField.text;
        _kUserModel.userInfo.savePassword = self.rmButton.selected?self.passwordTextField.text:@"";
        _kUserModel.userInfo.save_password = self.rmButton.selected;

        [_kUserModel.userInfo save];
        
        _kUserModel.isLogined = YES;
        
        [_kUserModel hideLoginViewWithBlock:nil];
        
//            // 注册推送
//            NSString *jalias = self.nameTextField.text;
//            NSString *jtags = self.nameTextField.text;
//            [self setTags:jtags andAlias:jalias];
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error);
        DLog(@"error.userInfo == %@",error.userInfo);
        
        NSString *unauthorized = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        if ([unauthorized containsString:@"401"]) {
            [_kHUDManager hideAfter:0.1 onHide:nil];
            [_kHUDManager showMsgInView:nil withTitle:@"用户名或密码错误！" isSuccess:NO];
            return ;
        }
        [self failedOperation];
    }];
    //请求完毕回到主线程
    [[NSOperationQueue mainQueue] addOperation:op];
   
}
//记住密码
-(void)rememberKeyButtonClick
{
    DLog(@"记住密码");
    _rmButton.selected = !_rmButton.selected;
}
- (void)failedOperation
{
    [_kHUDManager hideAfter:0.1 onHide:nil];
    [_kHUDManager showMsgInView:nil withTitle:@"登陆失败" isSuccess:NO];
}


@end
