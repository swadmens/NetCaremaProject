//
//  DownloadListCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/5.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "DownloadListCell.h"
#import "CarmeaVideosModel.h"
#import "YBDownloadManager.h"
#import "DownLoadSence.h"
#import <UIImageView+YYWebImage.h>

@interface DownloadListCell ()

@property (nonatomic,strong) UIImageView *showImageView;
@property (nonatomic,strong) UILabel *titleLabel;//名称
@property (nonatomic,strong) UILabel *timeLabel;//时间
@property (nonatomic,strong) UILabel *speedLabel;//下载速度

@property (nonatomic,strong) UILabel *currentDataLabel;//当前已下载量
@property (nonatomic,strong) UILabel *totalDataLabel;//总下载量

@property (nonatomic,strong) UIProgressView *progressView;//进度条
@property (nonatomic,strong) CarmeaVideosModel *model;



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
    _showImageView.userInteractionEnabled = YES;
    _showImageView.image = UIImageWithFileName(@"playback_back_image");
    [backView addSubview:_showImageView];
    [_showImageView alignTop:@"10" leading:@"10" bottom:@"10" trailing:nil toView:backView];
    [_showImageView addWidth:135];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startDownLoad:)];
    [_showImageView addGestureRecognizer:tap];
    
    
    
    
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

-(void)makeCellData:(CarmeaVideosModel *)model
{
    self.model = model;
    [_showImageView yy_setImageWithURL:[NSURL URLWithString:model.snap] placeholder:UIImageWithFileName(@"playback_back_image")];
    _titleLabel.text = model.video_name;
    _timeLabel.text = model.start_time;
}

- (void)setUrl:(NSString *)url
{
    _url = url;
    
    // 控制状态
    YBFileModel *info = [[YBDownloadManager defaultManager] downloadFileModelForURL:url];
    if (info.state == DownloadStateResumed) {
        
        
        if (info.totalExpectedSize) {
        
            NSString *str = [NSString stringWithFormat:@"%.2f%%",1.0*info.totlalReceivedSize / info.totalExpectedSize*100];
            NSLog(@"下载进度 ==  %@",str);
//            self.progressLab.text = str;
        }
        
    }else if (info.state == DownloadStateCompleted)
    {
//        self.progressLab.text = @"下载完毕";
    }else if (info.state == DownloadStateWait)
    {
//        self.progressLab.text = @"等待中";
    }
}
-(void)startDownLoad:(UITapGestureRecognizer*)tp
{
    __unsafe_unretained typeof(self) weak_self = self;

    NSString *urlString = [NSString stringWithFormat:@"http://192.168.6.120:10102/outer/liveqing/record/download/%@/%@",self.url,_model.start_time];
    DownLoadSence *sence = [DownLoadSence new];
    sence.filePath = @"";
    sence.fileName = @"Video.mp4";
    sence.fileLenth = @"3382";
    sence.needReDownload = YES;
    sence.url = urlString;
    [sence startDownload];
    sence.progressBlock = ^(float progress) {
        DLog(@"下载进度 ==  %f",progress)
    };
    sence.finishedBlock = ^(NSString *filePath) {
        DLog(@"文件路径  ==  %@",filePath);
        NSURL *url = [NSURL URLWithString:filePath];
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
        if (compatible)
        {
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum([url path], weak_self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        }
    };
    
//    YBFileModel *info = [[YBDownloadManager defaultManager] downloadFileModelForURL:_model.hls];
//
//       if (info.state == DownloadStateResumed || info.state == DownloadStateWait) {
//           // 暂停下载某个文件
//           [[YBDownloadManager defaultManager] suspend:_model.hls];
//
//       } else {
//           //下载文件
//           [[YBDownloadManager defaultManager] download:_model.hls progress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
//               DLog(@"totalBytesWritten == %ld",(long)totalBytesWritten);
//               DLog(@"totalBytesExpectedToWrite == %ld",(long)totalBytesExpectedToWrite);
//               dispatch_async(dispatch_get_main_queue(), ^{
//                   self.url = self.url;
//               });
//           } state:^(DownloadState state, NSString *file, NSError *error) {
//               DLog(@"error == %@",error);
//               dispatch_async(dispatch_get_main_queue(), ^{
//                   self.url = self.url;
//               });
//           }];
//       }
}
//保存视频完成之后的回调
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        NSLog(@"保存视频失败%@", error.localizedDescription);
    }
    else {
        NSLog(@"保存视频成功");
       
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
