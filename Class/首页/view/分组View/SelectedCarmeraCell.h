//
//  SelectedCarmeraCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/4/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@protocol selectedCarmeraDelegate <NSObject>

-(void)selectedIndexRow:(NSInteger)indexs withSection:(NSInteger)section;
-(void)selectedIndexSection:(NSInteger)section;

@end


@interface SelectedCarmeraCell : WWTableViewCell

@property (nonatomic,weak) id<selectedCarmeraDelegate>delegate;

@property (nonatomic,strong) NSArray *array;


@end

NS_ASSUME_NONNULL_END
