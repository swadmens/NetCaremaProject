//
//  DemandViewCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "DemandViewCell.h"
#import "DemandModel.h"
#import <UIImageView+YYWebImage.h>

@interface DemandViewCell ()

@property (nonatomic,strong) UIButton *selectBtn;

@property (nonatomic,strong) UIImageView *showImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *describeLabel;
@property (nonatomic,strong) UILabel *createTimeLabel;

@property (nonatomic,strong) DemandModel *model;
@end

@implementation DemandViewCell
-(void)doSetup
{
    [super doSetup];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _showImageView = [UIImageView new];
    _showImageView.image = UIImageWithFileName(@"player_hoder_image");
    [self.contentView addSubview:_showImageView];
    [_showImageView leftToView:self.self.contentView withSpace:8];
    [_showImageView topToView:self.contentView withSpace:8];
    [_showImageView bottomToView:self.contentView withSpace:8];
    [_showImageView addWidth:84];
    
    
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"测试视频";
    _titleLabel.textColor = kColorMainTextColor;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeFifty];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel topToView:self.contentView withSpace:8];
    [_titleLabel leftToView:_showImageView withSpace:8];
    
    
    _describeLabel = [UILabel new];
    _describeLabel.text = @"视频描述视频描述视频描述视频描述视频描述视频描述视频描述视频描述视频描述视频描述";
    _describeLabel.textColor = kColorSecondTextColor;
    _describeLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    _describeLabel.numberOfLines = 2;
    [self.contentView addSubview:_describeLabel];
    [_describeLabel topToView:_titleLabel withSpace:5];
    [_describeLabel leftToView:_showImageView withSpace:8];
    [_describeLabel addWidth:kScreenWidth - 108];
    
    _createTimeLabel = [UILabel new];
    _createTimeLabel.text = @"2020-09-30T17:29:35.118+08:00";
    _createTimeLabel.textColor = kColorSecondTextColor;
    _createTimeLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [self.contentView addSubview:_createTimeLabel];
    [_createTimeLabel leftToView:_showImageView withSpace:8];
    [_createTimeLabel bottomToView:self.contentView withSpace:5];
    
    
    
}

-(void)makeCellData:(DemandModel *)model
{
//    if (self.model != nil) {
//        return;
//    }
    self.model = model;
//    [_showImageView yy_setImageWithURL:[NSURL URLWithString:model.snapUrl] placeholder:UIImageWithFileName(@"player_hoder_image")];
    
    //此处获取视频封面，会有卡顿
//    _showImageView.image = [self getImage:self.model.videoUrl];
    _titleLabel.text = self.model.name;
    NSArray *time1 = [self.model.creationTime componentsSeparatedByString:@"."];
    _createTimeLabel.text = [time1[0] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
}
//根据视频地址获取视频封面
-(UIImage *)getImage:(NSString *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

@end
