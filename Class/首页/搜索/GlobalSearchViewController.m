//
//  GlobalSearchViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/5/7.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "GlobalSearchViewController.h"
#import "WWTableView.h"
#import "GlobalSearchCell.h"
#import "RequestSence.h"

@interface GlobalSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger page;
/// 没有内容
@property (nonatomic, strong) UIView *noDataView;
@property (nonatomic, strong) UISearchBar *searchButton;
@property (nonatomic,strong) NSString *searchValue;


@end

@implementation GlobalSearchViewController

-(void)setupSearchView
{
    UIView *searchView = [UIView new];
    searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchView];
    [searchView alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:self.view];
    [searchView addHeight:64];
    [searchView addBottomLineByColor:kColorLineColor];
    
    UIButton *backBtn = [UIButton new];
    [backBtn setImage:UIImageWithFileName(@"black_back_image") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBackClick) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:backBtn];
    [backBtn leftToView:searchView withSpace:5];
    [backBtn bottomToView:searchView withSpace:5];
    [backBtn addWidth:30];
    [backBtn addHeight:30];
    
    
    
    UIButton *searchBtn = [UIButton new];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:kColorMainColor forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    [searchView addSubview:searchBtn];
    [searchBtn rightToView:searchView withSpace:15];
    [searchBtn yCenterToView:backBtn];
    [searchBtn addWidth:30];
    [searchBtn addHeight:30];
    [searchBtn addTarget:self action:@selector(startSearchClick) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    searchField1.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField1.layer.cornerRadius=12.5;
    searchField1.layer.masksToBounds=YES;
    NSMutableAttributedString *arrStr = [[NSMutableAttributedString alloc]initWithString:searchField1.placeholder attributes:@{NSForegroundColorAttributeName:kColorThirdTextColor,NSFontAttributeName:[UIFont customFontWithSize:kFontSizeTen]}];
    searchField1.attributedPlaceholder = arrStr;
    [self.searchButton setTintColor:kColorThirdTextColor];
    [searchView addSubview:self.searchButton];
    UIImage *image=[UIImage imageWithColor:[UIColor whiteColor]];
    UIImage *searchBGImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 30.0, 0.0, 40.0) resizingMode:UIImageResizingModeStretch];
    [self.searchButton setBackgroundImage:searchBGImage];
    [self.searchButton yCenterToView:backBtn];
    [self.searchButton leftToView:backBtn withSpace:0];
    [self.searchButton addWidth:kScreenWidth-80];
    [self.searchButton addHeight:35];
    
    
}
-(void)goBackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setupTableView
{
    self.tableView = [[WWTableView alloc] init];
    self.tableView.backgroundColor = kColorBackgroundColor;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    [self.tableView alignTop:@"74" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[GlobalSearchCell class] forCellReuseIdentifier:[GlobalSearchCell getCellIDStr]];
 
    self.tableView.refreshEnable = YES;
    self.tableView.loadingMoreEnable = NO;
    __unsafe_unretained typeof(self) weak_self = self;
    self.tableView.actionHandle = ^(WWScrollingState state){
        switch (state) {
            case WWScrollingStateRefreshing:
            {
//                [weak_self loadNewData];
            }
                break;
            case WWScrollingStateLoadingMore:
            {
//                [weak_self loadMoreData];
            }
                break;
            default:
                break;
        }
    };
}
- (void)setupNoDataView
{
    self.noDataView = [self setupnoDataContentViewWithTitle:@"无搜索结果，换个词试试吧~" andImageNamed:@"search_empty_backimage" andTop:@"70"];
    // label
//    UILabel *tipLabel = [self getNoDataTipLabel];
//    UIButton *againBtn = [UIButton new];
//    againBtn.enabled = NO;
//    [againBtn setTitle:@"暂无搜索结果，请重试" forState:UIControlStateNormal];
//    [againBtn setTitleColor:kColorThirdTextColor forState:UIControlStateNormal];
//    againBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
//    [self.noDataView addSubview:againBtn];
//    [againBtn xCenterToView:self.noDataView];
//    [againBtn topToView:tipLabel withSpace:-8];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden = YES;
    
    [self setupSearchView];
    [self setupTableView];
    [self setupNoDataView];
    

    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.dataArray.count;
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GlobalSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:[GlobalSearchCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lineHidden = NO;
//        IndexDataModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell makeCellData:self.searchValue];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *url = [NSString stringWithFormat:@"https://leo.quarkioe.com/apps/androidapp/#/device/%@/dashboard/%@",model.childId,model.wechat[0]];
//    IndexDataModel *model = [self.dataArray objectAtIndex:indexPath.row];
//
    [TargetEngine controller:self pushToController:PushTargetMyEquipments WithTargetId:nil];
}

- (void)loadNewData
{
    self.page = 1;
    [self loadData];
}
- (void)loadMoreData
{
    [self loadData];
}
-(void)loadData
{
    [self startLoadDataRequest];
}
- (void)startLoadDataRequest
{
    [_kHUDManager showActivityInView:self.view withTitle:nil];
    
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathURL = [NSString stringWithFormat:@"inventory/managedObjects?pageSize=100&fragmentType=quark_IsCameraManageDevice&currentPage=%ld",(long)self.page];;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {

        [weak_self handleObject:obj];
    };
    sence.errorBlock = ^(NSError *error) {
        
        [weak_self failedOperation];
    };
    [sence sendRequest];
}
- (void)failedOperation
{
    [_kHUDManager hideAfter:0.1 onHide:nil];
    [_kHUDManager showMsgInView:nil withTitle:@"请求失败" isSuccess:NO];
    self.tableView.loadingMoreEnable = NO;
    [self.tableView stopLoading];
    [self changeNoDataViewHiddenStatus];
}
- (void)handleObject:(id)obj
{
    [_kHUDManager hideAfter:0.1 onHide:nil];
    __unsafe_unretained typeof(self) weak_self = self;
    [[GCDQueue globalQueue] queueBlock:^{
        NSArray *data = [obj objectForKey:@"managedObjects"];
        NSMutableArray *tempArray = [NSMutableArray array];

        if (weak_self.page == 1) {
            [weak_self.dataArray removeAllObjects];
        }

        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
//            IndexDataModel *model = [IndexDataModel makeModelData:dic];
//            [tempArray addObject:model];
        }];
        [weak_self.dataArray addObjectsFromArray:tempArray];
        
        [[GCDQueue mainQueue] queueBlock:^{
            
            [weak_self.tableView reloadData];
            if (tempArray.count >0) {
                weak_self.page++;
                weak_self.tableView.loadingMoreEnable = YES;
            } else {
                weak_self.tableView.loadingMoreEnable = NO;
            }
            [weak_self.tableView stopLoading];
            [weak_self changeNoDataViewHiddenStatus];
        }];
    }];
}
- (void)changeNoDataViewHiddenStatus
{
//    if (_isHadFirst == NO) {
//        return ;
//    }
//
    NSInteger count = self.dataArray.count;
    if (count == 0) {
        self.tableView.hidden = YES;
        self.noDataView.hidden = NO;
    } else {
        self.tableView.hidden = NO;
        self.noDataView.hidden = YES;
    }
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        self.searchValue = @"";
        return;
    }else {
        self.searchValue = searchText;
    }
    [self.tableView reloadData];
}
//开始搜索
-(void)startSearchClick
{
    [self.view endEditing:YES];
    
    if (![WWPublicMethod isStringEmptyText:self.searchValue]) {
        [_kHUDManager showMsgInView:nil withTitle:@"请输入搜索内容" isSuccess:YES];
        return;
    }
    
    [_kHUDManager showMsgInView:nil withTitle:self.searchValue isSuccess:YES];
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
