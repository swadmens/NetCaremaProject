//
//  PlayerLocalVideosCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/5/7.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class CarmeaVideosModel;
@interface PlayerLocalVideosCell : WWTableViewCell

@property (nonatomic,copy) void(^allBtn)(void);
@property (nonatomic,copy) void(^selectedRowData)(CarmeaVideosModel*model);
-(void)makeCellData:(NSArray*)array withTitle:(NSString*)title;

@end

NS_ASSUME_NONNULL_END
