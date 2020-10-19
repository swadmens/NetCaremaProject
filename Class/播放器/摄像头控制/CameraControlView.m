//
//  CameraControlView.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/20.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "CameraControlView.h"
#import "PresetView.h"
#import "LEEAlert.h"
#import "RequestSence.h"
#import "MyEquipmentsModel.h"
#import "EquipmentAbilityModel.h"

#define KTopviewheight kScreenWidth*0.68


@interface CameraControlView ()<UIScrollViewDelegate>


@property (nonatomic,strong) UIButton *ControlBtn;
@property (nonatomic,strong) UIButton *CollectionBtn;


@property (nonatomic,strong) UIButton *leftUpBtn;
@property (nonatomic,strong) UIButton *leftDownBtn;

@property (nonatomic,strong) UIButton *rightUpBtn;
@property (nonatomic,strong) UIButton *rightDownBtn;

//@property (nonatomic,strong) UIButton *focusin;
//@property (nonatomic,strong) UIButton *focusout;
//
//@property (nonatomic,strong) UIButton *aperturein;
//@property (nonatomic,strong) UIButton *apertureout;

@property (nonatomic,strong) PresetView *setView;
@property (nonatomic,strong) UIButton *scSetBtn;//收藏位置按钮

@property (nonatomic,strong) UIScrollView *sView;//滚动视图

@property (nonatomic,strong) NSString *systemSource;//设备类型
@property (nonatomic,strong) NSString *device_id;//设备id
//@property (nonatomic,strong) NSString *equiment_id;//父设备id
@property (nonatomic,strong) NSString *presetIndex;//预置点
@property (nonatomic,assign) NSInteger indexItem;//选择的视图位置
@property (nonatomic,strong) NSMutableArray *mutPresets;//预置点数组


@end

@implementation CameraControlView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self creadUI];
    }
    
    return self;
}
-(void)creadUI
{
    
    UIButton *cancelBtn = [UIButton new];
    [cancelBtn setImage:UIImageWithFileName(@"video_control_close_image") forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelViewClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    [cancelBtn topToView:self withSpace:2];
    [cancelBtn rightToView:self withSpace:2];
    [cancelBtn addWidth:40];
    [cancelBtn addHeight:40];
    
    
    CGFloat leftSpace = kScreenWidth/2 - 80;
    
    _ControlBtn = [UIButton new];
    [_ControlBtn setTitle:@"云台控制" forState:UIControlStateNormal];
    [_ControlBtn setTitleColor:kColorMainTextColor forState:UIControlStateNormal];
    _ControlBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEighTeen];
    [_ControlBtn addTarget:self action:@selector(controlBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_ControlBtn];
    [_ControlBtn topToView:self withSpace:10];
    [_ControlBtn leftToView:self withSpace:leftSpace];
    
    
    _CollectionBtn = [UIButton new];
    [_CollectionBtn setTitle:@"收藏位置" forState:UIControlStateNormal];
    [_CollectionBtn setTitleColor:kColorMainTextColor forState:UIControlStateNormal];
    [_CollectionBtn setTitleColor:kColorThirdTextColor forState:UIControlStateDisabled];
    _CollectionBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    [_CollectionBtn addTarget:self action:@selector(collectionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_CollectionBtn];
    [_CollectionBtn yCenterToView:_ControlBtn];
    [_CollectionBtn leftToView:_ControlBtn withSpace:20];
    

    _sView = [UIScrollView new];
    _sView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_sView];
    [_sView alignTop:@"45" leading:@"0" bottom:@"0" trailing:@"0" toView:self];
    _sView.contentSize = CGSizeMake(kScreenWidth, 250);
    _sView.showsVerticalScrollIndicator = NO;
    _sView.showsHorizontalScrollIndicator = NO;
    _sView.delegate = self;
    _sView.bounces = NO;

    
    UIView *centerView = [UIView new];
    centerView.backgroundColor = UIColorFromRGB(0xDCDFE4, 1);
//    // 阴影颜色
//    centerView.layer.shadowColor = [UIColor blackColor].CGColor;
//    // 阴影偏移，默认(0, -3)
//    centerView.layer.shadowOffset = CGSizeMake(0,0);
//    // 阴影透明度，默认0
//    centerView.layer.shadowOpacity = 0.5;
//    // 阴影半径，默认3
//    centerView.layer.shadowRadius = 5;
    centerView.clipsToBounds = YES;
    centerView.layer.cornerRadius = 75;
    [_sView addSubview:centerView];
    [centerView xCenterToView:_sView];
    [centerView topToView:_sView withSpace:15];
    [centerView addWidth:150];
    [centerView addHeight:150];
         
    
    UIButton *upBtn = [UIButton new];
    [upBtn setImage:UIImageWithFileName(@"video_control_up_image") forState:UIControlStateNormal];
    [upBtn addTarget:self action:@selector(controlUpClick) forControlEvents:UIControlEventTouchUpInside];
//    [upBtn setBGColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [centerView addSubview:upBtn];
    [upBtn xCenterToView:centerView];
    [upBtn topToView:centerView withSpace:3];
    [upBtn addWidth:40];
    [upBtn addHeight:40];
    
    
    UIButton *downBtn = [UIButton new];
    [downBtn setImage:UIImageWithFileName(@"video_control_down_image") forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(controlDownClick) forControlEvents:UIControlEventTouchUpInside];
//    [downBtn setBGColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [centerView addSubview:downBtn];
    [downBtn xCenterToView:centerView];
    [downBtn bottomToView:centerView withSpace:3];
    [downBtn addWidth:40];
    [downBtn addHeight:40];
    
    
    UIButton *leftBtn = [UIButton new];
    [leftBtn setImage:UIImageWithFileName(@"video_control_left_image") forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(controlLeftClick) forControlEvents:UIControlEventTouchUpInside];
//    [leftBtn setBGColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [centerView addSubview:leftBtn];
    [leftBtn yCenterToView:centerView];
    [leftBtn leftToView:centerView withSpace:3];
    [leftBtn addWidth:40];
    [leftBtn addHeight:40];
    
    
    UIButton *rightBtn = [UIButton new];
    [rightBtn setImage:UIImageWithFileName(@"video_control_right_image") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(controlRightClick) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:rightBtn];
    [rightBtn yCenterToView:centerView];
    [rightBtn rightToView:centerView withSpace:3];
    [rightBtn addWidth:40];
    [rightBtn addHeight:40];
    
    
    UIButton *stopBtn = [UIButton new];
    [stopBtn setImage:UIImageWithFileName(@"video_control_stop_image") forState:UIControlStateNormal];
    [stopBtn addTarget:self action:@selector(controlStopClick) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:stopBtn];
    [stopBtn yCenterToView:centerView];
    [stopBtn xCenterToView:centerView];
//    [stopBtn addWidth:40];
//    [stopBtn addHeight:40];
    
    
    _leftUpBtn = [UIButton new];
    _leftUpBtn.hidden = YES;
    [_leftUpBtn setTitle:@"左上" forState:UIControlStateNormal];
    [_leftUpBtn addTarget:self action:@selector(controlLeftUpClick) forControlEvents:UIControlEventTouchUpInside];
    [_leftUpBtn setBGColor:[UIColor blackColor] forState:UIControlStateNormal];
    [centerView addSubview:_leftUpBtn];
    [_leftUpBtn leftToView:centerView withSpace:25];
    [_leftUpBtn topToView:centerView withSpace:25];
    [_leftUpBtn addWidth:40];
    [_leftUpBtn addHeight:40];
    
    
    
    _leftDownBtn = [UIButton new];
    _leftDownBtn.hidden = YES;
    [_leftDownBtn setTitle:@"左下" forState:UIControlStateNormal];
    [_leftDownBtn addTarget:self action:@selector(controlLeftDownClick) forControlEvents:UIControlEventTouchUpInside];
    [_leftDownBtn setBGColor:[UIColor blackColor] forState:UIControlStateNormal];
    [centerView addSubview:_leftDownBtn];
    [_leftDownBtn bottomToView:centerView withSpace:25];
    [_leftDownBtn leftToView:centerView withSpace:25];
    [_leftDownBtn addWidth:40];
    [_leftDownBtn addHeight:40];
    
    
    _rightUpBtn = [UIButton new];
    _rightUpBtn.hidden = YES;
    [_rightUpBtn setTitle:@"右上" forState:UIControlStateNormal];
    [_rightUpBtn addTarget:self action:@selector(controlRightUpClick) forControlEvents:UIControlEventTouchUpInside];
    [_rightUpBtn setBGColor:[UIColor blackColor] forState:UIControlStateNormal];
    [centerView addSubview:_rightUpBtn];
    [_rightUpBtn rightToView:centerView withSpace:25];
    [_rightUpBtn topToView:centerView withSpace:25];
    [_rightUpBtn addWidth:40];
    [_rightUpBtn addHeight:40];
    
    
    
    _rightDownBtn = [UIButton new];
    _rightDownBtn.hidden = YES;
    [_rightDownBtn setTitle:@"右下" forState:UIControlStateNormal];
    [_rightDownBtn addTarget:self action:@selector(controlRightDownClick) forControlEvents:UIControlEventTouchUpInside];
    [_rightDownBtn setBGColor:[UIColor blackColor] forState:UIControlStateNormal];
    [centerView addSubview:_rightDownBtn];
    [_rightDownBtn bottomToView:centerView withSpace:25];
    [_rightDownBtn rightToView:centerView withSpace:25];
    [_rightDownBtn addWidth:40];
    [_rightDownBtn addHeight:40];
    
    
    
    UIButton *zoomin = [UIButton new];
    [zoomin setImage:UIImageWithFileName(@"index_add_image") forState:UIControlStateNormal];
    [zoomin addTarget:self action:@selector(controlZoominClick) forControlEvents:UIControlEventTouchUpInside];
    [_sView addSubview:zoomin];
    [zoomin topToView:centerView withSpace:25];
    [zoomin leftToView:_sView withSpace:30];

    
    UIButton *zoomout = [UIButton new];
    [zoomout setImage:UIImageWithFileName(@"index_reduce_image") forState:UIControlStateNormal];
    [zoomout addTarget:self action:@selector(controlZoomoutClick) forControlEvents:UIControlEventTouchUpInside];
    [_sView addSubview:zoomout];
    [zoomout yCenterToView:zoomin];
    [zoomout leftToView:zoomin withSpace:35];
    
    
    
    _scSetBtn = [UIButton new];
    _scSetBtn.clipsToBounds = YES;
    _scSetBtn.layer.borderColor = kColorMainColor.CGColor;
    _scSetBtn.layer.borderWidth = 1.0f;
    _scSetBtn.layer.cornerRadius = 3;
    [_scSetBtn setTitle:@"收藏位置" forState:UIControlStateNormal];
    [_scSetBtn setTitleColor:kColorMainColor forState:UIControlStateNormal];
    [_scSetBtn setTitleColor:kColorThirdTextColor forState:UIControlStateDisabled];
    _scSetBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeFourteen];
    [_sView addSubview:_scSetBtn];
    [_scSetBtn yCenterToView:zoomin];
    [_scSetBtn addCenterX:50 toView:_sView];
    [_scSetBtn addWidth:90];
    [_scSetBtn addHeight:30];
    [_scSetBtn addTarget:self action:@selector(collectionSetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    //预置点视图
    self.setView = [PresetView new];
    [self addSubview:self.setView];
    self.setView.frame = CGRectMake(kScreenWidth, 45, kScreenWidth, kScreenHeight - KTopviewheight - 222);
    
}
-(void)makeAllData:(NSArray*)presets withSystemSource:(NSString*)systemSource withDevice_id:(NSString*)device_id withIndex:(NSInteger)index withAbility:(EquipmentAbilityModel*)model
{
    self.mutPresets = [NSMutableArray arrayWithArray:presets];
    
    self.systemSource = [NSString stringWithString:systemSource];
    self.device_id = [NSString stringWithString:device_id];
    self.indexItem = index;

    [self.setView makeAllData:presets withSystemSource:systemSource withDevice_id:device_id];
    
    
    _scSetBtn.enabled = model.preset;
    _scSetBtn.layer.borderColor = model.preset?kColorMainColor.CGColor:kColorThirdTextColor.CGColor;
    _CollectionBtn.enabled = model.preset;
    
}


-(void)cancelViewClick
{
    //还原
    self.transform = CGAffineTransformIdentity;
    if ([self.delegate respondsToSelector:@selector(cameraColseControl:)]) {
        [self.delegate cameraColseControl:self];
    }
}

-(void)controlBtnClick
{
    _ControlBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEighTeen];
    _CollectionBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];

    [UIView animateWithDuration:0.3 animations:^{
        //还原
        self.sView.transform = CGAffineTransformIdentity;
        self.setView.transform = CGAffineTransformIdentity;
    }];
}
-(void)collectionBtnClick
{
    _ControlBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
    _CollectionBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeEighTeen];
 
    [UIView animateWithDuration:0.3 animations:^{
        //X轴向左平移
        self.setView.transform = CGAffineTransformMakeTranslation(-kScreenWidth, 0);
        self.sView.transform = CGAffineTransformMakeTranslation(-kScreenWidth, 0);

    }];
      
}

-(void)controlUpClick
{
    if ([self.delegate respondsToSelector:@selector(cameraControl:withState:)]) {
        [self.delegate cameraControl:self withState:ControlStateUp];
    }
}
-(void)controlDownClick
{
    if ([self.delegate respondsToSelector:@selector(cameraControl:withState:)]) {
        [self.delegate cameraControl:self withState:ControlStateDown];
    }
}
-(void)controlLeftClick
{
    if ([self.delegate respondsToSelector:@selector(cameraControl:withState:)]) {
        [self.delegate cameraControl:self withState:ControlStateLeft];
    }
}
-(void)controlRightClick
{
    if ([self.delegate respondsToSelector:@selector(cameraControl:withState:)]) {
        [self.delegate cameraControl:self withState:ControlStaterRight];
    }
}
-(void)controlStopClick
{
    if ([self.delegate respondsToSelector:@selector(cameraControl:withState:)]) {
        [self.delegate cameraControl:self withState:ControlStaterStop];
    }
}
-(void)controlLeftUpClick
{
    if ([self.delegate respondsToSelector:@selector(cameraControl:withState:)]) {
        [self.delegate cameraControl:self withState:ControlStaterLeftUp];
    }
}
-(void)controlLeftDownClick
{
    if ([self.delegate respondsToSelector:@selector(cameraControl:withState:)]) {
        [self.delegate cameraControl:self withState:ControlStaterLeftDown];
    }
}
-(void)controlRightUpClick
{
    if ([self.delegate respondsToSelector:@selector(cameraControl:withState:)]) {
        [self.delegate cameraControl:self withState:ControlStaterRightUp];
    }
}
-(void)controlRightDownClick
{
    if ([self.delegate respondsToSelector:@selector(cameraControl:withState:)]) {
        [self.delegate cameraControl:self withState:ControlStaterRightDown];
    }
}
-(void)controlZoominClick
{
    if ([self.delegate respondsToSelector:@selector(cameraControl:withState:)]) {
        [self.delegate cameraControl:self withState:ControlStaterZoomin];
    }
}
-(void)controlZoomoutClick
{
    if ([self.delegate respondsToSelector:@selector(cameraControl:withState:)]) {
        [self.delegate cameraControl:self withState:ControlStaterZoomout];
    }
}

//点击收藏位置
-(void)collectionSetBtnClick
{
    
    if (self.mutPresets.count > 24) {
        [_kHUDManager showMsgInView:nil withTitle:@"收藏不超过25个！" isSuccess:YES];
        return;
    }
    
    [_kHUDManager showActivityInView:nil withTitle:nil];
    NSString *url = [NSString stringWithFormat:@"inventory/managedObjects/%@",self.device_id];
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"GET";
    sence.pathHeader = @"application/json";
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"obj ==  %@",obj)
        NSArray *data = [obj objectForKey:@"presets"];
        NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:data.count];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *Mdic = obj;
            PresetsModel *model = [PresetsModel makeModelData:Mdic];
            [tempArr addObject:model];
        }];
        [weak_self.mutPresets removeAllObjects];
        [weak_self.mutPresets addObjectsFromArray:tempArr];
        
        weak_self.presetIndex = [weak_self dealWithPresetIndex:weak_self.mutPresets];
        //获取最新的预置点数据
        [weak_self getDeviceNewPresetInfo];
        DLog(@"mutPresets: %@", weak_self.mutPresets);

    };
    sence.errorBlock = ^(NSError *error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"error: %@", error);
    };
    [sence sendRequest];
}
//新增预置点
-(void)addNewPerSetWithName:(NSString*_Nonnull)name withIndex:(NSString*)indexs
{
    
    if ([self nameRepeated:name]) {
        [_kHUDManager showMsgInView:nil withTitle:@"命名重复，请重新设置！" isSuccess:YES];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"service/cameraManagement/camera/operation/addpreset/%@/%@",self.systemSource,self.device_id];
    NSDictionary *finalParams = @{
                                  @"name":name,
                                  @"index":indexs,
                                  };
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:finalParams
                                                       options:0
                                                         error:nil];
    
    RequestSence *sence = [[RequestSence alloc] init];
    sence.requestMethod = @"BODY";
    sence.pathHeader = @"application/json";
    sence.body = jsonData;
    sence.pathURL = url;
    __unsafe_unretained typeof(self) weak_self = self;
    sence.successBlock = ^(id obj) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        DLog(@"Received: %@", obj);
        [_kHUDManager showMsgInView:nil withTitle:@"已收藏" isSuccess:YES];
        PresetsModel *model = [PresetsModel makeModelData:finalParams];
        [weak_self.mutPresets addObject:model];
        [weak_self.setView makeAllData:weak_self.mutPresets withSystemSource:weak_self.systemSource withDevice_id:weak_self.device_id];
    };
    sence.errorBlock = ^(NSError *error) {
        [_kHUDManager hideAfter:0.1 onHide:nil];
        // 请求失败
        DLog(@"error  ==  %@",error.userInfo);
        [_kHUDManager showMsgInView:nil withTitle:@"新增失败，请重试！" isSuccess:YES];
    };
    [sence sendRequest];
}

///处理预置点index
-(NSString*)dealWithPresetIndex:(NSArray*)array
{
   static NSString *string;
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:self.mutPresets.count];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PresetsModel *model = obj;
        [tempArr addObject:model.index];
    }];
    
    for (int i = 1; i<=25 ; i++) {
        
        NSString *str = [NSString stringWithFormat:@"%d",i];

        if (![tempArr containsObject:str]) {
            string = str;
            break;
        }
    }
    
    return string;
}

//检查名称是否重复
-(BOOL)nameRepeated:(NSString*)name
{
    BOOL result = NO;
    for (int i=0; i<self.mutPresets.count; i++) {
        PresetsModel *model = [self.mutPresets objectAtIndex:i];
        if ([model.name isEqualToString:name]) {
            result = YES;
        }
    }
    return result;
}

//获取设备最新的预置点数据
-(void)getDeviceNewPresetInfo
{
    // 使用一个变量接收自定义的输入框对象 以便于在其他位置调用
    __block UITextField *tf = nil;
    [LEEAlert alert].config
    .LeeTitle(@"设置位置名称")
    .LeeContent(@"")
    .LeeAddTextField(^(UITextField *textField) {
        
        // 这里可以进行自定义的设置
        textField.text = [NSString stringWithFormat:@"预置点%@",self.presetIndex];
        textField.font = [UIFont customFontWithSize:kFontSizeFifty];
        textField.textColor = kColorMainTextColor;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;

//            if (@available(iOS 13.0, *)) {
//                textField.textColor = [UIColor secondaryLabelColor];
//            } else {
//                textField.textColor = [UIColor darkGrayColor];
//            }
        
        tf = textField; //赋值
    })
    .LeeAction(@"确定", ^{
        DLog(@"名称是  %@",tf.text);
        
        [self addNewPerSetWithName:tf.text withIndex:self.presetIndex];
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
