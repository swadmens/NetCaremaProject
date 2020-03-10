//
//  NetLivingViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/2.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "NetLivingViewController.h"

@interface NetLivingViewController ()

@end

@implementation NetLivingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorBackgroundColor;
    
    [self creadUI];
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
           
    [TargetEngine controller:self pushToController:PushTargetDHLiving WithTargetId:@"1"];//大华直播
//    [TargetEngine controller:self pushToController:PushTargetHKLiving WithTargetId:@"1"];//海康直播
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
