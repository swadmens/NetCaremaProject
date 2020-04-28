//
//  NoChooseCarmerasCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/4/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NoChooseCarmerasDelegate <NSObject>

-(void)nosSelectIndexRow:(NSInteger)indexs withSection:(NSInteger)section;
-(void)noSelectedIndexSection:(NSInteger)section;


@end

@interface NoChooseCarmerasCell : WWTableViewCell

@property (nonatomic,weak) id<NoChooseCarmerasDelegate>delegate;

@property (nonatomic,strong) NSArray *array;


@end

NS_ASSUME_NONNULL_END
