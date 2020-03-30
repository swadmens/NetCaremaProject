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

@interface NetLivingViewController ()

@property (nonatomic,strong) NSMutableDictionary *dicData;

@property (nonatomic,strong) LivingModel *model;


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
    
    UIImageView *showImageView = [UIImageView new];
    showImageView.userInteractionEnabled = YES;
    showImageView.image = [UIImage imageWithColor:[UIColor redColor]];
    [self.view addSubview:showImageView];
    [showImageView leftToView:self.view withSpace:16];
    [showImageView topToView:topLeftLabel withSpace:10];
    [showImageView addWidth:width];
    [showImageView addHeight:width*0.6];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goLivingClick:)];
    [showImageView addGestureRecognizer:tap];
    
    
    
    UIView *backView = [UIView new];
    backView.backgroundColor = UIColorFromRGB(0x000000, 0.52);
    [showImageView addSubview:backView];
    [backView alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:showImageView];
    [backView addHeight:15.5];
    
    
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"直播一";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont customFontWithSize:9];
    [nameLabel sizeToFit];
    [backView addSubview:nameLabel];
    [nameLabel yCenterToView:backView];
    [nameLabel leftToView:backView withSpace:5];
    
    
    UILabel *tagLabel = [UILabel new];
    tagLabel.backgroundColor = kColorMainColor;
    tagLabel.text = @"直播中";
    tagLabel.textColor = [UIColor whiteColor];
    tagLabel.font = [UIFont customFontWithSize:9];
    tagLabel.textAlignment = NSTextAlignmentCenter;
    [tagLabel sizeToFit];
    [backView addSubview:tagLabel];
    [tagLabel yCenterToView:backView];
    [tagLabel rightToView:backView];
    [tagLabel addWidth:35.5];
    [tagLabel addHeight:15.5];
    
    
    
    
}


-(void)goLivingClick:(UITapGestureRecognizer*)tp
{
           
    if (_model == nil) {
        return;
    }
//[TargetEngine controller:self pushToController:PushTargetDHLiving WithTargetId:@"1"];//大华直播
//    [TargetEngine controller:self pushToController:PushTargetHKLiving WithTargetId:@"1"];//海康直播
    
    
    //live直播
    NSDictionary *dic = @{@"name":_model.name,
                          @"RTMP":_model.RTMP,
                          @"shared":_model.shared,
                          @"sharedLink":_model.sharedLink,
                          @"url":_model.url,
    };
    NSString *pushId = [WWPublicMethod jsonTransFromObject:dic];
    [TargetEngine controller:self pushToController:PushTargetLiveLiving WithTargetId:pushId];
    
    
    
}
- (void)startLoadDataRequest
{
    [_kHUDManager showActivityInView:nil withTitle:nil];
    
    NSString *ClientId = [self.dicData objectForKey:@"ClientId"];
    NSString *DeviceId = [self.dicData objectForKey:@"DeviceId"];
    NSString *CameraId = [self.dicData objectForKey:@"CameraId"];
    
    ClientId = [WWPublicMethod isStringEmptyText:ClientId]?ClientId:@"";
    DeviceId = [WWPublicMethod isStringEmptyText:DeviceId]?DeviceId:@"";
    CameraId = [WWPublicMethod isStringEmptyText:CameraId]?CameraId:@"";

    NSString *ids = [NSString stringWithFormat:@"%@%@%@",ClientId,DeviceId,CameraId];
    
    NSDictionary *finalParams = @{
                                  @"q":ids,
                                  };
        
    //提交数据
    NSString *url = @"http://192.168.6.120:10102/outer/liveqing/live/list";
    
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
        [rows enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            if (idx == 0) {
                self.model = [LivingModel makeModelData:dic];
            }
        }];
        
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
