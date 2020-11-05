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
#import "GCDAsyncSocket.h"


#define SAMPLE_RATE 16000
#define BIT_RATE SAMPLE_RATE*16

@interface TalkManager ()<PCMCaptureDelegate,AACSendDelegate,GCDAsyncSocketDelegate>

@property (nonatomic,retain) GCDAsyncSocket *socket;
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
    [self connectServer:self.ip port:self.port];

//    [self startCapture];
}

- (void)stopTalk {
    //停止语音，断开连接
    [_captureSession stop];
    self.socket = nil;
    [self doTeardown:self.url];
}

- (int)connectServer:(NSString *)hostIP port:(int)hostPort {
    if (_socket == nil) {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        NSError *err = nil;
        int t = [_socket connectToHost:hostIP onPort:hostPort error:&err];
        if (!t) {
            return 0;
        }else{
            return 1;
        }
    }else {
        [_socket readDataWithTimeout:-1 tag:0];
        return 1;
    }
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    BOOL state = [self.socket isConnected];
    if (state) {
        [self sendCmd];
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    BOOL state = [_socket isConnected];
    NSLog(@"disconnect,state=%d",state);
    self.socket = nil;
}

- (void)sendCmd
{
    [self doSetup:self.url];
}

- (void)doSetup:(NSString *)url {
    NSMutableString *dataString = [NSMutableString string];
    [dataString appendString:[NSString stringWithFormat:@"SETUP %@ RTSP/1.0\r\n", url]];
    [dataString appendString:@"Content-Length: 0\r\n"];
    [dataString appendFormat:@"CSeq: 0\r\n"];
    [dataString appendString:@"Transport: RTP/AVP/DHTP;unicast\r\n"];
    [dataString appendString:@"\r\n"];
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:-1 tag:0];
    [self.socket readDataWithTimeout:-1 tag:0];
}

- (void)doPlay:(NSString *)url {
    NSMutableString *dataString = [NSMutableString string];
    [dataString appendString:[NSString stringWithFormat:@"PLAY %@ RTSP/1.0\r\n", url]];
    [dataString appendString:@"Content-Length: 0\r\n"];
    [dataString appendFormat:@"CSeq: 1\r\n"];
    [dataString appendString:@"\r\n"];
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:-1 tag:1];
    [self.socket readDataWithTimeout:-1 tag:1];
}

- (void)doTeardown:(NSString *)url {
    NSMutableString *dataString = [NSMutableString string];
    [dataString appendString:[NSString stringWithFormat:@"TEARDOWN %@ RTSP/1.0\r\n", url]];
    [dataString appendString:@"Content-Length: 0\r\n"];
    [dataString appendString:@"CSeq: 2\r\n"];
    [dataString appendString:@"\r\n"];
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:-1 tag:2];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    switch (tag) {
        case 0:
//            [self doPlay:self.url];
            break;
        case 1:
            [self startCapture];
            break;
        case 200:
            if (!dataString) {
//                [self getPayload:data];
            }
            break;
        default:
            break;
    }
    [sock readDataWithTimeout:-1 tag:200];
}




- (void)startCapture {
    [_captureSession start];
}

- (void)audioWithSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    [_aac encodeSmapleBuffer:sampleBuffer];
    
//    CMBlockBufferRef blockBufferRef = CMSampleBufferGetDataBuffer(sampleBuffer);
//    size_t length = CMBlockBufferGetDataLength(blockBufferRef);
//    Byte buffer[length];
//    CMBlockBufferCopyDataBytes(blockBufferRef, 0, length, buffer);
//    NSData *data = [NSData dataWithBytes:buffer length:length];
//
//    DLog(@"声音data ==  %@",data);
    
}

- (void)sendData:(NSMutableData *)data {
    [self.socket writeData:data withTimeout:-1 tag:100];
//    [self.delegate sendAudioData:data];
//    DLog(@"声音data ==  %@",data);
}




@end
