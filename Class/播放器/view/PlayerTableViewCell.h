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
@protocol PlayerTableViewCellDelegate <NSObject>

- (void)tableViewWillPlay:(PlayerTableViewCell *)cell;

- (void)tableViewCellEnterFullScreen:(PlayerTableViewCell *)cell;

- (void)tableViewCellExitFullScreen:(PlayerTableViewCell *)cell;

@end

@class DemandModel;
@interface PlayerTableViewCell : WWTableViewCell

@property (nonatomic, weak) id<PlayerTableViewCellDelegate> delegate;

-(void)makeCellDataNoLiving:(DemandModel*)model witnLive:(BOOL)isLiving;
-(void)makeCellDataLiving:(NSArray*)array witnLive:(BOOL)isLiving;

@end

NS_ASSUME_NONNULL_END
