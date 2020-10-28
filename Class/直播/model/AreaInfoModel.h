//
//  AreaInfoModel.h
//  NetCamera
//
//  Created by 汪伟 on 2020/10/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AreaInfoModel : NSObject

+(AreaInfoModel*)makeModelData:(NSDictionary*)dic;

@property (nonatomic,strong) NSString *areaType;

@property (nonatomic,strong) NSArray *shortNames;


@end

NS_ASSUME_NONNULL_END
