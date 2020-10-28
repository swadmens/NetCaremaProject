//
//  AreaNormalCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/4.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "AreaNormalCell.h"
#import "AreaInfoModel.h"

@interface AreaNormalCell ()


@property (nonatomic,strong) UILabel *titleLabel;


@end


@implementation AreaNormalCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = UIColorFromRGB(0xf8f8f8, 1);
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"UserLocationIndex";
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    _titleLabel.textColor = kColorMainTextColor;
    [self.contentView addSubview:_titleLabel];
//    [_titleLabel alignTop:@"0" leading:@"15" bottom:@"0" trailing:@"0" toView:self.contentView];
    [_titleLabel leftToView:self.contentView withSpace:15];
    [_titleLabel yCenterToView:self.contentView];
    [_titleLabel rightToView:self.contentView withSpace:10];
    
}
-(void)makeCellData:(AreaInfoModel *)model
{
    _titleLabel.text = model.areaType;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        _titleLabel.textColor = kColorMainColor;
    }else{
        _titleLabel.textColor = kColorMainTextColor;
        self.contentView.backgroundColor = UIColorFromRGB(0xf8f8f8, 1);
    }
    

    // Configure the view for the selected state
}

@end
