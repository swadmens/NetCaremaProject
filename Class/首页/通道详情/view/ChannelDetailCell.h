//
//  ChannelDetailCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/10/15.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChannelDetailCell : WWTableViewCell

@property (nonatomic,strong) void(^switchChange)(BOOL switchOn);


-(void)makeCellData:(NSInteger)indexRow withData:(NSDictionary*)dic;


@end

NS_ASSUME_NONNULL_END
