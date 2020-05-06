//
//  AddNewGroupController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "AddNewGroupController.h"
#import "WWTableView.h"
#import "AddGroupTopViewCell.h"
#import "SelectedCarmeraCell.h"
#import "NoChooseCarmerasCell.h"
#import "RequestSence.h"
#import "LEEAlert.h"

@interface AddNewGroupController ()<UITableViewDelegate,UITableViewDataSource,selectedCarmeraDelegate,NoChooseCarmerasDelegate>

@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSMutableArray *noSelectArray;

@property (nonatomic,strong) UILabel *groupNameLabel;


@end

@implementation AddNewGroupController
-(NSMutableArray*)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}
-(NSMutableArray*)noSelectArray
{
    if (!_noSelectArray) {
        _noSelectArray = [NSMutableArray array];
    }
    return _noSelectArray;
}
- (void)setupTableView
{
 
    self.tableView = [[WWTableView alloc] init];
    self.tableView.backgroundColor = kColorBackgroundColor;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    [self.tableView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AddGroupTopViewCell class] forCellReuseIdentifier:[AddGroupTopViewCell getCellIDStr]];
    [self.tableView registerClass:[SelectedCarmeraCell class] forCellReuseIdentifier:[SelectedCarmeraCell getCellIDStr]];
    [self.tableView registerClass:[NoChooseCarmerasCell class] forCellReuseIdentifier:[NoChooseCarmerasCell getCellIDStr]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加分组";
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    
    
    //模拟数据
    NSArray *arr = @[@{@"title":@"已选测试111111",
                      @"content":@[@"1111111",@"2222222",@"333333"]},
                    @{@"title":@"已选测试2222222",
                    @"content":@[@"12345",@"34567",@"67890"]},
                    ];
    [self.selectedArray addObjectsFromArray:arr];
    
    NSArray *noChooseArr = @[@{@"title":@"未选测试111111",
                              @"content":@[@"1111111",@"2222222",@"333333"]},
                            @{@"title":@"未选测试22222",
                            @"content":@[@"12345",@"34567",@"67890"]},
                            ];
    [self.noSelectArray addObjectsFromArray:noChooseArr];
    
    
    [self setupTableView];
    
    
    //右上角按钮
    UIButton *rightBtn = [UIButton new];
    [rightBtn setImage:UIImageWithFileName(@"group_save_image") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(right_clicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    
}
//保存分组
-(void)right_clicked
{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        AddGroupTopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[AddGroupTopViewCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        return cell;
    }else if (indexPath.row == 1){
        SelectedCarmeraCell *cell = [tableView dequeueReusableCellWithIdentifier:[SelectedCarmeraCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.array = self.selectedArray;
        cell.delegate = self;
        
        
        return cell;
    }else{
        NoChooseCarmerasCell *cell = [tableView dequeueReusableCellWithIdentifier:[NoChooseCarmerasCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.array = self.noSelectArray;
        cell.delegate = self;
        
        
        return cell;
    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        // 使用一个变量接收自定义的输入框对象 以便于在其他位置调用
        
        __block UITextField *tf = nil;
        [LEEAlert alert].config
        .LeeTitle(@"修改设备名称")
        .LeeContent(@"")
        .LeeAddTextField(^(UITextField *textField) {
            
            // 这里可以进行自定义的设置
            
            textField.placeholder = @" ";
            
            if (@available(iOS 13.0, *)) {
                textField.textColor = [UIColor secondaryLabelColor];
                
            } else {
                textField.textColor = [UIColor darkGrayColor];
            }
            
            tf = textField; //赋值
        })
        .LeeAction(@"好的", ^{
          
        })
        .leeShouldActionClickClose(^(NSInteger index){
            // 是否可以关闭回调, 当即将关闭时会被调用 根据返回值决定是否执行关闭处理
            // 这里演示了与输入框非空校验结合的例子
            BOOL result = ![tf.text isEqualToString:@""];
            result = index == 0 ? result : YES;
            return result;
        })
        .LeeCancelAction(@"取消", nil) // 点击事件的Block如果不需要可以传nil
        .LeeShow();
    }

    
}

- (void)startLoadDataRequest
{
    [_kHUDManager showActivityInView:nil withTitle:nil];
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
//    sence.pathURL = [NSString stringWithFormat:@"inventory/managedObjects?pageSize=100&fragmentType=quark_IsCameraManageDevice&currentPage=%ld",(long)self.page];;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {

        [weak_self handleObject:obj];
    };
    sence.errorBlock = ^(NSError *error) {
        
        [weak_self failedOperation];
    };
    [sence sendRequest];
}
- (void)failedOperation
{
    [_kHUDManager hideAfter:0.1 onHide:nil];
    [_kHUDManager showMsgInView:nil withTitle:@"请求失败" isSuccess:NO];
    self.tableView.loadingMoreEnable = NO;
    [self.tableView stopLoading];
}
- (void)handleObject:(id)obj
{
    [_kHUDManager hideAfter:0.1 onHide:nil];
    __unsafe_unretained typeof(self) weak_self = self;
    [[GCDQueue globalQueue] queueBlock:^{
        NSArray *data = [obj objectForKey:@"managedObjects"];
        NSMutableArray *tempArray = [NSMutableArray array];

        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
//            IndexDataModel *model = [IndexDataModel makeModelData:dic];
//            [tempArray addObject:model];
        }];
//        [weak_self.dataArray addObjectsFromArray:tempArray];
        
        
        [[GCDQueue mainQueue] queueBlock:^{
            
            [weak_self.tableView reloadData];
            if (tempArray.count >0) {
                weak_self.tableView.loadingMoreEnable = YES;
            } else {
                weak_self.tableView.loadingMoreEnable = NO;
            }
            [weak_self.tableView stopLoading];
        }];
    }];
}

#pragma mark - selectedCarmeraDelegate
-(void)selectedIndexRow:(NSInteger)indexs withSection:(NSInteger)section
{
    [self dealwithData:indexs withSecion:section withSelected:YES];
}
-(void)selectedIndexSection:(NSInteger)section
{
    [self dealwithDatawithSecion:section withSelected:YES];
}
#pragma mark - NoChooseCarmerasDelegate
-(void)nosSelectIndexRow:(NSInteger)indexs withSection:(NSInteger)section
{
    [self dealwithData:indexs withSecion:section withSelected:NO];
}
-(void)noSelectedIndexSection:(NSInteger)section
{
    [self dealwithDatawithSecion:section withSelected:NO];
}
-(void)dealwithData:(NSInteger)indexs withSecion:(NSInteger)section withSelected:(BOOL)selected
{
    NSMutableDictionary *deleteDic = [NSMutableDictionary dictionary];
    NSMutableArray *deleteArr = [NSMutableArray array];
    [deleteArr addObject:[[selected?self.selectedArray[section]:self.noSelectArray[section] objectForKey:@"content"] objectAtIndex:indexs]];
    [deleteDic setObject:[selected?self.selectedArray[section]:self.noSelectArray[section] objectForKey:@"title"] forKey:@"title"];
    [deleteDic setObject:deleteArr forKey:@"content"];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:selected?self.selectedArray[section]:self.noSelectArray[section]];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[dic objectForKey:@"content"]];
    NSString *value = [array objectAtIndex:indexs];
    [array removeObjectAtIndex:indexs];
    
    if (array.count == 0) {
        [selected?self.selectedArray:self.noSelectArray removeObjectAtIndex:section];
    }else{
        [dic setObject:array forKey:@"content"];
        [selected?self.selectedArray:self.noSelectArray replaceObjectAtIndex:section withObject:dic];
    }
    
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:selected?self.noSelectArray.count:self.selectedArray.count];
    [selected?self.noSelectArray:self.selectedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = obj;
        [titleArray addObject:[dic objectForKey:@"title"]];
    }];
    
    
    if ([titleArray containsObject:[dic objectForKey:@"title"]]) {
        
        NSInteger idx = [titleArray indexOfObject:[dic objectForKey:@"title"]];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[selected?self.noSelectArray:self.selectedArray objectAtIndex:idx]];
        NSMutableArray *mutArr = [NSMutableArray arrayWithArray:[dict objectForKey:@"content"]];
        [mutArr addObject:value];
        [dict setObject:mutArr forKey:@"content"];
        [selected?self.noSelectArray:self.selectedArray replaceObjectAtIndex:idx withObject:dict];
    }else{
        [selected?self.noSelectArray:self.selectedArray addObject:deleteDic];
    }
    
    [self.tableView reloadData];
}
-(void)dealwithDatawithSecion:(NSInteger)section withSelected:(BOOL)selected
{
    NSDictionary *dic = [selected?self.selectedArray:self.noSelectArray objectAtIndex:section];
    NSString *title = [dic objectForKey:@"title"];
    NSArray *array = [dic objectForKey:@"content"];

    
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:selected?self.noSelectArray.count:self.selectedArray.count];
    [selected?self.noSelectArray:self.selectedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = obj;
        [titleArray addObject:[dic objectForKey:@"title"]];
    }];
    
    if ([titleArray containsObject:title]) {
        
        NSInteger idx = [titleArray indexOfObject:[dic objectForKey:@"title"]];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[selected?self.noSelectArray:self.selectedArray objectAtIndex:idx]];
        NSMutableArray *mutArr = [NSMutableArray arrayWithArray:[dict objectForKey:@"content"]];
        [mutArr addObjectsFromArray:array];
        [dict setObject:mutArr forKey:@"content"];
        [selected?self.noSelectArray:self.selectedArray replaceObjectAtIndex:idx withObject:dict];
        
    }else{
        [selected?self.noSelectArray:self.selectedArray addObject:dic];
    }
    
    
    [selected?self.selectedArray:self.noSelectArray removeObjectAtIndex:section];
    
    [self.tableView reloadData];
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
