//
//  WebSocketManager.h
//  NetCamera
//
//  Created by 汪伟 on 2020/11/4.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket.h>

typedef NS_ENUM(NSUInteger,WebSocketConnectType){
    WebSocketDefault = 0, //初始状态,未连接
    WebSocketConnect,      //已连接
    WebSocketFailConnect,      //连接失败
    WebSocketDisconnect    //连接后断开
};

@class WebSocketManager;
@protocol WebSocketManagerDelegate <NSObject>

- (void)webSocketManagerDidReceiveMessageWithString:(NSString *)string;

-(void)webSocketConnectType:(WebSocketConnectType)connectType;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WebSocketManager : NSObject

@property (nonatomic, strong) SRWebSocket *webSocket;
@property(nonatomic,weak)  id<WebSocketManagerDelegate > delegate;
@property (nonatomic, assign)   BOOL isConnect;  //是否连接

@property (nonatomic,strong) NSString *urlPrefixed;


+ (instancetype)shared;
- (void)connectServer;//建立长连接
- (void)reConnectServer;//重新连接
- (void)RMWebSocketClose;//关闭长连接
- (void)sendDataToServer:(id)data;//发送数据给服务器

@end

NS_ASSUME_NONNULL_END
