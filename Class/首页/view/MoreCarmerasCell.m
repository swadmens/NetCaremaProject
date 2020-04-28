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

@interface MoreCarmerasCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UILabel *equipmentName;
@property (nonatomic,strong) UILabel *equipmentAddress;
@property (nonatomic,strong) UILabel *equipmentStates;

@property (nonatomic, strong) WWCollectionView *collectionView;

@end

@implementation MoreCarmerasCell
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
    [backView addSubview:_equipmentName];
    [_equipmentName leftToView:backView withSpace:12];
    [_equipmentName topToView:backView withSpace:12];
    
    
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
    
    _equipmentAddress = [UILabel new];
    _equipmentAddress.text = @"广东省广州市天河区信息港A座11层";
    _equipmentAddress.textColor = kColorThirdTextColor;
    _equipmentAddress.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [backView addSubview:_equipmentAddress];
    [_equipmentAddress leftToView:backView withSpace:12];
    [_equipmentAddress topToView:_equipmentName withSpace:5];

//    UILabel *lineLabel = [UILabel new];
//    lineLabel.backgroundColor = UIColorFromRGB(0xCCCCCC, 1);
//    [backView addSubview:lineLabel];
//    [lineLabel yCenterToView:backView];
//    [lineLabel rightToView:backView withSpace:70];
//    [lineLabel addWidth:1];
//    [lineLabel addHeight:33.5];
//
//
//    UILabel *detailLabel = [UILabel new];
//    detailLabel.text = @"查看详情";
//    detailLabel.textColor = kColorMainColor;
//    detailLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
//    [backView addSubview:detailLabel];
//    [detailLabel yCenterToView:backView];
//    [detailLabel leftToView:lineLabel withSpace:12];
    
    
    [backView addSubview:self.collectionView];
    self.collectionView.frame = CGRectMake(0,  60, kScreenWidth-30, backHeight-60);
    
      
}
-(void)makeCellData:(IndexDataModel *)model
{
    _equipmentName.text = model.equipment_name;
    _equipmentStates.text = model.equipment_states;
    
    if ([model.equipment_states isEqualToString:@"离线"]) {
        _equipmentStates.backgroundColor = UIColorFromRGB(0xAEAEAE, 1);
    }else{
        _equipmentStates.backgroundColor = UIColorFromRGB(0xF39700, 1);
    }
}
#pragma mark -- collectionDelegate
//定义展示的Section的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return self.titleDataArray.count;
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    MoreCarmerasCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MoreCarmerasCollectionViewCell getCellIDStr] forIndexPath:indexPath];
    
    cell.moreBtnClick = ^{
        if (self.moreDealClick) {
            self.moreDealClick();
        }
    };

    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    DemandSubcatalogModel *model = [self.titleDataArray objectAtIndex:indexPath.row];
//    self.folder = model.folder;
//    [self loadNewData];

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
