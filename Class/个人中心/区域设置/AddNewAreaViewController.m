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

@interface AddNewAreaViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) WWTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

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
    self.title = @"添加区域";
    self.view.backgroundColor = kColorBackgroundColor;
    
    
    NSArray *Arr = @[
//    @{@"title":@"摄像头",@"detail":@"选择一个要添加区域的设备"},
                     @{@"title":@"位置分类",@"detail":@"请输入位置分类"},
                     @{@"title":@"分类别名",@"detail":@"请输入分类别名"},
                     @{@"title":@"位置信息",@"detail":@"请输入位置信息"},
                     @{@"title":@"位置别名",@"detail":@"请输入位置别名"},
//                     @{@"title":@"楼宇",@"detail":@"请输入楼宇"},
//                     @{@"title":@"楼层",@"detail":@"请输入楼层"},
//                     @{@"title":@"备注",@"detail":@"请输入备注"}
    ];
    [self.dataArray addObjectsFromArray:Arr];
    
    
    
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
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    
//    if (indexPath.row == 0) {
//        AddNewAreaChooseCarmeraCell *cell = [tableView dequeueReusableCellWithIdentifier:[AddNewAreaChooseCarmeraCell getCellIDStr] forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        [cell makeCellData:dic];
//
//        return cell;
//    }else{
    AddNewAreaTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:[AddNewAreaTextFieldCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell makeCellData:dic withEdit:YES];
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
//    }
}
//确定
-(void)addAreaButtonClick
{
    //提交数据
    DLog(@"self.name  ==  %@",self.name);
    DLog(@"self.nameEn  ==  %@",self.nameEn);
    DLog(@"self.locationDetail  ==  %@",self.locationDetail);
    DLog(@"self.shortName  ==  %@",self.shortName);
    
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
    sence.pathHeader = @"application/json";
    sence.body = jsonData;
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"Received: %@", obj);
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
