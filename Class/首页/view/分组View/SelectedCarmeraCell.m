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
@property (nonatomic,strong) NSMutableArray *isExpandArray;//记录section是否展开
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
    
    CGFloat height = (kScreenHeight-145)/2;
    
    
    UIView *backView = [UIView new];
    backView.backgroundColor = UIColorClearColor;
    backView.clipsToBounds = YES;
    backView.layer.cornerRadius = 5;
    [self.contentView addSubview:backView];
    [backView alignTop:@"0" leading:@"15" bottom:@"10" trailing:@"15" toView:self.contentView];
    [backView addHeight:height];
    
    UILabel *markLabel = [UILabel new];
    markLabel.backgroundColor = kColorMainColor;
    [backView addSubview:markLabel];
    [markLabel topToView:backView withSpace:15];
    [markLabel leftToView:backView];
    [markLabel addWidth:1.5];
    [markLabel addHeight:12];
    
    
    
    UILabel *title = [UILabel new];
    title.text = @"已选设备";
    title.textColor = kColorMainTextColor;
    title.font = [UIFont customBoldFontWithSize:kFontSizeFifty];
    [backView addSubview:title];
    [title yCenterToView:markLabel];
    [title leftToView:markLabel withSpace:5];
 
    self.tableView = [[WWTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = kColorBackgroundColor;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [backView addSubview:self.tableView];
    self.tableView.rowHeight = 45;
    [self.tableView alignTop:@"40" leading:@"0" bottom:@"5" trailing:@"0" toView:backView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[SelectedCarmeraSubCell class] forCellReuseIdentifier:[SelectedCarmeraSubCell getCellIDStr]];
    
}

-(void)setArray:(NSArray *)array
{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:array];
    self.isExpandArray = [NSMutableArray array];
    for (NSInteger i = 0; i < array.count; i++) {
        [self.isExpandArray addObject:@"1"];//0:没展开 1:展开
    }
    
    [self.tableView reloadData];
}

#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_isExpandArray[section]isEqualToString:@"1"]) {
        NSArray *array = [self.dataArray[section] objectForKey:@"content"];
        return array.count;
    }else{
        return 0;
    }
    
    
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
//    headerView.layer.cornerRadius = 7.5;
    
    UILabel *botLine = [UILabel new];
    botLine.backgroundColor = kColorLineColor;
    [headerView addSubview:botLine];
    [botLine alignTop:nil leading:@"15" bottom:@"0" trailing:@"15" toView:headerView];
    [botLine addHeight:0.5];
    
    
    
    UIImageView *iconImageView = [UIImageView new];
    iconImageView.image = UIImageWithFileName(@"group_header_image");
    [headerView addSubview:iconImageView];
    [iconImageView yCenterToView:headerView];
    [iconImageView leftToView:headerView withSpace:15];
    

    UILabel *titleLabel = [UILabel new];
    titleLabel.text = [self.dataArray[section] objectForKey:@"title"];
    titleLabel.textColor = kColorMainTextColor;
    titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [headerView addSubview:titleLabel];
    [titleLabel yCenterToView:headerView];
    [titleLabel leftToView:iconImageView withSpace:15];
    
    
    UIButton *dealBtn = [UIButton new];
    [dealBtn setImage:UIImageWithFileName(@"group_down_image") forState:UIControlStateNormal];
    [dealBtn setTitleColor:kColorMainColor forState:UIControlStateNormal];
    dealBtn.tag = section;
    [headerView addSubview:dealBtn];
    [dealBtn yCenterToView:headerView];
    [dealBtn leftToView:titleLabel];
    [dealBtn addWidth:30];
    [dealBtn addHeight:30];
    [dealBtn addTarget:self action:@selector(dealWithButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    if ([_isExpandArray[section] isEqualToString:@"0"]) {
        //未展开
        [dealBtn setImage:UIImageWithFileName(@"group_up_image") forState:UIControlStateNormal];
        botLine.hidden = YES;
    }else{
        //展开
        [dealBtn setImage:UIImageWithFileName(@"group_down_image") forState:UIControlStateNormal];
        botLine.hidden = NO;
    }
    
    
    
    UIButton *addBtn = [UIButton new];
    [addBtn setImage:UIImageWithFileName(@"group_remove_image") forState:UIControlStateNormal];
    [addBtn setTitleColor:kColorMainColor forState:UIControlStateNormal];
    addBtn.tag = section;
    [headerView addSubview:addBtn];
    [addBtn yCenterToView:headerView];
    [addBtn rightToView:headerView withSpace:15];
    [addBtn addTarget:self action:@selector(addEquimentClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return headerView;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = kColorBackgroundColor;
    
    return footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(void)addEquimentClick:(UIButton*)sender
{
    [self.delegate selectedIndexSection:sender.tag];
}
-(void)dealWithButtonClick:(UIButton*)sender
{
    if ([_isExpandArray[sender.tag] isEqualToString:@"0"]) {
        //关闭 => 展开
        [_isExpandArray replaceObjectAtIndex:sender.tag withObject:@"1"];
    }else{
        //展开 => 关闭
        [_isExpandArray replaceObjectAtIndex:sender.tag withObject:@"0"];
    }
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:sender.tag];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
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
    
    
    UIImageView *iconImageView = [UIImageView new];
    iconImageView.image = UIImageWithFileName(@"group_row_image");
    [self.contentView addSubview:iconImageView];
    [iconImageView yCenterToView:self.contentView];
    [iconImageView leftToView:self.contentView withSpace:40];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"866262045665618";
    _titleLabel.textColor = kColorMainTextColor;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel yCenterToView:self.contentView];
    [_titleLabel leftToView:iconImageView withSpace:5];
    
}

@end
