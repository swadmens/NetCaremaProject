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
#import "HSDownloadManager.h"
#import "YDDownload.h"



@interface DownloadListCell ()

@property (nonatomic,strong) UIImageView *showImageView;
@property (nonatomic,strong) UILabel *titleLabel;//名称
@property (nonatomic,strong) UILabel *timeLabel;//时间
@property (nonatomic,strong) UILabel *totalDataLabel;//总下载量

@property (nonatomic,strong) UIProgressView *progressView;//进度条
@property (nonatomic,strong) CarmeaVideosModel *model;
@property (nonatomic,strong) DemandModel *demandModel;



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
    _progressView.progress = 0.0;
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


-(void)startDownLoad:(UITapGestureRecognizer*)tp
{
    __unsafe_unretained typeof(self) weak_self = self;

    NSString *urlString = [NSString stringWithFormat:@"http://192.168.6.120:10102/outer/liveqing/record/download/%@/%@",self.url,_model.start_time];
    
    if (self.model == nil) {
        urlString = [NSString stringWithFormat:@"http://192.168.6.120:10102/outer/liveqing/vod/download/%@",self.demandModel.video_id];
    }
    
//    DownLoadSence *sence = [DownLoadSence new];
//    sence.filePath = @"";
//    sence.fileName = @"nvr017_record.mp4";
//    sence.needReDownload = YES;
//    sence.url = @"http://192.168.6.120:10080/record/download/nvr017/20200325034226?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1ODY0ODk1NTAsInB3IjoiMjEyMzJmMjk3YTU3YTVhNzQzODk0YTBlNGE4MDFmYzMiLCJ0bSI6MTU4NjQwMzE1MCwidW4iOiJhZG1pbiJ9.G6tdm9KGD0bZF4UN17pdv2Ld85CQOVerunk8k-UFHF0";
//    [sence startDownload];
//    sence.progressBlock = ^(float progress, NSString *writeBytes) {
//        DLog(@"下载进度 ==  %f",progress)
//        [[GCDQueue mainQueue] queueBlock:^{
//            weak_self.progressView.progress = progress;
//            weak_self.totalDataLabel.text = writeBytes;
//            if (self.downlaodProgress) {
//                self.downlaodProgress(progress);
//            }
//        }];
//    };
//    sence.finishedBlock = ^(NSString *filePath) {
//        DLog(@"文件路径  ==  %@",filePath);
//        NSURL *url = [NSURL URLWithString:filePath];
//        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
//        if (compatible)
//        {
//            //保存相册核心代码
//            UISaveVideoAtPathToSavedPhotosAlbum([url path], weak_self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
//            if (self.localizedFilePath) {
//                self.localizedFilePath(filePath);
//            }
//        }
//    };
    
////    http://192.168.6.120:10080/record/download/nvr017/20200325034226?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1ODYzMzUzNjAsInB3IjoiMjEyMzJmMjk3YTU3YTVhNzQzODk0YTBlNGE4MDFmYzMiLCJ0bSI6MTU4NjI0ODk2MCwidW4iOiJhZG1pbiJ9.tVK2AV8q3MBAPZZiVNDuWmoFJrngWtDh-oYkZcFRRa8

//    [[HSDownloadManager sharedInstance] deleteAllFile];
//
//    [self download:@"http://192.168.6.120:10080/record/download/nvr017/20200325034226?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1ODY0ODk1NTAsInB3IjoiMjEyMzJmMjk3YTU3YTVhNzQzODk0YTBlNGE4MDFmYzMiLCJ0bSI6MTU4NjQwMzE1MCwidW4iOiJhZG1pbiJ9.G6tdm9KGD0bZF4UN17pdv2Ld85CQOVerunk8k-UFHF0" progressLabel:nil progressView:self.progressView button:nil];

    
//    http://192.168.6.120:10102/outer/liveqing/vod/download/M8KKhNrZR
    
//    if ([sender.currentTitle isEqualToString:@"下载"]) {
           
           self.downloadTask = [[YDDownloadQueue defaultQueue] addDownloadTaskWithPriority:YDDownloadPriorityDefault url:self.url progressHandler:^(CGFloat progress, CGFloat speed, NSString *writeBytes) {
               
               self.progressView.progress = progress;
               self.totalDataLabel.text = writeBytes;
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
                   self.progressView.progress = 0;
               }
               NSLog(@"%@", filePath);
               NSURL *url = [NSURL URLWithString:filePath];
               BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
               if (compatible)
               {
                   //保存相册核心代码
                   UISaveVideoAtPathToSavedPhotosAlbum([url path], weak_self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
                   if (self.localizedFilePath) {
                       self.localizedFilePath(filePath);
                   }
               }
           }];
           
//       } else if ([sender.currentTitle isEqualToString:@"继续"]) {
//
//           [self.downloadTask resumeTask];
//
//       } else if ([sender.currentTitle isEqualToString:@"暂停"] || [sender.currentTitle isEqualToString:@"等待中"]) {
//
//           [self.downloadTask suspendTask];
//           self.speedLabel.text = nil;
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

#pragma mark 开启任务下载资源
- (void)download:(NSString *)url progressLabel:(UILabel *)progressLabel progressView:(UIProgressView *)progressView button:(UIButton *)button
{
    [[HSDownloadManager sharedInstance] download:url progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        
        NSString *writeBytes = [NSString stringWithFormat:@"%ldM/%ldM",(long)receivedSize/1048576,(long)expectedSize/1048576];

        dispatch_async(dispatch_get_main_queue(), ^{
//            progressLabel.text = [NSString stringWithFormat:@"%.f%%", progress * 100];
            self.progressView.progress = progress;
            self.totalDataLabel.text = writeBytes;
        });
    } state:^(DownloadState state) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [button setTitle:[self getTitleWithDownloadState:state] forState:UIControlStateNormal];
        });
    }];

    
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
//            [_downLoadBtn setTitle:@"等待中" forState:UIControlStateNormal];
            DLog(@"等待中");
        }
            break;
        case YDDownloadTaskStatusRunning: {
//            [_downLoadBtn setTitle:@"暂停" forState:UIControlStateNormal];
            DLog(@"暂停");

        }
            break;
        case YDDownloadTaskStatusSuspended: {
//            [_downLoadBtn setTitle:@"继续" forState:UIControlStateNormal];
            DLog(@"继续");

        }
            break;
        case YDDownloadTaskStatusCanceled: {
//            [_downLoadBtn setTitle:@"下载" forState:UIControlStateNormal];
            DLog(@"下载");

        }
            break;
        case YDDownloadTaskStatusCompleted: {
//            [_downLoadBtn setTitle:@"已完成" forState:UIControlStateNormal];
            DLog(@"已完成");

        }
            break;
        default: {
//            [_downLoadBtn setTitle:@"下载" forState:UIControlStateNormal];
            DLog(@"下载");

        }
            break;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
