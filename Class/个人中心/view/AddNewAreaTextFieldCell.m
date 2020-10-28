//
//  AddNewAreaTextFieldCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/10/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "AddNewAreaTextFieldCell.h"

@interface AddNewAreaTextFieldCell ()<UITextFieldDelegate>

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UITextField *nameTextField;

@end

@implementation AddNewAreaTextFieldCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = kColorMainTextColor;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeSixteen];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel leftToView:self.contentView withSpace:20];
    [_titleLabel yCenterToView:self.contentView];
    
    
    
    _nameTextField = [UITextField new];
    _nameTextField.delegate = self;
    _nameTextField.font = [UIFont customFontWithSize:kFontSizeFourteen];
    _nameTextField.textColor = kColorThirdTextColor;
    [self.contentView addSubview:_nameTextField];
    [_nameTextField yCenterToView:_titleLabel];
    [_nameTextField leftToView:self.contentView withSpace:105];
    [_nameTextField rightToView:self.contentView withSpace:15];
    [_nameTextField addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    
}
-(void)makeCellData:(NSDictionary*)dic
{
    _titleLabel.text = [dic objectForKey:@"title"];
    NSString *detail = [dic objectForKey:@"detail"];
    if ([detail hasPrefix:@"请输入"]) {
        _nameTextField.placeholder = [dic objectForKey:@"detail"];
    }else{
        _nameTextField.text = [dic objectForKey:@"detail"];
    }
    
    BOOL isEdit = [[dic objectForKey:@"isedit"] boolValue];
    _nameTextField.enabled = isEdit;
    

}
#pragma mark - UITextFieldDelegate
-(void)valueChange:(UITextField*)field
{
    if (self.textFieldValue) {
        self.textFieldValue(field.text);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
