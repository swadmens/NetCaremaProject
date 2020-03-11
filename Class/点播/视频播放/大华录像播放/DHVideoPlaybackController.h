//
//  DHVideoPlaybackController.h
//  NetCamera
//
//  Created by 汪伟 on 2020/3/11.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class VideoWnd;
@interface DHVideoPlaybackController : WWViewController

@property (nonatomic,strong) NSString *video_id;


@property (strong, nonatomic) VideoWnd *viewPlay;


@property (nonatomic, retain) NSString *fname;

-(id)initWithValue:(NSString *)value;


@end

NS_ASSUME_NONNULL_END
