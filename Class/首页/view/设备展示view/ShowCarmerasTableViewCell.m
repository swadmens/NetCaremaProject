//
//  ShowCarmerasTableViewCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/29.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "ShowCarmerasTableViewCell.h"
#import "MyEquipmentsModel.h"

@interface ShowCarmerasTableViewCell ()

@property (nonatomic,strong) UIImageView *titleImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *statesLabel;


@end
@implementation ShowCarmerasTableViewCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _titleImageView = [UIImageView new];
    _titleImageView.image = [UIImage imageWithColor:[UIColor redColor]];
    [self.contentView addSubview:_titleImageView];
    [_titleImageView alignTop:@"10" leading:@"15" bottom:@"10" trailing:nil toView:self.contentView];
    [_titleImageView addWidth:94.5];
    [_titleImageView addHeight:58.5];
    
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"设备名称";
    _titleLabel.textColor = kColorMainTextColor;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeSixteen];
    [_titleLabel sizeToFit];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel yCenterToView:self.contentView];
    [_titleLabel leftToView:_titleImageView withSpace:10];
    
    _statesLabel = [UILabel new];
    _statesLabel.clipsToBounds = YES;
    _statesLabel.layer.cornerRadius = 8;
    _statesLabel.text = @"在线";
    _statesLabel.textColor = [UIColor whiteColor];
    _statesLabel.backgroundColor = kColorMainColor;
    _statesLabel.textAlignment = NSTextAlignmentCenter;
    _statesLabel.font = [UIFont customFontWithSize:kFontSizeTen];
    [self.contentView addSubview:_statesLabel];
    [_statesLabel leftToView:_titleLabel withSpace:10];
    [_statesLabel yCenterToView:self.contentView];
    [_statesLabel addWidth:35];
    [_statesLabel addHeight:16];
    
    
    UILabel *lineLabel = [UILabel new];
    lineLabel.backgroundColor = kColorLineColor;
    [self.contentView addSubview:lineLabel];
    [lineLabel alignTop:@"0" leading:@"15" bottom:nil trailing:@"15" toView:self.contentView];
    [lineLabel addHeight:1];
    
    
    UIImageView *rightImageView = [UIImageView new];
    rightImageView.image = UIImageWithFileName(@"mine_right_arrows");
    [self.contentView addSubview:rightImageView];
    [rightImageView yCenterToView:self.contentView];
    [rightImageView rightToView:self.contentView withSpace:10];
    
}
-(void)makeCellData:(MyEquipmentsModel *)model
{
    _titleLabel.text = model.equipment_name;
    _statesLabel.text = model.equipment_states;
    if ([model.equipment_states isEqualToString:@"离线"]) {
        _statesLabel.backgroundColor = UIColorFromRGB(0xAEAEAE, 1);
    }else{
        _statesLabel.backgroundColor = UIColorFromRGB(0xF39700, 1);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
