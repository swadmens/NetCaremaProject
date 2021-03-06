//
//  ChooseAreaView.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/4.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "ChooseAreaView.h"
#import "WWTableView.h"
#import "AreaNormalCell.h"
#import "AreaSelectCell.h"
#import "LGXVerticalButton.h"
#import "AreaInfoModel.h"

@interface ChooseAreaView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) WWTableView *leftTableView;
@property (nonatomic,strong) NSMutableArray *leftDataArray;

@property (nonatomic,strong) WWTableView *rightTableView;
@property (nonatomic,strong) NSMutableArray *rightDataArray;

@property (nonatomic,strong) NSMutableDictionary *dataDic;


@end

@implementation ChooseAreaView

-(NSMutableArray*)leftDataArray
{
    if (!_leftDataArray) {
        _leftDataArray = [NSMutableArray array];
    }
    return _leftDataArray;
}
-(NSMutableArray*)rightDataArray
{
    if (!_rightDataArray) {
        _rightDataArray = [NSMutableArray array];
    }
    return _rightDataArray;
}
-(NSMutableDictionary*)dataDic
{
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //UI视图
        [self creadAreaUI];
    }
    return self;
}
-(void)creadAreaUI
{
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    [backView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self];
    
    
    self.leftTableView = [[WWTableView alloc] init];
    self.leftTableView.backgroundColor = UIColorFromRGB(0xf0f0f0, 1);
    [self.leftTableView registerClass:[AreaNormalCell class] forCellReuseIdentifier:[AreaNormalCell getCellIDStr]];
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    [backView addSubview:self.leftTableView];
    [self.leftTableView alignTop:@"0" leading:@"0" bottom:@"50" trailing:nil toView:backView];
    [self.leftTableView addWidth:kScreenWidth/3];
    
    
    NSString *leftSpace = [NSString stringWithFormat:@"%f",kScreenWidth/3];
    self.rightTableView = [[WWTableView alloc] init];
    self.rightTableView.backgroundColor = [UIColor whiteColor];
    [self.rightTableView registerClass:[AreaSelectCell class] forCellReuseIdentifier:[AreaSelectCell getCellIDStr]];
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    [backView addSubview:self.rightTableView];
    [self.rightTableView alignTop:@"0" leading:leftSpace bottom:@"50" trailing:@"0" toView:backView];
    
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:bottomView];
    [bottomView alignTop:nil leading:@"0" bottom:@"0" trailing:@"0" toView:backView];
    [bottomView addHeight:50];
    
    LGXVerticalButton*resetBtn = [LGXVerticalButton new];
    [resetBtn setImage:UIImageWithFileName(@"choose_area_reset_iamge") forState:UIControlStateNormal];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn setTitleColor:kColorMainTextColor forState:UIControlStateNormal];
    resetBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeTen];
    [bottomView addSubview:resetBtn];
    [resetBtn yCenterToView:bottomView];
    [resetBtn leftToView:bottomView withSpace:20];
    [resetBtn addWidth:30];
    [resetBtn addHeight:40];
    [resetBtn addTarget:self action:@selector(resetDataClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *sureBtn = [UIButton new];
    sureBtn.clipsToBounds = YES;
    sureBtn.layer.cornerRadius = 3;
    [sureBtn setBGColor:kColorMainColor forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    [bottomView addSubview:sureBtn];
    [sureBtn yCenterToView:bottomView];
    [sureBtn leftToView:bottomView withSpace:85];
    [sureBtn addWidth:kScreenWidth-110];
    [sureBtn addHeight:30];
    [sureBtn addTarget:self action:@selector(sureChooseDataClick) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)makeViewData:(NSArray*)array
{
    [self.leftDataArray removeAllObjects];
    [self.rightDataArray removeAllObjects];
    
    [self.leftDataArray addObjectsFromArray:array];

    if (self.dataDic == nil) {

        AreaInfoModel *model = self.leftDataArray.firstObject;
        [self.rightDataArray addObjectsFromArray:model.shortNames];
        NSString *title = self.rightDataArray.firstObject;
        NSDictionary *dic = @{@"first":model.areaType,@"firstIndex":@(0),@"three":title,@"threeIndex":@(0)};
        [self.dataDic  addEntriesFromDictionary:dic];
        
    }else{
        
        NSInteger indexRow = [[self.dataDic objectForKey:@"firstIndex"] integerValue];
        AreaInfoModel *model = [self.leftDataArray objectAtIndex:indexRow];
        [self.rightDataArray addObjectsFromArray:model.shortNames];
    }
    
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.leftTableView]) {
        return self.leftDataArray.count;
    }else{
        return self.rightDataArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.leftTableView]) {
        
        AreaInfoModel *model = [self.leftDataArray objectAtIndex:indexPath.row];;
        NSInteger indexRow = [[self.dataDic objectForKey:@"firstIndex"] integerValue];
        
        AreaNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:[AreaNormalCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell makeCellData:model];
        
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        
       return cell;
    }else{
        AreaSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:[AreaSelectCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        NSInteger indexRow = [[self.dataDic objectForKey:@"threeIndex"] integerValue];
        NSString *title = [self.rightDataArray objectAtIndex:indexPath.row];
        [cell makeCellData:title];


        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];

        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView isEqual:self.leftTableView]){
        
        AreaInfoModel *model = [self.leftDataArray objectAtIndex:indexPath.row];
        [self.rightDataArray removeAllObjects];
        [self.rightDataArray addObjectsFromArray:model.shortNames];
        [self.rightTableView reloadData];
        
        NSString *title = self.rightDataArray.firstObject;
        [self.dataDic setValue:model.areaType forKey:@"first"];
        [self.dataDic setValue:@(indexPath.row) forKey:@"firstIndex"];
        [self.dataDic setValue:title forKey:@"three"];
        [self.dataDic setValue:@(0) forKey:@"threeIndex"];

        
        [self.rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        
    }else{
        NSString *title = [self.rightDataArray objectAtIndex:indexPath.row];
        [self.dataDic setValue:title forKey:@"three"];
        [self.dataDic setValue:@(indexPath.row) forKey:@"threeIndex"];
    }
}

//重置数据
-(void)resetDataClick
{
    [self.dataDic removeAllObjects];
    [self.rightDataArray removeAllObjects];
    
    AreaInfoModel *model = self.leftDataArray.firstObject;
    [self.rightDataArray addObjectsFromArray:model.shortNames];
    NSString *title = self.rightDataArray.firstObject;
    NSDictionary *dic = @{@"first":model.areaType,@"firstIndex":@(0),@"three":title,@"threeIndex":@(0)};
    [self.dataDic  addEntriesFromDictionary:dic];

    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
    
    
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    
    [self.leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    [self.rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone  animated:YES];

}
//确定选择
-(void)sureChooseDataClick
{
    NSString *value = [WWPublicMethod jsonTransFromObject:self.dataDic];
    self.chooseArea(value);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
