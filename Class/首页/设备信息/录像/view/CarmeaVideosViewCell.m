//
//  CarmeaVideosViewCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/2.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "CarmeaVideosViewCell.h"
#import "DemandModel.h"
#import <UIImageView+YYWebImage.h>

@interface CarmeaVideosViewCell ()

@property (nonatomic,strong) UIButton *selectBtn;

@property (nonatomic,strong) UIImageView *showImageView;
@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation CarmeaVideosViewCell
-(void)doSetup
{
    [super doSetup];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = kScreenWidth/2-21;
    
    _showImageView = [UIImageView new];
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
    [_titleLabel leftToView:self.contentView withSpace:8];
    [_titleLabel topToView:_showImageView withSpace:10];
    
//    button_unselect_image
//    button_select_image
    
    
    _selectBtn = [UIButton new];
    _selectBtn.hidden = YES;
    [_selectBtn setImage:UIImageWithFileName(@"button_select_image") forState:UIControlStateSelected];
    [_selectBtn setImage:UIImageWithFileName(@"button_unselect_image") forState:UIControlStateNormal];
    [_showImageView addSubview:_selectBtn];
    [_selectBtn bottomToView:_showImageView withSpace:10];
    [_selectBtn rightToView:_showImageView withSpace:10];

    
}

-(void)makeCellData:(DemandModel *)model
{
//    [_showImageView yy_setImageWithURL:[NSURL URLWithString:model.snapUrl] options:YYWebImageOptionProgressive];
    [_showImageView yy_setImageWithURL:[NSURL URLWithString:model.snapUrl] placeholder:[UIImage imageWithColor:[UIColor greenColor]]];
    _titleLabel.text = model.video_name;
}

-(void)setIsEdit:(BOOL)isEdit
{
    _selectBtn.hidden = !isEdit;
}
-(void)setIsChoosed:(BOOL)isChoosed
{
    _selectBtn.selected = !isChoosed;
}
//-(void)setSelected:(BOOL)selected
//{
//    [super setSelected:selected];
//    _selectBtn.hidden = selected;
//    _selectBtn.selected = selected;
//}
@end
