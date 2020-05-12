//
//  AddNewEquipmentController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/5/12.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "AddNewEquipmentController.h"

@interface AddNewEquipmentController ()

@end

@implementation AddNewEquipmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden = YES;
    
    [self createShowUI];
    
}
-(void)backBtnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)createShowUI
{
    UIButton *backBtn = [UIButton new];
    [backBtn setImage:UIImageWithFileName(@"black_back_image") forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn topToView:self.view withSpace:30];
    [backBtn leftToView:self.view withSpace:10];
    [backBtn addWidth:30];
    [backBtn addHeight:30];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"输入设备ID添加";
    titleLabel.textColor = kColorMainTextColor;
    titleLabel.font = [UIFont customFontWithSize:kFontSizeEighTeen];
    [self.view addSubview:titleLabel];
    [titleLabel topToView:backBtn withSpace:10];
    [titleLabel leftToView:self.view withSpace:15];
    
    
    
    UILabel *subLabel = [UILabel new];
    subLabel.text = @"请在机身上找到设备ID并输入";
    subLabel.textColor = kColorMainTextColor;
    subLabel.font = [UIFont customFontWithSize:kFontSizeTen];
    [self.view addSubview:subLabel];
    [subLabel topToView:titleLabel withSpace:5];
    [subLabel leftToView:self.view withSpace:15];
    
    
//    add_device_back_image
    
    UIImageView *backImageView = [UIImageView new];
    backImageView.image = UIImageWithFileName(@"add_device_back_image");
    [self.view addSubview:backImageView];
    [backImageView xCenterToView:self.view];
    [backImageView topToView:self.view withSpace:150];
    
    
    UILabel *codeLabel = [UILabel new];
    codeLabel.text = @"设备ID:XXXXX-XXXX-XXXX-XXXX";
    codeLabel.textColor = kColorMainTextColor;
    codeLabel.font = [UIFont customFontWithSize:kFontSizeEleven];
    [backImageView addSubview:codeLabel];
    [codeLabel xCenterToView:backImageView];
    [codeLabel bottomToView:backImageView withSpace:4];
    
    
    UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 21)];
    
    UITextField *idTextField = [UITextField new];
    idTextField.leftView = leftV;
    idTextField.leftViewMode = UITextFieldViewModeAlways;
    idTextField.placeholder = @"请输入设备ID";
    idTextField.text = ![WWPublicMethod isStringEmptyText:self.device_id]?@"":self.device_id;
    idTextField.textColor = kColorMainTextColor;
    idTextField.font = [UIFont customFontWithSize:kFontSizeFifty];
    idTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    idTextField.clipsToBounds = YES;
    idTextField.layer.cornerRadius = 22.5;
    idTextField.backgroundColor = UIColorFromRGB(0xf6f6f6, 1);
    idTextField.layer.borderColor = kColorLineColor.CGColor;
    idTextField.layer.borderWidth = 0.5;
    [self.view addSubview:idTextField];
    [idTextField xCenterToView:self.view];
    [idTextField topToView:backImageView withSpace:45];
    [idTextField addHeight:45];
    [idTextField addWidth:kScreenWidth-30];
    
    [idTextField addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    UIButton *addBtn = [UIButton new];
    addBtn.clipsToBounds = YES;
    addBtn.layer.cornerRadius = 19;
    [addBtn setTitle:@"确定" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:UIImageWithFileName(@"button_back_image") forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [addBtn addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    [addBtn xCenterToView:self.view];
    [addBtn topToView:idTextField withSpace:30];
    [addBtn addWidth:kScreenWidth-30];
    [addBtn addHeight:38];
}
-(void)sureButtonClick
{
    [_kHUDManager showMsgInView:nil withTitle:self.device_id isSuccess:YES];
}
-(void)valueChange:(UITextField*)textField
{
    self.device_id = textField.text;
    
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
