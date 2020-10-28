//
//  AreaNormalCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/3/4.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class AreaInfoModel;
@interface AreaNormalCell : WWTableViewCell

-(void)makeCellData:(AreaInfoModel*)model;

@end

NS_ASSUME_NONNULL_END
