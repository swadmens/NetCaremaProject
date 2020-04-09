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
    
    [aCoder encodeObject:_imageUrl forKey:@"snapUrl"];
    [aCoder encodeObject:_downloadProgress forKey:@"progress"];
    [aCoder encodeObject:_video_name forKey:@"name"];
    [aCoder encodeObject:_video_time forKey:@"shart_time"];
    [aCoder encodeObject:_filePath forKey:@"filePath"];
    [aCoder encodeObject:_download_url forKey:@"filUrl"];

}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{

    self = [super init];

    if (self) {
    
        self.imageUrl= [aDecoder decodeObjectForKey:@"snapUrl"];
        self.downloadProgress = [aDecoder decodeObjectForKey:@"progress"];
        self.video_name = [aDecoder decodeObjectForKey:@"name"];
        self.video_time = [aDecoder decodeObjectForKey:@"shart_time"];
        self.filePath = [aDecoder decodeObjectForKey:@"filePath"];
        self.download_url = [aDecoder decodeObjectForKey:@"filUrl"];

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
        
        self.imageUrl= [dict objectForKey:@"snapUrl"];
        self.downloadProgress = [dict objectForKey:@"progress"];
        self.video_name = [dict objectForKey:@"name"];
        self.video_time = [dict objectForKey:@"shart_time"];
        self.filePath = [dict objectForKey:@"filePath"];
        self.download_url = [dict objectForKey:@"filUrl"];

    }
    return self;
}

@end
