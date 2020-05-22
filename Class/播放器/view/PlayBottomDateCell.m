//
//  PlayBottomDateCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/5/13.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "PlayBottomDateCell.h"
#import "CGXPickerView.h"

@interface PlayBottomDateCell ()

@property (nonatomic,strong) UILabel *dateLabel;

@end


@implementation PlayBottomDateCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = kColorBackgroundColor;
    
    UIView *backView = [UIView new];
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = [UIColor whiteColor];
    backView.clipsToBounds = YES;
    backView.layer.cornerRadius = 17.5;
    [self.contentView addSubview:backView];
    [backView topToView:self.contentView withSpace:10];
    [backView bottomToView:self.contentView withSpace:10];
    [backView xCenterToView:self.contentView];
    [backView addWidth:200];
    [backView addHeight:35];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackViewClick:)];
    [backView addGestureRecognizer:tap];
    
    
    
    _dateLabel = [UILabel new];
    _dateLabel.text = @"2020-05-05 09:51:36";
    _dateLabel.textColor = kColorMainTextColor;
    _dateLabel.font = [UIFont customFontWithSize:kFontSizeEleven];
    [backView addSubview:_dateLabel];
    [_dateLabel xCenterToView:backView];
    [_dateLabel yCenterToView:backView];
    
    
    
}
-(void)tapBackViewClick:(UITapGestureRecognizer*)tp
{
    [CGXPickerView showDatePickerWithTitle:@"日期和时间" DateType:UIDatePickerModeDateAndTime DefaultSelValue:nil MinDateStr:nil MaxDateStr:[_kDatePicker getCurrentTimes:@"YYYY-MM-dd  hh:mm"] IsAutoSelect:YES Manager:nil ResultBlock:^(NSString *selectValue) {
        DLog(@"%@",selectValue);
        self.dateLabel.text = selectValue;;
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
