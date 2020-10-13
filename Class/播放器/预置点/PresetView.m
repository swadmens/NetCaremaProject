//
//  PresetView.m
//  NetCamera
//
//  Created by 汪伟 on 2020/9/23.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "PresetView.h"
#import "WWTableView.h"
#import "WWTableViewCell.h"
#import "MyEquipmentsModel.h"
#import "RequestSence.h"


@interface PresetView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSString *systemSource;//设备类型
@property (nonatomic,strong) NSString *device_id;//设备id

@end

@implementation PresetView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        [self createUI];
    }
    return self;
}
//创建UI
-(void)createUI
{
    self.tableView = [WWTableView new];
    self.tableView.backgroundColor = kColorBackgroundColor;
    self.tableView.rowHeight = 45;
    [self addSubview:self.tableView];
    [self.tableView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    self.dataArray = [NSMutableArray array];
    for (int i=0; i<25; i++) {
        [self.dataArray addObject:@" "];
    }
    
    
}

-(void)makeAllData:(NSArray*)presets withSystemSource:(NSString*)systemSource withDevice_id:(NSString*)device_id
{
//    [self.dataArray removeAllObjects];
//    self.dataArray = [NSMutableArray arrayWithArray:presets];
    
    [presets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PresetsModel *model = obj;
        NSInteger indexs = [model.index integerValue];
        if (indexs < 26) {
            [self.dataArray replaceObjectAtIndex:indexs-1 withObject:model];
        }
    }];
    [self.tableView reloadData];
    
    self.systemSource = [NSString stringWithString:systemSource];
    self.device_id = [NSString stringWithString:device_id];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WWTableViewCell *cell = [[WWTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"persetCell"];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"persetCell" forIndexPath:indexPath];
    }
    cell.lineHidden = NO;
    
    id objs = [self.dataArray objectAtIndex:indexPath.row];
    if ([objs isKindOfClass:[PresetsModel class]]) {
        PresetsModel *model = objs;
        cell.textLabel.text = model.name;
    }else{
        cell.textLabel.text = @" ";
    }
    cell.textLabel.font = [UIFont customFontWithSize:kFontSizeFifty];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self carmeraClickPresetWithIndex:indexPath.row];
}
#pragma mark ---- 侧滑删除
// 点击了“左滑出现的Delete按钮”会调用这个方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deletePresetwithIndex:indexPath];
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

// 修改Delete按钮文字为“删除”
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
      return NO;
}

//删除预置点
-(void)deletePresetwithIndex:(NSIndexPath*)path
{
    PresetsModel *dModel = [self.dataArray objectAtIndex:path.row];
    
    NSString *url = [NSString stringWithFormat:@"service/cameraManagement/camera/operation/deletepreset?index=%@&systemSource=%@&id=%@",dModel.index,self.systemSource,self.device_id];
    
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"DELETE";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
    sence.successBlock = ^(id obj) {
//        [_kHUDManager showMsgInView:nil withTitle:@"" isSuccess:YES];
        DLog(@"Received: %@", obj);
        //删除数据
//        [self.dataArray removeObjectAtIndex:path.row];
        [self.dataArray replaceObjectAtIndex:path.row withObject:@" "];
        // 刷新
//        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
        [[GCDQueue mainQueue] queueBlock:^{
            [self.tableView reloadData];
        }];

    };
    sence.errorBlock = ^(NSError *error) {
        DLog(@"error  ==  %@",error.userInfo);
        [_kHUDManager showMsgInView:nil withTitle:@"失败，请重试！" isSuccess:YES];
    };
    
    [sence sendRequest];
}

//点击预置点控制
-(void)carmeraClickPresetWithIndex:(NSInteger)index
{
    
    id objs = [self.dataArray objectAtIndex:index];
    if (![objs isKindOfClass:[PresetsModel class]]) {
        return;
    }
    
    PresetsModel *dModel = objs;
    
    NSString *url = [NSString stringWithFormat:@"service/cameraManagement/camera/operation/movepreset?index=%@&systemSource=%@&id=%@",dModel.index,self.systemSource,self.device_id];
    
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
    sence.successBlock = ^(id obj) {
//        [_kHUDManager showMsgInView:nil withTitle:@"" isSuccess:YES];
        DLog(@"Received: %@", obj);
    
    };
    sence.errorBlock = ^(NSError *error) {
        DLog(@"error  ==  %@",error.userInfo);
        [_kHUDManager showMsgInView:nil withTitle:@"失败，请重试！" isSuccess:YES];
    };
    
    [sence sendRequest];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
