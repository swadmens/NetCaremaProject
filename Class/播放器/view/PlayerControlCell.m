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

    
    CGFloat btnWidth = 30;
    
    
    UIView *topView = [UIView new];
    topView.backgroundColor = UIColorFromRGB(0x585A66, 1);
    [self.contentView addSubview:topView];
    [topView alignTop:@"0" leading:@"0" bottom:@"68" trailing:@"0" toView:self.contentView];
    [topView addHeight:35];
    
    
    _gongGeBtn = [UIButton new];
    [_gongGeBtn setImage:UIImageWithFileName(@"player_gongge_image") forState:UIControlStateNormal];
    [_gongGeBtn setImage:UIImageWithFileName(@"player_full_image") forState:UIControlStateSelected];
    [topView addSubview:_gongGeBtn];
    [_gongGeBtn xCenterToView:topView];
    [_gongGeBtn yCenterToView:topView];
    [_gongGeBtn addTarget:self action:@selector(gongGeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_gongGeBtn addWidth:btnWidth];
    [_gongGeBtn addHeight:btnWidth];
    
    
    _voiceBtn = [UIButton new];
    [_voiceBtn setImage:UIImageWithFileName(@"player_voice_image") forState:UIControlStateNormal];
    [topView addSubview:_voiceBtn];
    [_voiceBtn yCenterToView:topView];
    [_voiceBtn addCenterX:-space toView:topView];
    [_voiceBtn addTarget:self action:@selector(voiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_voiceBtn addWidth:btnWidth];
    [_voiceBtn addHeight:btnWidth];
    
    _clarityBtn = [UIButton new];
    [_clarityBtn setTitle:@"标清" forState:UIControlStateNormal];
    [_clarityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    [_playerBtn setImage:UIImageWithFileName(@"player_full_image") forState:UIControlStateNormal];
    [topView addSubview:_playerBtn];
    [_playerBtn yCenterToView:topView];
    [_playerBtn addCenterX:-space toView:_voiceBtn];
    [_playerBtn addTarget:self action:@selector(playerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_playerBtn addWidth:btnWidth];
    [_playerBtn addHeight:btnWidth];
        
    
    _videoBtn = [LGXVerticalButton new];
    [_videoBtn setImage:UIImageWithFileName(@"player_videos_image") forState:UIControlStateNormal];
    [_videoBtn setImage:UIImageWithFileName(@"player_videos_select_image") forState:UIControlStateHighlighted];
    [_videoBtn setImage:UIImageWithFileName(@"player_videos_disabled_image") forState:UIControlStateDisabled];
    [_videoBtn setTitle:@"录像" forState:UIControlStateNormal];
    [_videoBtn setTitleColor:kColorSecondTextColor forState:UIControlStateNormal];
    _videoBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEight];
    [self.contentView addSubview:_videoBtn];
    [_videoBtn addTarget:self action:@selector(videoBtnClick:) forControlEvents:UIControlEventTouchUpInside];


    
    _screenshotsBtn = [LGXVerticalButton new];
    [_screenshotsBtn setImage:UIImageWithFileName(@"player_screenshots_image") forState:UIControlStateNormal];
    [_screenshotsBtn setImage:UIImageWithFileName(@"player_screenshots_select_image") forState:UIControlStateSelected];
    [_screenshotsBtn setImage:UIImageWithFileName(@"player_screenshots_disabled_image") forState:UIControlStateDisabled];
    [_screenshotsBtn setTitle:@"截图" forState:UIControlStateNormal];
    [_screenshotsBtn setTitleColor:kColorSecondTextColor forState:UIControlStateNormal];
    _screenshotsBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEight];
    [self.contentView addSubview:_screenshotsBtn];
    [_screenshotsBtn addTarget:self action:@selector(screenshotsBtnClick:) forControlEvents:UIControlEventTouchUpInside];


    
    _controlBtn = [LGXVerticalButton new];
    [_controlBtn setImage:UIImageWithFileName(@"player_control_image") forState:UIControlStateNormal];
    [_controlBtn setImage:UIImageWithFileName(@"player_control_select_image") forState:UIControlStateSelected];
    [_controlBtn setTitle:@"云台" forState:UIControlStateNormal];
    [_controlBtn setTitleColor:kColorSecondTextColor forState:UIControlStateNormal];
    _controlBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEight];
    [self.contentView addSubview:_controlBtn];
    [_controlBtn addCenterX:bigSpace toView:_videoBtn];
    [_controlBtn yCenterToView:_videoBtn];
    [_controlBtn addTarget:self action:@selector(controlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setIsLiving:(BOOL)isLiving
{
    CGFloat bigSpace = kScreenWidth * 0.3;
    
    if (isLiving) {
        _controlBtn.hidden = NO;
        
        [_videoBtn lgx_remakeConstraints:^(LGXLayoutMaker *make) {
            make.xCenter.lgx_equalTo(self.contentView.lgx_xCenter);
            make.bottomEdge.lgx_equalTo(self.contentView.lgx_bottomEdge).lgx_floatOffset(-15);
        }];
        
        [_screenshotsBtn lgx_remakeConstraints:^(LGXLayoutMaker *make) {
            make.xCenter.lgx_equalTo(self.videoBtn.lgx_xCenter).lgx_floatOffset(-bigSpace);
            make.yCenter.lgx_equalTo(self.videoBtn.lgx_yCenter);
        }];
        
    }else{
        _controlBtn.hidden = YES;
        
        [_videoBtn lgx_remakeConstraints:^(LGXLayoutMaker *make) {
            make.xCenter.lgx_equalTo(self.contentView.lgx_xCenter).lgx_floatOffset(40);
            make.bottomEdge.lgx_equalTo(self.contentView.lgx_bottomEdge).lgx_floatOffset(-15);
        }];
        
        [_screenshotsBtn lgx_remakeConstraints:^(LGXLayoutMaker *make) {
            make.xCenter.lgx_equalTo(self.contentView.lgx_xCenter).lgx_floatOffset(-40);
            make.yCenter.lgx_equalTo(self.videoBtn.lgx_yCenter);
        }];
    }
        
}

-(void)gongGeBtnClick:(UIButton*)sender
{
//    _gongGeBtn.selected = !_gongGeBtn.selected;
//
//
//    NSDictionary *userDic = @{@"value":@(_gongGeBtn.selected)};
//    //注册通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"gonggeChangeInfomation" object:nil userInfo:userDic];
//    
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
//    _videoBtn.selected = !_videoBtn.selected;
    [self.delegate playerControlwithState:videoSateVideing withButton:sender];
}
-(void)screenshotsBtnClick:(UIButton*)sender
{
//    _screenshotsBtn.selected = !_screenshotsBtn.selected;
    [self.delegate playerControlwithState:videoSatesSreenshots withButton:sender];
}
-(void)controlBtnClick:(UIButton*)sender
{
//    _controlBtn.selected = !_controlBtn.selected;
    [self.delegate playerControlwithState:videoSateYuntai withButton:sender];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
