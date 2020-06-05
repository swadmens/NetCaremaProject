//
//  SingleCarmeraCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "SingleCarmeraCell.h"
#import "IndexDataModel.h"
#import <UIImageView+YYWebImage.h>
#import "MyEquipmentsModel.h"
#import "AFHTTPSessionManager.h"
#import "LivingModel.h"
@interface SingleCarmeraCell ()

@property (nonatomic,strong) UILabel *equipmentName;
@property (nonatomic,strong) UILabel *equipmentAddress;
@property (nonatomic,strong) UILabel *equipmentStates;

@property (nonatomic,strong) UIImageView *showImageView;

@property (nonatomic,strong) LivingModel *model;


@end

@implementation SingleCarmeraCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = kColorBackgroundColor;
    
    
    CGFloat backHeight = kScreenWidth*0.6;
    
    
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
//    backView.clipsToBounds = YES;
    backView.layer.cornerRadius = 5;
    backView.layer.shadowColor = UIColorFromRGB(0xB0E5E4, 1).CGColor;
    backView.layer.shadowOffset = CGSizeMake(0,3);
    backView.layer.shadowOpacity = 1;
    backView.layer.shadowRadius = 4;
    backView.layer.cornerRadius = 5;
    [self.contentView addSubview:backView];
    [backView alignTop:@"0" leading:@"15" bottom:@"10" trailing:@"15" toView:self.contentView];
    [backView addHeight:backHeight];
    
    
    
    _equipmentName = [UILabel new];
    _equipmentName.text = @"设备名称123456";
    _equipmentName.textColor = kColorMainTextColor;
    _equipmentName.font = [UIFont customFontWithSize:kFontSizeSixteen];
    [backView addSubview:_equipmentName];
    [_equipmentName leftToView:backView withSpace:12];
    [_equipmentName topToView:backView withSpace:12];
    
    
    _equipmentStates = [UILabel new];
//    _equipmentStates.text = @"在线";
    _equipmentStates.text = @"离线";
    _equipmentStates.textAlignment = NSTextAlignmentCenter;
    _equipmentStates.font = [UIFont customFontWithSize:kFontSizeTen];
    _equipmentStates.textColor = [UIColor whiteColor];
//    _equipmentStates.backgroundColor = UIColorFromRGB(0xF39700, 1);
    _equipmentStates.backgroundColor = UIColorFromRGB(0xAEAEAE, 1);
    _equipmentStates.clipsToBounds = YES;
    _equipmentStates.layer.cornerRadius = 2;
    [backView addSubview:_equipmentStates];
    [_equipmentStates topToView:backView withSpace:8];
    [_equipmentStates leftToView:_equipmentName withSpace:5];
    [_equipmentStates addWidth:30];
    [_equipmentStates addHeight:16];
    
    UIImageView *addressView = [UIImageView new];
    addressView.image = UIImageWithFileName(@"index_address_image");
    [backView addSubview:addressView];
    [addressView leftToView:backView withSpace:12];
    [addressView topToView:_equipmentName withSpace:5];
    
    _equipmentAddress = [UILabel new];
    _equipmentAddress.text = @"广东省广州市天河区信息港A座11层";
    _equipmentAddress.textColor = kColorThirdTextColor;
    _equipmentAddress.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [backView addSubview:_equipmentAddress];
    [_equipmentAddress leftToView:addressView withSpace:2];
    [_equipmentAddress yCenterToView:addressView];
 
    
    
    UIButton *moreBtn = [UIButton new];
    [moreBtn setImage:UIImageWithFileName(@"index_more_image") forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:moreBtn];
    [moreBtn rightToView:backView withSpace:2];
    [moreBtn topToView:backView withSpace:20];
    [moreBtn addWidth:35];
    [moreBtn addHeight:25];
    
    
    
    _showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 70, kScreenWidth-30, backHeight-70)];
    _showImageView.image = UIImageWithFileName(@"player_hoder_image");
    // 绘制圆角 需设置的圆角 使用"|"来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_showImageView.bounds byRoundingCorners:UIRectCornerBottomLeft |
    UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    // 设置大小
    maskLayer.frame = _showImageView.bounds;
    // 设置图形样子
    maskLayer.path = maskPath.CGPath;
    _showImageView.layer.mask = maskLayer;
    [backView addSubview:_showImageView];
    
}
-(void)makeCellData:(IndexDataModel *)model
{
    _equipmentName.text = model.equipment_name;
    _equipmentStates.text = model.equipment_states;
    
    if ([model.equipment_states isEqualToString:@"离线"]) {
        _equipmentStates.backgroundColor = UIColorFromRGB(0xAEAEAE, 1);
    }else{
        _equipmentStates.backgroundColor = UIColorFromRGB(0xF39700, 1);
    }
    if (model.equipment_nums.count > 0) {
        MyEquipmentsModel *models = model.equipment_nums.firstObject;
        NSString *ClientId = [WWPublicMethod isStringEmptyText:models.ClientId]?models.ClientId:@"";
        NSString *DeviceId = [WWPublicMethod isStringEmptyText:models.DeviceId]?models.DeviceId:@"";
        NSString *CameraId = [WWPublicMethod isStringEmptyText:models.CameraId]?models.CameraId:@"";
        
        [self startLoadDataRequest:[NSString stringWithFormat:@"%@%@%@",ClientId,DeviceId,CameraId]];
    }else{
        LivingModel *models = [LivingModel new];
        if (self.getSingleModelBackdata) {
            self.getSingleModelBackdata(models);
        }
    }
}
-(void)moreButtonClick
{
    if (self.moreClick) {
        self.moreClick();
    }
}
- (void)startLoadDataRequest:(NSString*)device_id
{
    NSDictionary *finalParams = @{
                                  @"q":device_id,
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
//            [_kHUDManager showMsgInView:nil withTitle:@"上传失败，请重试！" isSuccess:YES];
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
            LivingModel *models = [LivingModel new];
            if (self.getSingleModelBackdata) {
                self.getSingleModelBackdata(models);
            }
            [[GCDQueue mainQueue] queueBlock:^{
//                weak_self.showImageView.image = [UIImage imageWithColor:kColorThirdTextColor];
//                weak_self.isLiving = NO;
//                weak_self.coverView.hidden = NO;
            }];
            return ;
        }
        [rows enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            if (idx == 0) {
                weak_self.model = [LivingModel makeModelData:dic];
                if (self.getSingleModelBackdata) {
                    self.getSingleModelBackdata(weak_self.model);
                }
                if ([dic.allKeys containsObject:@"session"]) {
                    [weak_self getLivingCoverPhoto:weak_self.model.live_id];
                    [[GCDQueue mainQueue] queueBlock:^{
//                        weak_self.isLiving = YES;
//                        weak_self.coverView.hidden = YES;
                    }];
                }else{
                    [[GCDQueue mainQueue] queueBlock:^{
//                        weak_self.showImageView.image = [UIImage imageWithColor:kColorThirdTextColor];
//                        weak_self.timeLabel.text = weak_self.model.updateAt;
//                        weak_self.isLiving = NO;
//                        weak_self.coverView.hidden = NO;
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
    _equipmentName.text = self.model.name;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
