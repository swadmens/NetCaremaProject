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
@property (nonatomic,strong) DemandModel *model;
@end

@implementation DemandViewCell
-(void)doSetup
{
    [super doSetup];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = kScreenWidth/2-21;
    
    _showImageView = [UIImageView new];
    _showImageView.image = UIImageWithFileName(@"player_hoder_image");
    [self.contentView addSubview:_showImageView];
    [_showImageView leftToView:self.self.contentView];
    [_showImageView topToView:self.contentView];
    [_showImageView bottomToView:self.contentView withSpace:32.5];
    [_showImageView addWidth:width];
    
    
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"测试视频";
    _titleLabel.textColor = kColorSecondTextColor;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel leftToView:self.contentView withSpace:8];
    [_titleLabel topToView:_showImageView withSpace:10];
    [_titleLabel addWidth:width];
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
