//
//  AreaSelectCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/4.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "AreaSelectCell.h"

@interface AreaSelectCell ()


@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *selectBtn;

@end


@implementation AreaSelectCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"type+fragmentType+fragmentType";
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    _titleLabel.textColor = kColorMainTextColor;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel leftToView:self.contentView withSpace:15];
    [_titleLabel yCenterToView:self.contentView];
    [_titleLabel rightToView:self.contentView withSpace:40];

    //
    
    _selectBtn = [UIButton new];
    [_selectBtn setImage:UIImageWithFileName(@"rm_key_noselect") forState:UIControlStateNormal];
    [_selectBtn setImage:UIImageWithFileName(@"rm_key_select") forState:UIControlStateSelected];
    [self.contentView addSubview:_selectBtn];
    [_selectBtn yCenterToView:_titleLabel];
    [_selectBtn rightToView:self.contentView withSpace:28];

    

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    _selectBtn.selected = selected;

    // Configure the view for the selected state
}

@end
