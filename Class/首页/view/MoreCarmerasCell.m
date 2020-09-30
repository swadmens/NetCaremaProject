//
//  MoreCarmerasCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "MoreCarmerasCell.h"
#import "IndexDataModel.h"
#import "WWCollectionView.h"
#import "MoreCarmerasCollectionViewCell.h"
#import "MyEquipmentsModel.h"
#import "LivingModel.h"
#import "RequestSence.h"


@interface MoreCarmerasCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UILabel *equipmentName;
@property (nonatomic,strong) UILabel *equipmentAddress;
@property (nonatomic,strong) UILabel *equipmentStates;

@property (nonatomic, strong) WWCollectionView *collectionView;
@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,strong) NSMutableArray *modelArray;

@end

@implementation MoreCarmerasCell
-(NSMutableArray*)modelArray
{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}
- (WWCollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向
        flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //左右间距
        flowlayout.minimumInteritemSpacing = 5;
//        //上下间距
        flowlayout.minimumLineSpacing = 0.1;
//        flowlayout.estimatedItemSize = CGSizeMake(40, 35);
        _collectionView = [[WWCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        // 注册
        [_collectionView registerClass:[MoreCarmerasCollectionViewCell class] forCellWithReuseIdentifier:[MoreCarmerasCollectionViewCell getCellIDStr]];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    
    }
    return _collectionView;
}
- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = kColorBackgroundColor;
    
    
    CGFloat backHeight = kScreenWidth*0.6;
    CGFloat preMaxWidth = kScreenWidth - 105;

    
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
//    backView.clipsToBounds = YES;
    backView.layer.cornerRadius = 5;
    backView.layer.shadowColor = UIColorFromRGB(0xB0E5E4, 1).CGColor;
    backView.layer.shadowOffset = CGSizeMake(0,3);
    backView.layer.shadowOpacity = 1;
    backView.layer.shadowRadius = 4;
    backView.layer.cornerRadius = 5;
    [self.contentView addSubview:backView];
    [backView alignTop:@"0" leading:@"15" bottom:@"10" trailing:@"15" toView:self.contentView];
    [backView addHeight:backHeight];
    
    
    
    _equipmentName = [UILabel new];
    _equipmentName.text = @"设备名称123456";
    _equipmentName.textColor = kColorMainTextColor;
    _equipmentName.font = [UIFont customFontWithSize:kFontSizeSixteen];
    _equipmentName.preferredMaxLayoutWidth = preMaxWidth;
    _equipmentName.numberOfLines = 0;
    [backView addSubview:_equipmentName];
    [_equipmentName leftToView:backView withSpace:12];
    [_equipmentName topToView:backView withSpace:12];
    [_equipmentName addHeight:20];

    
    _equipmentStates = [UILabel new];
//    _equipmentStates.text = @"在线";
    _equipmentStates.text = @"离线";
    _equipmentStates.textAlignment = NSTextAlignmentCenter;
    _equipmentStates.font = [UIFont customFontWithSize:kFontSizeTen];
    _equipmentStates.textColor = [UIColor whiteColor];
//    _equipmentStates.backgroundColor = UIColorFromRGB(0xF39700, 1);
    _equipmentStates.backgroundColor = UIColorFromRGB(0xAEAEAE, 1);
    _equipmentStates.clipsToBounds = YES;
    _equipmentStates.layer.cornerRadius = 2;
    [backView addSubview:_equipmentStates];
    [_equipmentStates topToView:backView withSpace:8];
    [_equipmentStates leftToView:_equipmentName withSpace:5];
    [_equipmentStates addWidth:30];
    [_equipmentStates addHeight:16];
    
    
    UIImageView *addressView = [UIImageView new];
    addressView.image = UIImageWithFileName(@"index_address_image");
    [backView addSubview:addressView];
    [addressView leftToView:backView withSpace:12];
    [addressView topToView:_equipmentName withSpace:5];
    
    _equipmentAddress = [UILabel new];
    _equipmentAddress.text = @"广东省广州市天河区信息港A座11层";
    _equipmentAddress.textColor = kColorThirdTextColor;
    _equipmentAddress.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [backView addSubview:_equipmentAddress];
    [_equipmentAddress leftToView:addressView withSpace:2];
    [_equipmentAddress yCenterToView:addressView];
    [_equipmentAddress addWidth:kScreenWidth-105];

    
    UIButton *rightBtn = [UIButton new];
    [rightBtn setImage:UIImageWithFileName(@"index_right_image") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:rightBtn];
    [rightBtn rightToView:backView withSpace:8];
    [rightBtn topToView:backView withSpace:20];
    [rightBtn addWidth:15];
    [rightBtn addHeight:25];
    
    
    UIButton *playBtn = [UIButton new];
    [playBtn setImage:UIImageWithFileName(@"index_allplay_image") forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playAllButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:playBtn];
    [playBtn rightToView:rightBtn withSpace:10];
    [playBtn yCenterToView:rightBtn];
    [playBtn addWidth:15];
    [playBtn addHeight:25];
    
    
    [backView addSubview:self.collectionView];
    self.collectionView.frame = CGRectMake(0,  60, kScreenWidth-30, backHeight-60);
}
-(void)makeCellData:(IndexDataModel *)model
{
    _equipmentName.text = model.equipment_name;
    _equipmentAddress.text = model.creationTime;
    _equipmentStates.text = model.equipment_states;

    _equipmentStates.backgroundColor = model.online?UIColorFromRGB(0xF39700, 1):UIColorFromRGB(0xAEAEAE, 1);
    
    self.dataArray = [NSArray arrayWithArray:model.childDevices_info];
    
    [self.collectionView reloadData];
}
#pragma mark -- collectionDelegate
//定义展示的Section的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MoreCarmerasCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MoreCarmerasCollectionViewCell getCellIDStr] forIndexPath:indexPath];
    
    MyEquipmentsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell makeCellData:model.model];

    cell.moreBtnClick = ^(BOOL offline) {
        if (self.moreDealClick) {
            self.moreDealClick(indexPath.row,offline);
        }
    };
    
    cell.getModelBackdata = ^(LivingModel * _Nonnull model) {
        if (![WWPublicMethod isStringEmptyText:model.hls]) {
            [self.modelArray addObject:model];
        }else{
            [self.modelArray insertObject:model atIndex:0];
        }
        
        if (self.modelArray.count == self.dataArray.count) {
            if (self.getModelArrayBackdata) {
                self.getModelArrayBackdata(self.modelArray);
            }
        }
    };

    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    MyEquipmentsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 12, 5, 12);
}
//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
 
}
//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (kScreenWidth-55)/2;
    return CGSizeMake(width, width*0.625+30);
}

-(void)rightButtonClick
{
    if (self.rightBtnClick) {
        self.rightBtnClick();
    }

}
-(void)playAllButtonClick
{
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
