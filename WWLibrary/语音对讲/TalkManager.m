//
//  TalkManager.m
//  GCDAsyncSocketDemo
//
//  Created by aipu on 2018/4/16.
//  Copyright © 2018年 XuningZhai All rights reserved.
//

#import "TalkManager.h"
#import "AACEncoder.h"
#import "PCMCapture.h"
#import "WebSocketManager.h"
#import "SocketRocketUtility.h"


#define SAMPLE_RATE 16000
#define BIT_RATE SAMPLE_RATE*16

@interface TalkManager ()<PCMCaptureDelegate,AACSendDelegate,WebSocketManagerDelegate>

@property (nonatomic, strong) AACEncoder *aac;
@property (nonatomic, strong) PCMCapture *captureSession;

@end

@implementation TalkManager

+ (instancetype)manager {
//    return [[[self class] alloc] init];
    static TalkManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}

- (instancetype)init {
    if ( self = [super init]) {
        [self initEncoder];
    }
    return self;
}

- (void)initEncoder {
    _aac = [[AACEncoder alloc] init];
    _captureSession = [[PCMCapture alloc] initCaptureWithPreset:CapturePreset640x480];
    _captureSession.delegate = self;
    _aac.delegate = self;
}

- (void)startTalk {
    //先建立连接，连接建立成功后开启语音
    
//    [[SocketRocketUtility instance] SRWebSocketOpen];
//    return;
    
    
    [WebSocketManager shared].token = self.token;
    //    [WebSocketManager shared].urlPrefixed = self.urlPrefixed;
    //    [WebSocketManager shared].serial = self.selectModel.deviceSerial;
    //    [WebSocketManager shared].code = self.selectModel.model.channelId;
    [WebSocketManager shared].delegate = self;
    [[WebSocketManager shared] connectServer];
    
        
//    [self startCapture];
}

#pragma mark - WebSocketManagerDelegate
- (void)webSocketConnectType:(WebSocketConnectType)connectType
{
    switch (connectType) {
        case WebSocketDefault:
            //初始状态，未连接
            DLog(@"···············初始状态，未连接··········");
            break;
        case WebSocketConnect:
            //已连接
            DLog(@"···········已连接·········");
            [self startCapture];
            break;
        case WebSocketDisconnect:
            //断开连接
            DLog(@"·········断开连接······");
            break;
        case WebSocketFailConnect:
            //连接失败
            DLog(@"·······连接失败·····");
            break;
            
        default:
            break;
    }
}

- (void)stopTalk {
    //停止语音，断开连接
    [[SocketRocketUtility instance] SRWebSocketClose];
    [[WebSocketManager shared] RMWebSocketClose];
    [_captureSession stop];
}

- (void)startCapture {
    [_captureSession start];
}

#pragma mark - PCMCaptureDelegate
- (void)audioWithSampleBuffer:(CMSampleBufferRef)sampleBuffer {
//    [_aac encodeSmapleBuffer:sampleBuffer];
    
    CMBlockBufferRef blockBufferRef = CMSampleBufferGetDataBuffer(sampleBuffer);
    size_t length = CMBlockBufferGetDataLength(blockBufferRef);
    Byte buffer[length];
    CMBlockBufferCopyDataBytes(blockBufferRef, 0, length, buffer);
    NSData *data = [[NSData dataWithBytes:buffer length:length] base64EncodedDataWithOptions:0];
//    NSData *base64Data = [data base64EncodedDataWithOptions:0];

    DLog(@"声音data ==  %@", data);
//    [[WebSocketManager shared] sendDataToServer:data];
    
}

#pragma mark - AACSendDelegate
- (void)sendData:(NSMutableData *)data {
//    [self.socket writeData:data withTimeout:-1 tag:100];
//    [self.delegate sendAudioData:data];
//    DLog(@"声音data ==  %@",data);
//    [[WebSocketManager shared] sendDataToServer:data];
}




@end
