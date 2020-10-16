//
//  ChannelDetailCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/10/15.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "ChannelDetailCell.h"

@interface ChannelDetailCell ()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UISwitch *switchView;

@property (nonatomic,assign) NSInteger indexRow;
//@property (nonatomic,strong) SingleEquipmentModel *myModel;


@end
@implementation ChannelDetailCell

-(void)dosetup
{
    [super dosetup];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"测试的";
    _titleLabel.textColor = kColorMainTextColor;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeFifty];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel leftToView:self.contentView withSpace:15];
    [_titleLabel topToView:self.contentView withSpace:15];
    [_titleLabel bottomToView:self.contentView withSpace:15];
    
    _detailLabel = [UILabel new];
    _detailLabel.text = @"无";
    _detailLabel.textColor = kColorThirdTextColor;
    _detailLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [self.contentView addSubview:_detailLabel];
    [_detailLabel yCenterToView:self.contentView];
    [_detailLabel rightToView:self.contentView withSpace:15];
    
    
    _switchView = [UISwitch new];
    _switchView.on = YES;
//    _switchView.tintColor = [UIColor redColor];
    _switchView.onTintColor = UIColorFromRGB(0x009CEA, 1);
//    _switchView.thumbTintColor = [UIColor blueColor];
//    _switchView.backgroundColor = [UIColor redColor];
    [_switchView addTarget:self action:@selector(valueChanged:) forControlEvents:(UIControlEventValueChanged)];
    [self.contentView addSubview:_switchView];
    [_switchView yCenterToView:self.contentView];
    [_switchView rightToView:self.contentView withSpace:15];
    
    
    
}
-(void)valueChanged:(UISwitch*)mySwitch
{
    if (_switchChange) {
        self.switchChange(mySwitch.on);
    }
}
-(void)makeCellData:(NSInteger)indexRow withData:(NSDictionary*)dic
{
    _titleLabel.text = [dic objectForKey:@"name"];
    _detailLabel.text = [dic objectForKey:@"detail"];
    _switchView.on = [[dic objectForKey:@"value"] boolValue];
    _switchView.hidden = ![[dic objectForKey:@"showSwitch"] boolValue];
    _detailLabel.hidden = [[dic objectForKey:@"showSwitch"] boolValue];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
