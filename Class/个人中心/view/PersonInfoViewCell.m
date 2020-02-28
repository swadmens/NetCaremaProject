//
//  PersonInfoViewCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/2/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "PersonInfoViewCell.h"

@interface PersonInfoViewCell ()


@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *describeLabel;


@end


@implementation PersonInfoViewCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = UIColorFromRGB(0x555555, 1);
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeSixteen];
    [_titleLabel sizeToFit];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel yCenterToView:self.contentView];
    [_titleLabel leftToView:self.contentView withSpace:15];
    
    
    UIImageView *rightImageView = [UIImageView new];
    rightImageView.image = UIImageWithFileName(@"mine_right_arrows");
    [self.contentView addSubview:rightImageView];
    [rightImageView yCenterToView:self.contentView];
    [rightImageView rightToView:self.contentView withSpace:15];
    
    
    _describeLabel = [UILabel new];
    _describeLabel.textColor = kColorThirdTextColor;
    _describeLabel.font = [UIFont customFontWithSize:kFontSizeFifty];
    [_describeLabel sizeToFit];
    [self.contentView addSubview:_describeLabel];
    [_describeLabel yCenterToView:self.contentView];
    [_describeLabel rightToView:rightImageView withSpace:8];
    
}
-(void)makeCellData:(NSDictionary*)dic
{
    
    //    NSArray *arr = @[@{@"icon":@"mine_opinion_image",@"title":@"意见反馈",@"describe":@"0"},];
    
    NSString *title = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    NSString *describe = [NSString stringWithFormat:@"%@",[dic objectForKey:@"describe"]];
    
    _titleLabel.text = title;
    _describeLabel.text = describe;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
