//
//  MyEquipmentsCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/2/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "MyEquipmentsCell.h"
#import "MyEquipmentsModel.h"


@interface MyEquipmentsCell ()

@property (nonatomic,strong) UILabel *equipmentName;
@property (nonatomic,strong) UILabel *equipmentDeatil;
@property (nonatomic,strong) UILabel *equipmentStates;


@end

@implementation MyEquipmentsCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = kColorBackgroundColor;
    
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    backView.clipsToBounds = YES;
    backView.layer.cornerRadius = 5;
    backView.layer.shadowColor = UIColorFromRGB(0xB0E5E4, 1).CGColor;
    backView.layer.shadowOffset = CGSizeMake(0,3);
    backView.layer.shadowOpacity = 1;
    backView.layer.shadowRadius = 4;
    backView.layer.cornerRadius = 5;
    [self.contentView addSubview:backView];
    [backView topToView:self.contentView withSpace:0];
    [backView leftToView:self.contentView withSpace:14];
    [backView bottomToView:self.contentView withSpace:10];
    [backView addHeight:53.5];
    [backView addWidth:kScreenWidth-28];
    
    
    _equipmentName = [UILabel new];
    _equipmentName.text = @"LiveNVP官网演示";
    _equipmentName.textColor = kColorSecondTextColor;
    _equipmentName.font = [UIFont customFontWithSize:kFontSizeTen];
    [backView addSubview:_equipmentName];
    [_equipmentName leftToView:backView withSpace:12];
    [_equipmentName yCenterToView:backView];
    
    
    
    _equipmentDeatil = [UILabel new];
    _equipmentDeatil.text = @"channer100";
    _equipmentDeatil.textColor = kColorMainTextColor;
    _equipmentDeatil.font = [UIFont customFontWithSize:kFontSizeSixteen];
    [backView addSubview:_equipmentDeatil];
    [_equipmentDeatil centerToView:backView];
    
    
    _equipmentStates = [UILabel new];
    _equipmentStates.text = @"在线";
//    _equipmentStates.text = @"离线";
    _equipmentStates.textAlignment = NSTextAlignmentCenter;
    _equipmentStates.font = [UIFont customFontWithSize:kFontSizeTen];
    _equipmentStates.textColor = [UIColor whiteColor];
    _equipmentStates.backgroundColor = UIColorFromRGB(0xF39700, 1);
//    _equipmentStates.backgroundColor = UIColorFromRGB(0xAEAEAE, 1);
    _equipmentStates.clipsToBounds = YES;
    _equipmentStates.layer.cornerRadius = 2;
    [backView addSubview:_equipmentStates];
    [_equipmentStates yCenterToView:backView];
    [_equipmentStates rightToView:backView withSpace:25];
    [_equipmentStates addWidth:30];
    [_equipmentStates addHeight:16];
    
    
    
    
    
}
-(void)makeCellData:(MyEquipmentsModel *)model
{
    _equipmentName.text = model.equipment_name;
    _equipmentDeatil.text = model.equipment_Channel;
    _equipmentStates.text = model.equipment_states;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
