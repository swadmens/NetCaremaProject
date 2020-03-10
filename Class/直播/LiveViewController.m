//
//  LiveViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/2/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "LiveViewController.h"
#import "WWCollectionView.h"
#import "LiveViewCollectionViewCell.h"
#import "ChooseAreaView.h"



@interface LiveViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UIButton *chooseBtn;

@property (nonatomic, strong) WWCollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (nonatomic,strong) ChooseAreaView *areaView;
@property (nonatomic,strong) UIView *coverView;
@end

@implementation LiveViewController
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
        flowlayout.minimumInteritemSpacing = 10;
        //上下间距
        flowlayout.minimumLineSpacing = 10;
        
        CGFloat width = kScreenWidth/2-20;
        flowlayout.itemSize = CGSizeMake(width, width*0.6);
        
        _collectionView = [[WWCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        _collectionView.backgroundColor = kColorBackgroundColor;
        // 注册
        [_collectionView registerClass:[LiveViewCollectionViewCell class] forCellWithReuseIdentifier:[LiveViewCollectionViewCell getCellIDStr]];
        
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
    self.title = @"直播";
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationItem.leftBarButtonItem=nil;
    
    [self.view addSubview:self.collectionView];
    [self.collectionView alignTop:@"45" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    
    
    _areaView = [ChooseAreaView new];
    _areaView.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, 350);
    [[UIApplication sharedApplication].keyWindow addSubview:_areaView];
    __weak __typeof(self)weakSelf = self;
    _areaView.chooseArea = ^(NSString * _Nonnull area_id) {
        DLog(@"选择的是  ==   %@",area_id);
        [weakSelf chooseAreaClick];
    };
    
    _coverView = [UIView new];
    _coverView.hidden = YES;
    _coverView.frame = CGRectMake(0, 450, kScreenWidth, kScreenHeight-450);
    _coverView.backgroundColor = UIColorFromRGB(0x000000, 0.7);
    [[UIApplication sharedApplication].keyWindow addSubview:_coverView];

    
    
    
    [self creadLivingUI];
}
//创建UI
-(void)creadLivingUI
{
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:self.view];
    [topView addHeight:35];
    
    
    _chooseBtn = [UIButton new];
    [_chooseBtn setTitle:@"选择区域" forState:UIControlStateNormal];
    [_chooseBtn setTitleColor:kColorMainTextColor forState:UIControlStateNormal];
    [_chooseBtn setTitleColor:kColorMainColor forState:UIControlStateSelected];
    [_chooseBtn setImage:UIImageWithFileName(@"choose_area_down_image") forState:UIControlStateNormal];
    [_chooseBtn setImage:UIImageWithFileName(@"choose_area_up_image") forState:UIControlStateSelected];
    _chooseBtn.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
//    下面是设置图片跟文字的间距：
    CGFloat margin = (60 - CGRectGetWidth(_chooseBtn.imageView.frame) - CGRectGetWidth(_chooseBtn.titleLabel.frame)) *0.5;
    CGFloat marginGay = 22;
    _chooseBtn.imageEdgeInsets = UIEdgeInsetsMake(0, marginGay, 0, margin - marginGay);
    _chooseBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    [topView addSubview:_chooseBtn];
    [_chooseBtn centerToView:topView];
    [_chooseBtn addTarget:self action:@selector(chooseAreaClick) forControlEvents:UIControlEventTouchUpInside];
    
}
//选择区域
-(void)chooseAreaClick
{
    _chooseBtn.selected = !_chooseBtn.selected;
    
    __weak __typeof(self)weakself = self;
    
    if (_chooseBtn.selected) {
        _coverView.hidden = NO;
        _areaView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            weakself.areaView.frame = CGRectMake(0, 100, kScreenWidth, 350);
        }];
    }else{
        _coverView.hidden = YES;
        _areaView.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            weakself.areaView.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, 350);
        }];
    }
    
}

#pragma mark -- collectionDelegate
//定义展示的Section的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 14;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LiveViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[LiveViewCollectionViewCell getCellIDStr] forIndexPath:indexPath];
        
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [TargetEngine controller:self pushToController:PushTargetDHLiving WithTargetId:@"1"];
    }else{
        [TargetEngine controller:self pushToController:PushTargetHKLiving WithTargetId:@"1"];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
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
