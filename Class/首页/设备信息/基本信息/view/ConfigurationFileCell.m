//
//  ConfigurationFileCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/2.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "ConfigurationFileCell.h"

@interface ConfigurationFileCell ()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic,strong) UITextField *equipment_name;
@property (nonatomic,strong) UITextView *annotation_view;

@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) UILabel *statesLabel;
@property (nonatomic,strong) UILabel *equipment_id;
@property (nonatomic,strong) UILabel *equipment_user;
@property (nonatomic,strong) UILabel *timeLabel;

@end

@implementation ConfigurationFileCell

- (void)dosetup {
    [super dosetup];
    // Initialization code
    self.contentView.backgroundColor = kColorBackgroundColor;
    
    UIView *cardView = [UIView new];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.clipsToBounds = YES;
    cardView.layer.cornerRadius = 10;
    [self.contentView addSubview:cardView];
    [cardView alignTop:@"5" leading:@"15" bottom:@"5" trailing:@"15" toView:self.contentView];
    [cardView addHeight:423];
    
    
    UILabel *topLeftLabel = [UILabel new];
    topLeftLabel.backgroundColor = kColorMainColor;
    [cardView addSubview:topLeftLabel];
    [topLeftLabel leftToView:cardView withSpace:15];
    [topLeftLabel topToView:cardView withSpace:15];
    [topLeftLabel addWidth:1.5];
    [topLeftLabel addHeight:12];
    
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"设备配置文件";
    titleLabel.textColor = kColorSecondTextColor;
    titleLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [titleLabel sizeToFit];
    [cardView addSubview:titleLabel];
    [titleLabel yCenterToView:topLeftLabel];
    [titleLabel leftToView:topLeftLabel withSpace:3.5];
    
    UILabel *lineLabel1 = [UILabel new];
    lineLabel1.backgroundColor = kColorLineColor;
    [cardView addSubview:lineLabel1];
    [lineLabel1 leftToView:cardView withSpace:16.5];
    [lineLabel1 topToView:topLeftLabel withSpace:15];
    [lineLabel1 addWidth:kScreenWidth-63];
    [lineLabel1 addHeight:1];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"名称";
    nameLabel.textColor = kColorMainTextColor;
    nameLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [nameLabel sizeToFit];
    [cardView addSubview:nameLabel];
    [nameLabel topToView:lineLabel1 withSpace:13];
    [nameLabel leftToView:topLeftLabel withSpace:3.5];
    
    _equipment_name = [UITextField new];
    _equipment_name.delegate = self;
    _equipment_name.clipsToBounds = YES;
    _equipment_name.layer.cornerRadius = 4;
    _equipment_name.layer.borderColor = kColorLineColor.CGColor;
    _equipment_name.layer.borderWidth = 0.5;
    _equipment_name.textColor = kColorMainTextColor;
    _equipment_name.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [cardView addSubview:_equipment_name];
    [_equipment_name yCenterToView:nameLabel];
    [_equipment_name leftToView:nameLabel withSpace:8];
    [_equipment_name addWidth:kScreenWidth-100];
    [_equipment_name addHeight:25];
    [_equipment_name addTarget:self action:@selector(textfieldChangeValue:) forControlEvents:UIControlEventEditingChanged];
    
    
    UILabel *lineAddLabel = [UILabel new];
    lineAddLabel.backgroundColor = kColorLineColor;
    [cardView addSubview:lineAddLabel];
    [lineAddLabel leftToView:cardView withSpace:16.5];
    [lineAddLabel topToView:lineLabel1 withSpace:45];
    [lineAddLabel addWidth:kScreenWidth-63];
    [lineAddLabel addHeight:1];
    
    
    UILabel *dzLabel1 = [UILabel new];
    dzLabel1.text = @"地址";
    dzLabel1.textColor = kColorMainTextColor;
    dzLabel1.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [dzLabel1 sizeToFit];
    [cardView addSubview:dzLabel1];
    [dzLabel1 topToView:lineAddLabel withSpace:13];
    [dzLabel1 xCenterToView:nameLabel];
    
    UIView *addressView = [UIView new];
    addressView.userInteractionEnabled = YES;
    addressView.clipsToBounds = YES;
    addressView.layer.cornerRadius = 4;
    addressView.layer.borderColor = kColorLineColor.CGColor;
    addressView.layer.borderWidth = 0.5;
    [cardView addSubview:addressView];
    [addressView yCenterToView:dzLabel1];
    [addressView leftToView:dzLabel1 withSpace:8];
    [addressView addWidth:kScreenWidth-100];
    [addressView addHeight:25];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseAddressClick:)];
    [addressView addGestureRecognizer:tap];
    
        
    UIImageView *dwImage = [UIImageView new];
    dwImage.image = UIImageWithFileName(@"carmera_info_address_image");
    [addressView addSubview:dwImage];
    [dwImage yCenterToView:addressView];
    [dwImage leftToView:addressView withSpace:10];
    
    
    _addressLabel = [UILabel new];
    _addressLabel.text = @"广东省广州市天河区信息港A座11层";
    _addressLabel.textColor = kColorMainTextColor;
    _addressLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    [addressView addSubview:_addressLabel];
    [_addressLabel yCenterToView:addressView];
    [_addressLabel leftToView:dwImage withSpace:5];
    

    UILabel *lineLabel2 = [UILabel new];
    lineLabel2.backgroundColor = kColorLineColor;
    [cardView addSubview:lineLabel2];
    [lineLabel2 leftToView:cardView withSpace:16.5];
    [lineLabel2 topToView:lineAddLabel withSpace:45];
    [lineLabel2 addWidth:kScreenWidth-63];
    [lineLabel2 addHeight:1];
    
    
    UILabel *staesLabel1 = [UILabel new];
    staesLabel1.text = @"类型";
    staesLabel1.textColor = kColorMainTextColor;
    staesLabel1.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [staesLabel1 sizeToFit];
    [cardView addSubview:staesLabel1];
    [staesLabel1 topToView:lineLabel2 withSpace:13];
    [staesLabel1 xCenterToView:nameLabel];
    
    _statesLabel = [UILabel new];
    _statesLabel.backgroundColor = UIColorFromRGB(0xeff3f5, 1);
    _statesLabel.clipsToBounds = YES;
    _statesLabel.layer.cornerRadius = 4;
    _statesLabel.layer.borderColor = kColorLineColor.CGColor;
    _statesLabel.layer.borderWidth = 0.5;
    _statesLabel.textColor = kColorMainTextColor;
    [cardView addSubview:_statesLabel];
    [_statesLabel yCenterToView:staesLabel1];
    [_statesLabel leftToView:staesLabel1 withSpace:8];
    [_statesLabel addWidth:kScreenWidth-100];
    [_statesLabel addHeight:25];
    
    
    UILabel *lineLabel3 = [UILabel new];
    lineLabel3.backgroundColor = kColorLineColor;
    [cardView addSubview:lineLabel3];
    [lineLabel3 leftToView:cardView withSpace:16.5];
    [lineLabel3 topToView:lineLabel2 withSpace:45];
    [lineLabel3 addWidth:kScreenWidth-63];
    [lineLabel3 addHeight:1];
    
    
    UILabel *explanLabel = [UILabel new];
    explanLabel.text = @"注释";
    explanLabel.textColor = kColorMainTextColor;
    explanLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [explanLabel sizeToFit];
    [cardView addSubview:explanLabel];
    [explanLabel topToView:lineLabel3 withSpace:13];
    [explanLabel xCenterToView:nameLabel];
    
    _annotation_view = [UITextView new];
    _annotation_view.delegate = self;
    _annotation_view.clipsToBounds = YES;
    _annotation_view.layer.cornerRadius = 5;
    _annotation_view.layer.borderColor = kColorLineColor.CGColor;
    _annotation_view.layer.borderWidth = 0.5;
    _annotation_view.textColor = kColorMainTextColor;
    _annotation_view.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [cardView addSubview:_annotation_view];
    [_annotation_view topToView:lineLabel3 withSpace:10];
    [_annotation_view leftToView:explanLabel withSpace:8];
    [_annotation_view addWidth:kScreenWidth-100];
    [_annotation_view addHeight:117];

    
    UILabel *lineLabel4 = [UILabel new];
    lineLabel4.backgroundColor = kColorLineColor;
    [cardView addSubview:lineLabel4];
    [lineLabel4 leftToView:cardView withSpace:16.5];
    [lineLabel4 topToView:_annotation_view withSpace:10];
    [lineLabel4 addWidth:kScreenWidth-63];
    [lineLabel4 addHeight:1];
    
    
    UILabel *systemLabel = [UILabel new];
    systemLabel.text = @"系统";
    systemLabel.textColor = kColorThirdTextColor;
    systemLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    [systemLabel sizeToFit];
    [cardView addSubview:systemLabel];
    [systemLabel topToView:lineLabel4 withSpace:9];
    [systemLabel xCenterToView:nameLabel];
    
    _equipment_id = [UILabel new];
    _equipment_id.text = @"ID：34893317";
    _equipment_id.textColor = kColorMainTextColor;
    _equipment_id.font = [UIFont customFontWithSize:kFontSizeEleven];
    [_equipment_id sizeToFit];
    [cardView addSubview:_equipment_id];
    [_equipment_id leftToView:cardView withSpace:23.5];
    [_equipment_id topToView:systemLabel withSpace:7];
    
    _equipment_user = [UILabel new];
    _equipment_user.text = @"拥有者： wentest";
    _equipment_user.textColor = kColorMainTextColor;
    _equipment_user.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [_equipment_user sizeToFit];
    [cardView addSubview:_equipment_user];
    [_equipment_user leftToView:cardView withSpace:23.5];
    [_equipment_user topToView:_equipment_id withSpace:7];
    
    _timeLabel = [UILabel new];
    _timeLabel.text = @"最近更新 ：February 25, 2020 1:28 PM";
    _timeLabel.textColor = kColorMainTextColor;
    _timeLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [_timeLabel sizeToFit];
    [cardView addSubview:_timeLabel];
    [_timeLabel leftToView:cardView withSpace:23.5];
    [_timeLabel topToView:_equipment_user withSpace:7];
    
    
}
-(void)makeCellData:(NSDictionary *)dic
{
    if (![WWPublicMethod isStringEmptyText:_equipment_name.text]) {
        _equipment_name.text = [dic objectForKey:@"name"];
    }
    if (![WWPublicMethod isStringEmptyText:_annotation_view.text]) {
        _annotation_view.text = [dic objectForKey:@"c8y_Notes"];
    }
    _equipment_id.text = [NSString stringWithFormat:@"ID：%@",[dic objectForKey:@"id"]];
    _equipment_user.text = [NSString stringWithFormat:@"拥有者：%@",[dic objectForKey:@"owner"]];
    _timeLabel.text = [NSString stringWithFormat:@"最近更新：%@",[dic objectForKey:@"lastUpdated"]];
    _addressLabel.text = [dic objectForKey:@"address"];
    
}
-(void)textfieldChangeValue:(UITextField *)textField
{
    if (self.textFieldName) {
        self.textFieldName(textField.text);
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.textFieldAnnotation) {
        self.textFieldAnnotation(textView.text);
    }
}

//选择地址
-(void)chooseAddressClick:(UITapGestureRecognizer*)tp
{
    
    if (self.addAddressClick) {
        self.addAddressClick();
    }
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
