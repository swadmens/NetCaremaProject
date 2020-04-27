//
//  MineTableViewCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/2/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "MineTableViewCell.h"

@interface MineTableViewCell ()


@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *titleLabel;


@end


@implementation MineTableViewCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    
    self.contentView.backgroundColor = kColorBackgroundColor;
    
    
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
//    backView.clipsToBounds = YES;
    backView.layer.cornerRadius = 5;
    backView.layer.shadowColor = UIColorFromRGB(0xB0E5E4, 1).CGColor;
    backView.layer.shadowOffset = CGSizeMake(0,3);
    backView.layer.shadowOpacity = 1;
    backView.layer.shadowRadius = 4;
    backView.layer.cornerRadius = 5;
    [self.contentView addSubview:backView];
    [backView topToView:self.contentView withSpace:0];
    [backView leftToView:self.contentView withSpace:15];
    [backView bottomToView:self.contentView withSpace:10];
    [backView addHeight:52.5];
    [backView addWidth:kScreenWidth-30];
    
    
    
    _iconImageView = [UIImageView new];
    [backView addSubview:_iconImageView];
    [_iconImageView leftToView:backView withSpace:15];
    [_iconImageView yCenterToView:backView];
    
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = kColorMainTextColor;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeFifty];
    [_titleLabel sizeToFit];
    [backView addSubview:_titleLabel];
    [_titleLabel yCenterToView:backView];
    [_titleLabel leftToView:_iconImageView withSpace:15];
    
    
    UIImageView *rightImageView = [UIImageView new];
    rightImageView.image = UIImageWithFileName(@"mine_right_arrows");
    [backView addSubview:rightImageView];
    [rightImageView yCenterToView:backView];
    [rightImageView rightToView:backView withSpace:15];
    
}
-(void)makeCellData:(NSDictionary*)dic
{
    NSString *icon = [NSString stringWithFormat:@"%@",[dic objectForKey:@"icon"] ];
    NSString *title = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    _iconImageView.image = UIImageWithFileName(icon);
    _titleLabel.text = title;}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
