//
//  PlayerTopCollectionViewCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/5/8.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWCollectionViewCell.h"



@class PlayerTopCollectionViewCell;
@protocol PlayerTopCollectionDelegate <NSObject>

- (void)playerViewCellEnterFullScreen:(PlayerTopCollectionViewCell *_Nullable)cell;

- (void)playerViewCellExitFullScreen:(PlayerTopCollectionViewCell *_Nullable)cell;

- (void)playerViewCellWillPlay:(PlayerTopCollectionViewCell *_Nullable)cell;

- (void)getTopCellSnapshot:(PlayerTopCollectionViewCell *_Nullable)cell with:(UIImage*_Nullable)image;

@end


NS_ASSUME_NONNULL_BEGIN

@class PLPlayerView;
@interface PlayerTopCollectionViewCell : WWCollectionViewCell

@property (nonatomic,assign) id<PlayerTopCollectionDelegate>delegate;

-(void)makeCellData:(id)obj;

- (void)playerViewEnterFullScreen:(PLPlayerView *)playerView;

- (void)play;

- (void)stop;

- (void)configureVideo:(BOOL)enableRender;

-(void)makePlayerViewFullScreen:(BOOL)selected;

-(void)clickSnapshotButton;
- (void)changeVolume:(float)volume;
-(void)videoStandardClarity:(BOOL)standard;


@end

NS_ASSUME_NONNULL_END
