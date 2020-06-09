//
//  UserInfoModel.m
//  TaoChongYouPin
//
//  Created by icash on 16/8/30.
//  Copyright © 2016年 FusionHK. All rights reserved.
//

#import "UserInfoModel.h"
#import "JPUSHService.h"

@implementation UserInfoModel
@synthesize user_id = _user_id;

-(BOOL)isTest
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"istest"] == nil) {
        _isTest = YES;
    }else{
        _isTest = [[[NSUserDefaults standardUserDefaults] objectForKey:@"istest"] boolValue];
    }
    
    return _isTest;
}
-(BOOL)isClickLoginOut
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isClickLoginOut"] == nil) {
        _isClickLoginOut = NO;
    }else{
        _isClickLoginOut = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isClickLoginOut"] boolValue];
    }
    
    return _isTest;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSDictionary *valueDic = [self getPropertiesValues];
    NSArray *properArray = valueDic.allKeys;
    for (int i=0; i<properArray.count; i++) {
        id key = [properArray objectAtIndex:i];
        id value = [valueDic objectForKey:key];
        
        [aCoder encodeObject:value forKey:key];
    }
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        NSArray *properArray = [self getAllProperties];
        
        for (int i=0; i<properArray.count; i++) {
            id key = [properArray objectAtIndex:i];
            id value = [aDecoder decodeObjectForKey:key];
            SEL setMethod = [self creatSetterWithPropertyName:key];
            BOOL canRun = [self respondsToSelector:setMethod];
            if (canRun) {
                SuppressPerformSelectorLeakWarning(
                                                   ///2.3 把值通过setter方法赋值给实体类的属性
                                                   [self performSelectorOnMainThread:setMethod
                                                                          withObject:value
                                                                       waitUntilDone:[NSThread isMainThread]];
                                                   );
                
            }
        }
        
    }
    return self;
}
- (void)makeUserModelWithData:(NSDictionary *)uInfo
{
    
    self.email = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"email"]];
    self.firstName = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"firstName"]];
    self.lastName = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"lastName"]];
    self.lastPasswordChange = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"lastPasswordChange"]];
    self.user_self = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"self"]];
    self.shouldResetPassword = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"shouldResetPassword"]];
    self.user_id = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"id"]];
    self.user_name = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"userName"]];
    self.user_phone = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"phone"]];
    self.Authorization = [NSString stringWithFormat:@"%@",[uInfo objectForKey:@"Authorization"]];
    self.save_password = [[NSString stringWithFormat:@"%@",[uInfo objectForKey:@"save_password"]] boolValue];

    [self save];
    
//    // 注册推送
//    NSString *jalias = [uInfo objectForKey:@"jalias"];
//    NSString *jtags = [uInfo objectForKey:@"jtags"];
//    [self setTags:jtags andAlias:jalias];
}
// tags 以,号为分割
- (void)setTags:(NSString *)tags andAlias:(NSString *)alias
{
    NSSet *pushtags;
    if ([tags isKindOfClass:[NSString class]] && tags.length >0) {
         pushtags = [NSSet setWithArray:[tags componentsSeparatedByString:@","]];
    }
    
    [JPUSHService setTags:pushtags alias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    DLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
- (void)save
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:data forKey:_kUserInfoModelKey];
    [user synchronize];
 
}

+ (UserInfoModel *)read
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSData *data = [user objectForKey:_kUserInfoModelKey];
    UserInfoModel *uInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    return uInfo;
}

/// 更新我的微标
- (void)updateMineBadge
{
    
}

@end























