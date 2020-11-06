//
//  AudioTalkView.h
//  NetCamera
//
//  Created by 汪伟 on 2020/11/5.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class AudioTalkView;
@protocol AudioTalkViewDelegate <NSObject>

-(void)viewColseBtnClick:(AudioTalkView *_Nullable)view;

@end

@interface AudioTalkView : UIView

@property (nonatomic, weak) id<AudioTalkViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
