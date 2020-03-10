//
//  DHLivingViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/5.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "DHLivingViewController.h"
#import "LGXThirdEngine.h"
#import "ShareSDKMethod.h"

@interface DHLivingViewController ()

@property (nonatomic, strong) UIView *playView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic, strong) LGXShareParams *shareParams;


@end

@implementation DHLivingViewController

- (UIView *)playView {
    if (!_playView) {
        _playView = [[UIView alloc] init];
        _playView.backgroundColor = [UIColor redColor];
    }
    return _playView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.FDPrefersNavigationBarHidden = YES;
    
    
    
    [self.view addSubview:self.playView];
    self.playView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
       
    
    UIButton *backButton = [UIButton new];
    [backButton setImage:UIImageWithFileName(@"icon_back_gray") forState:UIControlStateNormal];
    [self.playView addSubview:backButton];
    [backButton leftToView:self.playView withSpace:15];
    [backButton topToView:self.playView withSpace:45];
    [backButton addTarget:self action:@selector(goBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _titleLabel = [UILabel new];
    _titleLabel.clipsToBounds = YES;
    _titleLabel.layer.cornerRadius = 15;
    _titleLabel.backgroundColor = UIColorFromRGB(0x000000, 0.6);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"001研发中心";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [self.playView addSubview:_titleLabel];
    [_titleLabel yCenterToView:backButton];
    [_titleLabel xCenterToView:self.playView];
    [_titleLabel addWidth:135];
    [_titleLabel addHeight:30];
    
    
    //右下角分享
    UIButton *sharaButton = [UIButton new];
    sharaButton.clipsToBounds = YES;
    sharaButton.layer.cornerRadius = 16.5;
    [sharaButton setBGColor:UIColorFromRGB(0x000000, 0.4) forState:UIControlStateNormal];
    [sharaButton setImage:UIImageWithFileName(@"living_share_image") forState:UIControlStateNormal];
    [sharaButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.playView addSubview:sharaButton];
    [sharaButton bottomToView:self.playView withSpace:10];
    [sharaButton rightToView:self.playView withSpace:25];
    [sharaButton addWidth:33];
    [sharaButton addHeight:33];
    
    
    
}
//返回
-(void)goBackButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
//分享按钮
-(void)shareButtonClick
{
    //分享里面的内容
        
    self.shareParams = [[LGXShareParams alloc] init];
//        [self.shareParams makeShreParamsByData:self.model.share];
            
    [ShareSDKMethod ShareTextActionWithParams:self.shareParams IsBlack:NO IsReport:NO IsDelete:NO Black:nil Report:nil Delete:nil Result:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        if (state == SSDKResponseStateSuccess) {
            
        }
        
    }];

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
