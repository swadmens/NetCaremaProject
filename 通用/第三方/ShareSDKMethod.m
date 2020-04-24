//
//  ShareSDKMethod.m
//  QLYDPro
//
//  Created by QiLu on 2017/4/26.
//  Copyright © 2017年 zxy. All rights reserved.
//
//分享自定义UI
#import "ShareSDKMethod.h"
@implementation ShareSDKMethod

//+(void)ShareTextActionWithParams:(LGXShareParams*)shareParams IsBlack:(BOOL)isBlack IsReport:(BOOL)isReport IsDelete:(BOOL)isDelete Black:(BlackBlock)blackBlock Report:(ReportBlock)reportBlock Delete:(DeleteBlock)deleteBlock Result:(ResultBlock)resultBlock
//{
//
////    //设置分享参数
//    myReportBlock = reportBlock;
//    myBlackBlock = blackBlock;
//    myResultBlock = resultBlock;
//    myDeleteBlock = deleteBlock;
//    myIsReport = isReport;
//    myIsBlack = isBlack;
//    myIsDelete = isDelete;
////    _shareParams = [NSMutableDictionary dictionary];
////
////    [_shareParams SSDKSetupShareParamsByText:shareParams.content
////                                     images:shareParams.images
////                                        url:[NSURL URLWithString:shareParams.url]
////                                      title:shareParams.title
////                                       type:SSDKContentTypeAuto];
//
//    //创建UI
//    [self createCustomUIWithBlack:isBlack Report:isReport Delete:isDelete];
//}
+(void)ShareTextActionWithParams:(LGXShareParams*)shareParams QRCode:(QrCodeBlock)qrcodeBlock url:(SharaUrlBlock)urlBlock Result:(ResultBlock)resultBlock
{
    //    //设置分享参数
        sharaQrCodeBlock = qrcodeBlock;
        sharaMyUrlBlock = urlBlock;
    //    _shareParams = [NSMutableDictionary dictionary];
    //
    //    [_shareParams SSDKSetupShareParamsByText:shareParams.content
    //                                     images:shareParams.images
    //                                        url:[NSURL URLWithString:shareParams.url]
    //                                      title:shareParams.title
    //                                       type:SSDKContentTypeAuto];
        
        //创建UI
        [self createCustomUIWithBlack:NO Report:NO Delete:NO];
}
//自定义分享UI
+(void)createCustomUIWithBlack:(BOOL)isBlack Report:(BOOL)isReport Delete:(BOOL)isDelete
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    
    //透明蒙层
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    grayView.backgroundColor = UIColorFromRGB(0x000000, 0.8);
    grayView.tag = 60000;
    UITapGestureRecognizer *tapGrayView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelShareAction)];
    [grayView addGestureRecognizer:tapGrayView];
    grayView.userInteractionEnabled = YES;
    [window addSubview:grayView];
    
    
    
    CGFloat spaceH = 360;
    if (!isBlack && !isReport && !isDelete) {
        spaceH = 200;
    }
    
    //分享控制器
    UIView *shareBackView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, spaceH)];
    shareBackView.backgroundColor = UIColorFromRGB(0xffffff, 0);
    shareBackView.tag = 60001;
    [window addSubview:shareBackView];
    
    //内容视图
    UIView *contentView = [UIView new];
    contentView.clipsToBounds = YES;
    contentView.layer.cornerRadius = 10;
    contentView.backgroundColor = [UIColor whiteColor];
    [shareBackView addSubview:contentView];
    [contentView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:shareBackView];
    
    
    UILabel *shareToLabel = [UILabel new];
    shareToLabel.text = @"分享到";
    shareToLabel.textColor = kColorMainTextColor;
    shareToLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    [contentView addSubview:shareToLabel];
    [shareToLabel xCenterToView:contentView];
    [shareToLabel topToView:contentView withSpace:15];
    
    
    UILabel *lineLabel = [UILabel new];
    lineLabel.backgroundColor = kColorLineColor;
    [contentView addSubview:lineLabel];
    [lineLabel bottomToView:contentView withSpace:46];
    [lineLabel leftToView:contentView];
    [lineLabel addWidth:kScreenWidth];
    [lineLabel addHeight:0.6];
    
    //取消按钮
    UIButton *cancelBtn = [UIButton new];
    [cancelBtn setBGColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kColorMainTextColor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont customFontWithSize:kFontSizeFifty];
    [cancelBtn addTarget:self action:@selector(cancelShareAction) forControlEvents:UIControlEventTouchUpInside];
//    cancelBtn.clipsToBounds = YES;
//    cancelBtn.layer.cornerRadius = 8;
    [shareBackView addSubview:cancelBtn];
    [cancelBtn xCenterToView:shareBackView];
    [cancelBtn addWidth:kScreenWidth];
    [cancelBtn bottomToView:shareBackView];
    [cancelBtn addHeight:45];
    
    
    
    //分享图标和标题数组
    NSArray *imageNameArr = @[@"shara_arcode_image",@"shara_url_image",@"shara_wechat_image",@"shara_qq_image"];
    NSMutableArray *imagesArr = [NSMutableArray array];
    for (NSString *imageName in imageNameArr) {
        UIImage *image = [UIImage imageNamed:imageName];
        [imagesArr addObject:image];
    }
    NSArray *titlesArr = @[@"二维码",@"链接",@"微信",@"QQ"];
    NSMutableArray *titleNameArr = [NSMutableArray array];
    for (NSString *title in titlesArr) {
        [titleNameArr addObject:title];
    }
    
    
    //分享栏中添加自己的功能，比如拉黑、举报之类的
    if (isReport) {
        [imagesArr addObject:[UIImage imageNamed:@"jubao_image"]];
        [titleNameArr addObject:@"举报"];
    }
    
    if (isBlack) {
        [imagesArr addObject:[UIImage imageNamed:@"shield_image"]];
        [titleNameArr addObject:@"拉黑"];
    }
  
    if (isDelete) {
        [imagesArr addObject:[UIImage imageNamed:@"pet_circle_delete"]];
        [titleNameArr addObject:@"删除"];
    }
    
    
    //分享按钮
    CGFloat itemWidth = 40;
    CGFloat itemHeight = 40+35;
    
    CGFloat spaceX = (kScreenWidth - 220)/3;
    
    NSInteger rowCount = 4;
    for (int i =0; i<titleNameArr.count; i++) {
        UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        iconBtn.frame = CGRectMake(30 + (i%rowCount)*(itemWidth+spaceX), 48 + (i/rowCount)*(itemHeight + 45), itemWidth, itemWidth);
        [iconBtn setImage:imagesArr[i] forState:UIControlStateNormal];
        iconBtn.tag = 2000 + i;
        [iconBtn addTarget:self action:@selector(shareItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:iconBtn];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
        titleLabel.center = CGPointMake(CGRectGetMinX(iconBtn.frame)+itemWidth/2, CGRectGetMaxY(iconBtn.frame)+20);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = kColorMainTextColor;
        titleLabel.font = [UIFont customFontWithSize:kFontSizeThirteen];
        titleLabel.text = titleNameArr[i];
        [contentView addSubview:titleLabel];
    }
    
    
    [UIView animateWithDuration:0.35 animations:^{
        shareBackView.frame = CGRectMake(0, kScreenHeight-shareBackView.frame.size.height, shareBackView.frame.size.width, shareBackView.frame.size.height);
    }];
    
}
+(void)shareItemAction:(UIButton*)button
{
    [self removeShareView];
    NSInteger sharetype = 0;
    NSMutableDictionary *publishContent = _shareParams;

    switch (button.tag) {
        case 2000:
        {
//            sharetype = SSDKPlatformSubTypeWechatSession;
            //二维码
            if (sharaQrCodeBlock) {
                sharaQrCodeBlock();
            }
        }
            break;
        case 2001:
        {
//            sharetype = SSDKPlatformSubTypeWechatTimeline;
            //链接
            if (sharaMyUrlBlock) {
                sharaMyUrlBlock();
            }
        }
            break;
        case 2002:
        {
            sharetype = SSDKPlatformTypeSinaWeibo;
            [publishContent SSDKEnableUseClientShare];
        }
            break;
        case 2003:
        {
            sharetype = SSDKPlatformSubTypeQZone;
        }
            break;
        case 2004:
        {
            if (myIsDelete)
            {
                if (myDeleteBlock) {
                    myDeleteBlock();
                }
            }else
            {
                if (myReportBlock) {
                    myReportBlock();
                }
            }
        }
            break;
        case 2005:
        {
            if (myBlackBlock) {
                myBlackBlock();
            }
        }
            break;
        default:
            break;
    }
    if (sharetype == 0)
    {
        [self removeShareView];
        
    }else
    {
        //调用ShareSDK的无UI分享方法
        [ShareSDK share:sharetype parameters:publishContent onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            if (myResultBlock) {
                myResultBlock(state,sharetype,userData,contentEntity,error);
            }
        }];
    }
}

//点击分享栏之外的区域 取消分享 移除分享栏
+(void)removeShareView{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [window viewWithTag:60000];
    UIView *shareView = [window viewWithTag:60001];
    shareView.frame =CGRectMake(0, shareView.frame.origin.y, shareView.frame.size.width, shareView.frame.size.height);
    [UIView animateWithDuration:0.35 animations:^{
        shareView.frame = CGRectMake(0, kScreenHeight, shareView.frame.size.width, shareView.frame.size.height);
    } completion:^(BOOL finished) {
        
        [shareView removeFromSuperview];
        [blackView removeFromSuperview];
    }];
    
    
}
+(void)cancelShareAction{
    
    [self removeShareView];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"KNotiVideoPlayForShare" object:nil];
}

@end
