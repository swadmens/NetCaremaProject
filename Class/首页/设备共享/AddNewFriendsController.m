//
//  AddNewFriendsController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/5/6.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "AddNewFriendsController.h"

@interface AddNewFriendsController ()<UITextFieldDelegate>

@property (nonatomic,strong) UIView *foreView;
@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong) UIButton *addButton;

@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *phoneLabel;

@end

@implementation AddNewFriendsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"添加好友";
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    [self createForeViewUI];
    [self createBackViewUI];
}
-(void)createForeViewUI
{
    _foreView = [UIView new];
    _foreView.backgroundColor = kColorBackgroundColor;
    [self.view addSubview:_foreView];
    [_foreView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    
    _phoneTextField = [UITextField new];
    _phoneTextField.delegate = self;
    _phoneTextField.placeholder = @"请输入账号/手机号";
    _phoneTextField.font = [UIFont customFontWithSize:kFontSizeFifty];
    _phoneTextField.textColor = kColorMainTextColor;
    _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneTextField.backgroundColor = [UIColor whiteColor];
    [_foreView addSubview:_phoneTextField];
    [_phoneTextField alignTop:@"10" leading:@"0" bottom:nil trailing:@"0" toView:_foreView];
    [_phoneTextField addHeight:45];
    [_phoneTextField addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    
    _addButton = [UIButton new];
    _addButton.enabled = NO;
    _addButton.clipsToBounds = YES;
    _addButton.layer.cornerRadius = 18.25;
    
//    CAGradientLayer *gl = [CAGradientLayer layer];
//    gl.frame = CGRectMake(0,0,108,36.5);
//    gl.startPoint = CGPointMake(0, 0);
//    gl.endPoint = CGPointMake(1, 0);
//    gl.locations = @[@(0.0),@(0.9)];
//    gl.colors = @[(id)UIColorFromRGB(0x00b2aa, 1).CGColor,(id)UIColorFromRGB(0x0c6cba, 1).CGColor];
//    [_addButton.layer addSublayer:gl];
    
    [_addButton setTitle:@"添加" forState:UIControlStateNormal];
    [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addButton.titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [_addButton setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xd4d4d4, 1)] forState:UIControlStateDisabled];
    [_addButton setBackgroundImage:[UIImage imageWithColor:kColorMainColor] forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_foreView addSubview:_addButton];
    [_addButton xCenterToView:_foreView];
    [_addButton topToView:_phoneTextField withSpace:25];
    [_addButton addWidth:108];
    [_addButton addHeight:36.5];
}
-(void)addButtonClick
{
//    [_kHUDManager showMsgInView:nil withTitle:@"无法找到该用户" isSuccess:YES];
    _foreView.hidden = YES;
    _backView.hidden = NO;
}

-(void)createBackViewUI
{
    _backView = [UIView new];
    _backView.hidden = YES;
    _backView.backgroundColor = kColorBackgroundColor;
    [self.view addSubview:_backView];
    [_backView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    
    
    UIView *upView = [UIView new];
    upView.backgroundColor = [UIColor whiteColor];
    [_backView addSubview:upView];
    [upView alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:_backView];
    [upView addHeight:250];
    
    
    _iconImageView = [UIImageView new];
    _iconImageView.clipsToBounds = YES;
    _iconImageView.layer.cornerRadius = 34;
    _iconImageView.image = [UIImage imageWithColor:[UIColor redColor]];
    [upView addSubview:_iconImageView];
    [_iconImageView xCenterToView:upView];
    [_iconImageView addCenterY:-28 toView:upView];
    [_iconImageView addWidth:68];
    [_iconImageView addHeight:68];
    
    
    _nameLabel = [UILabel new];
    _nameLabel.text = @"这是名称";
    _nameLabel.textColor = kColorMainTextColor;
    _nameLabel.font = [UIFont customFontWithSize:kFontSizeSixteen];
    [upView addSubview:_nameLabel];
    [_nameLabel xCenterToView:upView];
    [_nameLabel topToView:_iconImageView withSpace:15];
    
    _phoneLabel = [UILabel new];
    _phoneLabel.text = @"手机号：16653621889";
    _phoneLabel.textColor = kColorThirdTextColor;
    _phoneLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [upView addSubview:_phoneLabel];
    [_phoneLabel xCenterToView:upView];
    [_phoneLabel topToView:_nameLabel withSpace:10];
    

    UIButton *sureBtn = [UIButton new];
    sureBtn.clipsToBounds = YES;
    sureBtn.layer.cornerRadius = 18.25;

//    CAGradientLayer *gl = [CAGradientLayer layer];
//    gl.frame = CGRectMake(0,0,108,36.5);
//    gl.startPoint = CGPointMake(0, 0);
//    gl.endPoint = CGPointMake(1, 0);
//    gl.locations = @[@(0.0),@(0.9)];
//    gl.colors = @[(id)UIColorFromRGB(0x00b2aa, 1).CGColor,(id)UIColorFromRGB(0x0c6cba, 1).CGColor];
//    [sureBtn.layer addSublayer:gl];

    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [sureBtn setBackgroundImage:[UIImage imageWithColor:kColorMainColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:sureBtn];
    [sureBtn xCenterToView:_backView];
    [sureBtn topToView:upView withSpace:43.5];
    [sureBtn addWidth:108];
    [sureBtn addHeight:36.5];
    
    
}
-(void)sureButtonClick
{
    _foreView.hidden = NO;
    _backView.hidden = YES;
}




#pragma mark - UITextFieldDelegate
-(void)valueChange:(UITextField*)field
{
    _addButton.enabled = field.text.length >= 1;
  
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
