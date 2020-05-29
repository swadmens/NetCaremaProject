//
//  EquimentBasicInfoController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/2.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "EquimentBasicInfoController.h"
#import "WWTableView.h"
#import "ConfigurationFileCell.h"
#import "ConnectionMonitoringCell.h"
#import "AFHTTPSessionManager.h"
#import "AddCarmeraAddressController.h"


@interface EquimentBasicInfoController ()<UITableViewDelegate,UITableViewDataSource,AddCarmeraAddressDelegate>

@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *c8y_Notes;

@property (nonatomic,strong) NSMutableDictionary *dicData;

@property (nonatomic,assign)BOOL isSave;

@end

@implementation EquimentBasicInfoController
-(NSMutableDictionary*)dicData
{
    if (!_dicData) {
        _dicData = [NSMutableDictionary new];
    }
    return _dicData;
}
- (void)setupTableView
{
    self.tableView = [[WWTableView alloc] init];
    self.tableView.backgroundColor = kColorBackgroundColor;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    [self.tableView alignTop:@"10" leading:@"0" bottom:@"10" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ConfigurationFileCell class] forCellReuseIdentifier:[ConfigurationFileCell getCellIDStr]];
    [self.tableView registerClass:[ConnectionMonitoringCell class] forCellReuseIdentifier:[ConnectionMonitoringCell getCellIDStr]];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的设备";
    self.view.backgroundColor = kColorBackgroundColor;

    
    [self setupTableView];
    self.isSave = NO;
    
    
    //右上角按钮
    UIButton *rightBtn = [UIButton new];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font=[UIFont customFontWithSize:kFontSizeFourteen];
    [rightBtn.titleLabel setTextAlignment: NSTextAlignmentRight];
//    rightBtn.frame = CGRectMake(0, 0, 65, 40);
    [rightBtn addTarget:self action:@selector(right_clicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:rightItem];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isSave) {
        return;
    }
    NSDictionary *data = [NSDictionary dictionaryWithDictionary:[WWPublicMethod objectTransFromJson:self.equiment_id]];
    [self.dicData addEntriesFromDictionary:data];
    self.name = [self.dicData objectForKey:@"name"];
    self.c8y_Notes = [self.dicData objectForKey:@"c8y_Notes"];
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ConfigurationFileCell *cell = [tableView dequeueReusableCellWithIdentifier:[ConfigurationFileCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell makeCellData:self.dicData];
        
        cell.textFieldName = ^(NSString * _Nonnull text) {
            self.name = text;
        };
        cell.textFieldAnnotation = ^(NSString * _Nonnull text) {
            self.c8y_Notes = text;
        };
        cell.addAddressClick = ^{
            [self.view endEditing:YES];
            AddCarmeraAddressController *vc = [AddCarmeraAddressController new];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        };
       return cell;
    }else{
        
        ConnectionMonitoringCell *cell = [tableView dequeueReusableCellWithIdentifier:[ConnectionMonitoringCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell makeCellData:self.dicData];
       return cell;
    }
    
}

-(void)right_clicked
{
    //上传保存
    [self upLoadInfo];
}

-(void)upLoadInfo
{
    if (![WWPublicMethod isStringEmptyText:self.name]) {
        [_kHUDManager showMsgInView:nil withTitle:@"名称不能为空" isSuccess:YES];
        return;
    }
    
    if (![WWPublicMethod isStringEmptyText:self.c8y_Notes]) {
        [_kHUDManager showMsgInView:nil withTitle:@"注释不能为空" isSuccess:YES];
        return;
    }
    
    
    NSDictionary *finalParams = @{
                                  @"name":self.name,
                                  @"c8y_Notes": self.c8y_Notes,
                                  };
        
    //提交数据
    NSString *url = [NSString stringWithFormat:@"https://homebay.quarkioe.com/inventory/managedObjects/%@",[self.dicData objectForKey:@"id"]];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:finalParams
                                                       options:0
                                                         error:nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"application/vnd.com.nsn.cumulocity.managedobject+json",@"multipart/form-data", nil];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"PUT" URLString:url parameters:nil error:nil];
    
    // 设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //配置用户名 密码
    NSString *str1 = [NSString stringWithFormat:@"%@/%@:%@",_kUserModel.userInfo.tenant_name,_kUserModel.userInfo.user_name,_kUserModel.userInfo.password];
    //进行加密  [str base64EncodedString]使用开源Base64.h分类文件加密
    NSString *str2 = [NSString stringWithFormat:@"Basic %@",[WWPublicMethod encodeBase64:str1]];
    // 设置Authorization的方法设置header
    [request setValue:str2 forHTTPHeaderField:@"Authorization"];
    
    // 设置body
    [request setHTTPBody:jsonData];
    
    NSURLSessionDataTask *task = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        
        if (error) {
            // 请求失败
            DLog(@"error  ==  %@",error.userInfo);
            [_kHUDManager showMsgInView:nil withTitle:@"上传失败，请重试！" isSuccess:YES];
            
            return ;
        }
        DLog(@"responseObject  ==  %@",responseObject);
        
        [_kHUDManager showMsgInView:nil withTitle:@"保存成功" isSuccess:YES];
//        [self.navigationController popToRootViewControllerAnimated:YES];

        self.isSave = YES;
        
    }];
    [task resume];
}

#pragma AddCarmeraAddressDelegate
-(void)addNewAddress:(NSString *)address
{
    [self.dicData setObject:address forKey:@"address"];
    [self.tableView reloadData];
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
