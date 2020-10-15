//
//  PlayVideoDemadCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/10/15.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class PlayVideoDemadCell;
@protocol PlayVideoDemadDelegate <NSObject>

- (void)tableViewWillPlay:(PlayVideoDemadCell *)cell;

- (void)tableViewCellEnterFullScreen:(PlayVideoDemadCell *)cell;

- (void)tableViewCellExitFullScreen:(PlayVideoDemadCell *)cell;

@end


@class CarmeaVideosModel;
@interface PlayVideoDemadCell : WWTableViewCell

@property (nonatomic, assign) id<PlayVideoDemadDelegate> delegate;

- (void)stop;
- (void)play;
- (void)pause;
- (void)resume;

-(void)clickSnapshotButton;
-(void)makePlayerViewFullScreen;
- (void)changeVolume:(float)volume;
-(void)videoStandardClarity:(BOOL)standard;
-(void)makeModelData:(CarmeaVideosModel*)model;

@end

NS_ASSUME_NONNULL_END
