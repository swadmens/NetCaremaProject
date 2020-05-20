//
//  DeleteGroupsTableViewCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/5/6.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeleteGroupsTableViewCell : WWTableViewCell

-(void)makeCellData:(NSDictionary*)dic;
@property (nonatomic,strong) UIButton *selectBtn;

@end

NS_ASSUME_NONNULL_END
