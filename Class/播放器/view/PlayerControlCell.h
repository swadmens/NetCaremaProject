//
//  PlayerControlCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/5/7.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"


typedef enum {

    videoSatePlay = 0,
    videoSateVoice = 1,
    videoSateGongge = 2,
    videoSateClarity = 3,
    videoSateFullScreen = 4,
    videoSatesSreenshots = 5,
    videoSateVideing = 6,
    videoSateYuntai = 7,
    videoSateTalkBack = 8,
    
}videoSate;


@protocol PlayerControlDelegate <NSObject>


-(void)playerControlwithState:(videoSate)state withButton:(UIButton*_Nullable)sender;


@end


NS_ASSUME_NONNULL_BEGIN

@class EquipmentAbilityModel;
@interface PlayerControlCell : WWTableViewCell

@property (nonatomic,weak) id<PlayerControlDelegate>delegate;

-(void)makeCellData:(BOOL)isLiving withAbility:(EquipmentAbilityModel*)model;

@end

NS_ASSUME_NONNULL_END
