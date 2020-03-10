//
//  LiveViewCollectionViewCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/4.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "LiveViewCollectionViewCell.h"

@implementation LiveViewCollectionViewCell

-(void)doSetup
{
    [super doSetup];
    self.contentView.backgroundColor = UIColorClearColor;
    
    
    CGFloat width = kScreenWidth/2 - 20;
    
    UIImageView *showImageView = [UIImageView new];
   showImageView.image = [UIImage imageWithColor:[UIColor redColor]];
   [self.contentView addSubview:showImageView];
   [showImageView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.contentView];
   [showImageView addWidth:width];
   [showImageView addHeight:width*0.6];
   
   
   
   UIView *backView = [UIView new];
   backView.backgroundColor = UIColorFromRGB(0x000000, 0.52);
   [showImageView addSubview:backView];
   [backView alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:showImageView];
   [backView addHeight:15.5];
   
   
   
   UILabel *nameLabel = [UILabel new];
   nameLabel.text = @"001研发中心";
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


@end
