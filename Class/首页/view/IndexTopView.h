//
//  IndexTopView.h
//  NetCamera
//
//  Created by 汪伟 on 2020/4/26.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IndexTopDelegate <NSObject>

-(void)collectionSelect:(NSInteger)index;
-(void)searchValue:(NSString*)value;
-(void)navPopView:(NSInteger)value;

@end


@interface IndexTopView : UIView

@property (nonatomic, weak) id<IndexTopDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
