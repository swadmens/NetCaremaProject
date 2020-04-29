//
//  ShowCarmerasViewController.h
//  NetCamera
//
//  Created by 汪伟 on 2020/4/29.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol showCarmeraDelegate <NSObject>

-(void)getNewArray:(NSArray*)array;

@end


@interface ShowCarmerasViewController : WWViewController

@property (nonatomic,weak) id<showCarmeraDelegate>delegate;

@property (nonatomic,strong) NSString *equipment_id;

@end

NS_ASSUME_NONNULL_END
