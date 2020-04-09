//
//  CLInvoiceApplyAddressModelTool.h
//  NetCamera
//
//  Created by 汪伟 on 2020/4/7.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLVoiceApplyAddressModel;

NS_ASSUME_NONNULL_BEGIN

@interface CLInvoiceApplyAddressModelTool : NSObject

+(NSArray *)allAddressInfo;

+(CLVoiceApplyAddressModel *)currentSelectedAddress;

+(void)update;
+(void)updateAddressInfoAfterDeleted;

+(void)setSelectedAddressByNewInfoArray:(NSArray *)infoArray;
+(void)addInfo:(CLVoiceApplyAddressModel *)info;
+(void)removeInfoAtIndex:(NSUInteger)index;
+(void)updateInfoAtIndex:(NSUInteger)index withInfo:(CLVoiceApplyAddressModel *)info;

+(void)removeAllInfo;

@end

NS_ASSUME_NONNULL_END
