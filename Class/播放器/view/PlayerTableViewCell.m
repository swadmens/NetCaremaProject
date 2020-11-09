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
#import "PlayerControlCell.h"
#import "MyEquipmentsViewController.h"
#import "SuperPlayerViewController.h"
#import "LivingModel.h"
#import "CarmeaVideosModel.h"
#import "RequestSence.h"
#import "MyEquipmentsModel.h"

#define KDeleteHeight 60

@interface PlayerTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PlayerControlDelegate,MyEquipmentsDelegate,PlayerTopCollectionDelegate>

@property (nonatomic, strong) WWCollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSArray *changeDataArray;
@property (strong, nonatomic) NSMutableArray *allDataArray;
@property (nonatomic, strong) NSMutableDictionary *cellDic;

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

@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,assign) BOOL changeUI;

@property (nonatomic,strong) UIImageView *tipImageView;//录像提示点
@property (nonatomic,assign) BOOL videoing;//是否正在录像

@end

@implementation PlayerTableViewCell
- (void)onUIApplication:(BOOL)active {
    if (self.playingCell) {
        [self.playingCell configureVideo:active];
    }
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"Player_add_video_image",@"Player_add_video_image",@"Player_add_video_image",@"Player_add_video_image", nil];
    }
    return _dataArray;
}
- (NSMutableArray *)allDataArray
{
    if (!_allDataArray) {
        _allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
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
    self.videoing = NO;
    
    //录像提示图示
    _tipImageView = [UIImageView new];
    _tipImageView.image = UIImageWithFileName(@"videoing_show_tip_image");
    _tipImageView.hidden = YES;
    [_playerView addSubview:_tipImageView];
    [_tipImageView lgx_makeConstraints:^(LGXLayoutMaker *make) {
        make.xCenter.lgx_equalTo(self.playerView.lgx_xCenter);
        make.topEdge.lgx_equalTo(self.playerView.lgx_topEdge).lgx_floatOffset(15);
    }];
    
}
-(void)makeCellScale:(BOOL)scale
{
//    if (![self chengkVideoNormalPlay]) {
//        return;
//    }
    self.changeUI = scale;
    if (self.changeUI) {
        id obj = [self.dataArray objectAtIndex:self.selectIndexPath.row];
        self.changeDataArray = [NSArray arrayWithObjects:obj, nil];
        [_tipImageView lgx_remakeConstraints:^(LGXLayoutMaker *make) {
            make.xCenter.lgx_equalTo(self.playerView.lgx_rightEdge);
            make.topEdge.lgx_equalTo(self.playerView.lgx_topEdge).lgx_floatOffset(15);
        }];
    }else{
        [_tipImageView lgx_remakeConstraints:^(LGXLayoutMaker *make) {
            make.xCenter.lgx_equalTo(self.playerView.lgx_xCenter);
            make.topEdge.lgx_equalTo(self.playerView.lgx_topEdge).lgx_floatOffset(15);
        }];
    }
    
    [self.collectionView reloadData];
}

-(void)setIsLiving:(BOOL)isLiving
{
    self.playerView.hidden = !isLiving;
}
#pragma mark - UICollectionViewDataSourec
//定义展示的Section的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.changeUI?self.changeDataArray.count:self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = [self.changeUI?self.changeDataArray:self.dataArray objectAtIndex:indexPath.row];

    if ([obj isKindOfClass:[NSString class]]) {
        PlayerTopAddViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PlayerTopAddViewCell getCellIDStr] forIndexPath:indexPath];
        [cell makeCellData:obj];
        return cell;
    }else{
        if (self.changeUI) {
            [self.collectionView registerClass:[PlayerTopCollectionViewCell class] forCellWithReuseIdentifier:[PlayerTopCollectionViewCell getCellIDStr]];
            PlayerTopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PlayerTopCollectionViewCell getCellIDStr] forIndexPath:indexPath];
            cell.delegate = self;
            [cell makeCellData:obj];
            return cell;
        }else{
            // 每次先从字典中根据IndexPath取出唯一标识符
            NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
            // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
            if (identifier == nil) {
               identifier = [NSString stringWithFormat:@"%@%@", [PlayerTopCollectionViewCell getCellIDStr], [NSString stringWithFormat:@"%@", indexPath]];
               [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
               // 注册Cell
               [self.collectionView registerClass:[PlayerTopCollectionViewCell class] forCellWithReuseIdentifier:identifier];
            }
            PlayerTopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
            cell.delegate = self;
            [cell makeCellData:obj];
            
//            [collectionView selectItemAtIndexPath:self.selectIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            
            return cell;
        }
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self chengkVideoNormalPlay]) {
        return;
    }
    
    id obj = [self.changeUI?self.changeDataArray:self.dataArray objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        
        self.selectIndex = indexPath.row;
        MyEquipmentsViewController *mvc = [MyEquipmentsViewController new];
        mvc.delegate = self;
        [[SuperPlayerViewController viewController:self].navigationController pushViewController:mvc animated:YES];
    }else{
        if (!self.changeUI) {
            self.selectIndexPath = indexPath;
            self.playingCell = (PlayerTopCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
            if ([self.delegate respondsToSelector:@selector(selectCellCarmera:withData:withIndex:)]) {
                [self.delegate selectCellCarmera:self withData:obj withIndex:indexPath.row];
            }
        }
        
    }
}

//是否允许移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return !self.changeUI;
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
                if (point.y  <  30) {
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
                if (point.y  <  30) {
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

    if (self.changeUI) {
        return CGSizeMake(kScreenWidth, totalHeight);
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

-(void)makeCellDataLiving:(NSArray*)array
{
    if (array.count == 0) {
        return;
    }
    [self.allDataArray removeAllObjects];
    [self.allDataArray addObjectsFromArray:array];
    
    MyEquipmentsModel *myModel = array.firstObject;
    self.selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    if ([myModel.system_Source isEqualToString:@"GBS"] && myModel.online && !myModel.model.online) {
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MyEquipmentsModel *model = obj;
            [self gbsGetNewLiveData:model withIndex:idx];
        }];
        
    }else{

        [self.allDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MyEquipmentsModel *model = obj;
            if (idx < 4) {
                [self.dataArray replaceObjectAtIndex:idx withObject:model];
            }
        }];
        [self.collectionView reloadData];
    }
    
}
#pragma mark - MyEquipmentsDelegate
-(void)selectCarmeraModel:(MyEquipmentsModel *)model
{
    if (model == nil) {
        return;
    }
    [self.dataArray replaceObjectAtIndex:self.selectIndex withObject:model];
        
    [UIView performWithoutAnimation:^{
       [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectIndex inSection:0]]];
   }];
    
    if ([self.delegate respondsToSelector:@selector(selectCellCarmera:withData:withIndex:)]) {
        [self.delegate selectCellCarmera:self withData:model withIndex:self.selectIndex];
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
//    [self.allDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        MyEquipmentsModel *model = obj;
//        [self stopGbsLivingData:model];
//    }];

    NSArray *array = [self.collectionView visibleCells];
    for (PlayerTopCollectionViewCell *cell in array) {
        [cell stop];
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
 
}
- (void)pause
{

}
- (void)resume
{
    
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
 
}
-(void)clickSnapshotButton
{
//    if (![self chengkVideoNormalPlay]) {
//        return;
//    }
    PlayerTopCollectionViewCell *selectCell = (PlayerTopCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:self.selectIndexPath];
    NSArray *array = [self.collectionView visibleCells];
    for (PlayerTopCollectionViewCell *cell in array) {
        
        if (cell == selectCell) {
            [cell clickSnapshotButton];
        }
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
//    if (![self chengkVideoNormalPlay]) {
//        return;
//    }
//
    PlayerTopCollectionViewCell *selectCell = (PlayerTopCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:self.selectIndexPath];
    NSArray *array = [self.collectionView visibleCells];
    for (PlayerTopCollectionViewCell *cell in array) {
        
        if (cell == selectCell) {
            [cell changeVolume:volume];
        }
    }
 
}
-(void)videoStandardClarity:(BOOL)standard
{
    if (![self chengkVideoNormalPlay]) {
        return;
    }
    PlayerTopCollectionViewCell *selectCell = (PlayerTopCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:self.selectIndexPath];
    NSArray *array = [self.collectionView visibleCells];
    for (PlayerTopCollectionViewCell *cell in array) {
        
        if (cell == selectCell) {
            [cell videoStandardClarity:standard];
        }
    }
    
}
-(void)startOrStopVideo:(BOOL)start
{
    self.videoing = start;
    if (self.changeUI) {
        _tipImageView.hidden = YES;
        return;
    }
    CGFloat width = (kScreenWidth-1)/2 + 15;
    
    if (self.selectIndexPath.row == 0 || self.selectIndexPath.row == 1) {
        [_tipImageView lgx_remakeConstraints:^(LGXLayoutMaker *make) {
            make.xCenter.lgx_equalTo(self.collectionView.lgx_xCenter);
            make.topEdge.lgx_equalTo(self.collectionView.lgx_topEdge).lgx_floatOffset(15);
        }];
    }else{
        [_tipImageView lgx_remakeConstraints:^(LGXLayoutMaker *make) {
            make.xCenter.lgx_equalTo(self.collectionView.lgx_xCenter);
            make.topEdge.lgx_equalTo(self.collectionView.lgx_topEdge).lgx_floatOffset(width*0.68+10);
        }];
    }

    _tipImageView.hidden = !start;
    self.collectionView.userInteractionEnabled = !start;
}

//视频是否可以正常播放
-(BOOL)chengkVideoNormalPlay
{
    if (self.videoing) {
        [_kHUDManager showMsgInView:nil withTitle:@"正在录像！" isSuccess:YES];
        return NO;
    }else{
        return YES;
    }
    
    id obj = [self.dataArray objectAtIndex:self.selectIndexPath.row];
    if ([obj isKindOfClass:[MyEquipmentsModel class]]) {
        MyEquipmentsModel *model = obj;
        return model.model.online;
    }else{
       return YES;
    }
}

//gbs 设备在线，直播关闭的时候，开始直播获取新数据
-(void)gbsGetNewLiveData:(MyEquipmentsModel*)myModel withIndex:(NSInteger)index
{
    NSString *url = [NSString stringWithFormat:@"service/cameraManagement/camera/live/start?systemSource=GBS&id=%@",myModel.equipment_id];
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"newLivingData: %@", obj);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:obj];
        LivingModel *newModel = [LivingModel makeModelData:dic];
        
        MyEquipmentsModel *model = [self.allDataArray objectAtIndex:index];
        model.model.hls = newModel.hls;
        model.model.hlsHd = newModel.hlsHd;
        model.model.rtmp = newModel.rtmp;
        model.model.rtmpHd = newModel.rtmpHd;
        model.model.flv = newModel.flv;
        model.model.flvHd = newModel.flvHd;
        model.model.snap = newModel.snap;
        model.model.status = newModel.status;
        model.model.online = YES;

        [[GCDQueue mainQueue] queueBlock:^{
            [weak_self dealwithLivingData:model withIndex:index];
        }];
    };
    sence.errorBlock = ^(NSError *error) {

        [_kHUDManager hideAfter:0.1 onHide:nil];
        // 请求失败
        DLog(@"error  ==  %@",error.userInfo);

        [[GCDQueue mainQueue] queueBlock:^{
            [weak_self dealwithLivingData:myModel withIndex:index];
        }];
    };
    [sence sendRequest];
}
//停止GBS直播
-(void)stopGbsLivingData:(MyEquipmentsModel*)myModel
{
    if (![myModel.system_Source isEqualToString:@"GBS"]) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"service/cameraManagement/camera/live/stop?systemSource=GBS&id=%@",myModel.equipment_id];
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        
        [[GCDQueue mainQueue] queueBlock:^{

        }];
    };
    sence.errorBlock = ^(NSError *error) {

        [_kHUDManager hideAfter:0.1 onHide:nil];
        // 请求失败
        DLog(@"error  ==  %@",error.userInfo);
        
    };
    [sence sendRequest];
}

-(void)dealwithLivingData:(MyEquipmentsModel*)model withIndex:(NSInteger)index
{
    [self.allDataArray replaceObjectAtIndex:index withObject:model];
    if (index < 4) {
        [self.dataArray replaceObjectAtIndex:index withObject:model];
    }
    
//    [self.collectionView reloadData];
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];

//    //延迟处理一下
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        __weak __typeof(&*self)weakSelf = self;
//        [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
//    });
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
