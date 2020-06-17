//
//  AddGroupTopViewCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "AddGroupTopViewCell.h"

@interface AddGroupTopViewCell ()

@property (nonatomic,strong) UILabel *titleLabel;


@end

@implementation AddGroupTopViewCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = kColorBackgroundColor;
    
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    backView.clipsToBounds = YES;
    backView.layer.cornerRadius = 5;
    [self.contentView addSubview:backView];
    [backView alignTop:@"10" leading:@"15" bottom:@"10" trailing:@"15" toView:self.contentView];
    [backView addHeight:45];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"分组名称";
    nameLabel.textColor = kColorMainTextColor;
    nameLabel.font = [UIFont customBoldFontWithSize:kFontSizeThirteen];
    [backView addSubview:nameLabel];
    [nameLabel yCenterToView:backView];
    [nameLabel leftToView:backView withSpace:15];
    
    
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = kColorMainTextColor;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [backView addSubview:_titleLabel];
    [_titleLabel yCenterToView:backView];
    [_titleLabel rightToView:backView withSpace:35];
    
    UIImageView *rightImageView = [UIImageView new];
    rightImageView.image = UIImageWithFileName(@"mine_right_arrows");
    [backView addSubview:rightImageView];
    [rightImageView yCenterToView:backView];
    [rightImageView rightToView:backView withSpace:15];
}
-(void)makeCellData:(NSString *)title
{
    _titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
