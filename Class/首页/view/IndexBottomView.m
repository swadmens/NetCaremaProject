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
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 190)];
    backView.backgroundColor = [UIColor whiteColor];
//    backView.clipsToBounds = YES;
//    backView.layer.cornerRadius = 5;
    // 绘制圆角 需设置的圆角 使用"|"来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerTopLeft |
    UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    // 设置大小
    maskLayer.frame = backView.bounds;
    // 设置图形样子
    maskLayer.path = maskPath.CGPath;
    backView.layer.mask = maskLayer;
    [self addSubview:backView];

    
    
    self.tableView = [[WWTableView alloc] init];
    self.tableView.backgroundColor = kColorBackgroundColor;
    [backView addSubview:self.tableView];
    self.tableView.rowHeight = 35;
    [self.tableView alignTop:@"5" leading:@"0" bottom:@"45" trailing:@"0" toView:backView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[IndexBottomTableViewCell class] forCellReuseIdentifier:[IndexBottomTableViewCell getCellIDStr]];
    
    
    
    UIButton *cancelBtn = [UIButton new];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kColorMainColor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    [cancelBtn addTarget:self action:@selector(hideThisViewClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:cancelBtn];
    [cancelBtn alignTop:nil leading:@"0" bottom:@"0" trailing:@"0" toView:backView];
    [cancelBtn addHeight:45];
    
    
}
-(void)hideThisViewClick
{
//    self.transform = CGAffineTransformIdentity;
    [self.delegate clickCancelBtn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IndexBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[IndexBottomTableViewCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lineHidden = NO;
    
    NSArray *Arr = @[@"消息设置",@"全部录像",@"设备共享",@"设备详情"];
    cell.titleLabel.text = [Arr objectAtIndex:indexPath.row];
  
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

