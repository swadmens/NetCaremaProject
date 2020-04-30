//
//  AddCarmeraAddressController.h
//  NetCamera
//
//  Created by 汪伟 on 2020/4/30.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AddCarmeraAddressDelegate <NSObject>

-(void)addNewAddress:(NSString*)address;

@end


@interface AddCarmeraAddressController : WWViewController

@property (nonatomic,weak) id<AddCarmeraAddressDelegate>delegate;


@end

NS_ASSUME_NONNULL_END
