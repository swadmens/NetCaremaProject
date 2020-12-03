//
//  PersonInfoViewController.h
//  NetCamera
//
//  Created by 汪伟 on 2020/2/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonInfoViewController : WWViewController

//测试，RAC替换代理
@property (nonatomic,strong) RACSubject *delegateSignal;


@end

NS_ASSUME_NONNULL_END
