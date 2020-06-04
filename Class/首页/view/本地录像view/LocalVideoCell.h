//
//  LocalVideoCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/4/29.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class CarmeaVideosModel;
@interface LocalVideoCell : WWTableViewCell

@property (nonatomic,assign) BOOL isEdit;

@property (nonatomic,strong) UIButton *selectBtn;

-(void)makeCellData:(CarmeaVideosModel*)model;

@end

NS_ASSUME_NONNULL_END
