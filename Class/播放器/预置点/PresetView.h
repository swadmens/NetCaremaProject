//
//  PresetView.h
//  NetCamera
//
//  Created by 汪伟 on 2020/9/23.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PresetView : UIView


-(void)makeAllData:(NSArray*)presets withSystemSource:(NSString*)systemSource withDevice_id:(NSString*)device_id;


@end

NS_ASSUME_NONNULL_END
