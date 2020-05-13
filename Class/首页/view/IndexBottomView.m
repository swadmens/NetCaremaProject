//
//  IndexBottomView.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/27.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "IndexBottomView.h"
#import "WWTableView.h"
#import "WWTableViewCell.h"


@interface IndexBottomTableViewCell : WWTableViewCell

@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *titleLabel;



@end


@interface IndexBottomView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) UIView *backView;
@end

@implementation IndexBottomView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorClearColor;
        
        
        
        [self createUI];
        
    }
    return self;
}
-(void)createUI
{
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 190)];
    _backView.backgroundColor = [UIColor whiteColor];
//    backView.clipsToBounds = YES;
//    backView.layer.cornerRadius = 5;
    // 绘制圆角 需设置的圆角 使用"|"来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_backView.bounds byRoundingCorners:UIRectCornerTopLeft |
    UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    // 设置大小
    maskLayer.frame = _backView.bounds;
    // 设置图形样子
    maskLayer.path = maskPath.CGPath;
    _backView.layer.mask = maskLayer;
    [self addSubview:_backView];

    
    
    self.tableView = [[WWTableView alloc] init];
    self.tableView.backgroundColor = kColorBackgroundColor;
    [_backView addSubview:self.tableView];
    self.tableView.rowHeight = 35;
    [self.tableView alignTop:@"5" leading:@"0" bottom:@"45" trailing:@"0" toView:_backView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[IndexBottomTableViewCell class] forCellReuseIdentifier:[IndexBottomTableViewCell getCellIDStr]];
    
    
    
    UIButton *cancelBtn = [UIButton new];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kColorMainColor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    [cancelBtn addTarget:self action:@selector(hideThisViewClick) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:cancelBtn];
    [cancelBtn alignTop:nil leading:@"0" bottom:@"0" trailing:@"0" toView:_backView];
    [cancelBtn addHeight:45];
    
    
}
-(void)hideThisViewClick
{
//    self.transform = CGAffineTransformIdentity;
    [self.delegate clickCancelBtn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IndexBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[IndexBottomTableViewCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lineHidden = NO;
 
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [dic objectForKey:@"title"];
    cell.iconImageView.image = UIImageWithFileName([dic objectForKey:@"image"]);
  
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate clickCancelBtn];
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    NSString *title = [dic objectForKey:@"image"];
    
    if ([title isEqualToString:@"index_message_image"]) {
        //消息设置
        [TargetEngine controller:nil pushToController:PushTargetMessageNoticesDeal WithTargetId:nil];
    }else if ([title isEqualToString:@"index_all_video_image"]){
        //全部录像
        [TargetEngine controller:nil pushToController:PushTargetLocalVideo WithTargetId:nil];
    }else if ([title isEqualToString:@"index_equiment_shara_image"]){
        //设备共享
        [TargetEngine controller:nil pushToController:PushTargetEquimentShared WithTargetId:nil];
    }else{
        //通道详情
        [TargetEngine controller:nil pushToController:PushTargetChannelDetail WithTargetId:nil];
    }
 
}
-(void)makeViewData:(NSArray*)arr
{
    self.dataArray = [NSArray arrayWithArray:arr];
    
    CGFloat height = self.dataArray.count * 35 + 50;
    
    [_backView lgx_remakeConstraints:^(LGXLayoutMaker *make) {
        make.height.lgx_floatOffset(height);
        make.width.lgx_floatOffset(kScreenWidth);
    }];
    
    
    [self.tableView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation IndexBottomTableViewCell

-(void)dosetup
{
    [super dosetup];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _iconImageView = [UIImageView new];
    _iconImageView.image = [UIImage imageWithColor:kColorMainColor];
    [self.contentView addSubview:_iconImageView];
    [_iconImageView leftToView:self.contentView withSpace:15];
    [_iconImageView yCenterToView:self.contentView];
    [_iconImageView addWidth:22];
    [_iconImageView addHeight:22];
    
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"测试测试";
    _titleLabel.textColor = kColorMainTextColor;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    [_titleLabel sizeToFit];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel yCenterToView:self.contentView];
    [_titleLabel leftToView:_iconImageView withSpace:5];
    
    
    UIImageView *rightImageView = [UIImageView new];
    rightImageView.image = UIImageWithFileName(@"mine_right_arrows");
    [self.contentView addSubview:rightImageView];
    [rightImageView yCenterToView:self.contentView];
    [rightImageView rightToView:self.contentView withSpace:15];
    
    
}

@end

