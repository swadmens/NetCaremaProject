//
//  MoreCarmerasCollectionViewCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "MoreCarmerasCollectionViewCell.h"
#import "MyEquipmentsModel.h"
#import "LivingModel.h"
#import <UIImageView+YYWebImage.h>
#import "RequestSence.h"


@interface MoreCarmerasCollectionViewCell ()

@property (nonatomic,strong) UIImageView *showImageView;
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) LivingModel *model;
@property (nonatomic,assign) BOOL isLiving;//是否直播中


@end

@implementation MoreCarmerasCollectionViewCell
-(void)doSetup
{
    [super doSetup];
    self.contentView.backgroundColor = UIColorClearColor;
    
    UIView *backView = [UIView new];
    backView.backgroundColor = UIColorFromRGB(0xf1f2f3, 1);
//    backView.clipsToBounds = YES;
    backView.layer.cornerRadius = 5;
    [self.contentView addSubview:backView];
    [backView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.contentView];

    
    CGFloat width = (kScreenWidth-55)/2;
    
    _showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width*0.625)];
    _showImageView.clipsToBounds = YES;
    _showImageView.userInteractionEnabled = YES;
    _showImageView.image = UIImageWithFileName(@"player_hoder_image");
    // 绘制圆角 需设置的圆角 使用"|"来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_showImageView.bounds byRoundingCorners:UIRectCornerTopLeft |
    UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    // 设置大小
    maskLayer.frame = _showImageView.bounds;
    // 设置图形样子
    maskLayer.path = maskPath.CGPath;
    _showImageView.layer.mask = maskLayer;
    [backView addSubview:_showImageView];
    
    
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"597654";
    _titleLabel.textColor = kColorSecondTextColor;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [backView addSubview:_titleLabel];
    [_titleLabel leftToView:backView withSpace:8];
    [_titleLabel topToView:_showImageView withSpace:8];
    [_titleLabel addWidth:width];
    
    
    UIButton *moreBtn = [UIButton new];
    [moreBtn setImage:UIImageWithFileName(@"index_more_image") forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:moreBtn];
    [moreBtn rightToView:backView];
    [moreBtn bottomToView:backView withSpace:2];
    [moreBtn addWidth:35];
    [moreBtn addHeight:25];
    
    
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
-(void)makeCellData:(LivingModel *)model withOnline:(BOOL)online
{
    self.model = model;
    _titleLabel.text = model.name;
    [_showImageView yy_setImageWithURL:[NSURL URLWithString:model.snap] placeholder:UIImageWithFileName(@"player_hoder_image")];
    
    if (online) {
        self.isLiving = YES;
        self.coverView.hidden = YES;
    }else{
        self.timeLabel.text = model.createdAt;
        self.isLiving = NO;
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
//    BOOL offline = ![WWPublicMethod isStringEmptyText:self.model.hls];
    if (self.moreBtnClick) {
        self.moreBtnClick(self.model.status);
    }
}
@end
