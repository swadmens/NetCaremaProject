//
//  HikPlayerView.h
//  NetCamera
//
//  Created by 汪伟 on 2020/9/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HiKEZUIPlayerDelegate <NSObject>
@optional

/**
 返回按钮点击
 */
-(void)playerBackBtnClicked;

/**
 播放结束
 */
-(void)playerEnd;

/**
 进入全屏
 */
-(void)enterFullScreen;

/**
 退出全屏
 */
-(void)exitFullScreen;

/**
 屏幕方向改变
 */
-(void)OrienrationChanged:(UIDeviceOrientation)orientation;

/**
 开始播放

 @param seconds 开始播放位置(秒)
 */
-(void)playerStartPlay:(NSInteger)seconds;

/**
 播放中断

 @param seconds 中断播放位置(秒)
 */
-(void)breakEventBecome:(NSInteger)seconds;

/**
 切换地址
 */
-(void)changeEventBecome;

/**
 播放出错
 */
-(void)errorEventBecome;

@end

@interface HikPlayerView : UIView

@property (weak,nonatomic) id<HiKEZUIPlayerDelegate>delegate;

/**
 创建播放器
 url：地址
 type：类型 本地或网络
 */
-(instancetype)initWithFrame:(CGRect)frame url:(NSString*)url;


//正片地址
@property (retain,nonatomic) NSString *urlStr;
/**
 观看时长，从打开播放器到退出播放器的时长
 */
@property (assign,nonatomic) float watchTime;
/**
 观看时长，从打开播放器到退出播放器的时长
 */
@property (assign,nonatomic) float sumTime;
@property (strong,nonatomic) NSString *sumtimeNew;
/*
 播放时长，播放到多少秒
 */
@property (assign,nonatomic) float playTime;

/**
 显示/隐藏返回按钮
 */
-(void)showBackBtn:(BOOL)_show;
/**
 是否显示全屏按钮
 */
-(void)showFullScreenBtn:(BOOL)_show;

/**
 进入全屏
 */
-(void)go2FullScreen;

/**
 跳转进度
 */
-(void)seek2PlayTime:(CGFloat)time;
/**
 停止
 */
-(void)stop;
/**
 暂停
 */
-(void)pause;
/**
 播放
 */
-(void)play;


@end

NS_ASSUME_NONNULL_END
