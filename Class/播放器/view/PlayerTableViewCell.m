//
//  PlayerTableViewCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/5/7.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "PlayerTableViewCell.h"
#import "UIButton+Ex.h"
#import "UIView+Ex.h"

@interface PlayerTableViewCell ()

/**
 *  需要移动的矩阵
 */
@property (nonatomic, assign) CGRect moveFinalRect;
@property (nonatomic, assign) CGPoint oriCenter;
/**
 *  显示拖拽到底部出现删除 默认yes
 */
@property (nonatomic, assign) BOOL showDeleteView;

@property (nonatomic, strong) UIView *deleteView;
@property (nonatomic, strong) UIView *playerView;

@end

@implementation PlayerTableViewCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat height = kScreenWidth * 0.7;
    
    
    _playerView = [UIView new];
    _playerView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_playerView];
    [_playerView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.contentView];
    [_playerView addHeight:height];
    
    
//    UIImageView *testImageView = [UIImageView new];
//    testImageView.userInteractionEnabled = YES;
//    testImageView.layer.masksToBounds = YES;
//    testImageView.contentMode = UIViewContentModeScaleAspectFill;
//    testImageView.image = [UIImage imageWithColor:[UIColor blackColor]];
//    [_playerView addSubview:testImageView];
//    [testImageView xCenterToView:_playerView];
//    [testImageView yCenterToView:_playerView];
//    [testImageView addWidth:80];
//    [testImageView addHeight:80];
//
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//    [testImageView addGestureRecognizer:pan];
    
    
    self.showDeleteView = YES;
    
    
}
// 拖动标签
- (void)pan:(UIPanGestureRecognizer *)pan
{
    //坐标转换
    CGRect rect = [self.superview convertRect:self.frame toView:[UIApplication sharedApplication].keyWindow];
    
    // 获取偏移量
    CGPoint transP = [pan translationInView:self.playerView];
    
    UIImageView *tagButton = (UIImageView *)pan.view;
    
    // 开始
    if (pan.state == UIGestureRecognizerStateBegan) {
        _oriCenter = tagButton.center;
        [UIView animateWithDuration:-.25 animations:^{
            tagButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
        
        if (self.showDeleteView) {
            [self showDeleteViewAnimation];
        }
        
        [[UIApplication sharedApplication].keyWindow addSubview:tagButton];

        tagButton.top = rect.origin.y + tagButton.top;
        tagButton.left = rect.origin.x + tagButton.left;
    }
    
    CGPoint center = tagButton.center;
    center.x += transP.x;
    center.y += transP.y;
    tagButton.center = center;
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        
        CGPoint location = [pan locationInView:self.playerView];
        
        if (location.y < 0 || location.y > self.playerView.bounds.size.height) {
            return;
        }
        CGPoint translation = [pan translationInView:self.playerView];
        
        NSLog(@"当前视图在View的位置:%@----平移位置:%@",NSStringFromCGPoint(location),NSStringFromCGPoint(translation));
        pan.view.center = CGPointMake(pan.view.center.x + translation.x,pan.view.center.y + translation.y);
        
        if (self.showDeleteView) {
            if (tagButton.frame.origin.y  <  50) {
                [self setDeleteViewDeleteState];
            }else {
                [self setDeleteViewNormalState];
            }
        }
    }
    
    // 结束
    if (pan.state == UIGestureRecognizerStateEnded) {
        BOOL deleted = NO;
        if (self.showDeleteView) {
            [self hiddenDeleteViewAnimation];
            if (tagButton.frame.origin.y  <  50) {
                deleted = YES;
//                [self deleteItem:tagButton];
            }
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            tagButton.transform = CGAffineTransformIdentity;
            if (self->_moveFinalRect.size.width <= 0) {
                tagButton.center = self->_oriCenter;
            } else {
                tagButton.frame = self->_moveFinalRect;
            }
            tagButton.left = tagButton.left + rect.origin.x;
            tagButton.top = tagButton.top + rect.origin.y;
        } completion:^(BOOL finished) {
            self->_moveFinalRect = CGRectZero;
            if (!deleted) {
                [self.playerView addSubview:tagButton];
                tagButton.left = tagButton.left - rect.origin.x;
                tagButton.top = tagButton.top - rect.origin.y;
            }
        }];
        
    }
    
    [pan setTranslation:CGPointZero inView:self.playerView];
}
//// 看下当前按钮中心点在哪个按钮上
//- (UIView *)buttonCenterInButtons:(UIView *)curItem
//{
//    for (UIView *button in self.items) {
//        if (curItem == button) continue;
//        //坐标转换
//        CGRect rect = [self.superview convertRect:self.frame toView:[UIApplication sharedApplication].keyWindow];
//        CGRect frame = CGRectMake(button.x + rect.origin.x, button.y + rect.origin.y, button.width, button.height);
//        if (CGRectContainsPoint(frame, curItem.center)) {
//            return button;
//        }
//    }
//    return nil;
//}
#pragma mark - 顶部删除 视图
- (UIView *)deleteView{
    if (!_deleteView) {
        _deleteView = [[UIView alloc] initWithFrame:CGRectMake(0, -50, kScreenWidth, 50)];
        _deleteView.backgroundColor = [UIColor redColor];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 201809;
        [button setImage:[UIImage imageNamed:@"share_delete_image"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"share_delete_image"] forState:UIControlStateSelected];
        [button setTitle:@"拖到此处删除" forState:UIControlStateNormal];
        [button setTitle:@"松手即可删除" forState:UIControlStateSelected];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button layoutButtonWithEdgeInsetsStyle:TYButtonEdgeInsetsStyleTop imageTitleSpace:30];
        [_deleteView addSubview:button];
        [button sizeToFit];
        CGRect frame = button.frame;
        frame.origin.x = (_deleteView.frame.size.width - frame.size.width) / 2;
        frame.origin.y = (50 - frame.size.height) / 2 + 5;
        button.frame = frame;
        
        [[UIApplication sharedApplication].keyWindow addSubview:_deleteView];
    }
    return _deleteView;
}

- (void)showDeleteViewAnimation{
    self.deleteView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        
        self.deleteView.transform = CGAffineTransformTranslate( self.deleteView.transform, 0,50);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hiddenDeleteViewAnimation{
    [UIView animateWithDuration:0.25 animations:^{
        self.deleteView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setDeleteViewDeleteState{
    UIButton *button = (UIButton *)[_deleteView viewWithTag:201809];
    button.selected = YES;
}

- (void)setDeleteViewNormalState{
    UIButton *button = (UIButton *)[_deleteView viewWithTag:201809];
    button.selected = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
