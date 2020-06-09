//
//  UserInfoModel.h
//  TaoChongYouPin
//
//  Created by icash on 16/8/30.
//  Copyright © 2016年 FusionHK. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const _kUserInfoModelKey = @"netcamera.user_info";

@interface UserInfoModel : NSObject <NSCoding>

@property (nonatomic,assign) BOOL isTest;//是否是测试

@property (nonatomic,assign) BOOL isClickLoginOut;//是否点击了退出登录

@property (nonatomic,strong) NSString *user_permissions;//用户权限

@property (nonatomic, strong) NSString *email;//邮箱
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *lastPasswordChange;
@property (nonatomic, strong) NSString *user_self;
@property (nonatomic, strong) NSString *shouldResetPassword;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *user_phone;
@property (nonatomic, strong) NSString *Authorization;
@property (nonatomic, assign) BOOL save_password;

/// 更新我的微标
- (void)updateMineBadge;

- (void)makeUserModelWithData:(NSDictionary *)uInfo;
/// 保存,数据会在初始化时自动读取
- (void)save;
+ (UserInfoModel *)read;
// tags 以,号为分割
- (void)setTags:(NSString *)tags andAlias:(NSString *)alias;

@end
