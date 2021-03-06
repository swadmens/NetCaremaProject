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
#import "PLPlayModel.h"
#import "CarmeaVideosModel.h"
#import "LGXVerticalButton.h"
#import "DownloadListController.h"
#import "WWTableView.h"
#import "LocalVideoCell.h"
#import "CGXPickerView.h"
#import "RequestSence.h"
#import "WXZPickDateView.h"
#import "AFHTTPSessionManager.h"
#import "MyEquipmentsModel.h"


@interface LocalVideoViewController ()<UITableViewDelegate,UITableViewDataSource,PickerDateViewDelegate>
{
    BOOL _isHadFirst; // 是否第一次加载了
}
@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
//@property(nonatomic,assign) NSInteger page;
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
}
- (void)setupNoDataView
{
    self.noDataView = [self setupnoDataContentViewWithTitle:@"该日期无录像！" andImageNamed:@"localvideo_empty_backimage" andTop:@"60"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [self.recordType isEqualToString:@"local"]?@"本地录像":@"云端录像";
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    [self setupTableView];
    [self setupNoDataView];
    
    self.selectedIndexSet = [NSMutableIndexSet new];
    self.date_value = [_kDatePicker getCurrentTimes:@"YYYYMMdd"];
    
    [self startLoadDataRequest];
    
    self.editView = [UIView new];
    [self.editView addTopLineByColor:kColorLineColor];
    self.editView.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.editView];
    self.editView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 45);
    
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
//    [self.navigationItem setRightBarButtonItem:rightItem];
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
        self.editView.transform = CGAffineTransformMakeTranslation(0, -45);
    }];
    
    [self.tableView lgx_remakeConstraints:^(LGXLayoutMaker *make) {
        make.bottomEdge.lgx_equalTo(self.view.lgx_bottomEdge).lgx_floatOffset(-45);
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
    
   [self.tableView lgx_remakeConstraints:^(LGXLayoutMaker *make) {
       make.bottomEdge.lgx_equalTo(self.view.lgx_bottomEdge);
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
        
        if ([model.system_Source isEqualToString:@"GBS"] && [model.recordType isEqualToString:@"local"]) {
            [self getGBSLocalVideo:model withIndex:indexPath.row];
        }else{
            if (_isFromIndex) {
                
                SuperPlayerViewController *vc = [SuperPlayerViewController new];
//                vc.model = model;
//                vc.allDataArray = [NSArray arrayWithObject:self.model];
//                vc.indexInteger = indexPath.row;
//                vc.isDemandFile = NO;
//                vc.isLiving = NO;
//                vc.isVideoFile = YES;
//                vc.title_value = model.duration;
                [vc makeViewVideoData:self.model withCarmea:model];
                [self.navigationController pushViewController:vc animated:YES];

            }else{
                [self.delegate selectRowData:model];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
        
    }
}
- (void)startLoadDataRequest
{
    
    if (![WWPublicMethod isStringEmptyText:self.model.equipment_id]) {
        _isHadFirst = YES;
        [self changeNoDataViewHiddenStatus];
        return;
    }
    [_kHUDManager showActivityInView:nil withTitle:nil];
    __unsafe_unretained typeof(self) weak_self = self;

    NSString *recordUrl = [NSString stringWithFormat:@"http://management.etoneiot.com/service/cameraManagement/camera/record/list?systemSource=%@&id=%@&date=%@&type=%@",self.model.system_Source,self.model.equipment_id,self.date_value,self.recordType];

//    NSString *recordUrl = [NSString stringWithFormat:@"http://ncore.iot/service/cameraManagement/camera/record/list?systemSource=%@&id=%@&date=%@&type=%@",self.system_Source,self.device_id,self.date_value,self.recordType];
 
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"multipart/form-data",nil];

    // 设置请求头
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    //添加授权
    [manager.requestSerializer setValue:_kUserModel.userInfo.Authorization forHTTPHeaderField:@"Authorization"];

    NSURLSessionDataTask *task = [manager GET:recordUrl parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"responseObject == %@",responseObject);
        [weak_self handleObject:responseObject];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        // 请求失败
        DLog(@"error  ==  %@",error.userInfo);
        [weak_self failedOperation];

    }];
    [task resume];
    return;

    NSString *url = [NSString stringWithFormat:@"service/cameraManagement/camera/record/list?systemSource=%@&id=%@&date=%@",self.model.system_Source,@"524508",_date_value];
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
//    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"Received: %@", obj);
        [weak_self handleObject:obj];
    };
    sence.errorBlock = ^(NSError *error) {

        [_kHUDManager hideAfter:0.1 onHide:nil];
        // 请求失败
        DLog(@"error  ==  %@",error.userInfo);
        [weak_self failedOperation];
    };
    [sence sendRequest];
}
- (void)failedOperation
{
    _isHadFirst = YES;
    [_kHUDManager hideAfter:0.1 onHide:nil];
    [_kHUDManager showMsgInView:nil withTitle:@"请求失败" isSuccess:NO];
    [self changeNoDataViewHiddenStatus];
}
- (void)handleObject:(id)obj
{
    _isHadFirst = YES;
    [_kHUDManager hideAfter:0.1 onHide:nil];
    __unsafe_unretained typeof(self) weak_self = self;
    [[GCDQueue globalQueue] queueBlock:^{
        
        NSArray *list = (NSArray*)obj;
        NSMutableArray *tempArray = [NSMutableArray array];
        
        [self.dataArray removeAllObjects];
        
        [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [mutDic setObject:self.model.equipment_id forKey:@"deviceId"];
            [mutDic setObject:self.model.channel forKey:@"channel"];
            [mutDic setObject:self.model.deviceSerial forKey:@"deviceSerial"];
            [mutDic setObject:self.recordType forKey:@"recordType"];
            [mutDic setObject:self.model.system_Source forKey:@"system_Source"];
            CarmeaVideosModel *model = [CarmeaVideosModel makeModelData:mutDic];
            [tempArray addObject:model];
        }];
        [self.dataArray addObjectsFromArray:tempArray];
        
        [[GCDQueue mainQueue] queueBlock:^{

            [weak_self.tableView reloadData];
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
    NSString *url = [NSString stringWithFormat:@"service/video/liveqing/record/getsnap?forUrl=true&id=%@&&period=%@",self.model.equipment_id,period];
    
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"Received: %@", obj);

         [weak_self dealWithCoverPhoto:obj withData:indexInteger];
    };

    sence.errorBlock = ^(NSError *error) {

        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"error: %@", error);
    };
    [sence sendRequest];
}

-(void)dealWithCoverPhoto:(id)obj withData:(NSInteger)indexInteger
{
    if (obj == nil) {
        return;
    }
    CarmeaVideosModel *model = [self.dataArray objectAtIndex:indexInteger];
    model.picUrl = [NSString stringWithFormat:@"%@",[obj objectForKey:@"url"]];
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
//                [self deleteNumbersVideo:model.start_time withInteger:idx];
            }];
        }
    } buttonTitles:@"确定", nil];
}
-(void)deleteNumbersVideo:(NSString*)startime withInteger:(NSInteger)integer
{
    NSDictionary *finalParams = @{
                                      @"id":self.model.equipment_id,
                                      @"period": startime,
                                      };
        
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:finalParams
                                                       options:0
                                                         error:nil];
    
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"BODY";
    sence.pathHeader = @"application/json";
    sence.body = jsonData;
    sence.pathURL = @"service/video/liveqing/record/remove";
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"Received: %@", obj);
        
        [weak_self.dataArray removeObjectAtIndex:integer];
        [weak_self.selectedIndexSet removeIndex:integer];
        [weak_self.tableView reloadData];
    };
    sence.errorBlock = ^(NSError *error) {

        [_kHUDManager hideAfter:0.1 onHide:nil];
        // 请求失败
        DLog(@"error  ==  %@",error.userInfo);
        [_kHUDManager showMsgInView:nil withTitle:@"删除失败，请重试！" isSuccess:YES];

    };
    [sence sendRequest];
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
    dvc.downLoad_id = self.model.equipment_id;
    dvc.isRecord = YES;
    [self.navigationController pushViewController:dvc animated:YES];
}

//时间选择器
-(void)chooseDateClick
{
    if (self.isEdit) {
        [self exitTheEditStates];
    }
//    [CGXPickerView showDatePickerWithTitle:@"选择日期" DateType:UIDatePickerModeDate DefaultSelValue:self.default_date MinDateStr:nil MaxDateStr:[_kDatePicker getCurrentTimes:@"YYYY-MM-dd"] IsAutoSelect:NO Manager:nil ResultBlock:^(NSString *selectValue) {
//        DLog(@"选择的日期 ==  %@",selectValue);
//        self.default_date = selectValue;
//        self.date_value = [selectValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
//
//        NSArray *arr = [selectValue componentsSeparatedByString:@"-"];
//        NSString *btn_title = [NSString stringWithFormat:@"%@年%@月%@日",arr[0],arr[1],arr[2]];
//
//        [self.dateButton setTitle:btn_title forState:UIControlStateNormal];
//
//        [self startLoadDataRequest];
//    }];
//
    
    NSString *currentTime = [_kDatePicker getCurrentTimes:@"YYYY-MM-dd"];
    
    if ([WWPublicMethod isStringEmptyText:self.default_date]) {
        currentTime = self.default_date;
    }
    
    NSArray *arr = [currentTime componentsSeparatedByString:@"-"];
    WXZPickDateView *pickerDate = [[WXZPickDateView alloc]init];
    
    [pickerDate setIsAddYetSelect:NO];//是否显示至今选项
    [pickerDate setIsShowDay:YES];//是否显示日信息
    [pickerDate setDefaultTSelectYear:[arr[0] integerValue] defaultSelectMonth:[arr[1] integerValue] defaultSelectDay:[arr[2] integerValue]];//设定默认显示的日期
    [pickerDate setDelegate:self];
    [pickerDate show];
    
}
-(void)pickerDateView:(WXZBasePickView *)pickerDateView selectYear:(NSInteger)year selectMonth:(NSInteger)month selectDay:(NSInteger)day{
    NSLog(@"选择的日期是：%ld %ld %ld",year,month,day);
//    NSCalendar *gregorian = [[NSCalendar alloc]
//                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    // 获取当前日期
//    NSDate* dt = [NSDate date];
//    // 指定获取指定年、月、日、时、分、秒的信息
//    unsigned unitFlags = NSCalendarUnitYear |
//    NSCalendarUnitMonth |  NSCalendarUnitDay |
//    NSCalendarUnitHour |  NSCalendarUnitMinute |
//    NSCalendarUnitSecond | NSCalendarUnitWeekday;
//    // 获取不同时间字段的信息
//    NSDateComponents* comp = [gregorian components: unitFlags
//                                          fromDate:dt];
//
//    if (year > comp.year && month > comp.month && day > comp.day) {
//        return;
//    }
    NSString *monthValue;
    if (month < 10) {
        monthValue = [NSString stringWithFormat:@"0%ld",month];
    }else{
        monthValue = [NSString stringWithFormat:@"%ld",month];
    }
    
    NSString *dayValue;
    if (day < 10) {
        dayValue = [NSString stringWithFormat:@"0%ld",day];
    }else{
        dayValue = [NSString stringWithFormat:@"%ld",day];
    }
    
    
    
    NSString *currentTime = [_kDatePicker getCurrentTimes:@"YYYY-MM-dd"];
    NSString *chooseTime = [NSString stringWithFormat:@"%ld-%@-%@",year,monthValue,dayValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [dateFormatter dateFromString:currentTime];
    NSDate *chooseDate = [dateFormatter dateFromString:chooseTime];
    
    if ([chooseDate compare:currentDate] == NSOrderedDescending) {
        [_kHUDManager showMsgInView:nil withTitle:@"时间选择错误！" isSuccess:YES];
        return;
    }
      
    self.date_value = [NSString stringWithFormat:@"%ld%@%@",year,monthValue,dayValue];
    self.default_date = [NSString stringWithFormat:@"%ld-%@-%@",year,monthValue,dayValue];
    NSString *btn_title = [NSString stringWithFormat:@"%ld年%@月%@日",year,monthValue,dayValue];
    [self.dateButton setTitle:btn_title forState:UIControlStateNormal];
    [self startLoadDataRequest];
    
    [self.dateButton setTitle:btn_title forState:UIControlStateNormal];

    
}


//获取GBS本地录像视频播放流
-(void)getGBSLocalVideo:(CarmeaVideosModel*)model withIndex:(NSInteger)indexRow
{
    NSString *url = [NSString stringWithFormat:@"service/cameraManagement/camera/record/playback/start?serial=%@&channel=%@&starttime=%@&endtime=%@",model.deviceSerial,model.channel,model.startTime,model.endTime];
    NSDictionary *finalParams = @{
                                  @"serial": model.deviceSerial, //设备序列号
                                  @"channel": model.channel, // 通道号
                                  @"starttime": model.startTime, //开始时间，格式 YYYY-MM-DDTHH:mm:ss
                                  @"endtime": model.endTime // 结束时间，格式 YYYY-MM-DDTHH:mm:ss
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
        NSDictionary *received = [NSDictionary dictionaryWithDictionary:obj];
        model.picUrl = [NSString stringWithFormat:@"%@",[received objectForKey:@"SnapURL"]];
        model.url = [NSString stringWithFormat:@"%@",[received objectForKey:@"FLV"]];
        model.StreamID = [NSString stringWithFormat:@"%@",[received objectForKey:@"StreamID"]];
        model.duration = [NSString stringWithFormat:@"%@",[received objectForKey:@"PlaybackDuration"]];
        
        [[GCDQueue mainQueue] queueBlock:^{
            
            if (weak_self.isFromIndex) {
                
                SuperPlayerViewController *vc = [SuperPlayerViewController new];
//                vc.model = model;
//                vc.indexInteger = indexRow;
//                vc.isDemandFile = NO;
//                vc.isLiving = NO;
//                vc.isVideoFile = YES;
//                vc.title_value = model.duration;
                [vc makeViewVideoData:self.model withCarmea:model];
                [weak_self.navigationController pushViewController:vc animated:YES];

            }else{
                [weak_self.delegate selectRowData:model];
                [weak_self.navigationController popViewControllerAnimated:YES];
            }
            
        }];
    
    };
    sence.errorBlock = ^(NSError *error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        // 请求失败
        DLog(@"error  ==  %@",error.userInfo);
        
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
