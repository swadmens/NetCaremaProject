//
//  CLInvoiceApplyAddressModelTool.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/7.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "CLInvoiceApplyAddressModelTool.h"
#import "CLVoiceApplyAddressModel.h"
#define AddressInfosPath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"addressInfo1.data"]

@implementation CLInvoiceApplyAddressModelTool

static NSMutableArray *_addressInfos;
+(NSArray *)allAddressInfo{
    _addressInfos = [NSKeyedUnarchiver unarchiveObjectWithFile:AddressInfosPath];
    if (!_addressInfos) _addressInfos = [NSMutableArray array];
    return _addressInfos;
}
+(CLVoiceApplyAddressModel *)currentSelectedAddress{
    
    CLVoiceApplyAddressModel *currentAddress;
    BOOL hasSelectedAddress = NO;
    if ([self allAddressInfo].count) {
        for (CLVoiceApplyAddressModel *info in _addressInfos) {
//            if ([info.state isEqualToString:@"1"]) {
//                currentAddress = info;
//                hasSelectedAddress = YES;
//                break;
//            };
        }

    }else if([self allAddressInfo].count == 0 || hasSelectedAddress)
    {
        currentAddress = nil;
    }
    return currentAddress;
}
+(void)update{
    [NSKeyedArchiver archiveRootObject:_addressInfos toFile:AddressInfosPath];
}
+(void)updateAddressInfoAfterDeleted{
    if (_addressInfos.count) {
        if (![self currentSelectedAddress]) {
            CLVoiceApplyAddressModel *info = [CLInvoiceApplyAddressModelTool allAddressInfo][0];
            [CLInvoiceApplyAddressModelTool updateInfoAtIndex:0 withInfo:info];
        }
    }
}
+(void)setSelectedAddressByNewInfoArray:(NSArray *)infoArray{
    [NSKeyedArchiver archiveRootObject:infoArray toFile:AddressInfosPath];
}
+(void)addInfo:(CLVoiceApplyAddressModel *)info{
    if (!_addressInfos.count) {
        _addressInfos = [NSMutableArray array];
    }
    [_addressInfos insertObject:info atIndex:0];
    [self update];
}
+ (void)removeInfoAtIndex:(NSUInteger)index {

    [_addressInfos removeObjectAtIndex:index];
    [self update];
}
+ (void)removeAllInfo{
    [_addressInfos removeAllObjects];
    [self update];
}
+ (void)updateInfoAtIndex:(NSUInteger)index withInfo:(CLVoiceApplyAddressModel *)info {
    [_addressInfos replaceObjectAtIndex:index withObject:info];
    [self update];
}
@end
