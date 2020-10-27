//
//  AreaInfoViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/10/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "AreaInfoViewController.h"
#import "WWTableView.h"
#import "RequestSence.h"
#import "AddNewAreaTextFieldCell.h"
#import "AreaSetupModel.h"

@interface AreaInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) WWTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,assign) BOOL isEdit;

@property (nonatomic,strong) UIView *submitView;

@property (nonatomic,strong) NSString *locationClass;//位置分类
@property (nonatomic,strong) NSString *className;//分类别名
@property (nonatomic,strong) NSString *locationInfo;//位置信息
@property (nonatomic,strong) NSString *locationName;//位置别名

@property (nonatomic,strong) NSString *buildName;//位置别名
@property (nonatomic,strong) NSString *buildFloor;//位置别名
@property (nonatomic,strong) NSString *note;//位置别名


@end

@implementation AreaInfoViewController
-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)setupTableView
{
    self.tableView = [WWTableView new];
    self.tableView.backgroundColor = kColorBackgroundColor;
    self.tableView.rowHeight = 50;
    [self.view addSubview:self.tableView];
    [self.tableView alignTop:@"10" leading:@"0" bottom:@"58" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AddNewAreaTextFieldCell class] forCellReuseIdentifier:[AddNewAreaTextFieldCell getCellIDStr]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"区域信息";
    self.view.backgroundColor = kColorBackgroundColor;
    
    self.isEdit = NO;
    
    NSArray *Arr = @[
                     @{@"title":@"位置分类",@"detail":self.model.name},
                     @{@"title":@"分类别名",@"detail":self.model.nameEn},
                     @{@"title":@"位置信息",@"detail":self.model.locationDetail},
                     @{@"title":@"位置别名",@"detail":self.model.shortName},
                     @{@"title":@"楼宇",@"detail":@"请输入楼宇"},
                     @{@"title":@"楼层",@"detail":@"请输入楼层"},
                     @{@"title":@"备注",@"detail":@"请输入备注"}
    ];
    [self.dataArray addObjectsFromArray:Arr];
    [self setupTableView];
    
    //右上角按钮
    _rightBtn = [UIButton new];
    [_rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_rightBtn setTitle:@"取消" forState:UIControlStateSelected];
    [_rightBtn setTitleColor:kColorMainColor forState:UIControlStateSelected];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeFifty];
    [_rightBtn addTarget:self action:@selector(right_clicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    
    self.submitView = [UIView new];
    [self.submitView addTopLineByColor:kColorLineColor];
    self.submitView.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.submitView];
    self.submitView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 45);
    
    UIButton *addBtn = [UIButton new];
    addBtn.clipsToBounds = YES;
    addBtn.layer.cornerRadius = 19;
    [addBtn setTitle:@"确定" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:UIImageWithFileName(@"button_back_image") forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [addBtn addTarget:self action:@selector(addAreaButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.submitView addSubview:addBtn];
    [addBtn rightToView:self.submitView withSpace:10];
    [addBtn yCenterToView:self.submitView];
    [addBtn addWidth:kScreenWidth/2 - 20];
    [addBtn addHeight:38];
    
    UIButton *resetBtn = [UIButton new];
    resetBtn.clipsToBounds = YES;
    resetBtn.layer.cornerRadius = 19;
    [resetBtn setTitle:@"重设区域" forState:UIControlStateNormal];
    [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resetBtn setBackgroundImage:UIImageWithFileName(@"button_back_image") forState:UIControlStateNormal];
    resetBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [resetBtn addTarget:self action:@selector(resetAreaButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.submitView addSubview:resetBtn];
    [resetBtn leftToView:self.submitView withSpace:10];
    [resetBtn yCenterToView:self.submitView];
    [resetBtn addWidth:kScreenWidth/2 - 20];
    [resetBtn addHeight:38];
    
}
-(void)action_goback
{
    self.submitView.transform = CGAffineTransformIdentity;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)right_clicked
{
    self.rightBtn.selected = !self.rightBtn.selected;
    self.isEdit = !self.isEdit;
    [self.tableView reloadData];
    if (self.isEdit) {
        [UIView animateWithDuration:0.3 animations:^{
            self.submitView.transform = CGAffineTransformMakeTranslation(0, -45);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.submitView.transform = CGAffineTransformIdentity;
        }];
    }
    
}
-(void)resetAreaButtonClick
{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];

    AddNewAreaTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:[AddNewAreaTextFieldCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell makeCellData:dic withEdit:self.isEdit];
    cell.textFieldValue = ^(NSString * _Nonnull text) {
      
        if (indexPath.row == 0) {
            self.locationClass = text;
        }else if (indexPath.row == 1){
            self.className = text;
        }else if (indexPath.row == 2){
            self.locationInfo = text;
        }else if (indexPath.row == 3){
            self.locationName = text;
        }else if (indexPath.row == 4){
            self.buildName = text;
        }else if (indexPath.row == 5){
            self.buildFloor = text;
        }else if (indexPath.row == 6){
            self.note = text;
        }
 
    };
    
    return cell;
    
}
//确定
-(void)addAreaButtonClick
{
    //提交数据
    DLog(@"self.locationClass  ==  %@",self.locationClass);
    DLog(@"self.className  ==  %@",self.className);
    DLog(@"self.locationInfo  ==  %@",self.locationInfo);
    DLog(@"self.locationName  ==  %@",self.locationName);
    
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
