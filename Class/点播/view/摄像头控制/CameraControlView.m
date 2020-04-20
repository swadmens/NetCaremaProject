//
//  CameraControlView.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/20.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "CameraControlView.h"

@interface CameraControlView ()

@property (nonatomic,strong) UIButton *leftUpBtn;
@property (nonatomic,strong) UIButton *leftDownBtn;

@property (nonatomic,strong) UIButton *rightUpBtn;
@property (nonatomic,strong) UIButton *rightDownBtn;

@property (nonatomic,strong) UIButton *focusin;
@property (nonatomic,strong) UIButton *focusout;

@property (nonatomic,strong) UIButton *aperturein;
@property (nonatomic,strong) UIButton *apertureout;
@end

@implementation CameraControlView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorBackgroundColor;
        [self creadUI];
    }
    
    return self;
}
-(void)creadUI
{
    UIButton *cancelBtn = [UIButton new];
    [cancelBtn setImage:UIImageWithFileName(@"login_close") forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelViewClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    [cancelBtn topToView:self withSpace:15];
    [cancelBtn leftToView:self withSpace:15];
    
    
    
    UIView *centerView = [UIView new];
    centerView.backgroundColor = [UIColor whiteColor];
    // 阴影颜色
    centerView.layer.shadowColor = [UIColor blackColor].CGColor;
    // 阴影偏移，默认(0, -3)
    centerView.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    centerView.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    centerView.layer.shadowRadius = 5;
//    centerView.clipsToBounds = YES;
    centerView.layer.cornerRadius = 100;
    [self addSubview:centerView];
    [centerView addCenterX:-50 toView:self];
    [centerView yCenterToView:self];
    [centerView addWidth:200];
    [centerView addHeight:200];
    
    
    
    
    UIButton *upBtn = [UIButton new];
    [upBtn setTitle:@"上" forState:UIControlStateNormal];
    [upBtn addTarget:self action:@selector(controlUpClick) forControlEvents:UIControlEventTouchUpInside];
    [upBtn setBGColor:[UIColor blackColor] forState:UIControlStateNormal];
    [centerView addSubview:upBtn];
    [upBtn xCenterToView:centerView];
    [upBtn topToView:centerView withSpace:5];
    [upBtn addWidth:40];
    [upBtn addHeight:40];
    
    
    UIButton *downBtn = [UIButton new];
    [downBtn setTitle:@"下" forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(controlDownClick) forControlEvents:UIControlEventTouchUpInside];
    [downBtn setBGColor:[UIColor blackColor] forState:UIControlStateNormal];
    [centerView addSubview:downBtn];
    [downBtn xCenterToView:centerView];
    [downBtn bottomToView:centerView withSpace:5];
    [downBtn addWidth:40];
    [downBtn addHeight:40];
    
    
    UIButton *leftBtn = [UIButton new];
    [leftBtn setTitle:@"左" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(controlLeftClick) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBGColor:[UIColor blackColor] forState:UIControlStateNormal];
    [centerView addSubview:leftBtn];
    [leftBtn yCenterToView:centerView];
    [leftBtn leftToView:centerView withSpace:5];
    [leftBtn addWidth:40];
    [leftBtn addHeight:40];
    
    
    UIButton *rightBtn = [UIButton new];
    [rightBtn setTitle:@"右" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(controlRightClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBGColor:[UIColor blackColor] forState:UIControlStateNormal];
    [centerView addSubview:rightBtn];
    [rightBtn yCenterToView:centerView];
    [rightBtn rightToView:centerView withSpace:5];
    [rightBtn addWidth:40];
    [rightBtn addHeight:40];
    
    
    UIButton *stopBtn = [UIButton new];
    [stopBtn setTitle:@"停" forState:UIControlStateNormal];
    [stopBtn addTarget:self action:@selector(controlStopClick) forControlEvents:UIControlEventTouchUpInside];
    [stopBtn setBGColor:[UIColor blackColor] forState:UIControlStateNormal];
    [centerView addSubview:stopBtn];
    [stopBtn yCenterToView:centerView];
    [stopBtn xCenterToView:centerView];
    [stopBtn addWidth:40];
    [stopBtn addHeight:40];
    
    
    
    
    _leftUpBtn = [UIButton new];
    [_leftUpBtn setTitle:@"左上" forState:UIControlStateNormal];
    [_leftUpBtn addTarget:self action:@selector(controlLeftUpClick) forControlEvents:UIControlEventTouchUpInside];
    [_leftUpBtn setBGColor:[UIColor blackColor] forState:UIControlStateNormal];
    [centerView addSubview:_leftUpBtn];
    [_leftUpBtn leftToView:centerView withSpace:25];
    [_leftUpBtn topToView:centerView withSpace:25];
    [_leftUpBtn addWidth:40];
    [_leftUpBtn addHeight:40];
    
    
    
    _leftDownBtn = [UIButton new];
    [_leftDownBtn setTitle:@"左下" forState:UIControlStateNormal];
    [_leftDownBtn addTarget:self action:@selector(controlLeftDownClick) forControlEvents:UIControlEventTouchUpInside];
    [_leftDownBtn setBGColor:[UIColor blackColor] forState:UIControlStateNormal];
    [centerView addSubview:_leftDownBtn];
    [_leftDownBtn bottomToView:centerView withSpace:25];
    [_leftDownBtn leftToView:centerView withSpace:25];
    [_leftDownBtn addWidth:40];
    [_leftDownBtn addHeight:40];
    
    
    _rightUpBtn = [UIButton new];
    [_rightUpBtn setTitle:@"右上" forState:UIControlStateNormal];
    [_rightUpBtn addTarget:self action:@selector(controlRightUpClick) forControlEvents:UIControlEventTouchUpInside];
    [_rightUpBtn setBGColor:[UIColor blackColor] forState:UIControlStateNormal];
    [centerView addSubview:_rightUpBtn];
    [_rightUpBtn rightToView:centerView withSpace:25];
    [_rightUpBtn topToView:centerView withSpace:25];
    [_rightUpBtn addWidth:40];
    [_rightUpBtn addHeight:40];
    
    
    
    _rightDownBtn = [UIButton new];
    [_rightDownBtn setTitle:@"右下" forState:UIControlStateNormal];
    [_rightDownBtn addTarget:self action:@selector(controlRightDownClick) forControlEvents:UIControlEventTouchUpInside];
    [_rightDownBtn setBGColor:[UIColor blackColor] forState:UIControlStateNormal];
    [centerView addSubview:_rightDownBtn];
    [_rightDownBtn bottomToView:centerView withSpace:25];
    [_rightDownBtn rightToView:centerView withSpace:25];
    [_rightDownBtn addWidth:40];
    [_rightDownBtn addHeight:40];
    
    
    
    UIButton *zoomin = [UIButton new];
    zoomin.titleLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [zoomin setTitle:@"放大" forState:UIControlStateNormal];
    [zoomin addTarget:self action:@selector(controlZoominClick) forControlEvents:UIControlEventTouchUpInside];
    [zoomin setBGColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:zoomin];
    [zoomin topToView:self withSpace:25];
    [zoomin rightToView:self withSpace:5];
    [zoomin addWidth:40];
    [zoomin addHeight:30];
    
    
    UIButton *zoomout = [UIButton new];
    zoomout.titleLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [zoomout setTitle:@"缩小" forState:UIControlStateNormal];
    [zoomout addTarget:self action:@selector(controlZoomoutClick) forControlEvents:UIControlEventTouchUpInside];
    [zoomout setBGColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:zoomout];
    [zoomout yCenterToView:zoomin];
    [zoomout rightToView:zoomin withSpace:5];
    [zoomout addWidth:40];
    [zoomout addHeight:30];
    
    
    _focusin = [UIButton new];
    _focusin.titleLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [_focusin setTitle:@"聚焦-" forState:UIControlStateNormal];
    [_focusin addTarget:self action:@selector(controlFocusinClick) forControlEvents:UIControlEventTouchUpInside];
    [_focusin setBGColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_focusin];
    [_focusin topToView:zoomin withSpace:25];
    [_focusin rightToView:self withSpace:5];
    [_focusin addWidth:40];
    [_focusin addHeight:30];
    
    
    _focusout = [UIButton new];
    _focusout.titleLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [_focusout setTitle:@"聚焦+" forState:UIControlStateNormal];
    [_focusout addTarget:self action:@selector(controlFocusoutClick) forControlEvents:UIControlEventTouchUpInside];
    [_focusout setBGColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_focusout];
    [_focusout yCenterToView:_focusin];
    [_focusout rightToView:_focusin withSpace:5];
    [_focusout addWidth:40];
    [_focusout addHeight:30];
    
    _aperturein = [UIButton new];
    _aperturein.titleLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [_aperturein setTitle:@"光圈-" forState:UIControlStateNormal];
    [_aperturein addTarget:self action:@selector(controlApertureinClick) forControlEvents:UIControlEventTouchUpInside];
    [_aperturein setBGColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_aperturein];
    [_aperturein topToView:_focusin withSpace:25];
    [_aperturein rightToView:self withSpace:5];
    [_aperturein addWidth:40];
    [_aperturein addHeight:30];
    
    
    _apertureout = [UIButton new];
    _apertureout.titleLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [_apertureout setTitle:@"光圈+" forState:UIControlStateNormal];
    [_apertureout addTarget:self action:@selector(controlApertureoutClick) forControlEvents:UIControlEventTouchUpInside];
    [_apertureout setBGColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_apertureout];
    [_apertureout yCenterToView:_aperturein];
    [_apertureout rightToView:_aperturein withSpace:5];
    [_apertureout addWidth:40];
    [_apertureout addHeight:30];
    
    
    
}
-(void)cancelViewClick
{
    //还原
    self.transform = CGAffineTransformIdentity;
}
-(void)setIsLiveGBS:(BOOL)isLiveGBS
{
    _leftUpBtn.hidden = !isLiveGBS;
    _leftDownBtn.hidden = !isLiveGBS;
    _rightUpBtn.hidden = !isLiveGBS;
    _rightDownBtn.hidden = !isLiveGBS;

    
    _focusin.hidden = isLiveGBS;
    _focusout.hidden = isLiveGBS;
    _aperturein.hidden = isLiveGBS;
    _apertureout.hidden = isLiveGBS;

}

-(void)controlUpClick
{
    [self.delegate cameraControl:self withState:ControlStateUp];
}
-(void)controlDownClick
{
    [self.delegate cameraControl:self withState:ControlStateDown];
}
-(void)controlLeftClick
{
    [self.delegate cameraControl:self withState:ControlStateLeft];
}
-(void)controlRightClick
{
    [self.delegate cameraControl:self withState:ControlStaterRight];
}
-(void)controlStopClick
{
    [self.delegate cameraControl:self withState:ControlStaterStop];
}
-(void)controlLeftUpClick
{
    [self.delegate cameraControl:self withState:ControlStaterLeftUp];
}
-(void)controlLeftDownClick
{
    [self.delegate cameraControl:self withState:ControlStaterLeftDown];
}
-(void)controlRightUpClick
{
    [self.delegate cameraControl:self withState:ControlStaterRightUp];
}
-(void)controlRightDownClick
{
    [self.delegate cameraControl:self withState:ControlStaterRightDown];
}
-(void)controlZoominClick
{
    [self.delegate cameraControl:self withState:ControlStaterZoomin];
}
-(void)controlZoomoutClick
{
    [self.delegate cameraControl:self withState:ControlStaterZoomout];
}
-(void)controlFocusinClick
{
    [self.delegate cameraControl:self withState:ControlStaterFocusin];
}
-(void)controlFocusoutClick
{
    [self.delegate cameraControl:self withState:ControlStaterFocusout];
}
-(void)controlApertureinClick
{
    [self.delegate cameraControl:self withState:ControlStaterAperturein];
}
-(void)controlApertureoutClick
{
    [self.delegate cameraControl:self withState:ControlStaterApertureout];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
