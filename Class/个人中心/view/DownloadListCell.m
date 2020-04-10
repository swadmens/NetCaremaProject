//
//  DownloadListCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/5.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "DownloadListCell.h"
#import "CarmeaVideosModel.h"
#import "DownLoadSence.h"
#import <UIImageView+YYWebImage.h>
#import "DemandModel.h"
#import "YDDownload.h"
#import "CLVoiceApplyAddressModel.h"



@interface DownloadListCell ()

@property (nonatomic,strong) UIImageView *showImageView;
@property (nonatomic,strong) UILabel *titleLabel;//名称
@property (nonatomic,strong) UILabel *timeLabel;//时间
@property (nonatomic,strong) UILabel *totalDataLabel;//总下载量
@property (nonatomic,strong) UIButton *downLoadBtn;

@property (nonatomic,strong) UIProgressView *progressView;//进度条

@property (nonatomic,strong) CarmeaVideosModel *model;
@property (nonatomic,strong) DemandModel *demandModel;
@property (nonatomic,strong) CLVoiceApplyAddressModel *cacheModel;



@end


@implementation DownloadListCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = kColorBackgroundColor;
    
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    [backView alignTop:@"0" leading:@"0" bottom:@"10" trailing:@"0" toView:self.contentView];
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
    
    
    _downLoadBtn = [UIButton new];
    [_downLoadBtn setTitle:@"下载" forState:UIControlStateNormal];
    [_downLoadBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_downLoadBtn addTarget:self action:@selector(startDownloadClick:) forControlEvents:UIControlEventTouchUpInside];
    _downLoadBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [backView addSubview:_downLoadBtn];
    [_downLoadBtn topToView:backView];
    [_downLoadBtn rightToView:backView];
    [_downLoadBtn addWidth:50];
    [_downLoadBtn addHeight:30];
    
    
    
    
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
    _progressView.progress = 0.00;
    [backView addSubview:_progressView];
    [_progressView leftToView:_showImageView withSpace:10];
    [_progressView topToView:_timeLabel withSpace:8];
    [_progressView addWidth:kScreenWidth-195];
    [_progressView addHeight:0.6];

    
    _totalDataLabel = [UILabel new];
    _totalDataLabel.text = @"0.00M/0.00M";
    _totalDataLabel.textColor = kColorThirdTextColor;
    _totalDataLabel.font = [UIFont customFontWithSize:kFontSizeTen];
    [backView addSubview:_totalDataLabel];
    [_totalDataLabel rightToView:backView withSpace:15];
    [_totalDataLabel topToView:_progressView withSpace:5];

    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadTaskDidChangeStatusNotification:) name:YDDownloadTaskDidChangeStatusNotification object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setFrame:(CGRect)frame
{
    frame.origin.x += 15;
    frame.origin.y += 10;
    frame.size.height -= 10;
    frame.size.width -= 30;
    [super setFrame:frame];
}

-(void)makeCellData:(CarmeaVideosModel *)model
{
    self.model = model;
    [_showImageView yy_setImageWithURL:[NSURL URLWithString:model.snap] placeholder:UIImageWithFileName(@"playback_back_image")];
    _titleLabel.text = model.video_name;
    _timeLabel.text = model.time;
}
-(void)makeCellDemandData:(DemandModel *)model
{
    self.demandModel = model;
    [_showImageView yy_setImageWithURL:[NSURL URLWithString:model.snapUrl] placeholder:UIImageWithFileName(@"playback_back_image")];
    _titleLabel.text = model.video_name;
    _timeLabel.text = model.updateAt;
}
-(void)makeCellCacheData:(CLVoiceApplyAddressModel*)model
{
    self.cacheModel = model;
    [_showImageView yy_setImageWithURL:[NSURL URLWithString:model.snap] placeholder:UIImageWithFileName(@"playback_back_image")];
    _titleLabel.text = model.name;
    _timeLabel.text = model.time;
    _progressView.progress = [model.progress floatValue];
    _totalDataLabel.text = model.writeBytes;
    if (_progressView.progress >= 1) {
        _progressView.hidden = YES;
        [_downLoadBtn setTitle:@"已完成" forState:UIControlStateNormal];
    }else{
        [_downLoadBtn setTitle:@"下载" forState:UIControlStateNormal];
    }
}

//播放
-(void)startDownLoad:(UITapGestureRecognizer*)tp
{
    
}
//下载
-(void)startDownloadClick:(UIButton*)sender
{
    __unsafe_unretained typeof(self) weak_self = self;
    
    if ([sender.currentTitle isEqualToString:@"下载"]) {
           
           self.downloadTask = [[YDDownloadQueue defaultQueue] addDownloadTaskWithPriority:YDDownloadPriorityDefault url:self.url progressHandler:^(CGFloat progress, CGFloat speed, NSString *writeBytes) {
               
               weak_self.progressView.progress = progress;
               weak_self.totalDataLabel.text = writeBytes;
               NSString *strValue = [NSString stringWithFormat:@"%f",progress];
               if (weak_self.downlaodProgress) {
                   weak_self.downlaodProgress(strValue,writeBytes);
               }
//               if (speed < 1024) {
//                   self.speedLabel.text = [NSString stringWithFormat:@"%.2fB/s", speed];
//               } else if (speed < 1024 * 1024) {
//                   self.speedLabel.text = [NSString stringWithFormat:@"%.2fK/s", speed / 1024];
//               } else {
//                   self.speedLabel.text = [NSString stringWithFormat:@"%.2fM/s", speed / 1024 / 1024];
//               }
               
           } completionHandler:^(NSString *filePath, NSError *error) {
               
//               self.speedLabel.text = nil;
               if (error.code == -999) {
                   weak_self.progressView.progress = 0;
               }
               NSLog(@"%@", filePath);
               if (weak_self.localizedFilePath) {
                   weak_self.localizedFilePath(filePath);
               }
               NSURL *url = [NSURL URLWithString:filePath];
               BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
               if (compatible)
               {
                   //保存相册核心代码
                   UISaveVideoAtPathToSavedPhotosAlbum([url path], weak_self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
                   if (weak_self.localizedFilePath) {
                       weak_self.localizedFilePath(filePath);
                   }
               }
           }];
           
       } else if ([sender.currentTitle isEqualToString:@"继续"]) {
           [weak_self.downloadTask resumeTask];
          
       } else if ([sender.currentTitle isEqualToString:@"暂停"] || [sender.currentTitle isEqualToString:@"等待中"]) {
           [weak_self.downloadTask suspendTask];
       }
    
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
- (void)downloadTaskDidChangeStatusNotification:(NSNotification *)notify
{
    YDDownloadTask *downloadTask = (YDDownloadTask *)notify.object;
    if (![downloadTask.downloadUrl isEqualToString:self.url]) {
        return;
    }
    switch (downloadTask.taskStatus) {
        case YDDownloadTaskStatusWaiting:
        case YDDownloadTaskStatusFailed: {
            [_downLoadBtn setTitle:@"等待中" forState:UIControlStateNormal];
        }
            break;
        case YDDownloadTaskStatusRunning: {
            [_downLoadBtn setTitle:@"暂停" forState:UIControlStateNormal];
        }
            break;
        case YDDownloadTaskStatusSuspended: {
            [_downLoadBtn setTitle:@"继续" forState:UIControlStateNormal];
        }
            break;
        case YDDownloadTaskStatusCanceled: {
            [_downLoadBtn setTitle:@"下载" forState:UIControlStateNormal];
        }
            break;
        case YDDownloadTaskStatusCompleted: {
            [_downLoadBtn setTitle:@"已完成" forState:UIControlStateNormal];
        }
            break;
        default: {
            [_downLoadBtn setTitle:@"下载" forState:UIControlStateNormal];
        }
            break;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
