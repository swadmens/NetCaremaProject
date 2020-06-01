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

@end

NS_ASSUME_NONNULL_END
