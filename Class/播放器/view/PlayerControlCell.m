//
//  PlayerControlCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/5/7.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "PlayerControlCell.h"
#import "LGXVerticalButton.h"

@interface PlayerControlCell ()

@property (nonatomic,strong) UIButton *playerBtn;
@property (nonatomic,strong) UIButton *voiceBtn;
@property (nonatomic,strong) UIButton *gongGeBtn;
@property (nonatomic,strong) UIButton *clarityBtn;
@property (nonatomic,strong) UIButton *fullBtn;

@property (nonatomic,strong) LGXVerticalButton *screenshotsBtn;
@property (nonatomic,strong) LGXVerticalButton *videoBtn;
@property (nonatomic,strong) LGXVerticalButton *controlBtn;


@end



@implementation PlayerControlCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat space = kScreenWidth * 0.2;
    CGFloat bigSpace = kScreenWidth * 0.3;

    
    UIView *topView = [UIView new];
    topView.backgroundColor = UIColorFromRGB(0x585A66, 1);
    [self.contentView addSubview:topView];
    [topView alignTop:@"0" leading:@"0" bottom:@"68" trailing:@"0" toView:self.contentView];
    [topView addHeight:35];
    
    
    _gongGeBtn = [UIButton new];
    [_gongGeBtn setImage:UIImageWithFileName(@"player_gongge_image") forState:UIControlStateNormal];
    [topView addSubview:_gongGeBtn];
    [_gongGeBtn xCenterToView:topView];
    [_gongGeBtn yCenterToView:topView];
    
    
    _voiceBtn = [UIButton new];
    [_voiceBtn setImage:UIImageWithFileName(@"player_voice_image") forState:UIControlStateNormal];
    [topView addSubview:_voiceBtn];
    [_voiceBtn yCenterToView:topView];
    [_voiceBtn addCenterX:-space toView:topView];
    
    
    _clarityBtn = [UIButton new];
    [_clarityBtn setTitle:@"标清" forState:UIControlStateNormal];
    [_clarityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _clarityBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEleven];
    [topView addSubview:_clarityBtn];
    [_clarityBtn yCenterToView:topView];
    [_clarityBtn addCenterX:space toView:topView];
    
    
    _fullBtn = [UIButton new];
    [_fullBtn setImage:UIImageWithFileName(@"player_full_image") forState:UIControlStateNormal];
    [topView addSubview:_fullBtn];
    [_fullBtn yCenterToView:topView];
    [_fullBtn addCenterX:space toView:_clarityBtn];
    
    
    _playerBtn = [UIButton new];
    [_playerBtn setImage:UIImageWithFileName(@"player_full_image") forState:UIControlStateNormal];
    [topView addSubview:_playerBtn];
    [_playerBtn yCenterToView:topView];
    [_playerBtn addCenterX:-space toView:_voiceBtn];
    
        
    
    _videoBtn = [LGXVerticalButton new];
    [_videoBtn setImage:UIImageWithFileName(@"player_videos_image") forState:UIControlStateNormal];
    [_videoBtn setTitle:@"录像" forState:UIControlStateNormal];
    [_videoBtn setTitleColor:kColorSecondTextColor forState:UIControlStateNormal];
    _videoBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEight];
    [self.contentView addSubview:_videoBtn];
    [_videoBtn xCenterToView:self.contentView];
    [_videoBtn bottomToView:self.contentView withSpace:10];
    
    
    _screenshotsBtn = [LGXVerticalButton new];
    [_screenshotsBtn setImage:UIImageWithFileName(@"player_screenshots_image") forState:UIControlStateNormal];
    [_screenshotsBtn setTitle:@"截图" forState:UIControlStateNormal];
    [_screenshotsBtn setTitleColor:kColorSecondTextColor forState:UIControlStateNormal];
    _screenshotsBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEight];
    [self.contentView addSubview:_screenshotsBtn];
    [_screenshotsBtn addCenterX:-bigSpace toView:_videoBtn];
    [_screenshotsBtn yCenterToView:_videoBtn];
    
    
    _controlBtn = [LGXVerticalButton new];
    [_controlBtn setImage:UIImageWithFileName(@"player_control_image") forState:UIControlStateNormal];
    [_controlBtn setTitle:@"云台" forState:UIControlStateNormal];
    [_controlBtn setTitleColor:kColorSecondTextColor forState:UIControlStateNormal];
    _controlBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEight];
    [self.contentView addSubview:_controlBtn];
    [_controlBtn addCenterX:bigSpace toView:_videoBtn];
    [_controlBtn yCenterToView:_videoBtn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
