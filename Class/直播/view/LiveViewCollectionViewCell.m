//
//  LiveViewCollectionViewCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/4.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "LiveViewCollectionViewCell.h"
#import "LivingModel.h"
#import <UIImageView+YYWebImage.h>

@interface LiveViewCollectionViewCell ()


@property (nonatomic,strong) UIImageView *showImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *tagLabel;

@end


@implementation LiveViewCollectionViewCell

-(void)doSetup
{
    [super doSetup];
    self.contentView.backgroundColor = UIColorClearColor;
    
    
    CGFloat width = kScreenWidth/2 - 20;
    
    
    _showImageView = [UIImageView new];
    _showImageView.image = [UIImage imageWithColor:[UIColor redColor]];
    [self.contentView addSubview:_showImageView];
    [_showImageView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.contentView];
    [_showImageView addWidth:width];
    [_showImageView addHeight:width*0.6];
   
   
    
    UIView *backView = [UIView new];
    backView.backgroundColor = UIColorFromRGB(0x000000, 0.52);
    [_showImageView addSubview:backView];
    [backView alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:_showImageView];
    [backView addHeight:15.5];
   
   
   
    _titleLabel = [UILabel new];
    _titleLabel.text = @"001研发中心";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont customFontWithSize:9];
    [_titleLabel sizeToFit];
    [backView addSubview:_titleLabel];
    [_titleLabel yCenterToView:backView];
    [_titleLabel leftToView:backView withSpace:5];
   
   
    _tagLabel = [UILabel new];
    _tagLabel.backgroundColor = kColorMainColor;
    _tagLabel.text = @"直播中";
    _tagLabel.textColor = [UIColor whiteColor];
    _tagLabel.font = [UIFont customFontWithSize:9];
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    [_tagLabel sizeToFit];
    [backView addSubview:_tagLabel];
    [_tagLabel yCenterToView:backView];
    [_tagLabel rightToView:backView];
    [_tagLabel addWidth:35.5];
    [_tagLabel addHeight:15.5];
    
}
-(void)makeCellData:(LivingModel*)model
{
    [_showImageView yy_setImageWithURL:[NSURL URLWithString:model.snapUrl] placeholder:[UIImage imageWithColor:kColorBackSecondColor]];
    _titleLabel.text = model.name;
    
    if ([WWPublicMethod isStringEmptyText:model.RTMP]) {
        _tagLabel.text = @"直播中";
    }else{
        _tagLabel.text = @"离线";
    }
}


@end
