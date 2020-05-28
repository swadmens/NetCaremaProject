//
//  MyEquipmentsViewController.h
//  NetCamera
//
//  Created by 汪伟 on 2020/2/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class LivingModel;
@protocol MyEquipmentsDelegate <NSObject>

-(void)selectCarmeraModel:(LivingModel*)model;

@end


@interface MyEquipmentsViewController : WWViewController

@property (nonatomic,weak) id<MyEquipmentsDelegate>delegate;

@property (nonatomic,strong) NSArray *dataArray;

@end

NS_ASSUME_NONNULL_END
