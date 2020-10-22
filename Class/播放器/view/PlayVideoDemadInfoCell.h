//
//  PlayVideoDemadInfoCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/10/22.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class DemandModel;
@interface PlayVideoDemadInfoCell : WWTableViewCell

-(void)makeCellData:(DemandModel*)model;


@end

NS_ASSUME_NONNULL_END
