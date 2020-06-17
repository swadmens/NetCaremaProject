//
//  EquimentSharedViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/30.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "EquimentSharedViewController.h"
#import "WWTableView.h"
#import "WWTableViewCell.h"

@interface EquimentSharedCell : WWTableViewCell

@property (nonatomic,strong) UIImageView *titleImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *phoneLabel;


@end


@interface EquimentSharedViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger page;

/// 没有内容
@property (nonatomic, strong) UIView *noDataView;

@end

@implementation EquimentSharedViewController
-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)setupTableView
{
    self.tableView = [[WWTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = kColorBackgroundColor;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 55;
    [self.tableView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[EquimentSharedCell class] forCellReuseIdentifier:[EquimentSharedCell getCellIDStr]];
}
- (void)setupNoDataView
{
    self.noDataView = [self setupnoDataContentViewWithTitle:@"还没有好友，赶紧点击右上角添加吧~" andImageNamed:@"friends_empty_backimage" andTop:@"60"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"共享";
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    [self setupTableView];
    [self setupNoDataView];
    
    
    NSArray *arr = @[@{@"icon":@"",@"title":@"",@"phone":@""},
                    @{@"icon":@"",@"title":@"",@"phone":@""},
                    @{@"icon":@"",@"title":@"",@"phone":@""},
                    @{@"icon":@"",@"title":@"",@"phone":@""},];
    [self.dataArray addObjectsFromArray:arr];
    
    
    //右上角按钮
    UIButton *rightBtn = [UIButton new];
    [rightBtn setImage:UIImageWithFileName(@"share_add_image") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(right_clicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
}
-(void)right_clicked:(UIButton*)bt
{
    [TargetEngine controller:self pushToController:PushTargetAddNewFriends WithTargetId:nil];
}
#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    EquimentSharedCell *cell = [tableView dequeueReusableCellWithIdentifier:[EquimentSharedCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.lineHidden = NO;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = kColorBackgroundColor;
    
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"最近联系人";
    titleLabel.textColor = kColorThirdTextColor;
    titleLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    [headerView addSubview:titleLabel];
    [titleLabel leftToView:headerView withSpace:15];
    [titleLabel bottomToView:headerView withSpace:5];
    
  
    return headerView;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = kColorBackgroundColor;
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"(左滑列表删除动作)";
    titleLabel.textColor = kColorThirdTextColor;
    titleLabel.font = [UIFont customFontWithSize:kFontSizeEleven];
    [footerView addSubview:titleLabel];
    [titleLabel leftToView:footerView withSpace:15];
    [titleLabel topToView:footerView withSpace:5];
    
    return footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 27.5;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
      return NO;
}
-(UISwipeActionsConfiguration*)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        //删除操作
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self changeNoDataViewHiddenStatus];
        
        completionHandler (YES);
    }];
    deleteRowAction.image = UIImageWithFileName(@"share_delete_image");
    deleteRowAction.backgroundColor = [UIColor redColor];

    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return config;
}
- (void)changeNoDataViewHiddenStatus
{
    NSInteger count = self.dataArray.count;
    if (count == 0) {
        self.tableView.hidden = YES;
        self.noDataView.hidden = NO;
    } else {
        self.tableView.hidden = NO;
        self.noDataView.hidden = YES;
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

@implementation EquimentSharedCell

-(void)dosetup
{
    [super dosetup];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    
    _titleImageView = [UIImageView new];
    _titleImageView.clipsToBounds = YES;
    _titleImageView.layer.cornerRadius = 16.5;
    _titleImageView.image = UIImageWithFileName(@"friend_header_backimage");
    [self.contentView addSubview:_titleImageView];
    [_titleImageView yCenterToView:self.contentView];
    [_titleImageView leftToView:self.contentView withSpace:12.5];
    [_titleImageView addWidth:33];
    [_titleImageView addHeight:33];
    
    
    _nameLabel = [UILabel new];
    _nameLabel.text = @"这是测试名称";
    _nameLabel.textColor = kColorMainTextColor;
    _nameLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel leftToView:_titleImageView withSpace:5];
    [_nameLabel addCenterY:-8 toView:self.contentView];
    
    
    _phoneLabel = [UILabel new];
    _phoneLabel.text = @"16653621889";
    _phoneLabel.textColor = kColorThirdTextColor;
    _phoneLabel.font = [UIFont customFontWithSize:kFontSizeTen];
    [self.contentView addSubview:_phoneLabel];
    [_phoneLabel leftToView:_titleImageView withSpace:5];
    [_phoneLabel addCenterY:8 toView:self.contentView];
    

    
    UIImageView *rightImageView = [UIImageView new];
    rightImageView.image = UIImageWithFileName(@"mine_right_arrows");
    [self.contentView addSubview:rightImageView];
    [rightImageView yCenterToView:self.contentView];
    [rightImageView rightToView:self.contentView withSpace:15];
}

@end

