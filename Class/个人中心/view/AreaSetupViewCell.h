//
//  AreaSetupViewCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/10/26.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class AreaSetupModel;
@interface AreaSetupViewCell : WWTableViewCell

-(void)makeCellData:(AreaSetupModel*)model;

@end

NS_ASSUME_NONNULL_END
