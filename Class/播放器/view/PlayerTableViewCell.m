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


#define KDeleteHeight 60

@interface PlayerTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,PlayerControlDelegate,MyEquipmentsDelegate,PlayLocalVideoViewDelegate,PlayerTopCollectionDelegate>

@property (nonatomic, strong) WWCollectionView *collectionView;
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

- (WWCollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向
        flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //左右间距
        flowlayout.minimumLineSpacing = 1;
        //上下间距
        flowlayout.minimumInteritemSpacing = 1;
        
        CGFloat width = (kScreenWidth-1)/2;

        flowlayout.itemSize = CGSizeMake(width, width*0.68);
        flowlayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _collectionView = [[WWCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        // 注册
        [_collectionView registerClass:[PlayerTopCollectionViewCell class] forCellWithReuseIdentifier:[PlayerTopCollectionViewCell getCellIDStr]];
        [_collectionView registerClass:[PlayerTopAddViewCell class] forCellWithReuseIdentifier:[PlayerTopAddViewCell getCellIDStr]];

        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
//        _collectionView.pagingEnabled = YES;
//        _collectionView.backgroundColor = [UIColor redColor];
    }
    return _collectionView;
}

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat height = kScreenWidth * 0.68 + 0.5;
    
//    NSArray *arr = @[@"player_hoder_image",@"playback_back_image",@"mine_top_backimage",@"Player_add_video_image",];
//    [self.dataArray addObjectsFromArray:arr];

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
    
    self.selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadInfoNotica:) name:@"gonggeChangeInfomation" object:nil];
    
}
//接收通知并操作
- (void)uploadInfoNotica:(NSNotification *)notification
{
    if (_isPlayerVideo) {
        [[NSNotificationCenter defaultCenter] removeObserver:@"gonggeChangeInfomation"];
        return;
    }
    NSDictionary *dic = notification.userInfo;
    BOOL value = [[dic objectForKey:@"value"] boolValue];
    
    CGFloat totalHeight = kScreenWidth * 0.68 + 0.5;
    CGFloat width = (kScreenWidth-1)/2;
    CGFloat height = width * 0.68;

    CGFloat scaleXValue = kScreenWidth/width;
    CGFloat scaleYValue = totalHeight/height;

    CGFloat xSpacing;
    CGFloat ySpacing;

    if (self.selectIndexPath.row == 0) {
        xSpacing = width/4+0.25;
        ySpacing = width*0.68/4;
    }else if (self.selectIndexPath.row == 1){
        xSpacing = -width/4;
        ySpacing = width*0.68/4;
    }else if (self.selectIndexPath.row == 2){
        xSpacing = width/4+0.25;
        ySpacing = -width*0.68/4;
    }else{
        xSpacing = -width/4;
        ySpacing = -width*0.68/4;
    }
    
    for (int i = 0; i < 4; i++) {
        NSIndexPath *indexPaths = [NSIndexPath indexPathForRow:i inSection:0];
        PlayerTopCollectionViewCell *cells = (PlayerTopCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPaths];
        if (value) {
            if (i == self.selectIndexPath.row) {
                cells.transform = CGAffineTransformMakeScale(scaleXValue, scaleYValue);
                cells.transform = CGAffineTransformTranslate(cells.transform, xSpacing, ySpacing);
                
                cells.selected = NO;
                
            }else{
                cells.transform = CGAffineTransformMakeScale(0.01, 0.01);
            }
        }else{
            cells.transform = CGAffineTransformIdentity;
            [self.collectionView selectItemAtIndexPath:self.selectIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
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
    [self.dataArray exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
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
            
            [self.collectionView updateInteractiveMovementTargetPosition:point];
            
            NSLog(@"当前视图在View的位置:%@",NSStringFromCGPoint(point));
            
            if (self.showDeleteView) {
                if (point.y  <  50) {
                    [self setDeleteViewDeleteState];
                }else {
                    [self setDeleteViewNormalState];
                }
            }
            
          break;
        }
        case UIGestureRecognizerStateEnded: {
            if (self.showDeleteView) {
                [self hiddenDeleteViewAnimation];
                if (point.y  <  50) {
                    //删除
                    [self.dataArray removeObjectAtIndex:self.moveIndexPath.row];
                    [self.dataArray addObject:@"Player_add_video_image"];
                    [self.collectionView reloadData];
                }
            }
            [self.collectionView endInteractiveMovement];
            self.moveIndexPath = nil;
            //删除后默认选择第一个
            self.selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
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
        _deleteView.backgroundColor = kColorMainColor;
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
//    [self.collectionView reloadData];
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectIndex inSection:0]]];
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
    
    NSArray *array = [self.collectionView visibleCells];
    for (PlayerTopCollectionViewCell *cell in array) {
        [cell stop];
    }
    [self.localVideoView stop];
    
}
-(void)play
{
    NSArray *array = [self.collectionView visibleCells];
    for (PlayerTopCollectionViewCell *cell in array) {
        [cell play];
    }
    [self.localVideoView play];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
