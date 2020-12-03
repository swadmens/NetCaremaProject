//
//  EquimentAlarmsCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/12/1.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "EquimentAlarmsCell.h"
#import "EquimentAlarmsModel.h"

@interface EquimentAlarmsCell ()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *timeLabel;

@end
@implementation EquimentAlarmsCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"告警名称";
    _titleLabel.textColor = kColorMainTextColor;
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel leftToView:self.contentView withSpace:15];
    [_titleLabel topToView:self.contentView withSpace:15];
    [_titleLabel bottomToView:self.contentView withSpace:40];
    [_titleLabel addWidth:kScreenWidth - 30];
    
    
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = kColorSecondTextColor;
    _timeLabel.numberOfLines = 0;
    _timeLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel leftToView:self.contentView withSpace:15];
    [_timeLabel bottomToView:self.contentView withSpace:12];
    
}
-(void)makeCellData:(EquimentAlarmsModel*)model
{
    NSArray *times = [model.time componentsSeparatedByString:@"."];
    _titleLabel.text = model.text;
    _timeLabel.text = [times[0] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
