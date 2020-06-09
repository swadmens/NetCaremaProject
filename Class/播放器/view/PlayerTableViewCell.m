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
#import "PlayerTopAddViewCell.h"
#import "PlayLocalVideoView.h"
#import "PlayerControlCell.h"
#import "MyEquipmentsViewController.h"
#import "SuperPlayerViewController.h"
#import "LivingModel.h"
#import "DemandModel.h"


#define KDeleteHeight 60

@interface PlayerTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PlayerControlDelegate,MyEquipmentsDelegate,PlayLocalVideoViewDelegate,PlayerTopCollectionDelegate>

@property (nonatomic, strong) WWCollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSArray *allDataArray;

@property (nonatomic,strong) PlayLocalVideoView *localVideoView;
@property (nonatomic, weak) PlayerTopCollectionViewCell *playingCell;

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

@property (nonatomic,strong) NSIndexPath *moveIndexPath;
@property (nonatomic,strong) NSIndexPath *selectIndexPath;

@property (nonatomic,assign) BOOL isPlayerVideo;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,assign) BOOL changeUI;


@end

@implementation PlayerTableViewCell
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:@"gonggeChangeInfomation"];
}
- (void)onUIApplication:(BOOL)active {
    if (self.playingCell) {
        [self.playingCell configureVideo:active];
    }
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat height = kScreenWidth * 0.68 + 0.5;
    
    _playerView = [UIView new];
    _playerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_playerView];
    [_playerView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.contentView];
    [_playerView addHeight:height];
    
    
    _flowLayout = [UICollectionViewFlowLayout new];
    //设置滚动方向
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //左右间距
    _flowLayout.minimumLineSpacing = 1;
    //上下间距
    _flowLayout.minimumInteritemSpacing = 1;
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[WWCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    // 注册
    [_collectionView registerClass:[PlayerTopCollectionViewCell class] forCellWithReuseIdentifier:[PlayerTopCollectionViewCell getCellIDStr]];
    [_collectionView registerClass:[PlayerTopAddViewCell class] forCellWithReuseIdentifier:[PlayerTopAddViewCell getCellIDStr]];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.scrollEnabled = NO;
    [_playerView addSubview:self.collectionView];
    [self.collectionView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:_playerView];

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressed:)];
    [self.collectionView addGestureRecognizer:longPress];
    
    self.showDeleteView = YES;
    self.selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
}
-(void)makeCellScale:(BOOL)scale
{
    if (![self chengkVideoNormalPlay]) {
        return;
    }
    self.changeUI = scale;
    [self.collectionView reloadData];
}

-(void)setIsLiving:(BOOL)isLiving
{
    self.isPlayerVideo = !isLiving;
    self.localVideoView.hidden = isLiving;
    self.playerView.hidden = !isLiving;
}
#pragma mark - UICollectionViewDataSourec
//定义展示的Section的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = [self.dataArray objectAtIndex:indexPath.row];

    if ([obj isKindOfClass:[NSString class]]) {
        PlayerTopAddViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PlayerTopAddViewCell getCellIDStr] forIndexPath:indexPath];
        [cell makeCellData:obj];
        return cell;
    }else{
        PlayerTopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PlayerTopCollectionViewCell getCellIDStr] forIndexPath:indexPath];
        cell.delegate = self;
        
        [cell makeCellData:obj];
        
        if (indexPath == self.selectIndexPath && self.changeUI) {
            [collectionView scrollToItemAtIndexPath:self.selectIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        }
        
        return cell;
    }

   
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndexPath = indexPath;
    
    id obj = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([obj isKindOfClass:[NSString class]]) {
        self.selectIndex = indexPath.row;
        MyEquipmentsViewController *mvc = [MyEquipmentsViewController new];
        mvc.dataArray = [NSArray arrayWithArray:self.allDataArray];
        mvc.delegate = self;
        [[SuperPlayerViewController viewController:self].navigationController pushViewController:mvc animated:YES];
    }else{
        self.playingCell = (PlayerTopCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        if ([self.delegate respondsToSelector:@selector(selectCellCarmera:withData:)]) {
            [self.delegate selectCellCarmera:self withData:obj];
        }
    }
}

//是否允许移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
 
//完成移动更新数据
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{

//    [self.dataArray exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        
    id obj = [self.dataArray objectAtIndex:sourceIndexPath.item];
    
    [self.dataArray removeObjectAtIndex:sourceIndexPath.item];
    
    [self.dataArray insertObject:obj atIndex:destinationIndexPath.item];
    
    [self.collectionView reloadData];
    
}
- (void)onLongPressed:(UILongPressGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self.collectionView];
    if (self.moveIndexPath == nil) {
        self.moveIndexPath = [self.collectionView indexPathForItemAtPoint:point];
    }
    switch (sender.state) {

        case UIGestureRecognizerStateBegan: {
            if (self.showDeleteView) {
                [self showDeleteViewAnimation];
            }

            if (self.moveIndexPath) {
                [self.collectionView selectItemAtIndexPath:self.moveIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                self.selectIndexPath = self.moveIndexPath;
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:self.moveIndexPath];
            }
          break;
        }
        case UIGestureRecognizerStateChanged: {


            NSLog(@"当前视图在View的位置:%@",NSStringFromCGPoint(point));

            if (self.showDeleteView) {
                if (point.y  <  50) {
                    [self setDeleteViewDeleteState];
                }else {
                    [self setDeleteViewNormalState];
                }
            }

            [self.collectionView updateInteractiveMovementTargetPosition:point];

          break;
        }
        case UIGestureRecognizerStateEnded: {
            if (self.showDeleteView) {
                [self hiddenDeleteViewAnimation];
                if (point.y  <  50) {
                    //删除
                    [self.dataArray replaceObjectAtIndex:self.moveIndexPath.row withObject:@"Player_add_video_image"];

                    PlayerTopCollectionViewCell *selectCell = (PlayerTopCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:self.moveIndexPath];
                    [selectCell stop];
                    
                    [self.collectionView reloadData];
                    
                }
            }
            self.moveIndexPath = nil;
            //删除后默认选择第一个
            self.selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            
            [self.collectionView endInteractiveMovement];
            
          break;
        }
        default: {
          [self.collectionView cancelInteractiveMovement];
          break;
        }
      }
}
#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat totalHeight = kScreenWidth * 0.68 + 0.5;
    CGFloat width = (kScreenWidth-1)/2;
    
    if (indexPath == self.selectIndexPath && self.changeUI) {
        return CGSizeMake(kScreenWidth, totalHeight);
    }else if (indexPath != self.selectIndexPath && self.changeUI){
        return CGSizeMake(10, 10);
    }else{
        return CGSizeMake(width, width*0.68);
    }
}

 
#pragma mark - 顶部删除 视图
- (UIView *)deleteView{
    if (!_deleteView) {
        _deleteView = [[UIView alloc] initWithFrame:CGRectMake(0, -KDeleteHeight, kScreenWidth, KDeleteHeight)];
        _deleteView.backgroundColor = kColorMainColor;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 202004;
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
    UIButton *button = (UIButton *)[_deleteView viewWithTag:202004];
    button.selected = YES;
}

- (void)setDeleteViewNormalState{
    UIButton *button = (UIButton *)[_deleteView viewWithTag:202004];
    button.selected = NO;
}
-(void)makeCellDataNoLiving:(DemandModel*)model witnLive:(BOOL)isLiving
{
   
    CGFloat height = kScreenWidth * 0.68 + 0.5;

    _localVideoView = [PlayLocalVideoView new];
    self.localVideoView.model = model;
    self.localVideoView.delegate = self;
    [self.contentView addSubview:self.localVideoView];
    [self.localVideoView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.contentView];
    [self.localVideoView addHeight:height];
    
    self.isPlayerVideo = !isLiving;
    self.localVideoView.hidden = isLiving;
    self.playerView.hidden = !isLiving;
       
}
-(void)makeCellDataLiving:(NSArray*)array witnLive:(BOOL)isLiving
{
    self.isPlayerVideo = !isLiving;
    self.localVideoView.hidden = isLiving;
    self.playerView.hidden = !isLiving;
    self.allDataArray = [NSArray arrayWithArray:array];
    
    [self.dataArray removeAllObjects];
    if (array.count > 3) {
        NSArray *arr = [array subarrayWithRange:NSMakeRange(0, 4)];
        [self.dataArray addObjectsFromArray:arr];
    }else{

        [self.dataArray addObjectsFromArray:array];

        for (int i = 0; i < 4 - array.count; i++) {
            [self.dataArray addObject:@"Player_add_video_image"];
        }
    }

    [self.collectionView reloadData];
}
#pragma mark - MyEquipmentsDelegate
-(void)selectCarmeraModel:(LivingModel *)model
{
    [self.dataArray replaceObjectAtIndex:self.selectIndex withObject:model];
    
    [UIView performWithoutAnimation:^{
       [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectIndex inSection:0]]];
   }];
    
    if ([self.delegate respondsToSelector:@selector(selectCellCarmera:withData:)]) {
        [self.delegate selectCellCarmera:self withData:model];
    }
}
#pragma mark - PlayLocalVideoViewDelegate
- (void)tableViewWillPlay:(PlayLocalVideoView *)view
{
    
}

- (void)tableViewCellEnterFullScreen:(PlayLocalVideoView *)view
{
//    [[SuperPlayerViewController viewController:self] setNeedsStatusBarAppearanceUpdate];
    [self.delegate tableViewCellEnterFullScreen:self];
}

- (void)tableViewCellExitFullScreen:(PlayLocalVideoView *)view
{
    [self.delegate tableViewCellExitFullScreen:self];
}
-(void)getLocalViewSnap:(PlayLocalVideoView *)view with:(UIImage *)image
{
    if ([self.delegate respondsToSelector:@selector(getPlayerCellSnapshot:with:)]) {
        [self.delegate getPlayerCellSnapshot:self with:image];
    }
}

#pragma mark - PlayerTopCollectionDelegate
- (void)playerViewCellEnterFullScreen:(PlayerTopCollectionViewCell *_Nullable)cell
{
    
}

- (void)playerViewCellExitFullScreen:(PlayerTopCollectionViewCell *_Nullable)cell
{
    
}

- (void)playerViewCellWillPlay:(PlayerTopCollectionViewCell *_Nullable)cell
{
    
}

- (void)stop {
    
    if (![self chengkVideoNormalPlay]) {
        return;
    }
    
    NSArray *array = [self.collectionView visibleCells];
    for (PlayerTopCollectionViewCell *cell in array) {
        [cell stop];
    }
    if (self.localVideoView !=nil) {
        [self.localVideoView stop];
    }
}
-(void)play
{
    if (![self chengkVideoNormalPlay]) {
        return;
    }
    
    NSArray *array = [self.collectionView visibleCells];
    for (PlayerTopCollectionViewCell *cell in array) {
        [cell play];
    }
    if (self.localVideoView !=nil) {
        [self.localVideoView play];
    }
}

-(void)makePlayerViewFullScreen
{
    if (![self chengkVideoNormalPlay]) {
        return;
    }
    
    PlayerTopCollectionViewCell *selectCell = (PlayerTopCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:self.selectIndexPath];
    NSArray *array = [self.collectionView visibleCells];
    for (PlayerTopCollectionViewCell *cell in array) {
        [cell makePlayerViewFullScreen:cell == selectCell];
    }
    
    if (self.localVideoView !=nil) {
           [_localVideoView makePlayerViewFullScreen];
       }
}
-(void)clickSnapshotButton
{
    if (![self chengkVideoNormalPlay]) {
        return;
    }
    
    PlayerTopCollectionViewCell *selectCell = (PlayerTopCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:self.selectIndexPath];
    NSArray *array = [self.collectionView visibleCells];
    for (PlayerTopCollectionViewCell *cell in array) {
        
        if (cell == selectCell) {
            [cell clickSnapshotButton];
        }
    }
    
    if (self.localVideoView !=nil) {
        [_localVideoView clickSnapshotButton];
    }
    
}
-(void)getTopCellSnapshot:(PlayerTopCollectionViewCell *)cell with:(UIImage *)image
{
    if ([self.delegate respondsToSelector:@selector(getPlayerCellSnapshot:with:)]) {
        [self.delegate getPlayerCellSnapshot:self with:image];
    }
}
- (void)changeVolume:(float)volume
{
    if (![self chengkVideoNormalPlay]) {
        return;
    }
    
    PlayerTopCollectionViewCell *selectCell = (PlayerTopCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:self.selectIndexPath];
    NSArray *array = [self.collectionView visibleCells];
    for (PlayerTopCollectionViewCell *cell in array) {
        
        if (cell == selectCell) {
            [cell changeVolume:volume];
        }
    }
    if (self.localVideoView !=nil) {
        [_localVideoView changeVolume:volume];
    }
}

//视频是否可以正常播放
-(BOOL)chengkVideoNormalPlay
{
    id obj = [self.dataArray objectAtIndex:self.selectIndex];
    if ([obj isKindOfClass:[LivingModel class]]) {
        LivingModel *model = obj;
        if (![WWPublicMethod isStringEmptyText:model.RTMP]) {
            return NO;
        }else{
            return YES;
        }
    }else{
       return NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
