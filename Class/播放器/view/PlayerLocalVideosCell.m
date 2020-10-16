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
#import "CarmeaVideosModel.h"
#import "RequestSence.h"

@interface PlayerLocalVideosCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) WWCollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) UIView *noDataView;
@property (strong,nonatomic) UILabel *otherLabel;

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
    
    
    _otherLabel = [UILabel new];
    _otherLabel.text = @"本地录像";
    _otherLabel.textColor = UIColorFromRGB(0x2e2e2e, 1);
    _otherLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [_otherLabel sizeToFit];
    [backView addSubview:_otherLabel];
    [_otherLabel leftToView:iconImageView withSpace:5];
    [_otherLabel yCenterToView:iconImageView];
    
    
    
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
    [allButton yCenterToView:_otherLabel];
    [allButton rightToView:backView withSpace:25];
    [allButton addTarget:self action:@selector(allVideosClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [backView addSubview:self.collectionView];
    [self.collectionView alignTop:@"45" leading:@"0" bottom:nil trailing:@"0" toView:backView];
    [self.collectionView addHeight:130];
    
    
    self.noDataView = [UIView new];
    self.noDataView.backgroundColor = kColorBackgroundColor;
    self.noDataView.hidden = YES;
    [backView addSubview:self.noDataView];
    [self.noDataView alignTop:@"45" leading:@"0" bottom:nil trailing:@"0" toView:backView];
    [self.noDataView addHeight:130];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    tipLabel.textColor = kColorThirdTextColor;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"所选设备今日无录像!";
    [self.noDataView addSubview:tipLabel];
    [tipLabel xCenterToView:self.noDataView];
    [tipLabel yCenterToView:self.noDataView];
    
    
    
    
}
-(void)allVideosClick
{
    //全部录像
//    [TargetEngine controller:nil pushToController:PushTargetLocalVideo WithTargetId:nil];
    
    if (self.allBtn) {
        self.allBtn();
    }
    
}
-(void)makeCellData:(NSArray*)array withTitle:(NSString*)title
{
    _otherLabel.text = title;
    if (array.count == 0) {
        self.collectionView.hidden = YES;
        self.noDataView.hidden = NO;
    }else{
        self.collectionView.hidden = NO;
        self.noDataView.hidden = YES;
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:array];
        [self.collectionView reloadData];
    }
}
#pragma mark - UICollectionViewDataSourec
//定义展示的Section的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
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
    CarmeaVideosModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([model.system_Source isEqualToString:@"GBS"] && [model.recordType isEqualToString:@"local"]) {
        [self getGBSLocalVideo:model];
    }else{
        if (self.selectedRowData) {
            self.selectedRowData(model);
        }
    }
    
    

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

//获取GBS本地录像视频播放流
-(void)getGBSLocalVideo:(CarmeaVideosModel*)model
{
    NSString *url = [NSString stringWithFormat:@"service/cameraManagement/camera/record/playback/start?serial=%@&channel=%@&starttime=%@&endtime=%@",model.deviceSerial,model.channel,model.startTime,model.endTime];
    NSDictionary *finalParams = @{
                                  @"serial": model.deviceSerial, //设备序列号
                                  @"channel": model.channel, // 通道号
                                  @"starttime": model.startTime, //开始时间，格式 YYYY-MM-DDTHH:mm:ss
                                  @"endtime": model.endTime // 结束时间，格式 YYYY-MM-DDTHH:mm:ss
                                  };

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:finalParams
                                                       options:0
                                                         error:nil];
    
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"BODY";
    sence.pathHeader = @"application/json";
    sence.body = jsonData;
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"Received: %@", obj);
        NSDictionary *received = [NSDictionary dictionaryWithDictionary:obj];
        model.picUrl = [NSString stringWithFormat:@"%@",[received objectForKey:@"SnapURL"]];
        model.url = [NSString stringWithFormat:@"%@",[received objectForKey:@"RTMP"]];
        model.StreamID = [NSString stringWithFormat:@"%@",[received objectForKey:@"StreamID"]];        
        model.duration = [NSString stringWithFormat:@"%@",[received objectForKey:@"PlaybackDuration"]];

        [[GCDQueue mainQueue] queueBlock:^{
            if (weak_self.selectedRowData) {
                weak_self.selectedRowData(model);
            }
        }];
    
    };
    sence.errorBlock = ^(NSError *error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        // 请求失败
        DLog(@"error  ==  %@",error.userInfo);
        
    };
    [sence sendRequest];
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
