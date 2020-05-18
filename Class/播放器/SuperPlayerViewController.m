//
//  SuperPlayerViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/5/7.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "SuperPlayerViewController.h"
#import "WWTableView.h"
#import "PlayerTableViewCell.h"
#import "PlayerControlCell.h"
#import "PlayerLocalVideosCell.h"
#import "CameraControlView.h"
#import "AFHTTPSessionManager.h"
#import "LGXVerticalButton.h"
#import "PlayBottomDateCell.h"

#define KTopviewheight kScreenWidth*0.68

@interface SuperPlayerViewController ()<UITableViewDelegate,UITableViewDataSource,PlayerControlDelegate,CameraControlDelete>

@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger page;

@property (nonatomic,strong) CameraControlView *clView;
@property (nonatomic,strong) LGXVerticalButton *controlBtn;

@end

@implementation SuperPlayerViewController
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
    [self.tableView setScrollEnabled:NO];
    self.tableView.backgroundColor = kColorBackgroundColor;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    [self.tableView alignTop:@"1" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[PlayerTableViewCell class] forCellReuseIdentifier:[PlayerTableViewCell getCellIDStr]];
    [self.tableView registerClass:[PlayerControlCell class] forCellReuseIdentifier:[PlayerControlCell getCellIDStr]];
    [self.tableView registerClass:[PlayerLocalVideosCell class] forCellReuseIdentifier:[PlayerLocalVideosCell getCellIDStr]];
    [self.tableView registerClass:[PlayBottomDateCell class] forCellReuseIdentifier:[PlayBottomDateCell getCellIDStr]];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"播放器";
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    [self setupTableView];

    
    self.clView = [CameraControlView new];
    self.clView.delegate = self;
    self.clView.isLiveGBS = [self.live_type isEqualToString:@"LiveGBS"];
    [self.view addSubview:self.clView];
    self.clView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight - KTopviewheight - 177);
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        PlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PlayerTableViewCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isLiving = _isLiving;
        
        return cell;
        
    }else if (indexPath.row == 1){
        
        PlayerControlCell *cell = [tableView dequeueReusableCellWithIdentifier:[PlayerControlCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        cell.isLiving = _isLiving;

        return cell;
    }else{
        
        if (_isLiving) {
            PlayerLocalVideosCell *cell = [tableView dequeueReusableCellWithIdentifier:[PlayerLocalVideosCell getCellIDStr] forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }else{
            PlayBottomDateCell *cell = [tableView dequeueReusableCellWithIdentifier:[PlayBottomDateCell getCellIDStr] forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }
        
        
    }
}

#pragma mark - PlayerControlDelegate
-(void)playerControlwithState:(videoSate)state withButton:(UIButton *)sender
{
//    self.clView.transform = CGAffineTransformIdentity;
    
    self.controlBtn = (LGXVerticalButton*)sender;

    
    switch (state) {
        case videoSatePlay://播放暂停
            
            
            break;
        case videoSateVoice://声音控制
          
            self.isLiving = !self.isLiving;
            [self.tableView reloadData];
        
            break;
        case videoSateGongge://宫格变化
    
            
            break;
        case videoSateClarity://清晰度
        
        
            break;
        case videoSateFullScreen://全屏
        
        
            break;
        case videoSatesSreenshots://截图
        
//            btn.selected = NO;
           
        
            break;
        case videoSateVideing://录像
        
//            btn.selected = NO;

        
            break;
        case videoSateYuntai://云台控制
            self.controlBtn.selected = !self.controlBtn.selected;
            
            if (!self.controlBtn.isSelected) {
                self.clView.transform = CGAffineTransformIdentity;
            }else{
               [self clickMoreButton];
            }
            
            
        
        break;
        default:
            break;
    }
}

//云台操作
-(void)clickMoreButton
{
    [UIView animateWithDuration:0.3 animations:^{
        //Y轴向上平移
        self.clView.transform = CGAffineTransformMakeTranslation(0, -kScreenHeight + KTopviewheight + 114);
    }];
    
}
//摄像头控制回调
-(void)cameraControl:(CameraControlView *)CameraControlView withState:(ControlState)state
{
    switch (state) {
        case ControlStateUp:
            //上
            [self cameraControl:@"up"];
            break;
            
        case ControlStateDown:
            //下
            [self cameraControl:@"down"];
            break;
        
        case ControlStateLeft:
            //左
            [self cameraControl:@"left"];
            break;
        
        case ControlStaterRight:
            //右
            [self cameraControl:@"right"];
            break;
            
        case ControlStaterStop:
            //停
            [self cameraControl:@"stop"];
            break;
            
        case ControlStaterLeftUp:
            //左上
            [self cameraControl:@"upleft"];
            break;
            
        case ControlStaterLeftDown:
            //左下
            [self cameraControl:@"downleft"];
            break;
            
        case ControlStaterRightUp:
            //右上
            [self cameraControl:@"upright"];
            break;
            
        case ControlStaterRightDown:
            //右下
            [self cameraControl:@"downright"];
            break;
            
        case ControlStaterZoomin:
            //缩放
            [self cameraControl:@"zoomin"];
            break;
            
        case ControlStaterZoomout:
            //缩放
            [self cameraControl:@"zoomout"];
            break;
            
        case ControlStaterFocusin:
            //聚焦
            [self cameraControl:@"focusin"];
            break;
       
        case ControlStaterFocusout:
            //聚焦
            [self cameraControl:@"focusout"];
            break;
        
        case ControlStaterAperturein:
             //光圈
             [self cameraControl:@"aperturein"];
             break;
        
         case ControlStaterApertureout:
             //光圈
             [self cameraControl:@"apertureout"];
             break;
            
        default:
            break;
    }
}
-(void)cameraColseControl:(CameraControlView *)CameraControlView
{
    [self playerControlwithState:videoSateYuntai withButton:self.controlBtn];
}
-(void)cameraControl:(NSString*)controls
{
    //提交数据
    NSString *url;
    
    if ([self.live_type isEqualToString:@"LiveGBS"]) {
        url = [NSString stringWithFormat:@"http://192.168.6.120:10102/outer/livegbs/api/v1/control/ptz?serial=%@&code=%@&command=%@",self.gbs_serial,self.gbs_code,controls];
    }else{
        url = [NSString stringWithFormat:@"http://192.168.6.120:10102/outer/livenvr/api/v1/ptzcontrol?channel=%@&command=%@",self.nvr_channel,controls];
    }
    
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
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
//        DLog(@"RecordCoverPhoto.Received: %@", responseObject);
//        DLog(@"RecordCoverPhoto.Received HTTP %ld", (long)httpResponse.statusCode);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        DLog(@"error: %@", error);
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
