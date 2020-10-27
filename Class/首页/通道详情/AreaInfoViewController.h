//
//  AreaInfoViewController.h
//  NetCamera
//
//  Created by 汪伟 on 2020/10/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class AreaSetupModel;
@interface AreaInfoViewController : WWViewController

@property (nonatomic,strong) AreaSetupModel *model;
@property (nonatomic,strong) NSString *carmera_id;
@property (nonatomic,assign) BOOL isAddInfo;//新增还是编辑



@end

NS_ASSUME_NONNULL_END
