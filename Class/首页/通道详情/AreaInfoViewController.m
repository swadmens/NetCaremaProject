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
#import "ChannelDetailController.h"

@interface AreaInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) WWTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIButton *rightBtn;

@property (nonatomic,strong) UIView *submitView;

@property (nonatomic,strong) NSString *locationClass;//位置分类
@property (nonatomic,strong) NSString *className;//分类别名
@property (nonatomic,strong) NSString *locationInfo;//位置信息
@property (nonatomic,strong) NSString *locationName;//位置别名

@property (nonatomic,strong) NSString *building;//位置别名
@property (nonatomic,strong) NSString *floor;//位置别名
@property (nonatomic,strong) NSString *text;//位置别名


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
    
    if (!_isAddInfo) {
        self.building = self.model.building;
        self.floor = self.model.floor;
        self.text = self.model.text;
    }
    
    NSArray *Arr = @[
                     @{@"title":@"位置分类",@"detail":self.model.name,@"isedit":@(NO)},
                     @{@"title":@"分类别名",@"detail":self.model.nameEn,@"isedit":@(NO)},
                     @{@"title":@"位置信息",@"detail":self.model.locationDetail,@"isedit":@(NO)},
                     @{@"title":@"位置别名",@"detail":self.model.shortName,@"isedit":@(NO)},
                     @{@"title":@"楼宇",@"detail":_isAddInfo?@"请输入楼宇":self.model.building,@"isedit":@(_isAddInfo)},
                     @{@"title":@"楼层",@"detail":_isAddInfo?@"请输入楼层":self.model.floor,@"isedit":@(_isAddInfo)},
                     @{@"title":@"备注",@"detail":_isAddInfo?@"请输入备注":self.model.text,@"isedit":@(_isAddInfo)}
    ];
    [self.dataArray addObjectsFromArray:Arr];
    [self setupTableView];
    
    //右上角按钮
    _rightBtn = [UIButton new];
    [_rightBtn setTitle:_isAddInfo?@"保存":@"编辑" forState:UIControlStateNormal];
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
    if (_isAddInfo) {
        //新增，直接确定提交数据
        [self addAreaButtonClick];
    }else{
        //编辑
        self.rightBtn.selected = !self.rightBtn.selected;

        if (self.rightBtn.selected) {
            [self enterEditModelView];
        }else{
            [self exitEditModelView];
        }

    }
}
//进入编辑模式
-(void)enterEditModelView
{
    self.rightBtn.selected = YES;
    NSArray *arr = @[@{@"title":@"楼宇",@"detail":self.model.building,@"isedit":@(YES)},
                     @{@"title":@"楼层",@"detail":self.model.floor,@"isedit":@(YES)},
                     @{@"title":@"备注",@"detail":self.model.text,@"isedit":@(YES)}];
    [self.dataArray replaceObjectsInRange:NSMakeRange(4, 3) withObjectsFromArray:arr];
    [self.tableView reloadData];

    [UIView animateWithDuration:0.3 animations:^{
        self.submitView.transform = CGAffineTransformMakeTranslation(0, -45);
    }];
}
//退出编辑模式
-(void)exitEditModelView
{
    self.rightBtn.selected = NO;
    NSArray *arr = @[@{@"title":@"楼宇",@"detail":self.building,@"isedit":@(NO)},
                     @{@"title":@"楼层",@"detail":self.floor,@"isedit":@(NO)},
                     @{@"title":@"备注",@"detail":self.text,@"isedit":@(NO)}];
    
    [self.dataArray replaceObjectsInRange:NSMakeRange(4, 3) withObjectsFromArray:arr];
    [self.tableView reloadData];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.submitView.transform = CGAffineTransformIdentity;
    }];
}

//重设区域
-(void)resetAreaButtonClick
{
    NSString *url = [NSString stringWithFormat:@"service/cameraManagement/camera/area/cleardevice/%@",self.carmera_id];
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"Received: %@", obj);
        
        weak_self.submitView.transform = CGAffineTransformIdentity;
        [weak_self.navigationController popViewControllerAnimated:YES];
        
    };
    sence.errorBlock = ^(NSError *error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        // 请求失败
        DLog(@"error  ==  %@",error);
        [_kHUDManager showMsgInView:nil withTitle:@"重设失败，请重试！" isSuccess:YES];
       
    };
    [sence sendRequest];
    
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
    
    [cell makeCellData:dic];
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
            self.building = text;
        }else if (indexPath.row == 5){
            self.floor = text;
        }else if (indexPath.row == 6){
            self.text = text;
        }
 
    };
    
    return cell;
    
}
//确定
-(void)addAreaButtonClick
{
    //提交数据
    DLog(@"self.building  ==  %@",self.building);
    DLog(@"self.floor  ==  %@",self.floor);
    DLog(@"self.text  ==  %@",self.text);
    
    if (![WWPublicMethod isStringEmptyText:self.building]) {
        [_kHUDManager showMsgInView:nil withTitle:@"请填写楼宇！" isSuccess:YES];
        return;
    }
    
    if (![WWPublicMethod isStringEmptyText:self.floor]) {
        [_kHUDManager showMsgInView:nil withTitle:@"请填写楼层！" isSuccess:YES];
        return;
    }
    
    if (![WWPublicMethod isStringEmptyText:self.text]) {
        [_kHUDManager showMsgInView:nil withTitle:@"请填写备注！" isSuccess:YES];
        return;
    }
 
    
    [_kHUDManager showActivityInView:nil withTitle:nil];
    
    NSString *url = @"service/cameraManagement/camera/area/binddevice";
    
    NSDictionary *finalParams = @{
                                @"deviceId": self.carmera_id,
                                @"areaInfo": @{
                                        @"id": self.model.area_id,
                                        @"name": self.model.name,
                                        @"nameEn": self.model.nameEn,
                                        @"shortName": self.model.shortName,
                                        @"locationDetail": self.model.locationDetail
                                },
                                @"locationInfo": @{
                                        @"building": self.building,
                                        @"floor": self.floor,
                                        @"text": self.text
                                }
                            };

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:finalParams
                                                       options:0
                                                         error:nil];
    
    
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"BODY";
    sence.bodyMethod = @"PUT";
    sence.pathHeader = @"application/json";
    sence.body = jsonData;
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"Received: %@", obj);
        if (_isAddInfo) {
            //如果是新增，成功后返回设备详情
            for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[ChannelDetailController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                    }
                }
        }else{
            
            [weak_self exitEditModelView];
            [_kHUDManager showMsgInView:nil withTitle:@"已保存！" isSuccess:YES];
        }
      
        
    };
    sence.errorBlock = ^(NSError *error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        // 请求失败
        DLog(@"error  ==  %@",error);
        [_kHUDManager showMsgInView:nil withTitle:@"添加失败，请重试！" isSuccess:YES];
       
    };
    [sence sendRequest];
    
    
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
