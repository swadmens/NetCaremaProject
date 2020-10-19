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
#import "MyEquipmentsModel.h"
#import "LivingModel.h"
#import "RequestSence.h"

@interface SingleCarmeraCell ()

@property (nonatomic,strong) UILabel *equipmentName;
@property (nonatomic,strong) UILabel *equipmentAddress;
@property (nonatomic,strong) UILabel *equipmentStates;

@property (nonatomic,strong) UIImageView *showImageView;

@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) LivingModel *model;


@end

@implementation SingleCarmeraCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = kColorBackgroundColor;
    
    
    CGFloat backHeight = kScreenWidth*0.6;
    CGFloat preMaxWidth = kScreenWidth - 105;

    
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
    _equipmentName.preferredMaxLayoutWidth = preMaxWidth;
    _equipmentName.numberOfLines = 0;
    [backView addSubview:_equipmentName];
    [_equipmentName leftToView:backView withSpace:12];
    [_equipmentName topToView:backView withSpace:12];
    [_equipmentName addHeight:20];
    
    
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
    
    UIImageView *addressView = [UIImageView new];
    addressView.image = UIImageWithFileName(@"index_address_image");
    [backView addSubview:addressView];
    [addressView leftToView:backView withSpace:12];
    [addressView topToView:_equipmentName withSpace:5];
    
    _equipmentAddress = [UILabel new];
    _equipmentAddress.text = @"广东省广州市天河区信息港A座11层";
    _equipmentAddress.textColor = kColorThirdTextColor;
    _equipmentAddress.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [backView addSubview:_equipmentAddress];
    [_equipmentAddress leftToView:addressView withSpace:2];
    [_equipmentAddress yCenterToView:addressView];
    [_equipmentAddress addWidth:kScreenWidth-85];

 
    
    
    UIButton *moreBtn = [UIButton new];
    [moreBtn setImage:UIImageWithFileName(@"index_more_image") forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:moreBtn];
    [moreBtn rightToView:backView withSpace:2];
    [moreBtn topToView:backView withSpace:20];
    [moreBtn addWidth:35];
    [moreBtn addHeight:25];
    
    
    
    _showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 70, kScreenWidth-30, backHeight-70)];
    _showImageView.image = UIImageWithFileName(@"player_hoder_image");
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
    
    
    _coverView = [UIView new];
    _coverView.backgroundColor = UIColorFromRGB(0x060606, 0.55);
    [_showImageView addSubview:_coverView];
    [_coverView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:_showImageView];
    
    
    _timeLabel = [UILabel new];
    _timeLabel.text = @"2020-01-20  10:20:32";
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont customFontWithSize:kFontSizeTen];
    [_coverView addSubview:_timeLabel];
    [_timeLabel xCenterToView:_coverView];
    [_timeLabel addCenterY:-5 toView:_coverView];
    
    
    UILabel *outlineLabel = [UILabel new];
    outlineLabel.text = @"设备离线";
    outlineLabel.textColor = [UIColor whiteColor];
    outlineLabel.font = [UIFont customFontWithSize:kFontSizeTen];
    [_coverView addSubview:outlineLabel];
    [outlineLabel xCenterToView:_coverView];
    [outlineLabel bottomToView:_timeLabel withSpace:3];
    
    
    UIButton *helpBtn = [UIButton new];
    helpBtn.clipsToBounds = YES;
    helpBtn.layer.cornerRadius = 6.5;
    helpBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    helpBtn.layer.borderWidth = 0.5;
    [helpBtn setTitle:@"查看帮助" forState:UIControlStateNormal];
    [helpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [helpBtn setBGColor:UIColorFromRGB(0x949293, 1) forState:UIControlStateNormal];
    helpBtn.titleLabel.font = [UIFont customFontWithSize:8];
    [_coverView addSubview:helpBtn];
    [helpBtn xCenterToView:_coverView];
    [helpBtn topToView:_timeLabel withSpace:5];
    [helpBtn addWidth:52];
    [helpBtn addHeight:13];
    [helpBtn addTarget:self action:@selector(checkHelpClick) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)makeCellData:(IndexDataModel *)model
{
    MyEquipmentsModel *myModel = model.childDevices_info.firstObject;
    
    _equipmentName.text = model.equipment_name;
    _equipmentAddress.text = model.creationTime;
    _equipmentStates.text = model.equipment_states;

    _equipmentStates.backgroundColor = model.online?UIColorFromRGB(0xF39700, 1):UIColorFromRGB(0xAEAEAE, 1);
    [_showImageView yy_setImageWithURL:[NSURL URLWithString:myModel.model.snap] placeholder:UIImageWithFileName(@"player_hoder_image")];
    
    if (model.online) {
        self.coverView.hidden = YES;
    }else{
        self.timeLabel.text = myModel.creationTime;
        self.coverView.hidden = NO;
    }
    
}
-(void)checkHelpClick
{
    //设备离线，查看帮助
    [TargetEngine controller:nil pushToController:PushTargetEquipmentOffline WithTargetId:nil];
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
