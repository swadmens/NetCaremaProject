//
//  CLVoiceApplyAddressModel.m
//  NetCamera
//
//  Created by 汪伟 on 2020/4/7.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "CLVoiceApplyAddressModel.h"

@implementation CLVoiceApplyAddressModel
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_duration forKey:@"duration"];
    [aCoder encodeObject:_file_path forKey:@"file_path"];
    [aCoder encodeObject:_hls forKey:@"hls"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_progress forKey:@"progress"];
    [aCoder encodeObject:_snap forKey:@"snap"];
    [aCoder encodeObject:_start_time forKey:@"start_time"];
    [aCoder encodeObject:_time forKey:@"time"];
    [aCoder encodeObject:_url forKey:@"url"];
    [aCoder encodeObject:_writeBytes forKey:@"writeBytes"];


}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{

    self = [super init];

    if (self) {
    
        self.duration= [aDecoder decodeObjectForKey:@"duration"];
        self.file_path = [aDecoder decodeObjectForKey:@"file_path"];
        self.hls = [aDecoder decodeObjectForKey:@"hls"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.progress = [aDecoder decodeObjectForKey:@"progress"];
        self.snap = [aDecoder decodeObjectForKey:@"snap"];
        self.start_time = [aDecoder decodeObjectForKey:@"start_time"];
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.writeBytes = [aDecoder decodeObjectForKey:@"writeBytes"];


    }else{
        return nil;
    }
    return self;
}

+(instancetype)AddressModelWithDict:(NSDictionary *)dict{
    return [[self alloc] initAddressModelWithDict:dict];
}

-(instancetype)initAddressModelWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        
        self.duration= [dict objectForKey:@"duration"];
        self.file_path = [dict objectForKey:@"file_path"];
        self.hls = [dict objectForKey:@"hls"];
        self.name = [dict objectForKey:@"name"];
        self.progress = [dict objectForKey:@"progress"];
        self.snap = [dict objectForKey:@"snap"];
        self.start_time = [dict objectForKey:@"start_time"];
        self.time = [dict objectForKey:@"time"];
        self.url = [dict objectForKey:@"url"];
        self.writeBytes = [dict objectForKey:@"writeBytes"];



    }
    return self;
}

@end
