//
//  IndexTopView.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/26.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "IndexTopView.h"
#import "WWCollectionView.h"
#import "IndexTopCollectionViewCell.h"

@interface IndexTopView ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic, strong) UISearchBar *searchButton;
@property (nonatomic,strong) NSString *searchValue;


@property (nonatomic, strong) WWCollectionView *collectionUpView;
@property(nonatomic,strong) NSMutableArray *titleDataArray;
@property (nonatomic, strong) NSMutableDictionary *cellDic;
@property (nonatomic,assign) BOOL isClick;//是否点击过


@end

@implementation IndexTopView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorBackgroundColor;
        [self createUI];
    }
    return self;
}
- (WWCollectionView *)collectionUpView
{
    if (!_collectionUpView) {
        
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向
        flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //左右间距
//        flowlayout.minimumInteritemSpacing = 20;
//        //上下间距
//        flowlayout.minimumLineSpacing = 0.1;
        flowlayout.estimatedItemSize = CGSizeMake(40, 35);
        _collectionUpView = [[WWCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        // 注册
        [_collectionUpView registerClass:[IndexTopCollectionViewCell class] forCellWithReuseIdentifier:[IndexTopCollectionViewCell getCellIDStr]];
        _collectionUpView.backgroundColor = kColorBackgroundColor;
        _collectionUpView.showsHorizontalScrollIndicator = NO;
        _collectionUpView.delegate = self;
        _collectionUpView.dataSource = self;
    
    }
    return _collectionUpView;
}
-(void)createUI
{
    
    self.searchButton = [UISearchBar new];
    self.searchButton.placeholder = @"请输入关键词";
    self.searchButton.barStyle = UISearchBarStyleMinimal;
    self.searchButton.delegate = self;
    self.searchButton.clipsToBounds = YES;
    self.searchButton.layer.cornerRadius = 12.5;
     UITextField *searchField1;
       if ([[[UIDevice currentDevice]systemVersion] floatValue] >=     13.0) {
           searchField1 = self.searchButton.searchTextField;
       }else{
           searchField1 = [self.searchButton valueForKey:@"_searchField"];
       }
    searchField1.backgroundColor = [UIColor whiteColor];
    searchField1.textColor = kColorMainTextColor;
    searchField1.font=[UIFont customFontWithSize:kFontSizeTen];
    searchField1.layer.cornerRadius=12.5;
    searchField1.layer.masksToBounds=YES;
    NSMutableAttributedString *arrStr = [[NSMutableAttributedString alloc]initWithString:searchField1.placeholder attributes:@{NSForegroundColorAttributeName:kColorThirdTextColor,NSFontAttributeName:[UIFont customFontWithSize:kFontSizeTen]}];
    searchField1.attributedPlaceholder = arrStr;
    [self.searchButton setTintColor:kColorThirdTextColor];
    [self addSubview:self.searchButton];
    UIImage *image=[UIImage imageWithColor:[UIColor whiteColor]];
    UIImage *searchBGImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 30.0, 0.0, 40.0) resizingMode:UIImageResizingModeStretch];
    [self.searchButton setBackgroundImage:searchBGImage];
    [self.searchButton bottomToView:self];
    [self.searchButton leftToView:self withSpace:15];
    [self.searchButton addWidth:kScreenWidth-30];
    [self.searchButton addHeight:25];
    
    
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"我的设备";
    nameLabel.textColor = kColorMainTextColor;
    nameLabel.font = [UIFont customFontWithSize:20];
    [self addSubview:nameLabel];
    [nameLabel leftToView:self withSpace:15];
    [nameLabel bottomToView:self.searchButton withSpace:20];
    
    UILabel *lineLable = [UILabel new];
    lineLable.backgroundColor = kColorMainColor;
    [self addSubview:lineLable];
    [lineLable xCenterToView:nameLabel];
    [lineLable topToView:nameLabel withSpace:5];
    [lineLable addWidth:18];
    [lineLable addHeight:2];
    
    
    [self addSubview:self.collectionUpView];
    [self.collectionUpView yCenterToView:nameLabel];
    [self.collectionUpView leftToView:nameLabel withSpace:10];
    [self.collectionUpView addWidth:kScreenWidth-155];
    [self.collectionUpView addHeight:35];
    
    
    
    UIButton *addBtn = [UIButton new];
    [addBtn setImage:UIImageWithFileName(@"index_add_image") forState:UIControlStateNormal];
    [addBtn setTitleColor:kColorMainColor forState:UIControlStateNormal];
    [self addSubview:addBtn];
    [addBtn yCenterToView:nameLabel];
    [addBtn rightToView:self withSpace:15];
    [addBtn addTarget:self action:@selector(addGroupClick) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    // 每次先从字典中根据IndexPath取出唯一标识符
    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
    if (identifier == nil) {
       identifier = [NSString stringWithFormat:@"%@%@", [IndexTopCollectionViewCell getCellIDStr], [NSString stringWithFormat:@"%@", indexPath]];
       [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
       // 注册Cell
       [self.collectionUpView registerClass:[IndexTopCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    }
    IndexTopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
//    DemandSubcatalogModel *model = [self.titleDataArray objectAtIndex:indexPath.row];
//    [cell makeCellData:model];
    
    if (!self.isClick) {
        //设置首个默认选中
        [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    DemandSubcatalogModel *model = [self.titleDataArray objectAtIndex:indexPath.row];
//    self.folder = model.folder;
    self.isClick = YES;
//    [self loadNewData];
//    [self.delegate collectionSelect:indexPath.row];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.1;
 
}
//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.1;
}
//搜索处理
#pragma mark - UISearchBarDelegate
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//
//    if (searchText.length == 0) {
//        self.searchValue = @"";
//        return;
//    }else {
//        self.searchValue = searchText;
//    }
//    [self loadNewData];
//
//}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (searchBar.text.length == 0) {
           self.searchValue = @"";
       }else {
           self.searchValue = searchBar.text;
           [self.delegate searchValue:searchBar.text];
       }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchValue = @"";
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [TargetEngine controller:nil pushToController:PushTargetGlobalSearch WithTargetId:nil];
}

-(void)addGroupClick
{
    [TargetEngine controller:nil pushToController:PushTargetAllGroups WithTargetId:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
