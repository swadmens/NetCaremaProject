//
//  SingleCarmeraCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "SingleCarmeraCell.h"
#import "IndexDataModel.h"
#import <UIImageView+YYWebImage.h>

@interface SingleCarmeraCell ()

@property (nonatomic,strong) UILabel *equipmentName;
@property (nonatomic,strong) UILabel *equipmentAddress;
@property (nonatomic,strong) UILabel *equipmentStates;

@property (nonatomic,strong) UIImageView *showImageView;

@end

@implementation SingleCarmeraCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = kColorBackgroundColor;
    
    
    CGFloat backHeight = kScreenWidth*0.6;
    
    
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
//    backView.clipsToBounds = YES;
    backView.layer.cornerRadius = 5;
    backView.layer.shadowColor = UIColorFromRGB(0xB0E5E4, 1).CGColor;
    backView.layer.shadowOffset = CGSizeMake(0,3);
    backView.layer.shadowOpacity = 1;
    backView.layer.shadowRadius = 4;
    backView.layer.cornerRadius = 5;
    [self.contentView addSubview:backView];
    [backView alignTop:@"0" leading:@"15" bottom:@"10" trailing:@"15" toView:self.contentView];
    [backView addHeight:backHeight];
    
    
    
    _equipmentName = [UILabel new];
    _equipmentName.text = @"设备名称123456";
    _equipmentName.textColor = kColorMainTextColor;
    _equipmentName.font = [UIFont customFontWithSize:kFontSizeSixteen];
    [backView addSubview:_equipmentName];
    [_equipmentName leftToView:backView withSpace:12];
    [_equipmentName topToView:backView withSpace:12];
    
    
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
    _equipmentAddress.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [backView addSubview:_equipmentAddress];
    [_equipmentAddress leftToView:backView withSpace:12];
    [_equipmentAddress topToView:_equipmentName withSpace:5];
 
    
    
    UIButton *moreBtn = [UIButton new];
    [moreBtn setImage:UIImageWithFileName(@"index_more_image") forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:moreBtn];
    [moreBtn rightToView:backView withSpace:2];
    [moreBtn topToView:backView withSpace:20];
    [moreBtn addWidth:35];
    [moreBtn addHeight:25];
    
    
    
    _showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 70, kScreenWidth-30, backHeight-70)];
    _showImageView.image = [UIImage imageWithColor:[UIColor redColor]];
    // 绘制圆角 需设置的圆角 使用"|"来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_showImageView.bounds byRoundingCorners:UIRectCornerBottomLeft |
    UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    // 设置大小
    maskLayer.frame = _showImageView.bounds;
    // 设置图形样子
    maskLayer.path = maskPath.CGPath;
    _showImageView.layer.mask = maskLayer;
    [backView addSubview:_showImageView];
    
}
-(void)makeCellData:(IndexDataModel *)model
{
    _equipmentName.text = model.equipment_name;
    _equipmentStates.text = model.equipment_states;
    
    if ([model.equipment_states isEqualToString:@"离线"]) {
        _equipmentStates.backgroundColor = UIColorFromRGB(0xAEAEAE, 1);
    }else{
        _equipmentStates.backgroundColor = UIColorFromRGB(0xF39700, 1);
    }
}
-(void)moreButtonClick
{
    if (self.moreClick) {
        self.moreClick();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
