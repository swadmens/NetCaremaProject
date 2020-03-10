//
//  VideoUpLoadViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/4.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "VideoUpLoadViewController.h"

@interface VideoUpLoadViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic,strong) UITextField *titleTextField;

@property (nonatomic,strong) UITextView *describeTextView;
@property(nonatomic,strong) NSString *msg_content;

@end

@implementation VideoUpLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布视频";
    self.view.backgroundColor = kColorBackgroundColor;
    
    //上传按钮
    UIButton *upLoadBtn = [UIButton new];
    [upLoadBtn setBackgroundImage:UIImageWithFileName(@"demand_upload_image") forState:UIControlStateNormal];
    [upLoadBtn setTitle:@"上传" forState:UIControlStateNormal];
    [upLoadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    upLoadBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [upLoadBtn addTarget:self action:@selector(upLoadButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *righItem = [[UIBarButtonItem alloc]initWithCustomView:upLoadBtn];
    self.navigationItem.rightBarButtonItem = righItem;
    
    
    [self creadVideoUI];
    
}
//创建UI
-(void)creadVideoUI
{
    UIView *titleView = [UIView new];
    titleView.backgroundColor = [UIColor whiteColor];
    titleView.clipsToBounds = YES;
    titleView.layer.cornerRadius = 10;
    [self.view addSubview:titleView];
    [titleView alignTop:@"10" leading:@"15" bottom:nil trailing:@"15" toView:self.view];
    [titleView addHeight:48];
    
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"标题";
    nameLabel.textColor = kColorMainTextColor;
    nameLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [nameLabel sizeToFit];
    [titleView addSubview:nameLabel];
    [nameLabel yCenterToView:titleView];
    [nameLabel leftToView:titleView withSpace:20];
    
    _titleTextField = [UITextField new];
    _titleTextField.delegate = self;
    _titleTextField.font = [UIFont customFontWithSize:kFontSizeTwelve];
    _titleTextField.placeholder = @"请输入标题";
    _titleTextField.textColor = kColorMainTextColor;
    [titleView addSubview:_titleTextField];
    [_titleTextField yCenterToView:titleView];
    [_titleTextField leftToView:nameLabel withSpace:12];
    [_titleTextField addWidth:kScreenWidth-90];
    
    
    UIView *describeView = [UIView new];
    describeView.backgroundColor = [UIColor whiteColor];
    describeView.clipsToBounds = YES;
    describeView.layer.cornerRadius = 10;
    [self.view addSubview:describeView];
    [describeView alignTop:@"68" leading:@"15" bottom:nil trailing:@"15" toView:self.view];
    [describeView addHeight:230];
    
    
    UILabel *desNameLabel = [UILabel new];
    desNameLabel.text = @"描述";
    desNameLabel.textColor = kColorMainTextColor;
    desNameLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [desNameLabel sizeToFit];
    [describeView addSubview:desNameLabel];
    [desNameLabel topToView:describeView withSpace:18];
    [desNameLabel leftToView:describeView withSpace:20];
    
    _describeTextView = [UITextView new];
//    _describeTextView.backgroundColor = [UIColor redColor];
    _describeTextView.delegate = self;
    _describeTextView.font = [UIFont customFontWithSize:kFontSizeTwelve];
    _describeTextView.text = @"请输入描述内容";
    _describeTextView.textColor = kColorThirdTextColor;
    [describeView addSubview:_describeTextView];
    [_describeTextView topToView:describeView withSpace:11];
    [_describeTextView leftToView:desNameLabel withSpace:12];
    [_describeTextView addWidth:kScreenWidth-100];
    [_describeTextView addHeight:100];
    
    
    
    UIButton *addVideoBtn = [UIButton new];
    [addVideoBtn setImage:UIImageWithFileName(@"upload_add_image") forState:UIControlStateNormal];
    addVideoBtn.clipsToBounds = YES;
    addVideoBtn.layer.cornerRadius = 10;
    [addVideoBtn setBGColor:UIColorFromRGB(0xe8e8e8, 1) forState:UIControlStateNormal];
    [describeView addSubview:addVideoBtn];
    [addVideoBtn bottomToView:describeView withSpace:20];
    [addVideoBtn leftToView:describeView withSpace:20];
    [addVideoBtn addWidth:70];
    [addVideoBtn addHeight:70];
    [addVideoBtn addTarget:self action:@selector(addVedioClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
}



//上传视频
-(void)upLoadButtonClick
{
    
}
#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"请输入描述内容";
        textView.textColor = kColorThirdTextColor;
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"请输入描述内容"]){
        textView.text = @"";
        textView.textColor = kColorMainTextColor;
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.markedTextRange == nil) {
        self.msg_content = [NSString stringWithFormat:@"%@",textView.text];
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

//选择本地视频上传
-(void)addVedioClick
{
    
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
