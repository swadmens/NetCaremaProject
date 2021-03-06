//
//  ChooseAreaView.h
//  NetCamera
//
//  Created by 汪伟 on 2020/3/4.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChooseAreaView : UIView

@property (nonatomic,strong) void(^chooseArea)(NSString *area_id);
//@property (nonatomic,strong) void(^resetChooseBtn)(void);

-(void)makeViewData:(NSArray*)array;

@end

NS_ASSUME_NONNULL_END
