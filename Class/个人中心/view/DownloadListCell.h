//
//  DownloadListCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/3/5.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class CarmeaVideosModel;
@class DemandModel;
@class YDDownloadTask;
@class CLVoiceApplyAddressModel;
@interface DownloadListCell : WWTableViewCell

@property (copy, nonatomic) NSString *url;

@property (nonatomic,copy) void(^downlaodProgress)(NSString *value, NSString *writeBytes);//下载进度
@property (nonatomic,copy) void(^localizedFilePath)(NSString *value);//本地文件路径

@property (nonatomic, strong) YDDownloadTask *downloadTask;
@property (nonatomic, strong) NSIndexPath *indexPath;

-(void)makeCellData:(CarmeaVideosModel*)model;
-(void)makeCellDemandData:(DemandModel*)model;
-(void)makeCellCacheData:(CLVoiceApplyAddressModel*)model;

@end

NS_ASSUME_NONNULL_END
