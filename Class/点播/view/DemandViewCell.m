//
//  DemandViewCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "DemandViewCell.h"
#import "DemandModel.h"
#import <UIImageView+YYWebImage.h>

@interface DemandViewCell ()

@property (nonatomic,strong) UIButton *selectBtn;

@property (nonatomic,strong) UIImageView *showImageView;
@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation DemandViewCell
-(void)doSetup
{
    [super doSetup];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = kScreenWidth/2-21;
    
    _showImageView = [UIImageView new];
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
    [_titleLabel leftToView:self.contentView withSpace:8];
    [_titleLabel topToView:_showImageView withSpace:10];
    [_titleLabel addWidth:width];
}

-(void)makeCellData:(DemandModel *)model
{
//    [_showImageView yy_setImageWithURL:[NSURL URLWithString:model.snapUrl] options:YYWebImageOptionProgressive];
    [_showImageView yy_setImageWithURL:[NSURL URLWithString:model.snapUrl] placeholder:UIImageWithFileName(@"player_hoder_image")];
    _titleLabel.text = model.vods_vodName;
}

@end
