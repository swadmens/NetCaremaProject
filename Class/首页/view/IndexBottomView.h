//
//  IndexBottomView.h
//  NetCamera
//
//  Created by 汪伟 on 2020/4/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IndexBottomDelegate <NSObject>

-(void)clickCancelBtn;

-(void)clickAllVideos;

@end


@interface IndexBottomView : UIView

@property (nonatomic,weak) id<IndexBottomDelegate> delegate;

-(void)makeViewData:(NSArray*)arr with:(NSString*)device_id;

@end

NS_ASSUME_NONNULL_END
