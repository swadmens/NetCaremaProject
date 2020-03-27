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


@interface EquimentBasicInfoController ()<UITableViewDelegate,UITableViewDataSource>

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
    [self.tableView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ConfigurationFileCell class] forCellReuseIdentifier:[ConfigurationFileCell getCellIDStr]];
    [self.tableView registerClass:[ConnectionMonitoringCell class] forCellReuseIdentifier:[ConnectionMonitoringCell getCellIDStr]];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTableView];
    self.isSave = NO;
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadInfoNotica:) name:@"saveInfomation" object:nil];
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
//上传数据
- (void)uploadInfoNotica:(NSNotification *)notification
{
    [self upLoadInfo];
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
       return cell;
    }else{
        
        ConnectionMonitoringCell *cell = [tableView dequeueReusableCellWithIdentifier:[ConnectionMonitoringCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell makeCellData:self.dicData];
       return cell;
    }
    
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
    NSString *url = [NSString stringWithFormat:@"http://ncore.iot/inventory/managedObjects/%@",[self.dicData objectForKey:@"id"]];
    
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
        self.isSave = YES;
        
    }];
    [task resume];
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
