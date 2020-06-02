//
//  PlayerTopAddViewCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/5/29.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayerTopAddViewCell : WWCollectionViewCell

-(void)makeCellData:(NSString*)icon;

- (void)stop;
- (void)play;
-(void)makePlayerViewFullScreen:(BOOL)selected;


@end

NS_ASSUME_NONNULL_END
