//
//  PlayerControlCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/5/7.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "PlayerControlCell.h"
#import "LGXVerticalButton.h"
#import "EquipmentAbilityModel.h"

@interface PlayerControlCell ()

@property (nonatomic,strong) UIButton *playerBtn;
@property (nonatomic,strong) UIButton *voiceBtn;
@property (nonatomic,strong) UIButton *gongGeBtn;
@property (nonatomic,strong) UIButton *clarityBtn;
@property (nonatomic,strong) UIButton *fullBtn;

@property (nonatomic,strong) LGXVerticalButton *screenshotsBtn;
@property (nonatomic,strong) LGXVerticalButton *videoBtn;
@property (nonatomic,strong) LGXVerticalButton *controlBtn;
@property (nonatomic,strong) LGXVerticalButton *talkBtn;


@end



@implementation PlayerControlCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat space = kScreenWidth * 0.2;
    CGFloat bigSpace = kScreenWidth * 0.25;

    
    CGFloat btnWidth = 30;
    
    
    UIView *topView = [UIView new];
    topView.backgroundColor = UIColorFromRGB(0x585A66, 1);
    [self.contentView addSubview:topView];
    [topView alignTop:@"0" leading:@"0" bottom:@"68" trailing:@"0" toView:self.contentView];
    [topView addHeight:35];
    
    
    _gongGeBtn = [UIButton new];
    [_gongGeBtn setImage:UIImageWithFileName(@"player_gongge_image") forState:UIControlStateNormal];
    [_gongGeBtn setImage:UIImageWithFileName(@"player_gongge_select_image") forState:UIControlStateSelected];
    [_gongGeBtn setImage:UIImageWithFileName(@"player_gongge_select_image") forState:UIControlStateDisabled];
    [topView addSubview:_gongGeBtn];
    [_gongGeBtn xCenterToView:topView];
    [_gongGeBtn yCenterToView:topView];
    [_gongGeBtn addTarget:self action:@selector(gongGeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_gongGeBtn addWidth:btnWidth];
    [_gongGeBtn addHeight:btnWidth];
    
    
    _voiceBtn = [UIButton new];
    [_voiceBtn setImage:UIImageWithFileName(@"player_voice_image") forState:UIControlStateNormal];
    [_voiceBtn setImage:UIImageWithFileName(@"player_voice_select_image") forState:UIControlStateSelected];
    [topView addSubview:_voiceBtn];
    [_voiceBtn yCenterToView:topView];
    [_voiceBtn addCenterX:-space toView:topView];
    [_voiceBtn addTarget:self action:@selector(voiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_voiceBtn addWidth:btnWidth];
    [_voiceBtn addHeight:btnWidth];
    
    _clarityBtn = [UIButton new];
    [_clarityBtn setTitle:@"标清" forState:UIControlStateNormal];
    [_clarityBtn setTitle:@"高清" forState:UIControlStateSelected];
    [_clarityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_clarityBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    _clarityBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEleven];
    [topView addSubview:_clarityBtn];
    [_clarityBtn yCenterToView:topView];
    [_clarityBtn addCenterX:space toView:topView];
    [_clarityBtn addTarget:self action:@selector(clarityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_clarityBtn addWidth:btnWidth];
    [_clarityBtn addHeight:btnWidth];
    
    _fullBtn = [UIButton new];
    [_fullBtn setImage:UIImageWithFileName(@"player_full_image") forState:UIControlStateNormal];
    [topView addSubview:_fullBtn];
    [_fullBtn yCenterToView:topView];
    [_fullBtn addCenterX:space toView:_clarityBtn];
    [_fullBtn addTarget:self action:@selector(fullBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_fullBtn addWidth:btnWidth];
    [_fullBtn addHeight:btnWidth];
    
    _playerBtn = [UIButton new];
    [_playerBtn setImage:UIImageWithFileName(@"player_play_select_image") forState:UIControlStateNormal];
    [_playerBtn setImage:UIImageWithFileName(@"player_play_image") forState:UIControlStateSelected];
    [topView addSubview:_playerBtn];
    [_playerBtn yCenterToView:topView];
    [_playerBtn addCenterX:-space toView:_voiceBtn];
    [_playerBtn addTarget:self action:@selector(playerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_playerBtn addWidth:btnWidth];
    [_playerBtn addHeight:btnWidth];
        
    
    _videoBtn = [LGXVerticalButton new];
    [_videoBtn setImage:UIImageWithFileName(@"player_videos_image") forState:UIControlStateNormal];
    [_videoBtn setImage:UIImageWithFileName(@"player_videos_select_image") forState:UIControlStateSelected];
    [_videoBtn setImage:UIImageWithFileName(@"player_videos_disabled_image") forState:UIControlStateDisabled];
    [_videoBtn setTitle:@"录像" forState:UIControlStateNormal];
    [_videoBtn setTitleColor:kColorSecondTextColor forState:UIControlStateNormal];
    _videoBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEight];
    [self.contentView addSubview:_videoBtn];
    [_videoBtn addCenterX:-bigSpace/2 toView:self.contentView];
    [_videoBtn bottomToView:self.contentView withSpace:15];
    [_videoBtn addTarget:self action:@selector(videoBtnClick:) forControlEvents:UIControlEventTouchUpInside];


    
    _screenshotsBtn = [LGXVerticalButton new];
    [_screenshotsBtn setImage:UIImageWithFileName(@"player_screenshots_image") forState:UIControlStateNormal];
    [_screenshotsBtn setImage:UIImageWithFileName(@"player_screenshots_select_image") forState:UIControlStateSelected];
    [_screenshotsBtn setImage:UIImageWithFileName(@"player_screenshots_disabled_image") forState:UIControlStateDisabled];
    [_screenshotsBtn setTitle:@"截图" forState:UIControlStateNormal];
    [_screenshotsBtn setTitleColor:kColorSecondTextColor forState:UIControlStateNormal];
    _screenshotsBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEight];
    [self.contentView addSubview:_screenshotsBtn];
    [_screenshotsBtn addCenterX:-bigSpace toView:_videoBtn];
    [_screenshotsBtn yCenterToView:_videoBtn];
    [_screenshotsBtn addTarget:self action:@selector(screenshotsBtnClick:) forControlEvents:UIControlEventTouchUpInside];


    
    _controlBtn = [LGXVerticalButton new];
    [_controlBtn setImage:UIImageWithFileName(@"player_control_image") forState:UIControlStateNormal];
    [_controlBtn setImage:UIImageWithFileName(@"player_control_select_image") forState:UIControlStateSelected];
    [_controlBtn setImage:UIImageWithFileName(@"player_control_disabled_image") forState:UIControlStateDisabled];
    [_controlBtn setTitle:@"云台" forState:UIControlStateNormal];
    [_controlBtn setTitleColor:kColorSecondTextColor forState:UIControlStateNormal];
    _controlBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEight];
    [self.contentView addSubview:_controlBtn];
    [_controlBtn addCenterX:bigSpace toView:_videoBtn];
    [_controlBtn yCenterToView:_videoBtn];
    [_controlBtn addTarget:self action:@selector(controlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _talkBtn = [LGXVerticalButton new];
    [_talkBtn setImage:UIImageWithFileName(@"player_talkback_image") forState:UIControlStateNormal];
    [_talkBtn setImage:UIImageWithFileName(@"player_talkback_select_image") forState:UIControlStateSelected];
    [_talkBtn setImage:UIImageWithFileName(@"player_talkback_disabled_image") forState:UIControlStateDisabled];
    [_talkBtn setTitle:@"对讲" forState:UIControlStateNormal];
    [_talkBtn setTitleColor:kColorSecondTextColor forState:UIControlStateNormal];
    _talkBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEight];
    [self.contentView addSubview:_talkBtn];
    [_talkBtn addCenterX:bigSpace toView:_controlBtn];
    [_talkBtn yCenterToView:_videoBtn];
    [_talkBtn addTarget:self action:@selector(talkBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)makeCellData:(BOOL)isLiving withAbility:(EquipmentAbilityModel*)model
{
    CGFloat bigSpace = kScreenWidth * 0.25;
    
    if (isLiving) {
        _controlBtn.hidden = NO;
        _talkBtn.hidden = NO;
        _controlBtn.enabled = model.ptz;
        _gongGeBtn.enabled = YES;
        
        _videoBtn.enabled = YES;
//        _screenshotsBtn.enabled = YES;
        _clarityBtn.enabled = YES;

//        [_videoBtn lgx_remakeConstraints:^(LGXLayoutMaker *make) {
//            make.xCenter.lgx_equalTo(self.contentView.lgx_xCenter).lgx_floatOffset(-bigSpace/2);
//            make.bottomEdge.lgx_equalTo(self.contentView.lgx_bottomEdge).lgx_floatOffset(-15);
//        }];
//
//        [_screenshotsBtn lgx_remakeConstraints:^(LGXLayoutMaker *make) {
//            make.xCenter.lgx_equalTo(self.videoBtn.lgx_xCenter).lgx_floatOffset(-bigSpace);
//            make.yCenter.lgx_equalTo(self.videoBtn.lgx_yCenter);
//        }];
        
    }else{
//        _controlBtn.hidden = YES;
//        _talkBtn.hidden = YES;
        _gongGeBtn.selected = YES;
        _gongGeBtn.enabled = NO;
        
        _videoBtn.enabled = NO;
//        _screenshotsBtn.enabled = NO;
        _clarityBtn.enabled = NO;
        _controlBtn.enabled = NO;
        _talkBtn.enabled = NO;

//        [_videoBtn lgx_remakeConstraints:^(LGXLayoutMaker *make) {
//            make.xCenter.lgx_equalTo(self.contentView.lgx_xCenter).lgx_floatOffset(40);
//            make.bottomEdge.lgx_equalTo(self.contentView.lgx_bottomEdge).lgx_floatOffset(-15);
//        }];
//
//        [_screenshotsBtn lgx_remakeConstraints:^(LGXLayoutMaker *make) {
//            make.xCenter.lgx_equalTo(self.contentView.lgx_xCenter).lgx_floatOffset(-40);
//            make.yCenter.lgx_equalTo(self.videoBtn.lgx_yCenter);
//        }];
    }
}

-(void)gongGeBtnClick:(UIButton*)sender
{
    [self.delegate playerControlwithState:videoSateGongge withButton:sender];
}
-(void)voiceBtnClick:(UIButton*)sender
{
    [self.delegate playerControlwithState:videoSateVoice withButton:sender];
}
-(void)clarityBtnClick:(UIButton*)sender
{
    [self.delegate playerControlwithState:videoSateClarity withButton:sender];
}
-(void)fullBtnClick:(UIButton*)sender
{
    [self.delegate playerControlwithState:videoSateFullScreen withButton:sender];
}
-(void)playerBtnClick:(UIButton*)sender
{
    [self.delegate playerControlwithState:videoSatePlay withButton:sender];
}
-(void)videoBtnClick:(UIButton*)sender
{
    [self.delegate playerControlwithState:videoSateVideing withButton:sender];
}
-(void)screenshotsBtnClick:(UIButton*)sender
{
    [self.delegate playerControlwithState:videoSatesSreenshots withButton:sender];
}
-(void)controlBtnClick:(UIButton*)sender
{
    [self.delegate playerControlwithState:videoSateYuntai withButton:sender];
}
-(void)talkBackBtnClick:(UIButton*)sender
{
    [self.delegate playerControlwithState:videoSateTalkBack withButton:sender];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
