//
//  PlayerTableViewCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/5/7.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class PlayerTableViewCell;
@class MyEquipmentsModel;
@protocol PlayerTableViewCellDelegate <NSObject>

- (void)tableViewWillPlay:(PlayerTableViewCell *)cell;

- (void)tableViewCellEnterFullScreen:(PlayerTableViewCell *)cell;

- (void)tableViewCellExitFullScreen:(PlayerTableViewCell *)cell;

- (void)getPlayerCellSnapshot:(PlayerTableViewCell *_Nullable)cell with:(UIImage*_Nullable)image;

- (void)selectCellCarmera:(PlayerTableViewCell *_Nullable)cell withData:(MyEquipmentsModel*)model withIndex:(NSInteger)index;

@end

@class CarmeaVideosModel;
@interface PlayerTableViewCell : WWTableViewCell

@property (nonatomic, weak) id<PlayerTableViewCellDelegate> delegate;

-(void)makeCellDataLiving:(NSArray*)array;

- (void)stop;
-(void)play;
- (void)pause;
- (void)resume;
-(void)makePlayerViewFullScreen;
-(void)makeCellScale:(BOOL)scale;
-(void)clickSnapshotButton;
- (void)changeVolume:(float)volume;

- (void)startOrStopVideo:(BOOL)start;
-(void)videoStandardClarity:(BOOL)standard;


@end

NS_ASSUME_NONNULL_END
