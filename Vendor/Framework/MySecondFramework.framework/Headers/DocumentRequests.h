//
//  DocumentRequests.h
//  MyFrameworkTestProject
//
//  Created by 汪伟 on 2020/9/8.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 请求完成
typedef void(^RequestSuccessBlock)(id obj);
/// 请求失败
typedef void(^RequestErrorBlock)(NSError *error , id result);

/// 下载进度
typedef void(^DownloadProgressBlock)(NSProgress *progress);
///下载完成
typedef void(^DownloadCompleteBlock)(NSURL *filePath);

@interface DocumentRequests : NSObject

/*
 *上传文件
 *name file
 *fileName 文件名称
 *mimeType text/plain
 *data 文件数据
 *body @{
         @"name":@"file",
         @"fileName":@"",
         @"mimeType":@"text/plain",
         @"data":@""
         }
 */
+(void)documentUploadAuthorization:(NSString*)authorization documentFile:(NSDictionary*)body withName:(NSString*)fileName success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *获取文件信息
 *numbers  请求数据数量
 *pageNum  请求分页的页数
 */
+(void)documentGetInfomationAuthorization:(NSString*)authorization pageSize:(NSString*)numbers currentPage:(NSString*)pageNum success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;

/*
 *下载文件
 *binaryId  文件id
 */
+(void)documentDownLoadAuthorization:(NSString*)authorization binary:(NSString*)binaryId downloadFileName:(NSString*)fileName loadProgress:(DownloadProgressBlock)progress success:(DownloadCompleteBlock)complete error:(RequestErrorBlock)fail;

/*
 *删除文件
 *binaryId  文件id
 */
+(void)documentDeleteAuthorization:(NSString*)authorization binary:(NSString*)binaryId success:(RequestSuccessBlock)success error:(RequestErrorBlock)fail;




@end

NS_ASSUME_NONNULL_END
