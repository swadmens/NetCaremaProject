//
//  ChannelMoreSystemController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/30.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "ChannelMoreSystemController.h"
#import "WWTableView.h"
#import "WWTableViewCell.h"
#import <UIImageView+YYWebImage.h>


@interface ChannelMoreSystemImageCell : WWTableViewCell

@property (nonatomic,strong) UIImageView *titleImageView;


@end

@interface ChannelMoreSystemNameCell : WWTableViewCell

@property (nonatomic,strong) UILabel *titleLabel;

@end

@interface ChannelMoreSystemController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) WWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *addressDetail;

@end
@interface ChannelMoreSystemController ()

@end

@implementation ChannelMoreSystemController

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
    [self.tableView registerClass:[ChannelMoreSystemImageCell class] forCellReuseIdentifier:[ChannelMoreSystemImageCell getCellIDStr]];
    [self.tableView registerClass:[ChannelMoreSystemNameCell class] forCellReuseIdentifier:[ChannelMoreSystemNameCell getCellIDStr]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"更多设置";
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
        ChannelMoreSystemImageCell *cell = [tableView dequeueReusableCellWithIdentifier:[ChannelMoreSystemImageCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
        NSDictionary *dic = [WWPublicMethod objectTransFromJson:self.pushId];
        NSString *icon = [dic objectForKey:@"SnapURL"];
        [cell.titleImageView yy_setImageWithURL:[NSURL URLWithString:icon] placeholder:UIImageWithFileName(@"player_hoder_image")];

        return cell;
    }else{
        ChannelMoreSystemNameCell *cell = [tableView dequeueReusableCellWithIdentifier:[ChannelMoreSystemNameCell getCellIDStr] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dic = [WWPublicMethod objectTransFromJson:self.pushId];
        cell.titleLabel.text = [dic objectForKey:@"ChannelName"];
        
        return cell;
    }
    
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
@implementation ChannelMoreSystemImageCell

-(void)dosetup
{
    [super dosetup];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"封面设置";
    nameLabel.font = [UIFont customFontWithSize:kFontSizeSixteen];
    nameLabel.textColor = kColorSecondTextColor;
    [self.contentView addSubview:nameLabel];
    [nameLabel yCenterToView:self.contentView];
    [nameLabel leftToView:self.contentView withSpace:15];
    
    
    _titleImageView = [UIImageView new];
    _titleImageView.image = UIImageWithFileName(@"player_hoder_image");
    [self.contentView addSubview:_titleImageView];
    [_titleImageView topToView:self.contentView withSpace:10];
    [_titleImageView bottomToView:self.contentView withSpace:10];
    [_titleImageView rightToView:self.contentView withSpace:15];
    [_titleImageView addWidth:76];
    [_titleImageView addHeight:46.5];
    
    
    UILabel *lineLabel = [UILabel new];
    lineLabel.backgroundColor = kColorLineColor;
    [self.contentView addSubview:lineLabel];
    [lineLabel alignTop:nil leading:@"15" bottom:@"0" trailing:@"15" toView:self.contentView];
    [lineLabel addHeight:0.5];
    
    
}

@end

@implementation ChannelMoreSystemNameCell

-(void)dosetup
{
    [super dosetup];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"通道名称";
    nameLabel.font = [UIFont customFontWithSize:kFontSizeSixteen];
    nameLabel.textColor = kColorSecondTextColor;
    [self.contentView addSubview:nameLabel];
    [nameLabel topToView:self.contentView withSpace:15];
    [nameLabel bottomToView:self.contentView withSpace:15];
    [nameLabel leftToView:self.contentView withSpace:15];

    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"xxxxxx";
    _titleLabel.textColor = kColorThirdTextColor;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel yCenterToView:self.contentView];
    [_titleLabel rightToView:self.contentView withSpace:15];
    
  
}

@end
