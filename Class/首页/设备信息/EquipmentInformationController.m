//
//  EquipmentInformationController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/2.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "EquipmentInformationController.h"
#import "LGXMenuView.h"
#import "EquimentBasicInfoController.h"
#import "NetLivingViewController.h"
#import "CarmeaVideosViewController.h"

@interface EquipmentInformationController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
{
    UIViewController *_chosedController;
}
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) EquimentBasicInfoController *basicController;
@property (nonatomic, strong) NetLivingViewController *liveController;
@property (nonatomic, strong) CarmeaVideosViewController *videoController;
@property (nonatomic, strong) NSArray *pagesArray;

@property (nonatomic, strong) LGXMenuView *menuView;
@property (nonatomic,strong) UIButton *rightBtn;

@property (nonatomic,assign) NSInteger pages;//当前页码

@end

@implementation EquipmentInformationController
- (EquimentBasicInfoController *)basicController
{
    if (!_basicController) {
        _basicController = [[EquimentBasicInfoController alloc] init];
    }
    return _basicController;
}
- (NetLivingViewController *)liveController
{
    if (!_liveController) {
        _liveController = [[NetLivingViewController alloc] init];
    }
    return _liveController;
}
- (CarmeaVideosViewController *)videoController
{
    if (!_videoController) {
        _videoController = [[CarmeaVideosViewController alloc] init];
    }
    return _videoController;
}
- (void)setupPageViews
{
    //
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    [self.pageViewController.view alignTop:@"55" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    
    
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    //
    self.basicController.view.tag = 0;
    self.basicController.equiment_id = self.equiment_id;
    [self.basicController loadViewIfNeeded];
    
    self.liveController.view.tag = 1;
    self.liveController.equiment_id = self.equiment_id;
    
    self.videoController.view.tag = 2;
    self.videoController.equiment_id = self.equiment_id;
    
    self.pagesArray = @[
                        self.basicController,
                        self.liveController,
                        self.videoController,
                        ];
    
    // 设置controllers // self.detailController,self.pingJiaController
    [self.pageViewController setViewControllers:@[self.basicController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}
- (void)setupTopTitleView
{
    NSArray *arr = @[
                     @"基本信息",
                     @"直播",
                     @"录像",
                     ];
    self.menuView = [[LGXMenuView alloc] init];
    self.menuView.textColor=[UIColor whiteColor];
    self.menuView.chosedTextColor=kColorMainColor;
    self.menuView.lineColor=kColorMainColor;
    CGRect rect = self.navigationController.navigationBar.frame;
    self.menuView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(rect));
    __unsafe_unretained typeof(self) weak_self = self;
    self.menuView.didChangedIndex = ^(NSInteger index) {
        [weak_self didMenuChosedIndex:index];
    };
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i =0; i<arr.count  ; i++) {
        LMenuModel *model = [[LMenuModel alloc] init];
        model.title = [arr objectAtIndex:i];
        [tempArr addObject:model];
    }
    
    [self.menuView reloadMenuWith:[NSArray arrayWithArray:tempArr]];
    [self.view addSubview:self.menuView];
}

- (void)changeMenuViewCurrentIndex:(NSNotification *)notification{
    [self didMenuChosedIndex:2];
    self.menuView.currentIndex = 2;
}
/// 顶部点击了
- (void)didMenuChosedIndex:(NSInteger)index
{
    self.pages = index;
    
    if (index == 1) {
        [self.navigationItem setRightBarButtonItem:nil];
        _rightBtn.selected = NO;
        NSDictionary *dic = @{@"edit":@(NO)};
        //注册通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"editStates" object:nil userInfo:dic];
    }else if (index == 2){
        [_rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:kColorMainColor forState:UIControlStateSelected];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
        [self.navigationItem setRightBarButtonItem:rightItem];
    }else{
        [_rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        _rightBtn.selected = NO;
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
        [self.navigationItem setRightBarButtonItem:rightItem];
        
        NSDictionary *dic = @{@"edit":@(NO)};
        //注册通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"editStates" object:nil userInfo:dic];
    }
    
    
    
    UIViewController *controller = [self.pagesArray objectAtIndex:index];
//    [self reloadDataAtIndex:index];
    if (_chosedController == controller) {
        return;
    }
    NSUInteger exIndex = [self.pagesArray indexOfObject:_chosedController];
    UIPageViewControllerNavigationDirection NavigationDirection = UIPageViewControllerNavigationDirectionForward;
    if (_chosedController != nil && index < exIndex) { // 如果要加载的比现在的小，
        NavigationDirection = UIPageViewControllerNavigationDirectionReverse;
    }
    _chosedController = controller;

    [self.pageViewController setViewControllers:@[controller] direction:NavigationDirection animated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的设备";
    [self setupTopTitleView];
    [self setupPageViews];
    
    //右上角按钮
    _rightBtn = [UIButton new];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightBtn.titleLabel.font=[UIFont customFontWithSize:kFontSizeFourteen];
    [_rightBtn.titleLabel setTextAlignment: NSTextAlignmentRight];
    _rightBtn.frame = CGRectMake(0, 0, 65, 40);
    [_rightBtn addTarget:self action:@selector(right_clicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    [_rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    
    
    
    
}
//右上角按钮点击
-(void)right_clicked
{
    [self.view endEditing:YES];
    if (self.pages == 2) {
        _rightBtn.selected = !_rightBtn.selected;
        NSDictionary *dic = @{@"edit":@(_rightBtn.selected)};
        //注册通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"editStates" object:nil userInfo:dic];
    }else if (self.pages == 0){
        //注册通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"saveInfomation" object:nil userInfo:nil];
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
