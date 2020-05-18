//
//  MoreCarmerasCollectionViewCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/4/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class MyEquipmentsModel;
@interface MoreCarmerasCollectionViewCell : WWCollectionViewCell

-(void)makeCellData:(MyEquipmentsModel*)model;
@property (nonatomic,copy) void(^moreBtnClick)(void);

@end

NS_ASSUME_NONNULL_END
