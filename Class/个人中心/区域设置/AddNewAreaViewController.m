//
//  AddNewAreaViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/10/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "AddNewAreaViewController.h"
#import "WWTableView.h"
#import "AddNewAreaChooseCarmeraCell.h"
#import "AddNewAreaTextFieldCell.h"
#import "RequestSence.h"
#import "AreaSetupModel.h"

@interface AddNewAreaViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) WWTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIButton *rightBtn;

@property (nonatomic,strong) NSString *name;//位置分类
@property (nonatomic,strong) NSString *nameEn;//分类别名
@property (nonatomic,strong) NSString *locationDetail;//位置信息
@property (nonatomic,strong) NSString *shortName;//位置别名

@end

@implementation AddNewAreaViewController
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
    [self.tableView registerClass:[AddNewAreaChooseCarmeraCell class] forCellReuseIdentifier:[AddNewAreaChooseCarmeraCell getCellIDStr]];
    [self.tableView registerClass:[AddNewAreaTextFieldCell class] forCellReuseIdentifier:[AddNewAreaTextFieldCell getCellIDStr]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorBackgroundColor;
    
    
    [self setupTableView];
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView alignTop:nil leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    [bottomView addHeight:58];
    
    
    UIButton *addBtn = [UIButton new];
    addBtn.clipsToBounds = YES;
    addBtn.layer.cornerRadius = 19;
    [addBtn setTitle:@"确定" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:UIImageWithFileName(@"button_back_image") forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [addBtn addTarget:self action:@selector(addAreaButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addBtn];
    [addBtn centerToView:bottomView];
    [addBtn addWidth:kScreenWidth-30];
    [addBtn addHeight:38];
    
    if (self.model != nil) {
        self.title = @"区域详情";
        bottomView.hidden = YES;
        NSArray *Arr = @[
                         @{@"title":@"位置分类",@"detail":self.model.name,@"isedit":@(NO)},
                         @{@"title":@"分类别名",@"detail":self.model.nameEn,@"isedit":@(NO)},
                         @{@"title":@"位置信息",@"detail":self.model.locationDetail,@"isedit":@(NO)},
                         @{@"title":@"位置别名",@"detail":self.model.shortName,@"isedit":@(NO)},
        ];
        [self.dataArray addObjectsFromArray:Arr];
        
        //右上角按钮
        _rightBtn = [UIButton new];
        [_rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_rightBtn setTitle:@"保存" forState:UIControlStateSelected];
        [_rightBtn setTitleColor:kColorMainColor forState:UIControlStateSelected];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeFifty];
        [_rightBtn addTarget:self action:@selector(right_clicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
        [self.navigationItem setRightBarButtonItem:rightItem];
        
    }else{
        self.title = @"添加区域";
        NSArray *Arr = @[
                         @{@"title":@"位置分类",@"detail":@"请输入位置分类",@"isedit":@(YES)},
                         @{@"title":@"分类别名",@"detail":@"请输入分类别名",@"isedit":@(YES)},
                         @{@"title":@"位置信息",@"detail":@"请输入位置信息",@"isedit":@(YES)},
                         @{@"title":@"位置别名",@"detail":@"请输入位置别名",@"isedit":@(YES)},
        ];
        [self.dataArray addObjectsFromArray:Arr];
    }
    
    
}

//右上角
-(void)right_clicked
{
    self.rightBtn.selected = !self.rightBtn.selected;
    [self.tableView reloadData];
    if (self.rightBtn.selected) {
        //开始编辑
        [self.dataArray removeAllObjects];
        NSArray *Arr = @[
                         @{@"title":@"位置分类",@"detail":self.model.name,@"isedit":@(YES)},
                         @{@"title":@"分类别名",@"detail":self.model.nameEn,@"isedit":@(YES)},
                         @{@"title":@"位置信息",@"detail":self.model.locationDetail,@"isedit":@(YES)},
                         @{@"title":@"位置别名",@"detail":self.model.shortName,@"isedit":@(YES)},
        ];
        [self.dataArray addObjectsFromArray:Arr];
        self.name = self.model.name;
        self.nameEn = self.model.nameEn;
        self.locationDetail = self.model.locationDetail;
        self.shortName = self.model.shortName;
        [self.tableView reloadData];
        
    }else{
        //保存编辑
        [self addNewAreaOrEdit:YES];
    }
    
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
            self.name = text;
        }else if (indexPath.row == 1){
            self.nameEn = text;
        }else if (indexPath.row == 2){
            self.locationDetail = text;
        }else if (indexPath.row == 3){
            self.shortName = text;
        }
 
    };
    
    return cell;
}
//确定,新增区域
-(void)addAreaButtonClick
{
    [self addNewAreaOrEdit:NO];
}
//新增或编辑区域
-(void)addNewAreaOrEdit:(BOOL)isEdit
{
    //提交数据
    if (![WWPublicMethod isStringEmptyText:self.name]) {
        [_kHUDManager showMsgInView:nil withTitle:@"请填写位置分类！" isSuccess:YES];
        return;
    }
    
    if (![WWPublicMethod isStringEmptyText:self.nameEn]) {
        [_kHUDManager showMsgInView:nil withTitle:@"请填写分类别名！" isSuccess:YES];
        return;
    }
    
    if (![WWPublicMethod isStringEmptyText:self.locationDetail]) {
        [_kHUDManager showMsgInView:nil withTitle:@"请填写位置信息！" isSuccess:YES];
        return;
    }
    
    if (![WWPublicMethod isStringEmptyText:self.shortName]) {
        [_kHUDManager showMsgInView:nil withTitle:@"请填写位置别名！" isSuccess:YES];
        return;
    }
    
    [_kHUDManager showActivityInView:nil withTitle:nil];
    
    NSString *url = @"service/cameraManagement/camera/area";
    if (isEdit) {
        url = [NSString stringWithFormat:@"service/cameraManagement/camera/area/%@",self.model.area_id];
    }
    NSDictionary *finalParams = @{
                                @"name": self.name,
                                @"nameEn": self.nameEn,
                                @"locationDetail":self.locationDetail,
                                @"shortName": self.shortName,
                                };

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:finalParams
                                                       options:0
                                                         error:nil];
    
    
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"BODY";
    sence.bodyMethod = isEdit?@"PUT":@"POST";
    sence.pathHeader = @"application/json";
    sence.body = jsonData;
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
//        DLog(@"Received: %@", obj);
        if ([weak_self.delegate respondsToSelector:@selector(uploadAreaSuccess)]) {
            [weak_self.delegate uploadAreaSuccess];
        }
        [weak_self.navigationController popViewControllerAnimated:YES];
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
