//
//  PlayerLocalVideosCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/5/7.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "PlayerLocalVideosCell.h"
#import "WWCollectionView.h"
#import "VideoPlaybackViewCell.h"
#import "CarmeaVideosModel.h"
#import "DemandModel.h"

@interface PlayerLocalVideosCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) WWCollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation PlayerLocalVideosCell
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
        flowlayout.minimumLineSpacing = 10;
        //上下间距
        flowlayout.minimumInteritemSpacing = 0.1;
        
        flowlayout.itemSize = CGSizeMake(135, 121);
        
        _collectionView = [[WWCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        // 注册
        [_collectionView registerClass:[VideoPlaybackViewCell class] forCellWithReuseIdentifier:[VideoPlaybackViewCell getCellIDStr]];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}
- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = kColorBackgroundColor;
    
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    [backView alignTop:@"10" leading:@"0" bottom:@"0" trailing:@"0" toView:self.contentView];
    [backView addHeight:170];
    
        
    
    UIImageView *iconImageView = [UIImageView new];
    iconImageView.image = UIImageWithFileName(@"player_localvideo_image");
    [backView addSubview:iconImageView];
    [iconImageView topToView:backView withSpace:17];
    [iconImageView leftToView:backView withSpace:15];
    
    
    UILabel *otherLabel = [UILabel new];
    otherLabel.text = @"本地录像";
    otherLabel.textColor = UIColorFromRGB(0x2e2e2e, 1);
    otherLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [otherLabel sizeToFit];
    [backView addSubview:otherLabel];
    [otherLabel leftToView:iconImageView withSpace:5];
    [otherLabel yCenterToView:iconImageView];
    
    
    
    UIButton *allButton = [UIButton new];
    [allButton setTitle:@"全部" forState:UIControlStateNormal];
    allButton.titleLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    [allButton setTitleColor:kColorThirdTextColor forState:UIControlStateNormal];
    [allButton setImage:UIImageWithFileName(@"mine_right_arrows") forState:UIControlStateNormal];
    allButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
//    下面是设置图片跟文字的间距：
    CGFloat margin = (45 - CGRectGetWidth(allButton.imageView.frame) - CGRectGetWidth(allButton.titleLabel.frame)) *0.5;
    CGFloat marginGay = 22;
    allButton.imageEdgeInsets = UIEdgeInsetsMake(0, marginGay, 0, margin - marginGay);
    [backView addSubview:allButton];
    [allButton yCenterToView:otherLabel];
    [allButton rightToView:backView withSpace:25];
    [allButton addTarget:self action:@selector(allVideosClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [backView addSubview:self.collectionView];
    [self.collectionView alignTop:@"45" leading:@"0" bottom:nil trailing:@"0" toView:backView];
    [self.collectionView addHeight:130];
}
-(void)allVideosClick
{
    //全部录像
//    [TargetEngine controller:nil pushToController:PushTargetLocalVideo WithTargetId:nil];
    
    if (self.allBtn) {
        self.allBtn();
    }
    
}
-(void)makeCellData:(NSArray *)array
{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:array];
    [self.collectionView reloadData];
}
#pragma mark - UICollectionViewDataSourec
//定义展示的Section的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
//    return 5;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoPlaybackViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[VideoPlaybackViewCell getCellIDStr] forIndexPath:indexPath];

    CarmeaVideosModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell makeCellData:model];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     
//    if (self.isPlaying) {
//        [self stop];
//    }
//    self.isLiving = NO;
//    _deleteBtn.hidden = NO;
//    _downLoadBtn.hidden = NO;
//    _moreButton.hidden = YES;
//
    CarmeaVideosModel *model = [self.dataArray objectAtIndex:indexPath.row];
//
//    if ([obj isKindOfClass:[DemandModel class]]) {
//        DemandModel *model = obj;
//        self.playerView.media = obj;
//        self.playerView.media = model;
//        self.model = model;
//        self.indexInteger = indexPath.row;
//        _videoNameLabel.text = self.model.video_name;
//        _videoTimeLabel.text = self.model.createAt;
//
//    }else{
//        CarmeaVideosModel *model = obj;
//        self.carmeaModel = model;
//
        NSDictionary *dic = @{ @"name":model.video_name,
                               @"snapUrl":model.snap,
                               @"videoUrl":model.hls,
                               @"createAt":model.time,
                              };
        DemandModel *models = [DemandModel makeModelData:dic];
//        self.playerView.media = models;
//        self.indexInteger = indexPath.row;
//        _videoNameLabel.text = self.model.video_name;
//        _videoTimeLabel.text = self.model.createAt;
//   }
    if (self.selectedRowData) {
        self.selectedRowData(models);
    }

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
