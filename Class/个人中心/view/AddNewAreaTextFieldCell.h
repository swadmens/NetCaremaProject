//
//  AddNewAreaTextFieldCell.h
//  NetCamera
//
//  Created by 汪伟 on 2020/10/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "WWTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddNewAreaTextFieldCell : WWTableViewCell

@property (nonatomic,copy) void(^textFieldValue)(NSString*text);

-(void)makeCellData:(NSDictionary*)dic withEdit:(BOOL)isEdit;


@end

NS_ASSUME_NONNULL_END
