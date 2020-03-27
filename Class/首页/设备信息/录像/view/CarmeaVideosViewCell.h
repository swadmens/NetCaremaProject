//
//  CarmeaVideosViewCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/3/2.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class CarmeaVideosModel;
@interface CarmeaVideosViewCell : WWCollectionViewCell

@property (nonatomic,assign) BOOL isEdit;
@property (nonatomic,assign) BOOL isChoosed;

-(void)makeCellData:(CarmeaVideosModel*)model;

@end

NS_ASSUME_NONNULL_END
