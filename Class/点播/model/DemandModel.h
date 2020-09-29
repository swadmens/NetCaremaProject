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

@property (nonatomic,strong) NSString *streamName;
@property (nonatomic,strong) NSString *duration;
@property (nonatomic,strong) NSString *creationDate;
@property (nonatomic,strong) NSString *filePath;
@property (nonatomic,strong) NSString *fileSize;
@property (nonatomic,strong) NSString *streamId;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *vodId;
@property (nonatomic,strong) NSString *vodName;


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
