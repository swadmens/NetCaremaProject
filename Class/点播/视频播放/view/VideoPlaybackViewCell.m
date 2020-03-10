//
//  VideoPlaybackViewCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/4.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "VideoPlaybackViewCell.h"


@interface VideoPlaybackViewCell ()

@property (nonatomic,strong) UIImageView *showImageView;
@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation VideoPlaybackViewCell
-(void)doSetup
{
    [super doSetup];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = kScreenWidth/2-21;
    
    _showImageView = [UIImageView new];
    _showImageView.clipsToBounds = YES;
    _showImageView.layer.cornerRadius = 5;
    _showImageView.image = [UIImage imageWithColor:[UIColor redColor]];
    [self.contentView addSubview:_showImageView];
    [_showImageView leftToView:self.self.contentView];
    [_showImageView topToView:self.contentView];
    [_showImageView bottomToView:self.contentView withSpace:32.5];
    [_showImageView addWidth:width];
    [_showImageView addHeight:width*0.6];
    
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"测试视频";
    _titleLabel.textColor = kColorSecondTextColor;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel leftToView:self.contentView];
    [_titleLabel topToView:_showImageView withSpace:10];
    
    
}
@end
