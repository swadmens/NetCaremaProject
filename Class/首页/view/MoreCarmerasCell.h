//
//  MoreCarmerasCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/4/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class IndexDataModel;
@interface MoreCarmerasCell : WWTableViewCell

@property (nonatomic,copy) void(^moreDealClick)(NSInteger selectRow,BOOL offline);
@property (nonatomic,copy) void(^rightBtnClick)(void);
@property (nonatomic,copy) void(^getModelArrayBackdata)(NSArray *array);
@property (nonatomic,copy) void(^alarmMoreBtnClick)(NSInteger selectRow);

-(void)makeCellData:(IndexDataModel*)model;

@end

NS_ASSUME_NONNULL_END
