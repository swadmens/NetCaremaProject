//
//  StartRecordVideoController.h
//  YuLaLa
//
//  Created by 汪伟 on 2018/6/5.
//  Copyright © 2018年 Guangzhou YouPin Trade Co.,Ltd. All rights reserved.
//

#import "WWViewController.h"



@protocol StartRecordVideoDelegate <NSObject>

- (void)recordVideoNormalPath:(NSString *)path;

- (void)recordVideoTakeHomePath:(NSString *)path withImage:(UIImage*)image;


@end

typedef void(^TakeOperationSureBlock)(id item);

/**
 *  短视频录制VC
 */
@interface StartRecordVideoController : WWViewController

@property (copy, nonatomic) TakeOperationSureBlock takeBlock;

@property (nonatomic, weak) id<StartRecordVideoDelegate> delegate;

//-(void)onBtnCloseClicked;

@end
