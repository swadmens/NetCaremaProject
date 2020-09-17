//
//  LocalVideoCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/29.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "LocalVideoCell.h"
#import "CarmeaVideosModel.h"
#import <UIImageView+YYWebImage.h>

@interface LocalVideoCell ()

@property (nonatomic,strong) UIImageView *showImageView;
@property (nonatomic,strong) UILabel *titleLabel;//名称
@property (nonatomic,strong) UILabel *timeLabel;//时间

@property (nonatomic,assign) BOOL isCellEdit;

@end

@implementation LocalVideoCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    
//    UIView *backView = [UIView new];
//    backView.backgroundColor = [UIColor whiteColor];
//    [self.contentView addSubview:backView];
//    [backView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.contentView];
//    [backView addHeight:80];
    
    _selectBtn = [UIButton new];
    _selectBtn.hidden = YES;
    [_selectBtn setImage:UIImageWithFileName(@"button_select_image") forState:UIControlStateSelected];
    [_selectBtn setImage:UIImageWithFileName(@"button_unselect_image") forState:UIControlStateNormal];
    [self.contentView addSubview:_selectBtn];
    [_selectBtn yCenterToView:self.contentView];
    [_selectBtn leftToView:self.contentView withSpace:15];
    
    
    _showImageView = [UIImageView new];
    _showImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_showImageView];
//    [_showImageView alignTop:@"10" leading:@"15" bottom:@"10" trailing:nil toView:backView];
    [_showImageView lgx_makeConstraints:^(LGXLayoutMaker *make) {
        make.leftEdge.lgx_equalTo(self.contentView.lgx_leftEdge).lgx_floatOffset(15);
        make.width.lgx_floatOffset(95);
        make.height.lgx_floatOffset(60);
        make.topEdge.lgx_equalTo(self.contentView.lgx_topEdge).lgx_floatOffset(10);
        make.bottomEdge.lgx_equalTo(self.contentView.lgx_bottomEdge).lgx_floatOffset(-10);
    }];
//    [_showImageView addWidth:95];
   
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"这是测试名称这是测试名称这是测试名称这是测试名称这是测试名称";
    _titleLabel.textColor = kColorMainTextColor;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeSixteen];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel leftToView:_showImageView withSpace:10];
    [_titleLabel topToView:self.contentView withSpace:18];
    [_titleLabel addWidth:kScreenWidth-140];

    
    _timeLabel = [UILabel new];
    _timeLabel.text = @"2020-02-26 14:31:42";
    _timeLabel.textColor = kColorThirdTextColor;
    _timeLabel.font = [UIFont customFontWithSize:kFontSizeTen];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel leftToView:_showImageView withSpace:10];
    [_timeLabel topToView:_titleLabel withSpace:5];
    [_timeLabel addWidth:kScreenWidth-195];
    
    
    UIButton *rightBtn = [UIButton new];
    [rightBtn setImage:UIImageWithFileName(@"index_right_image") forState:UIControlStateNormal];
    [self.contentView addSubview:rightBtn];
    [rightBtn rightToView:self.contentView withSpace:8];
    [rightBtn yCenterToView:self.contentView];
    [rightBtn addWidth:15];
    [rightBtn addHeight:25];
    
    
    
}
-(void)makeCellData:(CarmeaVideosModel *)model
{
    _titleLabel.text = model.video_name;
    _timeLabel.text = model.start_time;
    [_showImageView yy_setImageWithURL:[NSURL URLWithString:model.snap] placeholder:UIImageWithFileName(@"player_hoder_image")];
}
-(void)setIsEdit:(BOOL)isEdit
{
    _selectBtn.hidden = !isEdit;
    self.isCellEdit = isEdit;
    
    if (isEdit) {
        [_showImageView lgx_remakeConstraints:^(LGXLayoutMaker *make) {
            make.leftEdge.lgx_equalTo(self.contentView.lgx_leftEdge).lgx_floatOffset(40);
            make.width.lgx_floatOffset(95);
            make.height.lgx_floatOffset(60);
            make.topEdge.lgx_equalTo(self.contentView.lgx_topEdge).lgx_floatOffset(10);
            make.bottomEdge.lgx_equalTo(self.contentView.lgx_bottomEdge).lgx_floatOffset(-10);
        }];
    }else{
        [_showImageView lgx_remakeConstraints:^(LGXLayoutMaker *make) {
            make.leftEdge.lgx_equalTo(self.contentView.lgx_leftEdge).lgx_floatOffset(15);
            make.width.lgx_floatOffset(95);
            make.height.lgx_floatOffset(60);
            make.topEdge.lgx_equalTo(self.contentView.lgx_topEdge).lgx_floatOffset(10);
            make.bottomEdge.lgx_equalTo(self.contentView.lgx_bottomEdge).lgx_floatOffset(-10);
        }];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (!self.isCellEdit) {
        _selectBtn.selected = NO;
        return;
    }
    // 选中 cell ，并且 之前 未选中 cell，选中它！！！
    if (selected && !_selectBtn.selected){
        _selectBtn.selected = YES;
    }
    // 取消选中 cell ，并且 之前 选中 cell
    else if (!selected && _selectBtn.selected){
        // 不处理
    }
    // 选中 cell ，并且 之前 选中 cell，取消选中！！！
    else if (selected && _selectBtn.selected) {
        _selectBtn.selected = NO;
    }
    // Configure the view for the selected state
}

@end
