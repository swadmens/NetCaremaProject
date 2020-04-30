//
//  ConfigurationFileCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/3/2.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfigurationFileCell : WWTableViewCell

@property (nonatomic,strong) void(^textFieldName)(NSString*text);
@property (nonatomic,strong) void(^textFieldAnnotation)(NSString*text);
@property (nonatomic,strong) void(^addAddressClick)(void);


-(void)makeCellData:(NSDictionary*)dic;

@end

NS_ASSUME_NONNULL_END
