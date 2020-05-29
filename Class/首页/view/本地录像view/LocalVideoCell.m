//
//  LocalVideoCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/29.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "LocalVideoCell.h"
#import "CarmeaVideosModel.h"

@interface LocalVideoCell ()

@property (nonatomic,strong) UIImageView *showImageView;
@property (nonatomic,strong) UILabel *titleLabel;//名称
@property (nonatomic,strong) UILabel *timeLabel;//时间

@end

@implementation LocalVideoCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    [backView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.contentView];
    [backView addHeight:80];
    
    
    _showImageView = [UIImageView new];
    _showImageView.userInteractionEnabled = YES;
    _showImageView.image = UIImageWithFileName(@"player_hoder_image");
    [backView addSubview:_showImageView];
    [_showImageView alignTop:@"10" leading:@"15" bottom:@"10" trailing:nil toView:backView];
    [_showImageView addWidth:95];
   
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"这是测试名称这是测试名称这是测试名称这是测试名称这是测试名称";
    _titleLabel.textColor = kColorMainTextColor;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeSixteen];
    [backView addSubview:_titleLabel];
    [_titleLabel leftToView:_showImageView withSpace:10];
    [_titleLabel topToView:backView withSpace:18];
    [_titleLabel addWidth:kScreenWidth-140];

    
    _timeLabel = [UILabel new];
    _timeLabel.text = @"2020-02-26 14:31:42";
    _timeLabel.textColor = kColorThirdTextColor;
    _timeLabel.font = [UIFont customFontWithSize:kFontSizeTen];
    [backView addSubview:_timeLabel];
    [_timeLabel leftToView:_showImageView withSpace:10];
    [_timeLabel topToView:_titleLabel withSpace:5];
    [_timeLabel addWidth:kScreenWidth-195];
    
    
    UIButton *rightBtn = [UIButton new];
    [rightBtn setImage:UIImageWithFileName(@"index_right_image") forState:UIControlStateNormal];
    [backView addSubview:rightBtn];
    [rightBtn rightToView:backView withSpace:8];
    [rightBtn yCenterToView:backView];
    [rightBtn addWidth:15];
    [rightBtn addHeight:25];
    
}
-(void)makeCellData:(CarmeaVideosModel *)model
{
    _titleLabel.text = model.video_name;
    _timeLabel.text = model.start_time;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
