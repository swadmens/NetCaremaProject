//
//  ChannelDetailImageCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/10/15.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "ChannelDetailImageCell.h"
#import <UIImageView+YYWebImage.h>

@interface ChannelDetailImageCell ()

@property (nonatomic,strong) UIImageView *titleImageView;


@end

@implementation ChannelDetailImageCell

-(void)dosetup
{
    [super dosetup];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"封面设置";
    nameLabel.font = [UIFont customFontWithSize:kFontSizeFifty];
    nameLabel.textColor = kColorMainTextColor;
    [self.contentView addSubview:nameLabel];
    [nameLabel yCenterToView:self.contentView];
    [nameLabel leftToView:self.contentView withSpace:15];
    
    
    _titleImageView = [UIImageView new];
    _titleImageView.image = UIImageWithFileName(@"player_hoder_image");
    [self.contentView addSubview:_titleImageView];
    [_titleImageView topToView:self.contentView withSpace:10];
    [_titleImageView bottomToView:self.contentView withSpace:10];
    [_titleImageView rightToView:self.contentView withSpace:15];
    [_titleImageView addWidth:76];
    [_titleImageView addHeight:46.5];
    
    
    UILabel *lineLabel = [UILabel new];
    lineLabel.backgroundColor = kColorLineColor;
    [self.contentView addSubview:lineLabel];
    [lineLabel alignTop:nil leading:@"15" bottom:@"0" trailing:@"15" toView:self.contentView];
    [lineLabel addHeight:0.5];
    
    
}
-(void)makeCellData:(NSDictionary*)dic
{
    [self.titleImageView yy_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"value"]] placeholder:UIImageWithFileName(@"player_hoder_image")];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
