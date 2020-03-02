//
//  ConnectionMonitoringCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/2.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "ConnectionMonitoringCell.h"


@interface ConnectionMonitoringCell ()<UITextFieldDelegate>

@property (nonatomic,strong) UILabel *sendLabel;
@property (nonatomic,strong) UILabel *pushLabel;

@property (nonatomic,strong) UITextField *minTextFiled;


@end

@implementation ConnectionMonitoringCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = kColorBackgroundColor;
       
    UIView *cardView = [UIView new];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.clipsToBounds = YES;
    cardView.layer.cornerRadius = 10;
    [self.contentView addSubview:cardView];
    [cardView alignTop:@"5" leading:@"15" bottom:@"5" trailing:@"15" toView:self.contentView];
    [cardView addHeight:188.5];
    
    UILabel *topLeftLabel = [UILabel new];
    topLeftLabel.backgroundColor = kColorMainColor;
    [cardView addSubview:topLeftLabel];
    [topLeftLabel leftToView:cardView withSpace:15];
    [topLeftLabel topToView:cardView withSpace:15];
    [topLeftLabel addWidth:1.5];
    [topLeftLabel addHeight:12];
    
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"连接监测";
    titleLabel.textColor = kColorSecondTextColor;
    titleLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [titleLabel sizeToFit];
    [cardView addSubview:titleLabel];
    [titleLabel yCenterToView:topLeftLabel];
    [titleLabel leftToView:topLeftLabel withSpace:3.5];
    
    UILabel *lineLabel1 = [UILabel new];
    lineLabel1.backgroundColor = kColorLineColor;
    [cardView addSubview:lineLabel1];
    [lineLabel1 leftToView:cardView withSpace:16.5];
    [lineLabel1 topToView:topLeftLabel withSpace:15];
    [lineLabel1 addWidth:kScreenWidth-63];
    [lineLabel1 addHeight:1];
    
    
    UIImageView *leftImageView = [UIImageView new];
    leftImageView.image = UIImageWithFileName(@"send_url_image");
    [cardView addSubview:leftImageView];
    [leftImageView topToView:lineLabel1 withSpace:12];
    [leftImageView leftToView:cardView withSpace:16.5];
    
    _sendLabel = [UILabel new];
    _sendLabel.text = @"发送链接:未监测";
    _sendLabel.textColor = UIColorFromRGB(0x4d4d4d, 1);
    _sendLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [_sendLabel sizeToFit];
    [cardView addSubview:_sendLabel];
    [_sendLabel yCenterToView:leftImageView];
    [_sendLabel leftToView:leftImageView withSpace:5];
    
    
    UILabel *lineLabel2 = [UILabel new];
    lineLabel2.backgroundColor = kColorLineColor;
    [cardView addSubview:lineLabel2];
    [lineLabel2 leftToView:cardView withSpace:16.5];
    [lineLabel2 topToView:leftImageView withSpace:12];
    [lineLabel2 addWidth:kScreenWidth-63];
    [lineLabel2 addHeight:1];
    
    UIImageView *rightImageView = [UIImageView new];
    rightImageView.image = UIImageWithFileName(@"push_url_image");
    [cardView addSubview:rightImageView];
    [rightImageView topToView:lineLabel2 withSpace:12];
    [rightImageView leftToView:cardView withSpace:16.5];
    
    _pushLabel = [UILabel new];
    _pushLabel.text = @"推送链接:不活跃";
    _pushLabel.textColor = UIColorFromRGB(0x4d4d4d, 1);
    _pushLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [_pushLabel sizeToFit];
    [cardView addSubview:_pushLabel];
    [_pushLabel yCenterToView:rightImageView];
    [_pushLabel leftToView:rightImageView withSpace:5];
    
    
    UILabel *lineLabel3 = [UILabel new];
    lineLabel3.backgroundColor = kColorLineColor;
    [cardView addSubview:lineLabel3];
    [lineLabel3 leftToView:cardView withSpace:16.5];
    [lineLabel3 topToView:rightImageView withSpace:12];
    [lineLabel3 addWidth:kScreenWidth-63];
    [lineLabel3 addHeight:1];
    
    
    UILabel *lastMesLabel = [UILabel new];
    lastMesLabel.text = @"最后一次通信";
    lastMesLabel.textColor = kColorThirdTextColor;
    lastMesLabel.font = [UIFont customFontWithSize:kFontSizeEleven];
    [lastMesLabel sizeToFit];
    [cardView addSubview:lastMesLabel];
    [lastMesLabel leftToView:cardView withSpace:16.5];
    [lastMesLabel topToView:lineLabel3 withSpace:11];
    
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.text = @"所需的时间间隔";
    timeLabel.textColor = kColorThirdTextColor;
    timeLabel.font = [UIFont customFontWithSize:kFontSizeEleven];
    [timeLabel sizeToFit];
    [cardView addSubview:timeLabel];
    [timeLabel leftToView:cardView withSpace:16.5];
    [timeLabel topToView:lastMesLabel withSpace:11];
    
    
    _minTextFiled = [UITextField new];
    _minTextFiled.delegate = self;
    _minTextFiled.clipsToBounds = YES;
    _minTextFiled.layer.cornerRadius = 5;
    _minTextFiled.layer.borderColor = kColorLineColor.CGColor;
    _minTextFiled.layer.borderWidth = 0.5;
    _minTextFiled.textColor = kColorMainTextColor;
    [cardView addSubview:_minTextFiled];
    [_minTextFiled yCenterToView:timeLabel];
    [_minTextFiled rightToView:cardView withSpace:48.5];
    [_minTextFiled addWidth:57.5];
    [_minTextFiled addHeight:25];
    
    UILabel *fzLabel = [UILabel new];
    fzLabel.text = @"分钟";
    fzLabel.textColor = kColorThirdTextColor;
    fzLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    [fzLabel sizeToFit];
    [cardView addSubview:fzLabel];
    [fzLabel leftToView:_minTextFiled withSpace:8];
    [fzLabel yCenterToView:_minTextFiled];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
