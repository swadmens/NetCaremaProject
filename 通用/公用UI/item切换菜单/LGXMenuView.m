//
//  LGXMenuView.m
//  TaoChongYouPin
//
//  Created by icash on 16/8/29.
//  Copyright © 2016年 FusionHK. All rights reserved.
//

#import "LGXMenuView.h"

@interface LGXMenuView()
{
    CGFloat _space;
    CGFloat _topSpace;
    CGFloat _offsetSpace;
    NSInteger _exIndex;
}
@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, strong) NSArray *menuArray;

@property (nonatomic, strong) UIView *lineView;
///
@property (nonatomic, strong) NSArray *viewsArray;

@property(nonatomic,assign) NSInteger ArrCount;

@end

@implementation LGXMenuView

- (UIColor *)textColor
{
    if (!_textColor) {
        _textColor = [UIColor whiteColor];
    }
    return _textColor;
}
- (UIColor *)chosedTextColor
{
    if (!_chosedTextColor) {
        _chosedTextColor = kColorYellowTextColor;
    }
    return _chosedTextColor;
}
- (UIColor *)lineColor
{
    if (!_lineColor) {
        _lineColor = kColorYellowTextColor;
    }
    return _lineColor;
}
- (UIFont *)choseTextFont
{
    if (!_choseTextFont) {
        _choseTextFont = [UIFont customFontWithSize:kFontSizeFourteen];
    }
    return _choseTextFont;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doinit];
    }
    return self;
}
- (CGSize)intrinsicContentSize
{
    return CGSizeMake(self.ArrCount *60, 44);
}
- (void)doinit
{
    self.backgroundColor = kColorBackSecondColor;
    self.lineHeight = 2.0;
    _space = 0.0;
    _topSpace = 0.0;
}

- (void)reloadMenuWith:(NSArray *)menus
{
    self.alpha = 0.0;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.menuArray = nil;
    self.menuArray = [NSArray arrayWithArray:menus];
    
    int count = (int)menus.count;
    self.ArrCount=menus.count;
    
    NSMutableArray *tempArr = [NSMutableArray array];
    
    //
    CGFloat space = _space;
    CGFloat topSpace = _topSpace;
    CGFloat offsetSpace = ((count-1)*space)/count;
    UIView *exView;
    
    // 循环创建
    for (int i =0; i<count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
//        button.titleLabel.font = [UIFont customFontWithSize:kFontSizeSixteen];
        button.titleLabel.font = [UIFont customFontWithSize:17];
        [button setTitleColor:self.textColor forState:UIControlStateNormal];
        [button setTitleColor:self.chosedTextColor forState:UIControlStateSelected];
        
//        button.titleLabel.font=self.choseTextFont;
        [button addTarget:self action:@selector(action_clicked:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.lineBreakMode = 0;
        
        
        LMenuModel *model = [menus objectAtIndex:i];
        [button setTitle:model.title forState:UIControlStateNormal];
        [self addSubview:button];
        
        [button addPercentWidth:(1.0/count) toView:self offset:(-1*offsetSpace)];
        [button topToView:self withSpace:topSpace];
        [button bottomToView:self withSpace:topSpace];
        
        float leftSpace = space;
        if (exView == nil) {
            exView = self;
            leftSpace = 0;
        }
        
        [button leftToView:exView withSpace:leftSpace];
        exView = button;
        
        [tempArr addObject:button];
    }
    
    self.viewsArray = [NSArray arrayWithArray:tempArr];
    
    /// 增加选中的线
    CGFloat lineY = self.bounds.size.height - self.lineHeight+1;
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, lineY, 0, self.lineHeight)];
    self.lineView.backgroundColor = self.lineColor;
    [self addSubview:self.lineView];
    
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.currentIndex = _currentIndex;
    }];
}
-(void)setChoseLineFloat:(CGFloat)choseLineFloat
{
    [self.lineView addWidth:choseLineFloat];
}
- (void)action_clicked:(UIButton *)sender
{
    self.currentIndex = sender.tag;
}
- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex <0 || currentIndex >= self.viewsArray.count) {
        return;
    }
    _currentIndex = currentIndex;
    DLog(@"按钮的编号 %ld",currentIndex);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIButton *exButton = [self.viewsArray objectAtIndex:_exIndex];
        exButton.selected = NO;
        
        UIButton *currentButton = [self.viewsArray objectAtIndex:_currentIndex];
        currentButton.selected = YES;
        
        _exIndex = _currentIndex;
        if (self.didChangedIndex) {
            self.didChangedIndex(_currentIndex);
        }
        
        //延迟加载线条的显示
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self showLineAnimation];
        });
    });
    
}
- (void)showLineAnimation
{
    /// 如果只有一个就不要显示线了
    if (self.menuArray.count <=1) {
        [self.lineView removeFromSuperview];
        return;
    }
    
    UIButton *aView = [self.viewsArray objectAtIndex:self.currentIndex];
    
    CGFloat centerX = aView.center.x;
    
    [UIView animateWithDuration:0
                          delay:0
         usingSpringWithDamping:0.3
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         CGRect frame = self.lineView.frame;
                         frame.size.width = aView.titleLabel.bounds.size.width;
                         
                         if (self.menuArray.count==2) {
                             frame.size.width = 100;
                         }
                         
                         self.lineView.frame = frame;
                         
                         CGPoint center =  self.lineView.center;
                         center.x = centerX;
                         self.lineView.center = center;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

@end


/* = = = = = = = = = = = = = = = = = = = = = = = = =*/


@implementation LMenuModel



@end





