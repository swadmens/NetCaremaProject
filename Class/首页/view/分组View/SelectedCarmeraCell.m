//
//  SelectedCarmeraCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "SelectedCarmeraCell.h"
#import "WWTableView.h"
#import "WWTableViewCell.h"


@interface SelectedCarmeraSubCell : WWTableViewCell

@property (nonatomic,strong) UILabel *titleLabel;


@end


@interface SelectedCarmeraCell ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SelectedCarmeraCell


-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = kColorBackgroundColor;
    
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    backView.clipsToBounds = YES;
    backView.layer.cornerRadius = 5;
    [self.contentView addSubview:backView];
    [backView alignTop:@"0" leading:@"15" bottom:@"10" trailing:@"15" toView:self.contentView];
    [backView addHeight:200];
    
    UILabel *markLabel = [UILabel new];
    markLabel.backgroundColor = kColorMainColor;
    [backView addSubview:markLabel];
    [markLabel topToView:backView withSpace:15];
    [markLabel leftToView:backView withSpace:15];
    [markLabel addWidth:1.5];
    [markLabel addHeight:12];
    
    
    
    UILabel *title = [UILabel new];
    title.text = @"已选设备";
    title.textColor = kColorMainTextColor;
    title.font = [UIFont customBoldFontWithSize:kFontSizeFifty];
    [backView addSubview:title];
    [title yCenterToView:markLabel];
    [title leftToView:markLabel withSpace:5];
    
    UILabel *lineLabel = [UILabel new];
    lineLabel.backgroundColor = kColorLineColor;
    [backView addSubview:lineLabel];
    [lineLabel alignTop:@"45" leading:@"15" bottom:nil trailing:@"15" toView:backView];
    [lineLabel addHeight:0.5];
    
    
    self.tableView = [[WWTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [backView addSubview:self.tableView];
    self.tableView.rowHeight = 35;
    [self.tableView alignTop:@"55" leading:@"0" bottom:@"5" trailing:@"0" toView:backView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[SelectedCarmeraSubCell class] forCellReuseIdentifier:[SelectedCarmeraSubCell getCellIDStr]];
    
}

-(void)setArray:(NSArray *)array
{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:array];
    [self.tableView reloadData];
}

#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [self.dataArray[section] objectForKey:@"content"];
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    SelectedCarmeraSubCell *cell = [tableView dequeueReusableCellWithIdentifier:[SelectedCarmeraSubCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSArray *array = [self.dataArray[indexPath.section] objectForKey:@"content"];
    cell.titleLabel.text = [array objectAtIndex:indexPath.row];
    

    
    return cell;
  
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate selectedIndexRow:indexPath.row withSection:indexPath.section];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *addBtn = [UIButton new];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:kColorMainColor forState:UIControlStateNormal];
    addBtn.tag = section;
    [headerView addSubview:addBtn];
    [addBtn yCenterToView:headerView];
    [addBtn leftToView:headerView withSpace:15];
    [addBtn addTarget:self action:@selector(addEquimentClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = [self.dataArray[section] objectForKey:@"title"];
    titleLabel.textColor = kColorMainTextColor;
    titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [headerView addSubview:titleLabel];
    [titleLabel yCenterToView:headerView];
    [titleLabel leftToView:addBtn withSpace:15];
    
    
    return headerView;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    
    return footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(void)addEquimentClick:(UIButton*)sender
{
    [self.delegate selectedIndexSection:sender.tag];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation SelectedCarmeraSubCell

-(void)dosetup
{
    [super dosetup];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"866262045665618";
    _titleLabel.textColor = kColorMainTextColor;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel yCenterToView:self.contentView];
    [_titleLabel leftToView:self.contentView withSpace:80];
    
}

@end
