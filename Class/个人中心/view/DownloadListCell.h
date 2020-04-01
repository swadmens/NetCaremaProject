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
@interface DownloadListCell : WWTableViewCell

@property (copy, nonatomic) NSString *url;

-(void)makeCellData:(CarmeaVideosModel*)model;

@end

NS_ASSUME_NONNULL_END
