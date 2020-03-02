//
//  CarmeaVideosViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/2.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "CarmeaVideosViewController.h"
#import "WWCollectionView.h"
#import "CarmeaVideosViewCell.h"
@interface CarmeaVideosViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    BOOL _isHadFirst; // 是否第一次加载了
}
@property (nonatomic, strong) WWCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation CarmeaVideosViewController
#pragma mark - 延迟加载
- (WWCollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向
        flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //左右间距
        flowlayout.minimumInteritemSpacing = 10;
        //上下间距
        flowlayout.minimumLineSpacing = 10;
        
        _collectionView = [[WWCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        _collectionView.backgroundColor = kColorBackgroundColor;
        // 注册
        [_collectionView registerClass:[CarmeaVideosViewCell class] forCellWithReuseIdentifier:[CarmeaVideosViewCell getCellIDStr]];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
//        _collectionView.refreshEnable = YES;
//        __unsafe_unretained typeof(self) weak_self = self;
//        _collectionView.actionHandle = ^(WWCollectionViewState state){
//
//            switch (state) {
//                case WWCollectionViewStateRefreshing:
//                {
//                    [weak_self loadNewData];
//                }
//                    break;
//                case WWCollectionViewStateLoadingMore:
//                {
//                    [weak_self loadMoreData];
//                }
//                    break;
//                default:
//                    break;
//            }
//        };
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorBackgroundColor;
    [self creadUI];
    [self.view addSubview:self.collectionView];
    [self.collectionView alignTop:@"40" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    
    
    NSArray *dataArr = @[@{@"choose":@(NO)},@{@"choose":@(NO)},@{@"choose":@(NO)},@{@"choose":@(NO)},
                             ];
    self.dataArray = [NSMutableArray arrayWithArray:dataArr];
    

    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takeGoHomeNotica:) name:@"editStates" object:nil];
}
- (void)takeGoHomeNotica:(NSNotification *)notification
{
    self.isEdit = [[NSString stringWithFormat:@"%@",notification.userInfo[@"edit"]] boolValue];
    
    if (!self.isEdit) {
        [self.dataArray removeAllObjects];
        NSArray *dataArr = @[@{@"choose":@(NO)},@{@"choose":@(NO)},@{@"choose":@(NO)},@{@"choose":@(NO)},];
        [self.dataArray addObjectsFromArray:dataArr];
    }
    
    [_collectionView reloadData];
}
//创建UI
-(void)creadUI
{
    UILabel *topLeftLabel = [UILabel new];
    topLeftLabel.backgroundColor = kColorMainColor;
    [self.view addSubview:topLeftLabel];
    [topLeftLabel leftToView:self.view withSpace:15];
    [topLeftLabel topToView:self.view withSpace:18];
    [topLeftLabel addWidth:1.5];
    [topLeftLabel addHeight:10.5];
  
  
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"所有录像";
    titleLabel.textColor = kColorSecondTextColor;
    titleLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [titleLabel sizeToFit];
    [self.view addSubview:titleLabel];
    [titleLabel yCenterToView:topLeftLabel];
    [titleLabel leftToView:topLeftLabel withSpace:6];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CarmeaVideosViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CarmeaVideosViewCell getCellIDStr] forIndexPath:indexPath];
//    cell.isGrid = _isGrid;
//
//    GoodsListModel *model=[self.dataArray objectAtIndex:indexPath.row];
//    [cell makeCellData:model];
    cell.isEdit = self.isEdit;
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    cell.isChoosed = ![[dic objectForKey:@"choose"] boolValue];
    
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}
//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = kScreenWidth/2-21;
    return CGSizeMake(width, width*0.8);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEdit) {
        CarmeaVideosViewCell *cell = (CarmeaVideosViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
        cell.isChoosed = [[dic objectForKey:@"choose"] boolValue];
        NSDictionary *lDic = @{@"choose":@(![[dic objectForKey:@"choose"] boolValue])};
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:lDic];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
