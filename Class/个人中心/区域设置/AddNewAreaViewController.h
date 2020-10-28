//
//  AddNewAreaViewController.h
//  NetCamera
//
//  Created by 汪伟 on 2020/10/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWViewController.h"

@protocol AddNewAreaSuccessDelegate <NSObject>

-(void)uploadAreaSuccess;

@end


NS_ASSUME_NONNULL_BEGIN

@class AreaSetupModel;
@interface AddNewAreaViewController : WWViewController

@property (nonatomic,weak) id<AddNewAreaSuccessDelegate>delegate;

@property (nonatomic,strong) AreaSetupModel *model;

@end

NS_ASSUME_NONNULL_END
