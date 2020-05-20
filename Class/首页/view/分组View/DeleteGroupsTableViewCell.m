//
//  DeleteGroupsTableViewCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/5/6.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "DeleteGroupsTableViewCell.h"

@interface DeleteGroupsTableViewCell ()

@property (nonatomic,strong) UILabel *titleLabel;

@end
@implementation DeleteGroupsTableViewCell

-(void)dosetup
{
    [super dosetup];
    self.contentView.backgroundColor = kColorBackgroundColor;
    
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    backView.clipsToBounds = YES;
    backView.layer.cornerRadius = 5;
    [self.contentView addSubview:backView];
    [backView alignTop:@"0" leading:@"15" bottom:@"10" trailing:@"15" toView:self.contentView];
    [backView addHeight:45];
    
    
    _selectBtn = [UIButton new];
    [_selectBtn setImage:UIImageWithFileName(@"button_unselect_image") forState:UIControlStateNormal];
    [_selectBtn setImage:UIImageWithFileName(@"button_select_image") forState:UIControlStateSelected];
    [backView addSubview:_selectBtn];
    [_selectBtn yCenterToView:backView];
    [_selectBtn leftToView:backView withSpace:15];

    _titleLabel = [UILabel new];
    _titleLabel.text = @"公司";
    _titleLabel.textColor = kColorMainTextColor;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [backView addSubview:_titleLabel];
    [_titleLabel yCenterToView:backView];
    [_titleLabel leftToView:_selectBtn withSpace:5];
    
}
-(void)makeCellData:(NSDictionary *)dic
{
    _titleLabel.text = [dic objectForKey:@"titles"];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    _selectBtn.selected = selected;

    // Configure the view for the selected state
}

@end
