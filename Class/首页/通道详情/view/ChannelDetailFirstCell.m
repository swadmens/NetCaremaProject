//
//  ChannelDetailFirstCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/10/15.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "ChannelDetailFirstCell.h"

@interface ChannelDetailFirstCell ()

@property (nonatomic,strong) UILabel *titleLabel;


@end


@implementation ChannelDetailFirstCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImageView = [UIImageView new];
    iconImageView.image = UIImageWithFileName(@"channel_detail_carmera_image");
    [self.contentView addSubview:iconImageView];
    [iconImageView leftToView:self.contentView withSpace:15];
    [iconImageView topToView:self.contentView withSpace:20];
    [iconImageView bottomToView:self.contentView withSpace:20];

    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"测试的";
    _titleLabel.textColor = kColorMainTextColor;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeFifty];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel leftToView:iconImageView withSpace:15];
    [_titleLabel yCenterToView:self.contentView];

    
    UIImageView *rightImageView = [UIImageView new];
    rightImageView.image = UIImageWithFileName(@"mine_right_arrows");
    [self.contentView addSubview:rightImageView];
    [rightImageView yCenterToView:self.contentView];
    [rightImageView rightToView:self.contentView withSpace:15];
}
-(void)makeCellData:(NSDictionary*)dic
{
    _titleLabel.text = [dic objectForKey:@"name"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
