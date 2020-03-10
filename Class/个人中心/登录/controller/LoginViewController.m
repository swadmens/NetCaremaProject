//
//  LoginViewController.m
//  YuLaLa
//
//  Created by 汪伟 on 2018/5/19.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "LoginViewController.h"
#import "LGXHorizontalButton.h"


@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UITextField *passwordTextField;

@property (nonatomic,strong) LGXHorizontalButton *rmButton;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = NSLocalizedString(@"registeredAccount", nil);
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
    DLog(@"登陆");
}
//记住密码
-(void)rememberKeyButtonClick
{
    DLog(@"记住密码");
    _rmButton.selected = !_rmButton.selected;
}



@end
