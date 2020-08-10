//
//  DemandModel.h
//  NetCamera
//
//  Created by 汪伟 on 2020/3/25.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemandModel : NSObject

+(DemandModel*)makeModelData:(NSDictionary*)dic;

@property (nonatomic,strong) NSString *video_id;//视频id
@property (nonatomic,strong) NSString *video_name;//视频名称
@property (nonatomic,strong) NSString *size;//文件大小
@property (nonatomic,strong) NSString *type;//文件类型
@property (nonatomic,strong) NSString *status;//转码状态
@property (nonatomic,strong) NSString *duration;//时长
@property (nonatomic,strong) NSString *aspect;
@property (nonatomic,strong) NSString *audioCodec;
@property (nonatomic,strong) NSString *createAt;
@property (nonatomic,strong) NSString *error;
@property (nonatomic,strong) NSString *flowNum;
@property (nonatomic,strong) NSString *folder;
@property (nonatomic,strong) NSString *isresolution;
@property (nonatomic,strong) NSString *path;
@property (nonatomic,strong) NSString *playNum;
@property (nonatomic,strong) NSString *progress;
@property (nonatomic,strong) NSString *resolution;
@property (nonatomic,strong) NSString *resolutiondefault;
@property (nonatomic,strong) NSString *rotate;
@property (nonatomic,strong) NSString *shared;
@property (nonatomic,strong) NSString *sharedLink;
@property (nonatomic,strong) NSString *snapUrl;
@property (nonatomic,strong) NSString *transvideo;
@property (nonatomic,strong) NSString *updateAt;
@property (nonatomic,strong) NSString *videoUrl;
@property (nonatomic,strong) NSString *videoCodec;


@property (nonatomic,strong) NSString *hls;
@property (nonatomic,strong) NSString *important;
@property (nonatomic,strong) NSString *snap;
@property (nonatomic,strong) NSString *start_time;
@property (nonatomic,strong) NSString *time;






@property (nonatomic,strong) NSString *vods_creationDate;
@property (nonatomic,strong) NSString *vods_duration;
@property (nonatomic,strong) NSString *vods_filePath;
@property (nonatomic,strong) NSString *vods_fileSize;
@property (nonatomic,strong) NSString *vods_streamId;
@property (nonatomic,strong) NSString *vods_streamName;
@property (nonatomic,strong) NSString *vods_type;
@property (nonatomic,strong) NSString *vods_vodId;
@property (nonatomic,strong) NSString *vods_vodName;






@end


@interface DemandSubcatalogModel : NSObject

+(DemandSubcatalogModel*)makeModelData:(NSDictionary*)dic;


@property (nonatomic,strong) NSString *createAt;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSString *folder;
@property (nonatomic,strong) NSString *sub_id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *realPath;
@property (nonatomic,strong) NSString *sort;
@property (nonatomic,strong) NSString *updateAt;

@end



NS_ASSUME_NONNULL_END
