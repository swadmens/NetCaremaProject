//
//  MyEquipmentsCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/2/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class LivingModel;
@interface MyEquipmentsCell : WWTableViewCell

-(void)makeCellData:(LivingModel*)model;


@end

NS_ASSUME_NONNULL_END
