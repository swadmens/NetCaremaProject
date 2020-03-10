//
//  DownloadListCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/5.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "DownloadListCell.h"

@interface DownloadListCell ()

@property (nonatomic,strong) UIImageView *showImageView;
@property (nonatomic,strong) UILabel *titleLabel;//名称
@property (nonatomic,strong) UILabel *timeLabel;//时间
@property (nonatomic,strong) UILabel *speedLabel;//下载速度

@property (nonatomic,strong) UILabel *currentDataLabel;//当前已下载量
@property (nonatomic,strong) UILabel *totalDataLabel;//总下载量

@property (nonatomic,strong) UIProgressView *progressView;//进度条



@end


@implementation DownloadListCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = kColorBackgroundColor;
    
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    [backView alignTop:@"0" leading:@"15" bottom:@"10" trailing:@"15" toView:self.contentView];
    [backView addHeight:102.5];
    
    
    _showImageView = [UIImageView new];
    _showImageView.image = UIImageWithFileName(@"playback_back_image");
    [backView addSubview:_showImageView];
    [_showImageView alignTop:@"10" leading:@"10" bottom:@"10" trailing:nil toView:backView];
    [_showImageView addWidth:135];
    
    
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"高清延时拍摄城市路口";
    _titleLabel.textColor = kColorMainTextColor;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeFifty];
    [backView addSubview:_titleLabel];
    [_titleLabel leftToView:_showImageView withSpace:10];
    [_titleLabel topToView:backView withSpace:15];
    [_titleLabel addWidth:kScreenWidth-195];
    
    
    _timeLabel = [UILabel new];
    _timeLabel.text = @"2020-02-26 14:31:42";
    _timeLabel.textColor = kColorThirdTextColor;
    _timeLabel.font = [UIFont customFontWithSize:kFontSizeTen];
    [backView addSubview:_timeLabel];
    [_timeLabel leftToView:_showImageView withSpace:10];
    [_timeLabel topToView:_titleLabel withSpace:5];
    [_timeLabel addWidth:kScreenWidth-195];
    
    
    _progressView = [UIProgressView new];
    _progressView.progressViewStyle = UIProgressViewStyleDefault;
    _progressView.progressTintColor = kColorMainColor;
    _progressView.trackTintColor = UIColorFromRGB(0xe5e5e5, 1);
    _progressView.progress = 0.5;
    [backView addSubview:_progressView];
    [_progressView leftToView:_showImageView withSpace:10];
    [_progressView topToView:_timeLabel withSpace:8];
    [_progressView addWidth:kScreenWidth-195];
    [_progressView addHeight:0.6];
    
 
    _speedLabel = [UILabel new];
    _speedLabel.text = @"652KB/S";
    _speedLabel.textColor = kColorThirdTextColor;
    _speedLabel.font = [UIFont customFontWithSize:kFontSizeTen];
    [backView addSubview:_speedLabel];
    [_speedLabel leftToView:_showImageView withSpace:10];
    [_speedLabel topToView:_progressView withSpace:5];
    
    
    _totalDataLabel = [UILabel new];
    _totalDataLabel.text = @"/258M";
    _totalDataLabel.textColor = kColorThirdTextColor;
    _totalDataLabel.font = [UIFont customFontWithSize:kFontSizeTen];
    [backView addSubview:_totalDataLabel];
    [_totalDataLabel rightToView:backView withSpace:15];
    [_totalDataLabel yCenterToView:_speedLabel];
    
    _currentDataLabel = [UILabel new];
    _currentDataLabel.text = @"129M";
    _currentDataLabel.textColor = kColorThirdTextColor;
    _currentDataLabel.font = [UIFont customFontWithSize:kFontSizeTen];
    [backView addSubview:_currentDataLabel];
    [_currentDataLabel rightToView:_totalDataLabel];
    [_currentDataLabel yCenterToView:_speedLabel];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
