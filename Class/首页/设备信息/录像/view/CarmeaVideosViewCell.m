//
//  CarmeaVideosViewCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/2.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "CarmeaVideosViewCell.h"

@interface CarmeaVideosViewCell ()

@property (nonatomic,strong) UIButton *selectBtn;

@end

@implementation CarmeaVideosViewCell
-(void)doSetup
{
    [super doSetup];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = kScreenWidth/2-21;
    
    UIImageView *showImageView = [UIImageView new];
    showImageView.image = [UIImage imageWithColor:[UIColor redColor]];
    [self.contentView addSubview:showImageView];
    [showImageView leftToView:self.self.contentView];
    [showImageView topToView:self.contentView];
    [showImageView bottomToView:self.contentView withSpace:32.5];
    [showImageView addWidth:width];
    [showImageView addHeight:width*0.6];
    
//    button_unselect_image
//    button_select_image
    
    
    _selectBtn = [UIButton new];
    _selectBtn.hidden = YES;
    [_selectBtn setImage:UIImageWithFileName(@"button_select_image") forState:UIControlStateSelected];
    [_selectBtn setImage:UIImageWithFileName(@"button_unselect_image") forState:UIControlStateNormal];
    [showImageView addSubview:_selectBtn];
    [_selectBtn bottomToView:showImageView withSpace:10];
    [_selectBtn rightToView:showImageView withSpace:10];

    
}
-(void)setIsEdit:(BOOL)isEdit
{
    _selectBtn.hidden = !isEdit;

}
-(void)setIsChoosed:(BOOL)isChoosed
{
    _selectBtn.selected = !isChoosed;
}
@end
