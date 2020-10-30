//
//  AddCarmeraAddressController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/30.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "AddCarmeraAddressController.h"
#import "CGXPickerView.h"
#import "WWTableView.h"
#import "WWTableViewCell.h"

@interface AddCarmeraAddressCell : WWTableViewCell

@property (nonatomic,strong) UILabel *titleLabel;


@end

@interface AddCarmeraAddressDetailCell : WWTableViewCell<UITextViewDelegate>

@property (nonatomic,strong) void(^textFieldAnnotation)(NSString*text);
@property (nonatomic,strong) UITextView *contentTextView;

@end

@interface AddCarmeraAddressController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *addressDetail;

@end

@implementation AddCarmeraAddressController
-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)setupTableView
{
    self.tableView = [[WWTableView alloc] init];
    self.tableView.backgroundColor = kColorBackgroundColor;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    [self.tableView alignTop:@"10" leading:@"0" bottom:@"58" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AddCarmeraAddressCell class] forCellReuseIdentifier:[AddCarmeraAddressCell getCellIDStr]];
    [self.tableView registerClass:[AddCarmeraAddressDetailCell class] forCellReuseIdentifier:[AddCarmeraAddressDetailCell getCellIDStr]];
    
    
//
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView alignTop:nil leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    [bottomView addHeight:58];
    
    
    UIButton *addBtn = [UIButton new];
    addBtn.clipsToBounds = YES;
    addBtn.layer.cornerRadius = 19;
    [addBtn setTitle:@"确定" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:UIImageWithFileName(@"button_back_image") forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [addBtn addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addBtn];
    [addBtn centerToView:bottomView];
    [addBtn addWidth:kScreenWidth-30];
    [addBtn addHeight:38];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加地址";
    self.view.backgroundColor = kColorBackgroundColor;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    
    
    [self setupTableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        AddCarmeraAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:[AddCarmeraAddressCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLabel.text = self.address;
        
        return cell;
    }else{
        AddCarmeraAddressDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[AddCarmeraAddressDetailCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textFieldAnnotation = ^(NSString *text) {
            self.addressDetail = text;
        };
        
        
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [CGXPickerView showAddressPickerWithTitle:@"选择地区" DefaultSelected:@[@0, @0,@0] IsAutoSelect:YES Manager:nil ResultBlock:^(NSArray *selectAddressArr, NSArray *selectAddressRow) {
            NSLog(@"%@-%@",selectAddressArr,selectAddressRow);
            self.address = [NSString stringWithFormat:@"%@%@%@", selectAddressArr[0], selectAddressArr[1],selectAddressArr[2]];
            [self.tableView reloadData];
        }];
    }
}
-(void)sureButtonClick
{
    self.address = [WWPublicMethod isStringEmptyText:self.address]?self.address:@"";
    self.addressDetail = [WWPublicMethod isStringEmptyText:self.addressDetail]?self.addressDetail:@"";
    NSString *value = [NSString stringWithFormat:@"%@%@",self.address,self.addressDetail];
    [self.delegate addNewAddress:value];
    [self.navigationController popViewControllerAnimated:YES];
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

@implementation AddCarmeraAddressCell

-(void)dosetup
{
    [super dosetup];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"所在地区";
    nameLabel.font = [UIFont customFontWithSize:kFontSizeSixteen];
    nameLabel.textColor = kColorSecondTextColor;
    [self.contentView addSubview:nameLabel];
    [nameLabel topToView:self.contentView withSpace:20];
    [nameLabel bottomToView:self.contentView withSpace:20];
    [nameLabel leftToView:self.contentView withSpace:15];
    
    
    self.titleLabel = [UILabel new];
    self.titleLabel.text = @"这是测试地址";
    self.titleLabel.textColor = kColorMainTextColor;
    self.titleLabel.font = [UIFont customFontWithSize:kFontSizeSixteen];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel yCenterToView:nameLabel];
    [self.titleLabel leftToView:nameLabel withSpace:15];
    
    
    
    
    UILabel *lineLabel = [UILabel new];
    lineLabel.backgroundColor = kColorLineColor;
    [self.contentView addSubview:lineLabel];
    [lineLabel alignTop:nil leading:@"15" bottom:@"0" trailing:@"15" toView:self.contentView];
    [lineLabel addHeight:0.5];
    
    
    
    UIImageView *rightImageView = [UIImageView new];
    rightImageView.image = UIImageWithFileName(@"mine_right_arrows");
    [self.contentView addSubview:rightImageView];
    [rightImageView yCenterToView:self.contentView];
    [rightImageView rightToView:self.contentView withSpace:10];
}

@end

@implementation AddCarmeraAddressDetailCell

-(void)dosetup
{
    [super dosetup];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"详细地址";
    nameLabel.font = [UIFont customFontWithSize:kFontSizeSixteen];
    nameLabel.textColor = kColorSecondTextColor;
    [self.contentView addSubview:nameLabel];
    [nameLabel topToView:self.contentView withSpace:20];
    [nameLabel bottomToView:self.contentView withSpace:45];
    [nameLabel leftToView:self.contentView withSpace:15];

    
    self.contentTextView = [UITextView new];
    self.contentTextView.delegate = self;
    self.contentTextView.text = @"如：道路、门牌号、小区、楼栋号、 单元等";
    self.contentTextView.textColor = kColorThirdTextColor;
    self.contentTextView.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [self.contentView addSubview:self.contentTextView];
    [self.contentTextView leftToView:nameLabel withSpace:15];
    [self.contentTextView topToView:self.contentView withSpace:12];
    [self.contentTextView bottomToView:self.contentView withSpace:10];
    [self.contentTextView addWidth:kScreenWidth-115];
    
}
#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"如：道路、门牌号、小区、楼栋号、 单元等";
        textView.textColor = kColorThirdTextColor;
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"如：道路、门牌号、小区、楼栋号、 单元等"]){
        textView.text = @"";
        textView.textColor = kColorMainTextColor;
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.markedTextRange == nil) {
        NSString *msg_content = [NSString stringWithFormat:@"%@",textView.text];
        if (self.textFieldAnnotation) {
            self.textFieldAnnotation(msg_content);
        }
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""] && range.length > 0) {
        //删除字符肯定是安全的
        return YES;
    }else {
        if (textView.text.length - range.length + text.length > 100) {
            return NO;
        }else {
            return YES;
        }
    }
}


@end
