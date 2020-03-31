//
//  DownloadEngine.m
//  AFTest
//
//  Created by icash on 15-7-23.
//  Copyright (c) 2015年 icash. All rights reserved.
//

#import "DownloadEngine.h"
#import "FilePathManager.h"

@interface DownloadEngine ()


@property (nonatomic, strong) AFURLSessionManager *defaultManager;
@property (nonatomic, strong) AFURLSessionManager *backgroundManager;
/// 默认下载路径
@property (nonatomic, strong) NSString *defaultDownloadPath;
@property (nonatomic, strong) NSString *cacheFilePath;
@property (nonatomic, strong) NSString *tmpFilePath;

@end

@implementation DownloadEngine

+ (DownloadEngine *)sharedInstance
{
    static DownloadEngine *_engine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _engine = [[DownloadEngine alloc] init];
    });
    return _engine;
}
- (AFURLSessionManager *)defaultManager
{
    if (!_defaultManager) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _defaultManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    }
    return _defaultManager;
}
- (AFURLSessionManager *)backgroundManager
{
    if (!_backgroundManager) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:kBackgroundDownloadIdentifier];
        _backgroundManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    }
    return _backgroundManager;
}
- (NSString *)cacheFilePath
{
    if (!_cacheFilePath) {
        _cacheFilePath = [FilePathManager cacheFilePath];
    }
    return _cacheFilePath;
}
- (NSString *)defaultDownloadPath
{
    if (!_defaultDownloadPath) {
        _defaultDownloadPath = [FilePathManager defaultDownloadPath];
    }
    return _defaultDownloadPath;
}
- (NSString *)tmpFilePath
{
    if (!_tmpFilePath) {
        _tmpFilePath = [FilePathManager tmpFilePath];
    }
    return _tmpFilePath;
}

/**
 * 增加一个普通下载
 */
- (NSURLSessionDownloadTask *)addDownload:(NSString *)url toPath:(NSString *)downloadPath withName:(NSString *)fileName reDownload:(BOOL)redown onCompletion:(DownloadDidFinished)finishBlock progress:(DownloadUpdateProgress)downloadProgress
{
    if (url == nil) {
        url = @"";
    }
    
//    //获取视频文件总大小
//    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:@"http://192.168.6.120:10080/frecord/nvr017/20200325/20200325034226/nvr017_record.m3u8"] options:nil];// url：网络视频的连接
//    NSArray *arr = [asset tracksWithMediaType:AVMediaTypeDepthData];// 项目中是明确媒体类型为视频，其他没试过
//    for (AVAssetTrack *track in arr) {
//        DLog(@"track---:%@", track);
//        DLog(@"track.totalSampleDataLength---:%lld", track.totalSampleDataLength);// 视频文件字节大小
//    }

//    __unsafe_unretained typeof(self) weak_self = self;

    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
//    [request setHTTPMethod:@"HEAD"];
//    // 清空Accept-Encoding请求头字段，不接受Gzip压缩
//    [request setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    //配置用户名 密码
    NSString *str1 = [NSString stringWithFormat:@"%@/%@:%@",_kUserModel.userInfo.tenant_name,_kUserModel.userInfo.user_name,_kUserModel.userInfo.password];
    //进行加密  [str base64EncodedString]使用开源Base64.h分类文件加密
    NSString *str2 = [NSString stringWithFormat:@"Basic %@",[WWPublicMethod encodeBase64:str1]];
    // 设置Authorization的方法设置header
    [request setValue:str2 forHTTPHeaderField:@"Authorization"];
    
    NSString *md5url = MD5(url);
    
    if (fileName == nil || [fileName isEqual:@""]) {
        NSString *lastName = [url componentsSeparatedByString:@"."].lastObject;
        NSString *space = @".";
        if (lastName == nil) {
            lastName = @"";
            space = @"";
        }
        fileName = [NSString stringWithFormat:@"%@%@%@",md5url,space,lastName];
    }
    if ([fileName rangeOfString:@"."].location == NSNotFound) fileName = [fileName stringByAppendingString:@".unknowfile"];
    
    if (downloadPath == nil || [downloadPath isEqual:@""]) {
        downloadPath = self.defaultDownloadPath;
    }
    if ([downloadPath hasSuffix:@"/"]) {
        downloadPath = [downloadPath substringToIndex:(downloadPath.length - 1)];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:downloadPath] == NO) {
        [fileManager createDirectoryAtPath:downloadPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    /// 最后的文件路径
    NSString *finalPath = [downloadPath stringByAppendingPathComponent:fileName];
    
    BOOL existFile = [fileManager fileExistsAtPath:finalPath];
    
    if (existFile) {
        if (redown == NO) {
            // 如果存在文件,并且不需要重下，就直接返回
            if (finishBlock) {
                finishBlock(finalPath);
            }
            return nil;
        }
        // 删除文件
        [fileManager removeItemAtPath:finalPath error:nil];
    }
    __block NSURLSessionDownloadTask *task = nil;
    
    if (redown) {
        task = [self.defaultManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {

        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [self handleDestinationWithPath:finalPath fromPath:targetPath response:response];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            [self handleCompletion:response atPath:filePath error:error onCompletion:finishBlock];
        }];
    }else{
        NSString *tmpFile = [NSString stringWithFormat:@"%@%@.tmp",[FilePathManager appTmpPath],md5url]; // 以md5加密url存tmp
        NSData *resumeData = [NSData dataWithContentsOfFile:tmpFile];
        if (resumeData) {
            [[NSFileManager defaultManager] removeItemAtPath:tmpFile error:nil];
            task =[self.defaultManager downloadTaskWithResumeData:resumeData progress:^(NSProgress * _Nonnull downloadProgress) {

            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                return [self handleDestinationWithPath:finalPath fromPath:targetPath response:response];
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                [self handleCompletion:response atPath:filePath error:error onCompletion:finishBlock];
            }];
        }else{
            task = [self.defaultManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {

            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                return [self handleDestinationWithPath:finalPath fromPath:targetPath response:response];
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                [self handleCompletion:response atPath:filePath error:error onCompletion:finishBlock];
            }];
        }
        
    }
    task.taskDescription = md5url;
    
    // 开始断点下载了
    [self.defaultManager setDownloadTaskDidResumeBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t fileOffset, int64_t expectedTotalBytes) {
        if (downloadProgress) {
            downloadProgress(downloadTask.progress);
        }
    }];
    
    /// 下载进度监控
    [self.defaultManager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        
        if (downloadProgress) {
            downloadProgress(downloadTask.progress);
        }
        DLog(@"totalBytesExpectedToWrite == %lld",totalBytesExpectedToWrite);
        DLog(@"downloadTask.progress == %lld",downloadTask.progress.completedUnitCount);
    }];
    
    // 开始下载
    [task resume];
    
    return task;
}

- (NSURL *)handleDestinationWithPath:(NSString *)finalPath fromPath:(NSURL *)targetPath response:(NSURLResponse *)response
{
    NSURL *fileURL = [NSURL fileURLWithPath:finalPath];
    return fileURL;
}
- (void)handleCompletion:(NSURLResponse *)response atPath:(NSURL *)filePath error:(NSError *)error onCompletion:(DownloadDidFinished)finishBlock
{
    if (finishBlock) {
        NSString *pathString = filePath.absoluteString;
        if ([pathString hasPrefix:@"file:///"]) {
            pathString = [pathString substringFromIndex:@"file:///".length];
        }
        finishBlock(pathString);
        DLog(@"response == %lld",response.expectedContentLength);
    }
}
/// 取消下载
- (void)cancelDownloadTask:(NSURLSessionDownloadTask *)task
{
    __block NSURLSessionDownloadTask *cancelTask = task;
    // 取消并拿到取消时下载完成的Data
    [cancelTask cancelByProducingResumeData:^(NSData *resumeData) {
        // 保存临时文件
        NSString *tmpFile = [NSString stringWithFormat:@"%@%@.tmp",[FilePathManager appTmpPath],task.taskDescription]; // 以md5加密url存tmp
        [resumeData writeToFile:tmpFile atomically:YES];
        cancelTask = nil;
    }];
}
/**
 * 增加后台下载,暂时不使用
 */
- (void)addBackgroundDownload:(NSString *)url toPath:(NSString *)downloadPath withName:(NSString *)fileName reDownload:(BOOL)redown onCompletion:(DownloadDidFinished)finishBlock progress:(DownloadUpdateProgress)downloadProgress
{
    
}
@end













