//
//  PlayerTopAddViewCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/5/29.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "PlayerTopAddViewCell.h"

@interface PlayerTopAddViewCell ()

@property (nonatomic,strong) UIImageView *titleImageView;

@end

@implementation PlayerTopAddViewCell
-(void)doSetup
{
    [super doSetup];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = (kScreenWidth-1)/2;

    UIView *backView = [UIView new];
    backView.backgroundColor = UIColorFromRGB(0x47484D, 1);
    [self.contentView addSubview:backView];
    [backView xCenterToView:self.contentView];
    [backView yCenterToView:self.contentView];
    [backView addWidth:width];
    [backView addHeight:width*0.68];
    
    _titleImageView = [UIImageView new];
    _titleImageView.clipsToBounds = YES;
    _titleImageView.layer.borderColor = [UIColor clearColor].CGColor;
    _titleImageView.layer.borderWidth = 0.5;
    _titleImageView.userInteractionEnabled = YES;
    _titleImageView.layer.masksToBounds = YES;
    _titleImageView.contentMode = UIViewContentModeScaleAspectFill;
    [backView addSubview:_titleImageView];
    [_titleImageView xCenterToView:backView];
    [_titleImageView yCenterToView:backView];
    
}
-(void)stop
{
    
}
-(void)play
{
    
}
-(void)makePlayerViewFullScreen:(BOOL)selected
{
    
}
-(void)clickSnapshotButton
{
    
}
-(void)makeCellData:(NSString *)icon
{
    _titleImageView.image = UIImageWithFileName(icon);

}
@end
