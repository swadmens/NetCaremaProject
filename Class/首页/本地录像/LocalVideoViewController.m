//
//  LocalVideoViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/29.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "LocalVideoViewController.h"
#import "WWTableView.h"
#import "LocalVideoCell.h"
#import "RequestSence.h"
#import "SuperPlayerViewController.h"
#import "DemandModel.h"
#import "AFHTTPSessionManager.h"
#import "CarmeaVideosModel.h"


@interface LocalVideoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isHadFirst; // 是否第一次加载了
}
@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger page;
/// 没有内容
@property (nonatomic, strong) UIView *noDataView;

@property (nonatomic, strong) NSMutableIndexSet* selectedIndexSet;


@end

@implementation LocalVideoViewController
-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)setupTableView
{
    self.tableView = [[WWTableView alloc] init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    [self.tableView alignTop:@"10" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[LocalVideoCell class] forCellReuseIdentifier:[LocalVideoCell getCellIDStr]];
    self.tableView.refreshEnable = YES;
    self.tableView.loadingMoreEnable = NO;
    __unsafe_unretained typeof(self) weak_self = self;
    self.tableView.actionHandle = ^(WWScrollingState state){
        switch (state) {
            case WWScrollingStateRefreshing:
            {
                [weak_self loadNewData];
            }
                break;
            case WWScrollingStateLoadingMore:
            {
                [weak_self loadMoreData];
            }
                break;
            default:
                break;
        }
    };
}
- (void)setupNoDataView
{
    self.noDataView = [self setupnoDataContentViewWithTitle:@"暂无录像，快去创建吧~" andImageNamed:@"localvideo_empty_backimage" andTop:@"60"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"本地录像";
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
   
    [self setupTableView];
    [self setupNoDataView];
    self.selectedIndexSet = [NSMutableIndexSet new];
    
//    self.page = 1;
//    [self loadNewData];

    //右上角按钮
    UIButton *rightBtn = [UIButton new];
    [rightBtn setImage:UIImageWithFileName(@"share_delete_image") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(right_clicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
}
-(void)right_clicked
{
    //删除本地录像
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LocalVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:[LocalVideoCell getCellIDStr] forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lineHidden = NO;
    
//        IndexDataModel *model = [self.dataArray objectAtIndex:indexPath.row];
//        [cell makeCellData:model];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (_isFromIndex) {
            SuperPlayerViewController *vc = [SuperPlayerViewController new];
            vc.isLiving = NO;
            [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self.delegate selectRowData:@"111"];
        [self.navigationController popViewControllerAnimated:YES];

    }
    
    
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
    [_kHUDManager showActivityInView:nil withTitle:nil];
    
    NSString *start = [NSString stringWithFormat:@"%ld",(self.page - 1)*10];

    NSDictionary *finalParams = @{
                                  @"id":self.device_id,
                                  @"day":@"all",
                                  @"start":start,
                                  @"limit":@"10",
                                  };
        
    //提交数据
    NSString *url = @"http://192.168.6.120:10102/outer/liveqing/record/query_records";
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:finalParams
                                                       options:0
                                                         error:nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"application/vnd.com.nsn.cumulocity.managedobject+json",@"multipart/form-data", nil];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    
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
    __unsafe_unretained typeof(self) weak_self = self;

    NSURLSessionDataTask *task = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        
        if (error) {
            // 请求失败
            DLog(@"error  ==  %@",error.userInfo);
            DLog(@"responseObject  ==  %@",responseObject);
            [self failedOperation];
            
//            self.refreshtoken++;
//            if (self.refreshtoken > 1) {
//                return ;
//            }
//            NSString *unauthorized = [error.userInfo objectForKey:@"NSLocalizedDescription"];
//            int statusCode = [[responseObject objectForKey:@"code"] intValue];
//            if ([unauthorized containsString:@"500"] && statusCode == 401) {
//                [WWPublicMethod refreshToken:^(id obj) {
//                    [self loadNewData];
//                }];
//            }
            return ;
        }
        DLog(@"responseObject  ==  %@",responseObject);
        [weak_self handleObject:responseObject];
    }];
    [task resume];
}
- (void)failedOperation
{
    _isHadFirst = YES;
    [_kHUDManager hideAfter:0.1 onHide:nil];
    [_kHUDManager showMsgInView:nil withTitle:@"请求失败" isSuccess:NO];
    self.tableView.loadingMoreEnable = NO;
    [self.tableView stopLoading];
    [self changeNoDataViewHiddenStatus];
}
- (void)handleObject:(id)obj
{
    _isHadFirst = YES;
    [_kHUDManager hideAfter:0.1 onHide:nil];
    __unsafe_unretained typeof(self) weak_self = self;
    [[GCDQueue globalQueue] queueBlock:^{
        NSDictionary *data = [obj objectForKey:@"data"];
        NSArray *months = [data objectForKey:@"months"];
        
        NSMutableArray *tempArray = [NSMutableArray array];

        [months enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *keys = obj;
            NSDictionary *mothsDic = [data objectForKey:keys];
            NSArray *days = [mothsDic objectForKey:@"days"];
            NSMutableArray *daysMutArray = [NSMutableArray new];
            [days enumerateObjectsUsingBlock:^(id  _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                NSString *dayKeys = obj2;
                NSArray *allData = [mothsDic objectForKey:dayKeys];
                [daysMutArray addObjectsFromArray:allData];
            }];
            
            [tempArray addObjectsFromArray:daysMutArray];
        }];
        
        if (weak_self.page == 1) {
            [weak_self.dataArray removeAllObjects];
        }
        NSMutableArray *modelArray = [NSMutableArray new];
        
        
        [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            
            NSString *originalSnap = [dic objectForKey:@"snap"];
            NSString *start_time = [dic objectForKey:@"start_time"];

            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            NSString *startTime = [mutDic objectForKey:@"start_time"];
            NSString *snap = [NSString stringWithFormat:@"http://192.168.6.120:10102/outer/liveqing/record/getsnap?id=%@&period=%@",self.device_id,startTime];
            if (![WWPublicMethod isStringEmptyText:originalSnap]) {
                [mutDic setValue:snap forKey:@"snap"];
                [self getRecordCoverPhoto:start_time withData:idx];
            }
            CarmeaVideosModel *model = [CarmeaVideosModel makeModelData:mutDic];
            [modelArray addObject:model];
        }];
        [weak_self.dataArray addObjectsFromArray:modelArray];

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
    if (_isHadFirst == NO) {
        return ;
    }
    
    NSInteger count = self.dataArray.count;
    if (count == 0) {
        self.tableView.hidden = YES;
        self.noDataView.hidden = NO;
    } else {
        self.tableView.hidden = NO;
        self.noDataView.hidden = YES;
    }
    
}
//获取录像封面快照
-(void)getRecordCoverPhoto:(NSString*)period withData:(NSInteger)indexInteger
{
    NSString *url = [NSString stringWithFormat:@"http://192.168.6.120:10102/outer/liveqing/record/getsnap?forUrl=true&id=%@&&period=%@",self.device_id,period];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //配置用户名 密码
    NSString *str1 = [NSString stringWithFormat:@"%@/%@:%@",_kUserModel.userInfo.tenant_name,_kUserModel.userInfo.user_name,_kUserModel.userInfo.password];
    //进行加密  [str base64EncodedString]使用开源Base64.h分类文件加密
    NSString *str2 = [NSString stringWithFormat:@"Basic %@",[WWPublicMethod encodeBase64:str1]];
    // 设置Authorization的方法设置header
    [manager.requestSerializer setValue:str2 forHTTPHeaderField:@"Authorization"];

    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];

    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;

        DLog(@"RecordCoverPhoto.Received: %@", responseObject);
        DLog(@"RecordCoverPhoto.Received HTTP %ld", (long)httpResponse.statusCode);

        [self dealWithCoverPhoto:responseObject withData:indexInteger];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"error: %@", error);
    }];
}

-(void)dealWithCoverPhoto:(id)obj withData:(NSInteger)indexInteger
{
    if (obj == nil) {
        return;
    }
    CarmeaVideosModel *model = [self.dataArray objectAtIndex:indexInteger];
    model.snap = [NSString stringWithFormat:@"%@",[obj objectForKey:@"url"]];
    [self.dataArray replaceObjectAtIndex:indexInteger withObject:model];
    [self.tableView reloadData];
}
//删除视频
-(void)deleteVideoClick
{
    [[TCNewAlertView shareInstance] showAlert:nil message:@"确认删除选择的视频吗？" cancelTitle:@"取消" viewController:self confirm:^(NSInteger buttonTag) {
        if (buttonTag == 0 ) {
            [self.selectedIndexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                CarmeaVideosModel *model = [self.dataArray objectAtIndex:idx];
                [self deleteNumbersVideo:model.start_time withInteger:idx];
            }];
        }
    } buttonTitles:@"确定", nil];
}
-(void)deleteNumbersVideo:(NSString*)startime withInteger:(NSInteger)integer
{
    NSDictionary *finalParams = @{
                                      @"id":self.device_id,
                                      @"period": startime,
                                      };
    //提交数据
    NSString *url = @"http://192.168.6.120:10102/outer/liveqing/record/remove";
        
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:finalParams
                                                       options:0
                                                         error:nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"application/vnd.com.nsn.cumulocity.managedobject+json",@"multipart/form-data", nil];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    
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
            [_kHUDManager showMsgInView:nil withTitle:@"删除失败，请重试！" isSuccess:YES];
            
            return ;
        }
        DLog(@"responseObject  ==  %@",responseObject);
//        [self exitTheEditStates];
//        NSIndexPath *path = [NSIndexPath indexPathForItem:integer inSection:0];
//        [self.collectionView deleteItemsAtIndexPaths:@[path]];
        
        [self.dataArray removeObjectAtIndex:integer];
        [self.selectedIndexSet removeIndex:integer];
        [self.tableView reloadData];
        
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
