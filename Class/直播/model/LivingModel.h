//
//  LivingModel.h
//  NetCamera
//
//  Created by 汪伟 on 2020/3/25.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LivingModel : NSObject
+(LivingModel*)makeModelData:(NSDictionary*)dic;

@property (nonatomic,strong) NSString *actived;
@property (nonatomic,strong) NSString *authed;
@property (nonatomic,strong) NSString *beginat;
@property (nonatomic,strong) NSString *clientid;
@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSString *createat;
@property (nonatomic,strong) NSString *customrecordplan;
@property (nonatomic,strong) NSString *customrecordreserve;
@property (nonatomic,strong) NSString *delay;
@property (nonatomic,strong) NSString *endat;
@property (nonatomic,strong) NSString *live_id;
@property (nonatomic,strong) NSString *keeped;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *recordplan;
@property (nonatomic,strong) NSString *recordreserve;
@property (nonatomic,strong) NSString *serial;
@property (nonatomic,strong) NSString *shared;
@property (nonatomic,strong) NSString *sharedlink;
@property (nonatomic,strong) NSString *sign;
@property (nonatomic,strong) NSString *storepath;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *updateat;
@property (nonatomic,strong) NSString *url;


@property (nonatomic,strong) NSString *application;
@property (nonatomic,strong) NSString *audiobitrate;
@property (nonatomic,strong) NSString *dhls;
@property (nonatomic,strong) NSString *hls;
@property (nonatomic,strong) NSString *httpflv;
@property (nonatomic,strong) NSString *session_id;
@property (nonatomic,strong) NSString *inbitrate;
@property (nonatomic,strong) NSString *inbytes;
@property (nonatomic,strong) NSString *session_name;
@property (nonatomic,strong) NSString *numoutputs;
@property (nonatomic,strong) NSString *outbitrate;
@property (nonatomic,strong) NSString *outbytes;
@property (nonatomic,strong) NSString *rtmp;
@property (nonatomic,strong) NSString *starttime;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *session_type;
@property (nonatomic,strong) NSString *videobitrate;
@property (nonatomic,strong) NSString *wsflv;

@end

NS_ASSUME_NONNULL_END
