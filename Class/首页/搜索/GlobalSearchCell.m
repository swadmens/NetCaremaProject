//
//  GlobalSearchCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/5/7.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "GlobalSearchCell.h"

@interface GlobalSearchCell ()

@property (nonatomic,strong) UILabel *equipmentName;
@property (nonatomic,strong) UILabel *equipmentAddress;
@property (nonatomic,strong) UILabel *equipmentStates;

@property (nonatomic,strong) UIImageView *showImageView;

@end

@implementation GlobalSearchCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    
    _showImageView = [UIImageView new];
    _showImageView.image = [UIImage imageWithColor:[UIColor redColor]];
    [self.contentView addSubview:_showImageView];
    [_showImageView topToView:self.contentView withSpace:10];
    [_showImageView leftToView:self.contentView withSpace:15];
    [_showImageView bottomToView:self.contentView withSpace:10];
    [_showImageView addWidth:94.5];
    [_showImageView addHeight:58.5];
    
    
    
    _equipmentName = [UILabel new];
    _equipmentName.text = @"设备名称123456";
    _equipmentName.textColor = kColorMainTextColor;
    _equipmentName.font = [UIFont customFontWithSize:kFontSizeSixteen];
    [self.contentView addSubview:_equipmentName];
    [_equipmentName leftToView:_showImageView withSpace:10];
    [_equipmentName addCenterY:-14 toView:self.contentView];
    
    
    _equipmentStates = [UILabel new];
//    _equipmentStates.text = @"在线";
    _equipmentStates.text = @"离线";
    _equipmentStates.textAlignment = NSTextAlignmentCenter;
    _equipmentStates.font = [UIFont customFontWithSize:kFontSizeTen];
    _equipmentStates.textColor = [UIColor whiteColor];
//    _equipmentStates.backgroundColor = UIColorFromRGB(0xF39700, 1);
    _equipmentStates.backgroundColor = UIColorFromRGB(0xAEAEAE, 1);
    _equipmentStates.clipsToBounds = YES;
    _equipmentStates.layer.cornerRadius = 2;
    [self.contentView addSubview:_equipmentStates];
    [_equipmentStates yCenterToView:_equipmentName];
    [_equipmentStates leftToView:_equipmentName withSpace:5];
    [_equipmentStates addWidth:30];
    [_equipmentStates addHeight:16];
    
    UIImageView *addressView = [UIImageView new];
    addressView.image = UIImageWithFileName(@"index_address_image");
    [self.contentView addSubview:addressView];
    [addressView leftToView:_showImageView withSpace:10];
    [addressView addCenterY:8 toView:self.contentView];
    
    _equipmentAddress = [UILabel new];
    _equipmentAddress.text = @"广东省广州市天河区信息港A座11层";
    _equipmentAddress.textColor = kColorThirdTextColor;
    _equipmentAddress.font = [UIFont customFontWithSize:kFontSizeTen];
    [self.contentView addSubview:_equipmentAddress];
    [_equipmentAddress leftToView:addressView withSpace:2];
    [_equipmentAddress yCenterToView:addressView];
    [_equipmentAddress addWidth:kScreenWidth-155];
 
    
    
    UIImageView *rightImageView = [UIImageView new];
    rightImageView.image = UIImageWithFileName(@"mine_right_arrows");
    [self.contentView addSubview:rightImageView];
    [rightImageView yCenterToView:self.contentView];
    [rightImageView rightToView:self.contentView withSpace:15];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
