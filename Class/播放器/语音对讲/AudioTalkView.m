//
//  AudioTalkView.m
//  NetCamera
//
//  Created by 汪伟 on 2020/11/5.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "AudioTalkView.h"

@implementation AudioTalkView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    UIButton *cancelBtn = [UIButton new];
    [cancelBtn setImage:UIImageWithFileName(@"login_close") forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelViewClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    [cancelBtn topToView:self withSpace:2];
    [cancelBtn rightToView:self withSpace:2];
    [cancelBtn addWidth:40];
    [cancelBtn addHeight:40];
    
    
    UIImageView *imageMid = [UIImageView new];
    imageMid.image = UIImageWithFileName(@"player_talkback_image");
    [self addSubview:imageMid];
    [imageMid xCenterToView:self];
    [imageMid yCenterToView:self];
    [imageMid addWidth:100];
    [imageMid addHeight:100];

}
-(void)cancelViewClick
{
    self.transform = CGAffineTransformIdentity;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
