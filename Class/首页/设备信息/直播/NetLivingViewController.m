//
//  NetLivingViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/2.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "NetLivingViewController.h"
#import "AFHTTPSessionManager.h"
#import "LivingModel.h"
#import <UIImageView+YYWebImage.h>
#import "HKVideoPlaybackController.h"
#import "DemandModel.h"

@interface NetLivingViewController ()

@property (nonatomic,strong) NSMutableDictionary *dicData;

@property (nonatomic,strong) LivingModel *model;

@property (nonatomic,strong) UIImageView *showImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *tagLabel;
@property (nonatomic,assign) BOOL isLiving;//是否直播中
@property (nonatomic,strong) NSString *device_id;

@end

@implementation NetLivingViewController
-(NSMutableDictionary*)dicData
{
    if (!_dicData) {
        _dicData = [NSMutableDictionary new];
    }
    return _dicData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorBackgroundColor;
    
    [self creadUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSDictionary *data = [NSDictionary dictionaryWithDictionary:[WWPublicMethod objectTransFromJson:self.equiment_id]];
    [self.dicData addEntriesFromDictionary:data];
    NSString *ClientId = [self.dicData objectForKey:@"ClientId"];
    NSString *DeviceId = [self.dicData objectForKey:@"DeviceId"];
    NSString *CameraId = [self.dicData objectForKey:@"CameraId"];
               
    ClientId = [WWPublicMethod isStringEmptyText:ClientId]?ClientId:@"";
    DeviceId = [WWPublicMethod isStringEmptyText:DeviceId]?DeviceId:@"";
    CameraId = [WWPublicMethod isStringEmptyText:CameraId]?CameraId:@"";
    self.device_id = [NSString stringWithFormat:@"%@%@%@",ClientId,DeviceId,CameraId];
    
    [self startLoadDataRequest];
}
//创建UI
-(void)creadUI
{
    UILabel *topLeftLabel = [UILabel new];
    topLeftLabel.backgroundColor = kColorMainColor;
    [self.view addSubview:topLeftLabel];
    [topLeftLabel leftToView:self.view withSpace:15];
    [topLeftLabel topToView:self.view withSpace:18];
    [topLeftLabel addWidth:1.5];
    [topLeftLabel addHeight:10.5];
  
  
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"当前直播";
    titleLabel.textColor = kColorSecondTextColor;
    titleLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [titleLabel sizeToFit];
    [self.view addSubview:titleLabel];
    [titleLabel yCenterToView:topLeftLabel];
    [titleLabel leftToView:topLeftLabel withSpace:6];
    
    
    CGFloat width = kScreenWidth/2-21;
    
    _showImageView = [UIImageView new];
    _showImageView.userInteractionEnabled = YES;
    _showImageView.image = [UIImage imageWithColor:[UIColor redColor]];
    [self.view addSubview:_showImageView];
    [_showImageView leftToView:self.view withSpace:16];
    [_showImageView topToView:topLeftLabel withSpace:10];
    [_showImageView addWidth:width];
    [_showImageView addHeight:width*0.6];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goLivingClick:)];
    [_showImageView addGestureRecognizer:tap];
    
    
    
    UIView *backView = [UIView new];
    backView.backgroundColor = UIColorFromRGB(0x000000, 0.52);
    [_showImageView addSubview:backView];
    [backView alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:_showImageView];
    [backView addHeight:15.5];
    
    
    
    _nameLabel = [UILabel new];
    _nameLabel.text = @"直播一";
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont customFontWithSize:9];
    [_nameLabel sizeToFit];
    [backView addSubview:_nameLabel];
    [_nameLabel yCenterToView:backView];
    [_nameLabel leftToView:backView withSpace:5];
    
    
    _tagLabel = [UILabel new];
    _tagLabel.backgroundColor = kColorMainColor;
    _tagLabel.text = @"直播中";
    _tagLabel.textColor = [UIColor whiteColor];
    _tagLabel.font = [UIFont customFontWithSize:9];
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    [_tagLabel sizeToFit];
    [backView addSubview:_tagLabel];
    [_tagLabel yCenterToView:backView];
    [_tagLabel rightToView:backView];
    [_tagLabel addWidth:35.5];
    [_tagLabel addHeight:15.5];
    
    
    self.isLiving = YES;
    
    
}


-(void)goLivingClick:(UITapGestureRecognizer*)tp
{
         
    if (!_isLiving) {
        [_kHUDManager showMsgInView:nil withTitle:@"当前设备已离线" isSuccess:YES];
        return;
    }
    
    if (_model == nil) {
        return;
    }
    //live直播
    NSDictionary *dic = @{ @"name":_model.name,
                            @"snapUrl":_model.url,
                            @"videoUrl":_model.RTMP,
                            @"sharedLink":_model.sharedLink,
                            @"createAt":_model.createAt,
                          };
    DemandModel *models = [DemandModel makeModelData:dic];
    HKVideoPlaybackController *vc = [HKVideoPlaybackController new];
    vc.model = models;
    vc.isLiving = YES;
    vc.isRecordFile = YES;
    vc.device_id = self.device_id;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)startLoadDataRequest
{
    [_kHUDManager showActivityInView:nil withTitle:nil];
    
    NSDictionary *finalParams = @{
                                  @"q":self.device_id,
                                  };
    //提交数据
    NSString *url = @"http://ncore.iot/service/video/liveqing/live/list";
    
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
            [_kHUDManager showMsgInView:nil withTitle:@"上传失败，请重试！" isSuccess:YES];
            return ;
        }
        DLog(@"responseObject  ==  %@",responseObject);
        [weak_self handleObject:responseObject];
    }];
    [task resume];
}

- (void)handleObject:(id)obj
{
    [_kHUDManager hideAfter:0.1 onHide:nil];
    __unsafe_unretained typeof(self) weak_self = self;
    [[GCDQueue globalQueue] queueBlock:^{
        NSDictionary *data = [obj objectForKey:@"data"];
        NSArray *rows= [data objectForKey:@"rows"];
        if (rows.count == 0) {
            [[GCDQueue mainQueue] queueBlock:^{
                weak_self.showImageView.image = [UIImage imageWithColor:kColorThirdTextColor];
                weak_self.nameLabel.text = @" ";
                weak_self.tagLabel.text = @"离线";
                weak_self.isLiving = NO;
            }];
            return ;
        }
        [rows enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            if (idx == 0) {
                weak_self.model = [LivingModel makeModelData:dic];
                if ([dic.allKeys containsObject:@"session"]) {
                    [weak_self getLivingCoverPhoto:weak_self.model.live_id];
                    [[GCDQueue mainQueue] queueBlock:^{
                        weak_self.isLiving = YES;
                    }];
                }else{
                    [[GCDQueue mainQueue] queueBlock:^{
                        weak_self.showImageView.image = [UIImage imageWithColor:kColorThirdTextColor];
                        weak_self.nameLabel.text = weak_self.model.name;
                        weak_self.tagLabel.text = @"离线";
                        weak_self.isLiving = NO;
                    }];
                }
            }
        }];
        
    }];
}
//获取直播快照
-(void)getLivingCoverPhoto:(NSString*)live_id
{
    NSString *url = [NSString stringWithFormat:@"http://ncore.iot/service/video/liveqing/snap/current?id=%@",live_id];
    
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
        
        DLog(@"Received: %@", responseObject);
        DLog(@"Received HTTP %ld", (long)httpResponse.statusCode);
        
        [self dealWithCoverPhoto:responseObject];
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"error: %@", error);
    }];
}

-(void)dealWithCoverPhoto:(id)obj
{
    if (obj == nil) {
        return;
    }
    
    NSDictionary *data = [obj objectForKey:@"data"];
    NSString *snapUrl = [NSString stringWithFormat:@"%@",[data objectForKey:self.model.live_id]];
    
    [_showImageView yy_setImageWithURL:[NSURL URLWithString:snapUrl] placeholder:[UIImage imageWithColor:kColorLineColor]];
    _nameLabel.text = self.model.name;
    _tagLabel.text = @"直播中";
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
