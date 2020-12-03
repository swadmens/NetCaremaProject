//
//  EquimentAlarmsCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/12/1.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class EquimentAlarmsModel;
@interface EquimentAlarmsCell : WWTableViewCell

-(void)makeCellData:(EquimentAlarmsModel*)model;

@end

NS_ASSUME_NONNULL_END
