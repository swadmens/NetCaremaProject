//
//  IndexTableViewCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/2/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "IndexTableViewCell.h"
#import "IndexDataModel.h"


@interface IndexTableViewCell ()

@property (nonatomic,strong) UILabel *equipmentName;
@property (nonatomic,strong) UILabel *equipmentAddress;
@property (nonatomic,strong) UILabel *equipmentStates;


@end

@implementation IndexTableViewCell

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
    [backView addHeight:65.5];
    [backView addWidth:kScreenWidth-28];
    
    
    _equipmentName = [UILabel new];
    _equipmentName.text = @"设备名称123456";
    _equipmentName.textColor = kColorMainTextColor;
    _equipmentName.font = [UIFont customFontWithSize:kFontSizeSixteen];
    [backView addSubview:_equipmentName];
    [_equipmentName leftToView:backView withSpace:12];
    [_equipmentName addCenterY:-10 toView:backView];
    
    
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
    [backView addSubview:_equipmentStates];
    [_equipmentStates topToView:backView withSpace:8];
    [_equipmentStates leftToView:_equipmentName withSpace:5];
    [_equipmentStates addWidth:30];
    [_equipmentStates addHeight:16];
    
    
    
    
    _equipmentAddress = [UILabel new];
    _equipmentAddress.text = @"广东省广州市天河区信息港A座11层";
    _equipmentAddress.textColor = kColorThirdTextColor;
    _equipmentAddress.font = [UIFont customFontWithSize:11];
    [backView addSubview:_equipmentAddress];
    [_equipmentAddress leftToView:backView withSpace:12];
    [_equipmentAddress addCenterY:10 toView:backView];
    
    
    
    
    
    
    
    UILabel *lineLabel = [UILabel new];
    lineLabel.backgroundColor = UIColorFromRGB(0xCCCCCC, 1);
    [backView addSubview:lineLabel];
    [lineLabel yCenterToView:backView];
    [lineLabel rightToView:backView withSpace:70];
    [lineLabel addWidth:1];
    [lineLabel addHeight:33.5];
    
    
    UILabel *detailLabel = [UILabel new];
    detailLabel.text = @"查看详情";
    detailLabel.textColor = UIColorFromRGB(0x04C0BC, 1);
    detailLabel.font = [UIFont customFontWithSize:11];
    [backView addSubview:detailLabel];
    [detailLabel yCenterToView:backView];
    [detailLabel leftToView:lineLabel withSpace:12];
    
    
    
    
    
    
    
}
-(void)makeCellData:(IndexDataModel *)model
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
