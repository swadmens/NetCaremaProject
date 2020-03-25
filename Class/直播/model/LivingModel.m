//
//  LivingModel.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/25.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "LivingModel.h"

@implementation LivingModel
+(LivingModel*)makeModelData:(NSDictionary *)dic
{
    LivingModel *model = [LivingModel new];
    

    model.actived = [NSString stringWithFormat:@"%@",[dic objectForKey:@"actived"]];
    model.authed = [NSString stringWithFormat:@"%@",[dic objectForKey:@"authed"]];
    model.beginat = [NSString stringWithFormat:@"%@",[dic objectForKey:@"beginat"]];
    model.clientid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"clientid"]];
    model.code = [NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
    model.createat = [NSString stringWithFormat:@"%@",[dic objectForKey:@"createat"]];
    model.customrecordplan = [NSString stringWithFormat:@"%@",[dic objectForKey:@"customrecordplan"]];
    model.customrecordreserve = [NSString stringWithFormat:@"%@",[dic objectForKey:@"customrecordreserve"]];
    model.delay = [NSString stringWithFormat:@"%@",[dic objectForKey:@"delay"]];
    model.endat = [NSString stringWithFormat:@"%@",[dic objectForKey:@"endat"]];
    model.live_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    model.keeped = [NSString stringWithFormat:@"%@",[dic objectForKey:@"keeped"]];
    model.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    model.recordplan = [NSString stringWithFormat:@"%@",[dic objectForKey:@"recordplan"]];
    model.recordreserve = [NSString stringWithFormat:@"%@",[dic objectForKey:@"recordreserve"]];
    model.serial = [NSString stringWithFormat:@"%@",[dic objectForKey:@"serial"]];
    model.shared = [NSString stringWithFormat:@"%@",[dic objectForKey:@"shared"]];
    model.sharedlink = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sharedlink"]];
    model.sign = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sign"]];
    model.storepath = [NSString stringWithFormat:@"%@",[dic objectForKey:@"storepath"]];
    model.type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
    model.updateat = [NSString stringWithFormat:@"%@",[dic objectForKey:@"updateat"]];
    model.url = [NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]];

    
    NSDictionary *session = (NSDictionary*)[dic objectForKey:@"session"];
    
    model.application = [NSString stringWithFormat:@"%@",[session objectForKey:@"application"]];
    model.audiobitrate = [NSString stringWithFormat:@"%@",[session objectForKey:@"audiobitrate"]];
    model.dhls = [NSString stringWithFormat:@"%@",[session objectForKey:@"dhls"]];
    model.hls = [NSString stringWithFormat:@"%@",[session objectForKey:@"hls"]];
    model.httpflv = [NSString stringWithFormat:@"%@",[session objectForKey:@"httpflv"]];
    model.session_id = [NSString stringWithFormat:@"%@",[session objectForKey:@"id"]];
    model.inbitrate = [NSString stringWithFormat:@"%@",[session objectForKey:@"inbitrate"]];
    model.inbytes = [NSString stringWithFormat:@"%@",[session objectForKey:@"inbytes"]];
    model.session_name = [NSString stringWithFormat:@"%@",[session objectForKey:@"name"]];
    model.numoutputs = [NSString stringWithFormat:@"%@",[session objectForKey:@"numoutputs"]];
    model.outbitrate = [NSString stringWithFormat:@"%@",[session objectForKey:@"outbitrate"]];
    model.outbytes = [NSString stringWithFormat:@"%@",[session objectForKey:@"outbytes"]];
    model.rtmp = [NSString stringWithFormat:@"%@",[session objectForKey:@"rtmp"]];
    model.starttime = [NSString stringWithFormat:@"%@",[session objectForKey:@"starttime"]];
    model.time = [NSString stringWithFormat:@"%@",[session objectForKey:@"time"]];
    model.session_type = [NSString stringWithFormat:@"%@",[session objectForKey:@"type"]];
    model.videobitrate = [NSString stringWithFormat:@"%@",[session objectForKey:@"videobitrate"]];
    model.wsflv = [NSString stringWithFormat:@"%@",[session objectForKey:@"wsflv"]];

 
    return model;
}
@end
