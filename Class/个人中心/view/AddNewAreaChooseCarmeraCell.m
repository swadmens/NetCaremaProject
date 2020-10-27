//
//  AddNewAreaChooseCarmeraCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/10/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "AddNewAreaChooseCarmeraCell.h"

@interface AddNewAreaChooseCarmeraCell ()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *namelLabel;

@end

@implementation AddNewAreaChooseCarmeraCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = kColorMainTextColor;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeSixteen];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel leftToView:self.contentView withSpace:20];
    [_titleLabel yCenterToView:self.contentView];
    
    
    _namelLabel = [UILabel new];
    _namelLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    _namelLabel.textColor = kColorThirdTextColor;
    [self.contentView addSubview:_namelLabel];
    [_namelLabel yCenterToView:_titleLabel];
    [_namelLabel leftToView:self.contentView withSpace:105];
    
    
    
    UIImageView *rightImageView = [UIImageView new];
    rightImageView.image = UIImageWithFileName(@"mine_right_arrows");
    [self.contentView addSubview:rightImageView];
    [rightImageView yCenterToView:self.contentView];
    [rightImageView rightToView:self.contentView withSpace:15];
    
}
-(void)makeCellData:(NSDictionary*)dic
{
    _titleLabel.text = [dic objectForKey:@"title"];
    _namelLabel.text = [dic objectForKey:@"detail"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
