//
//  PlayerTopAddViewCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/5/29.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "PlayerTopAddViewCell.h"

@interface PlayerTopAddViewCell ()

@property (nonatomic,strong) UIImageView *titleImageView;

@end

@implementation PlayerTopAddViewCell
-(void)doSetup
{
    [super doSetup];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIView *backView = [UIView new];
    backView.backgroundColor = UIColorFromRGB(0x47484D, 1);
    [self.contentView addSubview:backView];
    [backView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.contentView];

    
    _titleImageView = [UIImageView new];
    _titleImageView.userInteractionEnabled = YES;
    [backView addSubview:_titleImageView];
    [_titleImageView xCenterToView:backView];
    [_titleImageView yCenterToView:backView];
    
}
-(void)stop{}
-(void)play{}
-(void)makePlayerViewFullScreen:(BOOL)selected{}
-(void)clickSnapshotButton{}
- (void)changeVolume:(float)volume{}

-(void)makeCellData:(NSString *)icon
{
    _titleImageView.image = UIImageWithFileName(icon);
}
@end
