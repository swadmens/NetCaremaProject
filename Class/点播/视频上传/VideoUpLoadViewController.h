//
//  VideoUpLoadViewController.h
//  NetCamera
//
//  Created by 汪伟 on 2020/3/4.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWViewController.h"


@protocol VideoUpLoadSuccessDelegate <NSObject>

-(void)uploadVideoSuccess;//上传完成

@end


NS_ASSUME_NONNULL_BEGIN

@interface VideoUpLoadViewController : WWViewController

@property (nonatomic,assign) id<VideoUpLoadSuccessDelegate>delegate;


@end

NS_ASSUME_NONNULL_END
