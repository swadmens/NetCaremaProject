//
//  LocalVideoViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/29.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "LocalVideoViewController.h"
#import "RequestSence.h"
#import "SuperPlayerViewController.h"
#import "DemandModel.h"
#import "AFHTTPSessionManager.h"
#import "CarmeaVideosModel.h"
#import "LGXVerticalButton.h"
#import "DownloadListController.h"
#import "WWTableView.h"
#import "LocalVideoCell.h"
#import "CGXPickerView.h"


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

@property (nonatomic,assign) BOOL isEdit;//是否是编辑
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UIView *editView;

@property (nonatomic,strong) NSString *date_value;
@property (nonatomic,strong) NSString *default_date;
@property (nonatomic,strong) UIButton *dateButton;

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
    
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:self.view];
    [topView addHeight:35];
    
    _dateButton = [UIButton new];
    [_dateButton setTitle:[_kDatePicker getCurrentTimes:@"YYYY年MM月dd日"] forState:UIControlStateNormal];
    [_dateButton setTitleColor:kColorMainTextColor forState:UIControlStateNormal];
    _dateButton.titleLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [_dateButton addTarget:self action:@selector(chooseDateClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_dateButton];
    [_dateButton xCenterToView:topView];
    [_dateButton yCenterToView:topView];
    [_dateButton addWidth:150];
    [_dateButton addHeight:30];
        
    UIImageView *leftArrow = [UIImageView new];
    leftArrow.image = UIImageWithFileName(@"local_video_left_arrow");
    [topView addSubview:leftArrow];
    [leftArrow yCenterToView:topView];
    [leftArrow rightToView:_dateButton];
    
    
    UIImageView *rightArrow = [UIImageView new];
    rightArrow.image = UIImageWithFileName(@"local_video_right_arrow");
    [topView addSubview:rightArrow];
    [rightArrow yCenterToView:topView];
    [rightArrow leftToView:_dateButton];
    

    
    self.tableView = [[WWTableView alloc] init];
    self.tableView.backgroundColor = kColorBackgroundColor;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    [self.tableView alignTop:@"45" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
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
    self.noDataView = [self setupnoDataContentViewWithTitle:@"该日期无录像！" andImageNamed:@"localvideo_empty_backimage" andTop:@"60"];
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
    self.date_value = [_kDatePicker getCurrentTimes:@"YYYYMMdd"];
    self.default_date = [_kDatePicker getCurrentTimes:@"YYYY-MM-dd"];
    
    self.page = 1;
    [self loadNewData];
    
    
    self.editView = [UIView new];
    [self.editView addTopLineByColor:kColorLineColor];
    self.editView.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.editView];
    self.editView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 48);
    
    LGXVerticalButton *deleteBtn = [LGXVerticalButton new];
    [deleteBtn setImage:UIImageWithFileName(@"video_delete_image") forState:UIControlStateNormal];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:kColorMainTextColor forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEleven];
    [self.editView addSubview:deleteBtn];
    [deleteBtn alignTop:@"0" leading:@"0" bottom:@"0" trailing:nil toView:self.editView];
    [deleteBtn addWidth:kScreenWidth/2];
    [deleteBtn addTarget:self action:@selector(deleteVideoClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    LGXVerticalButton *downBtn = [LGXVerticalButton new];
    [downBtn setBGColor:kColorMainColor forState:UIControlStateNormal];
    [downBtn setImage:UIImageWithFileName(@"demand_download_image") forState:UIControlStateNormal];
    [downBtn setTitle:@"下载" forState:UIControlStateNormal];
    [downBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    downBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEleven];
    [self.editView addSubview:downBtn];
    [downBtn alignTop:@"0" leading:nil bottom:@"0" trailing:@"0" toView:self.editView];
    [downBtn addWidth:kScreenWidth/2];
    [downBtn addTarget:self action:@selector(downVideoClick) forControlEvents:UIControlEventTouchUpInside];
    
    

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
}
-(void)right_clicked
{
    //删除本地录像
    self.rightBtn.selected = !self.rightBtn.selected;
    self.isEdit = self.rightBtn.selected;

    if (!self.isEdit) {
        [self exitTheEditStates];
    }else{
        [self enterTheEditStates];
    }
}
//进入编辑状态
-(void)enterTheEditStates
{
    self.isEdit = YES;
    [_tableView reloadData];
    
    if (self.editView == nil) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.editView.transform = CGAffineTransformMakeTranslation(0, -48);
    }];
    
}
//退出编辑状态
-(void)exitTheEditStates
{
    self.isEdit = NO;
    _rightBtn.selected = NO;
    
    [self.selectedIndexSet removeAllIndexes];
    [_tableView reloadData];

    if (self.editView == nil) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.editView.transform = CGAffineTransformIdentity;
    }];
   
}
-(void)action_goback
{
    if (self.isEdit) {
        [self exitTheEditStates];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocalVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:[LocalVideoCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lineHidden = NO;
          
    CarmeaVideosModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell makeCellData:model];
    
    cell.isEdit = self.isEdit;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarmeaVideosModel *model = [self.dataArray objectAtIndex:indexPath.row];

    LocalVideoCell *cell = (LocalVideoCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (self.isEdit) {
        
        if (cell.selectBtn.selected) {
            [self.selectedIndexSet addIndex:indexPath.item];
        }else{
            [self.selectedIndexSet removeIndex:indexPath.item];
        }

    }else{
        if (_isFromIndex) {
            NSDictionary *dic = @{@"name":model.video_name,
                                   @"snapUrl":model.snap,
                                   @"videoUrl":model.hls,
                                   @"createAt":model.time,
                                  };
            DemandModel *models = [DemandModel makeModelData:dic];
            SuperPlayerViewController *vc = [SuperPlayerViewController new];
            vc.model = models;
            vc.indexInteger = indexPath.row;
            vc.isRecordFile = NO;
            vc.isLiving = NO;
            vc.title_value = model.video_name;
            [self.navigationController pushViewController:vc animated:YES];

        }else{
            [self.delegate selectRowData:indexPath.row];
            [self.navigationController popViewControllerAnimated:YES];
        }
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
    
    if (![WWPublicMethod isStringEmptyText:self.device_id]) {
        return;
    }
    
    NSString *start = [NSString stringWithFormat:@"%ld",(self.page - 1)*10];

    NSDictionary *finalParams = @{
                                  @"id":self.device_id,
                                  @"day":self.date_value,
                                  @"start":start,
                                  @"limit":@"10",
                                  };
        
    //提交数据
    NSString *url = @"https://homebay.quarkioe.com/service/video/liveqing/record/query_records";
    
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
            NSString *snap = [NSString stringWithFormat:@"https://homebay.quarkioe.com/service/video/liveqing/record/getsnap?id=%@&period=%@",self.device_id,startTime];
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
        self.rightBtn.hidden = YES;
    } else {
        self.tableView.hidden = NO;
        self.noDataView.hidden = YES;
        self.rightBtn.hidden = NO;
    }
    
}
//获取录像封面快照
-(void)getRecordCoverPhoto:(NSString*)period withData:(NSInteger)indexInteger
{
    NSString *url = [NSString stringWithFormat:@"https://homebay.quarkioe.com/service/video/liveqing/record/getsnap?forUrl=true&id=%@&&period=%@",self.device_id,period];
    
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
            
            NSMutableIndexSet *tempIndexSet = [[NSMutableIndexSet alloc]initWithIndexSet:self.selectedIndexSet];
            [self exitTheEditStates];
            
            [tempIndexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
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
    NSString *url = @"https://homebay.quarkioe.com/service/video/liveqing/record/remove";
        
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
        
        [self.dataArray removeObjectAtIndex:integer];
        [self.selectedIndexSet removeIndex:integer];
        [self.tableView reloadData];
        
    }];
    [task resume];
}

//下载视频
-(void)downVideoClick
{
    NSMutableIndexSet *tempIndexSet = [[NSMutableIndexSet alloc]initWithIndexSet:self.selectedIndexSet];
    
    [self exitTheEditStates];

    NSMutableArray *tempArray = [NSMutableArray new];
    [tempIndexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        CarmeaVideosModel *model = [self.dataArray objectAtIndex:idx];
        [tempArray addObject:model];
    }];
    
    DownloadListController *dvc = [DownloadListController new];
    dvc.dataArray = tempArray;
    dvc.downLoad_id = self.device_id;
    dvc.isRecord = YES;
    [self.navigationController pushViewController:dvc animated:YES];
}

//时间选择器
-(void)chooseDateClick
{
    [CGXPickerView showDatePickerWithTitle:@"选择日期" DateType:UIDatePickerModeDate DefaultSelValue:self.default_date MinDateStr:nil MaxDateStr:[_kDatePicker getCurrentTimes:@"YYYY-MM-dd"] IsAutoSelect:NO Manager:nil ResultBlock:^(NSString *selectValue) {
        DLog(@"选择的日期 ==  %@",selectValue);
        self.default_date = selectValue;
        self.date_value = [selectValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        NSArray *arr = [selectValue componentsSeparatedByString:@"-"];
        NSString *btn_title = [NSString stringWithFormat:@"%@年%@月%@日",arr[0],arr[1],arr[2]];
        
        [self.dateButton setTitle:btn_title forState:UIControlStateNormal];
        
        [self loadNewData];
    }];
    
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
