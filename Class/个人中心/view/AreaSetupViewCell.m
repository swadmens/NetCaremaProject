//
//  AreaSetupViewCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/10/26.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "AreaSetupViewCell.h"
#import "AreaSetupModel.h"

@interface AreaSetupViewCell ()

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *addressLabel;

@end


@implementation AreaSetupViewCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _nameLabel = [UILabel new];
    _nameLabel.text = @"位置分类";
    _nameLabel.textColor = kColorMainTextColor;
    _nameLabel.font = [UIFont customFontWithSize:kFontSizeSixteen];
    [_nameLabel sizeToFit];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel leftToView:self.contentView withSpace:15];
    [_nameLabel topToView:self.contentView withSpace:15];
    
    
    UIImageView *addressView = [UIImageView new];
    addressView.image = UIImageWithFileName(@"index_address_image");
    [self.contentView addSubview:addressView];
    [addressView leftToView:self.contentView withSpace:15];
    [addressView topToView:_nameLabel withSpace:5];
    [addressView bottomToView:self.contentView withSpace:15];

    _addressLabel = [UILabel new];
    _addressLabel.text = @"广东省广州市天河区信息港A座12层";
    _addressLabel.textColor = kColorThirdTextColor;
    _addressLabel.font = [UIFont customFontWithSize:kFontSizeEleven];
    [self.contentView addSubview:_addressLabel];
    [_addressLabel leftToView:addressView withSpace:5];
    [_addressLabel yCenterToView:addressView];
    [_addressLabel addWidth:kScreenWidth - 60];
    
    
    UIImageView *rightImageView = [UIImageView new];
    rightImageView.image = UIImageWithFileName(@"mine_right_arrows");
    [self.contentView addSubview:rightImageView];
    [rightImageView yCenterToView:self.contentView];
    [rightImageView rightToView:self.contentView withSpace:15];
    
}
-(void)makeCellData:(AreaSetupModel*)model
{
    _nameLabel.text = model.name;
    _addressLabel.text = model.locationDetail;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
