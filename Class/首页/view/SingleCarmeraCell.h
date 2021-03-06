//
//  SingleCarmeraCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/4/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class IndexDataModel;
@class LivingModel;
@interface SingleCarmeraCell : WWTableViewCell

@property (nonatomic,copy) void(^moreClick)(void);
@property (nonatomic,copy) void(^alarmBtnClick)(void);
@property (nonatomic,copy) void(^getSingleModelBackdata)(LivingModel *model);

-(void)makeCellData:(IndexDataModel*)model;


@end

NS_ASSUME_NONNULL_END
