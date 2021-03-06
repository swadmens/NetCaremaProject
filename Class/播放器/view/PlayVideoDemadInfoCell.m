//
//  PlayVideoDemadInfoCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/10/22.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "PlayVideoDemadInfoCell.h"
#import "DemandModel.h"
#import "RequestSence.h"
#import "SuperPlayerViewController.h"
#import "DownloadListController.h"


@interface PlayVideoDemadInfoCell ()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *describeLabel;
@property (nonatomic,strong) UILabel *createTimeLabel;

@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) DemandModel *model;


@end

@implementation PlayVideoDemadInfoCell

-(void)dosetup
{
    [super dosetup];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"测试视频";
    _titleLabel.textColor = kColorMainTextColor;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeFifty];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel topToView:self.contentView withSpace:10];
    [_titleLabel leftToView:self.contentView withSpace:10];
    
    
    _describeLabel = [UILabel new];
    _describeLabel.text = @"视频描述";
    _describeLabel.textColor = kColorSecondTextColor;
    _describeLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    _describeLabel.numberOfLines = 2;
    [self.contentView addSubview:_describeLabel];
    [_describeLabel topToView:self.contentView withSpace:35];
    [_describeLabel bottomToView:self.contentView withSpace:35];
    [_describeLabel leftToView:self.contentView withSpace:10];
    [_describeLabel addWidth:kScreenWidth - 20];
    
    _createTimeLabel = [UILabel new];
    _createTimeLabel.text = @"2020-09-30T17:29:35.118+08:00";
    _createTimeLabel.textColor = kColorSecondTextColor;
    _createTimeLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [self.contentView addSubview:_createTimeLabel];
    [_createTimeLabel leftToView:self.contentView withSpace:8];
    [_createTimeLabel bottomToView:self.contentView withSpace:5];
    
    
    self.deleteBtn = [UIButton new];
    [self.deleteBtn setImage:UIImageWithFileName(@"video_delete_image") forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteVideoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.deleteBtn];
    [self.deleteBtn bottomToView:self.contentView];
    [self.deleteBtn rightToView:self.contentView withSpace:1];
    [self.deleteBtn addWidth:40];
    [self.deleteBtn addHeight:40];
    
    
    UIButton *downloadBtn = [UIButton new];
    [downloadBtn setImage:UIImageWithFileName(@"demand_download_black_image") forState:UIControlStateNormal];
    [downloadBtn addTarget:self action:@selector(downloadVideoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:downloadBtn];
    [downloadBtn bottomToView:self.contentView];
    [downloadBtn rightToView:self.deleteBtn withSpace:1];
    [downloadBtn addWidth:40];
    [downloadBtn addHeight:40];
    
    
}
-(void)makeCellData:(DemandModel*)model
{
    self.model = model;
    _titleLabel.text = model.name;
    NSArray *time1 = [model.creationTime componentsSeparatedByString:@"."];
    _createTimeLabel.text = [time1[0] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    _describeLabel.text = [WWPublicMethod isStringEmptyText:model.describe]?model.describe:@"";
}
-(void)deleteVideoBtnClick
{
    //删除点播文件
    [[TCNewAlertView shareInstance] showAlert:nil message:@"确认删除该视频吗？" cancelTitle:@"取消" viewController:nil confirm:^(NSInteger buttonTag) {
        
        if (buttonTag == 0) {
//            [self queryDeleteVideo];
            if (self.deleteVideoBtn) {
                self.deleteVideoBtn();
            }
        }
    } buttonTitles:@"确定", nil];
}
-(void)downloadVideoBtnClick
{
    DownloadListController *dvc = [DownloadListController new];
    dvc.dataArray = [NSArray arrayWithObject:self.model];
    dvc.isRecord = NO;
    [[SuperPlayerViewController viewController:self].navigationController pushViewController:dvc animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
