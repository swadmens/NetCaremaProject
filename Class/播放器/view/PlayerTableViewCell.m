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
#import "WWCollectionView.h"
#import "PlayerTopCollectionViewCell.h"


#define KDeleteHeight 70

@interface PlayerTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) WWCollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArray;

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
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (WWCollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向
        flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //左右间距
        flowlayout.minimumLineSpacing = 1;
        //上下间距
        flowlayout.minimumInteritemSpacing = 1;
        
        CGFloat width = (kScreenWidth-1)/2;

        flowlayout.itemSize = CGSizeMake(width, width*0.68);
        
        _collectionView = [[WWCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        // 注册
        [_collectionView registerClass:[PlayerTopCollectionViewCell class] forCellWithReuseIdentifier:[PlayerTopCollectionViewCell getCellIDStr]];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}
- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat height = kScreenWidth * 0.68+1;
    
    NSArray *arr = @[@"player_hoder_image",@"player_hoder_image",@"player_hoder_image",@"Player_add_video_image",];
    [self.dataArray addObjectsFromArray:arr];
    
    
    
    _playerView = [UIView new];
    _playerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_playerView];
    [_playerView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.contentView];
    [_playerView addHeight:height];
    
    [_playerView addSubview:self.collectionView];
    [self.collectionView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:_playerView];

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressed:)];
    [self.collectionView addGestureRecognizer:longPress];
    

    self.showDeleteView = YES;
    
    
}
#pragma mark - UICollectionViewDataSourec
//定义展示的Section的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerTopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PlayerTopCollectionViewCell getCellIDStr] forIndexPath:indexPath];
    
    NSString *icon = [self.dataArray objectAtIndex:indexPath.row];
    [cell makeCellData:icon];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//是否允许移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        return NO;
    }
    return YES;
}
 
//完成移动更新数据
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [self.dataArray exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
}


- (void)onLongPressed:(UILongPressGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:sender.view];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    
    if (indexPath.row == 3) {
        return;
    }
    
    switch (sender.state) {
    
        case UIGestureRecognizerStateBegan: {
        
            if (self.showDeleteView) {
            
                [self showDeleteViewAnimation];
            }
          if (indexPath) {
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
          }
          break;
        }
        case UIGestureRecognizerStateChanged: {
            [self.collectionView updateInteractiveMovementTargetPosition:point];
            
            NSLog(@"当前视图在View的位置:%@",NSStringFromCGPoint(point));
            
            if (self.showDeleteView) {
                if (point.y  <  KDeleteHeight) {
                    [self setDeleteViewDeleteState];
                }else {
                    [self setDeleteViewNormalState];
                }
            }

            
          break;
        }
        case UIGestureRecognizerStateEnded: {
          [self.collectionView endInteractiveMovement];
            if (self.showDeleteView) {
                [self hiddenDeleteViewAnimation];
                if (point.y  <  KDeleteHeight) {
                    //删除
                    [self.dataArray replaceObjectAtIndex:indexPath.row withObject:@"Player_add_video_image"];
                    [self.collectionView reloadData];
                }
            }
          break;
        }
        default: {
          [self.collectionView cancelInteractiveMovement];
          break;
        }
      }
}
 
#pragma mark - 顶部删除 视图
- (UIView *)deleteView{
    if (!_deleteView) {
        _deleteView = [[UIView alloc] initWithFrame:CGRectMake(0, -KDeleteHeight, kScreenWidth, KDeleteHeight)];
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
        frame.origin.y = (KDeleteHeight - frame.size.height) / 2 + 5;
        button.frame = frame;
        
        [[UIApplication sharedApplication].keyWindow addSubview:_deleteView];
    }
    return _deleteView;
}

- (void)showDeleteViewAnimation{
    self.deleteView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        
        self.deleteView.transform = CGAffineTransformTranslate( self.deleteView.transform, 0,KDeleteHeight);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hiddenDeleteViewAnimation{
    UIButton *button = (UIButton *)[_deleteView viewWithTag:201809];
    button.selected = NO;
    
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
