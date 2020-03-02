//
//  LGXMenuView.h
//  TaoChongYouPin
//
//  Created by icash on 16/8/29.
//  Copyright © 2016年 FusionHK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMenuModel : NSObject

@property (nonatomic, strong) NSString *title;
///
@property (nonatomic, strong) id model;

@end


/* = = = = = = = = = = = = = = = = = = = = = = = = =*/

@interface LGXMenuView : UIView

/// 默认白色
@property (nonatomic, strong) UIColor *textColor;
/// 默认kColorYellowTextColor
@property (nonatomic, strong) UIColor *chosedTextColor;
/// 默认字体大小
@property (nonatomic, strong) UIFont *textFont;
/// 选中字体大小
@property (nonatomic, strong) UIFont *choseTextFont;

/// 选中线的长度
@property (nonatomic, assign) CGFloat choseLineFloat;


// 默认kColorYellowTextColor
@property (nonatomic, strong) UIColor *lineColor;

/// menus : LMenuModel 的集合
- (void)reloadMenuWith:(NSArray *)menus;

@property (nonatomic, copy) void (^didChangedIndex)(NSInteger index);
@property (nonatomic, assign) NSInteger currentIndex;

@end
