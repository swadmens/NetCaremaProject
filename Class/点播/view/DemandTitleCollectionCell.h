//
//  DemandTitleCollectionCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/3/3.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class DemandSubcatalogModel;
@interface DemandTitleCollectionCell : WWCollectionViewCell

-(void)makeCellData:(DemandSubcatalogModel*)model;


@end

NS_ASSUME_NONNULL_END
