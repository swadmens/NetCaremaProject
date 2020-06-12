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
#import "CarmeaVideosModel.h"
#import "LGXVerticalButton.h"
#import "DownloadListController.h"
#import "WWTableView.h"
#import "LocalVideoCell.h"
#import "CGXPickerView.h"
#import "RequestSence.h"


@interface LocalVideoViewController ()<UITableViewDelegate,UITableViewDataSource>
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
    self.title = @"本地录像";
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    [self setupTableView];
    [self setupNoDataView];
    
    self.selectedIndexSet = [NSMutableIndexSet new];
    self.date_value = [_kDatePicker getCurrentTimes:@"YYYYMMdd"];
    self.default_date = [_kDatePicker getCurrentTimes:@"YYYY-MM-dd"];
    
    
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
//        self.tableView.transform = CGAffineTransformMakeTranslation(0, -48);
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
//        self.tableView.transform = CGAffineTransformIdentity;
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
- (void)startLoadDataRequest
{
    
    if (![WWPublicMethod isStringEmptyText:self.device_id]) {
        _isHadFirst = YES;
        [self changeNoDataViewHiddenStatus];
        return;
    }
    [_kHUDManager showActivityInView:nil withTitle:nil];
    
    NSDictionary *finalParams = @{
                                  @"id":self.device_id,
                                  @"day":self.date_value,
                                  };
            
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:finalParams
                                                       options:0
                                                         error:nil];
    
    NSString *url = [NSString stringWithFormat:@"api/v1/cloudrecord/querydaily?serial=%@&code=%@&period=%@",self.device_id,self.code,self.date_value];
    
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
//    sence.body = jsonData;
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
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
        
        NSString *monthsKey = [self.date_value substringWithRange:NSMakeRange(0, 6)];
        NSString *dayKey = self.date_value;
        
        NSDictionary *data = [obj objectForKey:@"data"];
        NSDictionary *monthsDic = (NSDictionary*)[data objectForKey:monthsKey];
        NSArray *dayDataArr = [monthsDic objectForKey:dayKey];
        NSMutableArray *tempArray = [NSMutableArray array];
        
        [self.dataArray removeAllObjects];
        
        [dayDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            
//            NSString *originalSnap = [dic objectForKey:@"snap"];
//            NSString *start_time = [dic objectForKey:@"start_time"];
//
//            if (![WWPublicMethod isStringEmptyText:originalSnap]) {
//                [self getRecordCoverPhoto:start_time withData:idx];
//            }
            CarmeaVideosModel *model = [CarmeaVideosModel makeModelData:dic];
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
    NSString *url = [NSString stringWithFormat:@"service/video/liveqing/record/getsnap?forUrl=true&id=%@&&period=%@",self.device_id,period];
    
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
    dvc.downLoad_id = self.device_id;
    dvc.isRecord = YES;
    [self.navigationController pushViewController:dvc animated:YES];
}

//时间选择器
-(void)chooseDateClick
{
    if (self.isEdit) {
        [self exitTheEditStates];
    }
    [CGXPickerView showDatePickerWithTitle:@"选择日期" DateType:UIDatePickerModeDate DefaultSelValue:self.default_date MinDateStr:nil MaxDateStr:[_kDatePicker getCurrentTimes:@"YYYY-MM-dd"] IsAutoSelect:NO Manager:nil ResultBlock:^(NSString *selectValue) {
        DLog(@"选择的日期 ==  %@",selectValue);
        self.default_date = selectValue;
        self.date_value = [selectValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        NSArray *arr = [selectValue componentsSeparatedByString:@"-"];
        NSString *btn_title = [NSString stringWithFormat:@"%@年%@月%@日",arr[0],arr[1],arr[2]];
        
        [self.dateButton setTitle:btn_title forState:UIControlStateNormal];
        
        [self startLoadDataRequest];
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
